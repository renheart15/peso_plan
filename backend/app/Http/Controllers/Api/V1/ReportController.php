<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Household;
use App\Models\Transaction;
use Carbon\Carbon;
use Dompdf\Dompdf;
use Dompdf\Options;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Response;

class ReportController extends Controller
{
    /**
     * GET /households/{household}/reports/summary
     *
     * Returns total income, expenses, net, and savings rate for the given
     * month (defaults to current calendar month).
     *
     * Query params:
     *   month  — YYYY-MM  (default: current month)
     */
    public function summary(Request $request, Household $household): JsonResponse
    {
        Gate::authorize('view', $household);

        [$from, $to] = $this->monthRange($request->query('month'));

        $rows = Transaction::query()
            ->where('household_id', $household->id)
            ->whereBetween('date', [$from, $to])
            ->selectRaw('type, SUM(amount_cents) as total')
            ->groupBy('type')
            ->pluck('total', 'type');

        $income = (int) ($rows['income'] ?? 0);
        $expense = (int) ($rows['expense'] ?? 0);
        $transfer = (int) ($rows['transfer'] ?? 0);
        $net = $income - $expense;
        $rate = $income > 0 ? round(($net / $income) * 100, 2) : 0;

        return response()->json([
            'data' => [
                'period' => $request->query('month', now()->format('Y-m')),
                'income_cents' => $income,
                'expense_cents' => $expense,
                'transfer_cents' => $transfer,
                'net_cents' => $net,
                'savings_rate_pct' => $rate,
            ],
        ]);
    }

    /**
     * GET /households/{household}/reports/category-breakdown
     *
     * Returns expense totals grouped by category for the given month.
     *
     * Query params:
     *   month  — YYYY-MM
     *   type   — 'expense' (default) | 'income'
     */
    public function categoryBreakdown(Request $request, Household $household): JsonResponse
    {
        Gate::authorize('view', $household);

        [$from, $to] = $this->monthRange($request->query('month'));
        $type = in_array($request->query('type'), ['income', 'expense']) ? $request->query('type') : 'expense';

        $rows = Transaction::query()
            ->where('household_id', $household->id)
            ->where('type', $type)
            ->whereBetween('date', [$from, $to])
            ->join('categories', 'transactions.category_id', '=', 'categories.id')
            ->selectRaw('categories.id, categories.name, categories.icon, categories.color_hex, SUM(transactions.amount_cents) as total_cents')
            ->groupBy('categories.id', 'categories.name', 'categories.icon', 'categories.color_hex')
            ->orderByDesc('total_cents')
            ->get();

        return response()->json(['data' => $rows]);
    }

    /**
     * GET /households/{household}/reports/top-payees
     *
     * Returns the top 10 payees by total spend for the given month.
     *
     * Query params:
     *   month  — YYYY-MM
     *   limit  — 1–50 (default 10)
     */
    public function topPayees(Request $request, Household $household): JsonResponse
    {
        Gate::authorize('view', $household);

        [$from, $to] = $this->monthRange($request->query('month'));
        $limit = min((int) ($request->query('limit', 10)), 50);

        $rows = Transaction::query()
            ->where('household_id', $household->id)
            ->where('type', 'expense')
            ->whereBetween('date', [$from, $to])
            ->whereNotNull('payee')
            ->selectRaw('payee, SUM(amount_cents) as total_cents, COUNT(*) as count')
            ->groupBy('payee')
            ->orderByDesc('total_cents')
            ->limit($limit)
            ->get();

        return response()->json(['data' => $rows]);
    }

    /**
     * GET /households/{household}/reports/cash-flow
     *
     * Returns daily or monthly income vs expense for a date range.
     *
     * Query params:
     *   from       — YYYY-MM-DD (default: first day of current month)
     *   to         — YYYY-MM-DD (default: today)
     *   granularity — 'daily' | 'monthly' (default: 'daily')
     */
    public function cashFlow(Request $request, Household $household): JsonResponse
    {
        Gate::authorize('view', $household);

        $from = $request->query('from', now()->startOfMonth()->toDateString());
        $to = $request->query('to', now()->toDateString());
        $gran = in_array($request->query('granularity'), ['daily', 'monthly'])
            ? $request->query('granularity')
            : 'daily';

        $dateTrunc = $gran === 'monthly'
            ? "DATE_FORMAT(date, '%Y-%m-01')"
            : 'transaction_date';

        $rows = Transaction::query()
            ->where('household_id', $household->id)
            ->whereIn('type', ['income', 'expense'])
            ->whereBetween('date', [$from, $to])
            ->selectRaw("$dateTrunc as period, type, SUM(amount_cents) as total_cents")
            ->groupByRaw("$dateTrunc, type")
            ->orderByRaw('period')
            ->get()
            ->groupBy('period')
            ->map(fn ($group) => [
                'period' => $group->first()->period,
                'income_cents' => (int) ($group->where('type', 'income')->first()?->total_cents ?? 0),
                'expense_cents' => (int) ($group->where('type', 'expense')->first()?->total_cents ?? 0),
            ])
            ->values();

        return response()->json(['data' => $rows]);
    }

    /**
     * GET /households/{household}/reports/export.csv
     *
     * Streams a CSV of all transactions within the given date range.
     *
     * Query params:
     *   from — YYYY-MM-DD
     *   to   — YYYY-MM-DD
     */
    public function exportCsv(Request $request, Household $household)
    {
        Gate::authorize('view', $household);

        $validated = $request->validate([
            'from' => ['nullable', 'date_format:Y-m-d'],
            'to' => ['nullable', 'date_format:Y-m-d', 'after_or_equal:from'],
        ]);
        $from = $validated['from'] ?? now()->startOfMonth()->toDateString();
        $to = $validated['to'] ?? now()->toDateString();

        $transactions = Transaction::query()
            ->where('household_id', $household->id)
            ->whereBetween('date', [$from, $to])
            ->with(['category', 'account'])
            ->orderBy('transaction_date')
            ->get();

        $rows = [];
        $rows[] = ['Date', 'Type', 'Amount (PHP)', 'Category', 'Account', 'Payee', 'Notes'];

        foreach ($transactions as $t) {
            $rows[] = [
                $t->date?->toDateString() ?? '',
                $t->type,
                number_format($t->amount_cents / 100, 2, '.', ''),
                $t->category?->name ?? '',
                $t->account?->name ?? '',
                $t->payee ?? '',
                $t->notes ?? '',
            ];
        }

        $csv = '';
        foreach ($rows as $row) {
            $csv .= implode(',', array_map(fn ($v) => '"'.str_replace('"', '""', $v).'"', $row))."\r\n";
        }

        $filename = "peso-plan-transactions-{$from}-to-{$to}.csv";

        return Response::make($csv, 200, [
            'Content-Type' => 'text/csv; charset=UTF-8',
            'Content-Disposition' => "attachment; filename=\"{$filename}\"",
        ]);
    }

    /**
     * GET /households/{household}/reports/export.pdf
     *
     * PDF export — stub for Phase 4 (requires a PDF library, e.g. DomPDF).
     */
    public function exportPdf(Request $request, Household $household)
    {
        Gate::authorize('view', $household);

        $validated = $request->validate([
            'from' => ['nullable', 'date_format:Y-m-d'],
            'to' => ['nullable', 'date_format:Y-m-d', 'after_or_equal:from'],
        ]);
        $from = $validated['from'] ?? now()->startOfMonth()->toDateString();
        $to = $validated['to'] ?? now()->toDateString();

        $transactions = Transaction::query()
            ->where('household_id', $household->id)
            ->whereBetween('date', [$from, $to])
            ->with(['category', 'account'])
            ->orderBy('date')
            ->get();

        $rows = $transactions->map(function (Transaction $transaction) {
            return '<tr>'
                .'<td>'.e($transaction->date?->toDateString()).'</td>'
                .'<td>'.e(ucfirst($transaction->type)).'</td>'
                .'<td>'.number_format($transaction->amount_cents / 100, 2).'</td>'
                .'<td>'.e($transaction->category?->name ?? '').'</td>'
                .'<td>'.e($transaction->account?->name ?? '').'</td>'
                .'<td>'.e($transaction->payee ?? '').'</td>'
                .'</tr>';
        })->implode('');

        $html = '<!doctype html><html><head><meta charset="utf-8"><style>'
            .'body{font-family:sans-serif;font-size:11px} table{width:100%;border-collapse:collapse}'
            .'th,td{border:1px solid #ccc;padding:5px;text-align:left} th{background:#edf4ef}</style></head><body>'
            .'<h2>Peso Plan Transaction Export</h2><p>'.e("{$from} to {$to}").'</p>'
            .'<table><thead><tr><th>Date</th><th>Type</th><th>Amount (PHP)</th><th>Category</th><th>Account</th><th>Payee</th></tr></thead>'
            .'<tbody>'.$rows.'</tbody></table></body></html>';

        $options = new Options;
        $options->set('isRemoteEnabled', false);
        $dompdf = new Dompdf($options);
        $dompdf->loadHtml($html);
        $dompdf->setPaper('A4', 'landscape');
        $dompdf->render();

        $filename = "peso-plan-transactions-{$from}-to-{$to}.pdf";

        return Response::make($dompdf->output(), 200, [
            'Content-Type' => 'application/pdf',
            'Content-Disposition' => "attachment; filename=\"{$filename}\"",
        ]);
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    /**
     * Given an optional "YYYY-MM" string, return [startDate, endDate] as date strings.
     */
    private function monthRange(?string $month): array
    {
        $date = $month ? Carbon::createFromFormat('Y-m', $month) : now();

        return [
            $date->copy()->startOfMonth()->toDateString(),
            $date->copy()->endOfMonth()->toDateString(),
        ];
    }
}
