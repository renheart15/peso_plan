<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Household;
use App\Models\Transaction;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

class TransactionController extends Controller
{
    public function index(Request $request, Household $household): JsonResponse
    {
        abort_unless($household->isMember($request->user()), 403);

        $query = $household->transactions()
            ->with(['category', 'account', 'tags'])
            ->latest('date');

        if ($request->filled('start_date')) {
            $query->where('date', '>=', $request->start_date);
        }
        if ($request->filled('end_date')) {
            $query->where('date', '<=', $request->end_date);
        }
        if ($request->filled('account_id')) {
            $query->where('account_id', $request->account_id);
        }
        if ($request->filled('category_id')) {
            $query->where('category_id', $request->category_id);
        }
        if ($request->filled('search')) {
            $query->where(function ($q) use ($request) {
                $q->where('payee', 'like', "%{$request->search}%")
                    ->orWhere('notes', 'like', "%{$request->search}%");
            });
        }

        $transactions = $query->paginate($request->input('per_page', 25));

        return response()->json($transactions);
    }

    public function store(Request $request, Household $household): JsonResponse
    {
        abort_unless($household->canEdit($request->user()), 403);

        $validated = $request->validate([
            'account_id' => ['required', Rule::exists('accounts', 'id')->where(fn ($query) => $query->where('household_id', $household->id))],
            'category_id' => ['nullable', Rule::exists('categories', 'id')->where(fn ($query) => $query->where(fn ($q) => $q->where('household_id', $household->id)->orWhereNull('household_id')))],
            'amount_cents' => ['required', 'integer', 'min:1'],
            'type' => ['required', 'in:income,expense,transfer'],
            'date' => ['required', 'date'],
            'payee' => ['nullable', 'string', 'max:255'],
            'notes' => ['nullable', 'string'],
            'tag_ids' => ['nullable', 'array'],
            'tag_ids.*' => ['exists:tags,id'],
        ]);

        $validated['amount_cents'] = abs((int) $validated['amount_cents']);

        $transaction = $household->transactions()->create(
            array_merge($validated, ['created_by' => $request->user()->id])
        );

        if (! empty($validated['tag_ids'])) {
            $transaction->tags()->sync($validated['tag_ids']);
        }

        return response()->json(['data' => $transaction->load('category', 'account', 'tags')], 201);
    }

    public function show(Request $request, Household $household, Transaction $transaction): JsonResponse
    {
        abort_unless($household->isMember($request->user()), 403);
        abort_if($transaction->household_id !== $household->id, 404);

        return response()->json(['data' => $transaction->load('category', 'account', 'tags', 'splits')]);
    }

    public function update(Request $request, Household $household, Transaction $transaction): JsonResponse
    {
        abort_unless($household->canEdit($request->user()), 403);
        abort_if($transaction->household_id !== $household->id, 404);

        $validated = $request->validate([
            'account_id' => ['sometimes', Rule::exists('accounts', 'id')->where(fn ($query) => $query->where('household_id', $household->id))],
            'category_id' => ['nullable', Rule::exists('categories', 'id')->where(fn ($query) => $query->where(fn ($q) => $q->where('household_id', $household->id)->orWhereNull('household_id')))],
            'amount_cents' => ['sometimes', 'integer', 'min:1'],
            'type' => ['sometimes', 'in:income,expense,transfer'],
            'date' => ['sometimes', 'date'],
            'payee' => ['nullable', 'string', 'max:255'],
            'notes' => ['nullable', 'string'],
        ]);

        if (array_key_exists('amount_cents', $validated)) {
            $validated['amount_cents'] = abs((int) $validated['amount_cents']);
        }

        $transaction->update($validated);

        return response()->json(['data' => $transaction->fresh('category', 'account', 'tags')]);
    }

    public function destroy(Request $request, Household $household, Transaction $transaction): JsonResponse
    {
        abort_unless($household->canEdit($request->user()), 403);
        abort_if($transaction->household_id !== $household->id, 404);
        $transaction->delete();

        return response()->json(null, 204);
    }

    public function bulkCategorize(Request $request, Household $household): JsonResponse
    {
        abort_unless($household->canEdit($request->user()), 403);
        $validated = $request->validate([
            'transaction_ids' => ['required', 'array'],
            'transaction_ids.*' => ['integer'],
            'category_id' => ['required', 'exists:categories,id'],
        ]);

        $updated = $household->transactions()
            ->whereIn('id', $validated['transaction_ids'])
            ->update(['category_id' => $validated['category_id']]);

        return response()->json(['updated' => $updated]);
    }

    public function import(Request $request, Household $household): JsonResponse
    {
        abort_unless($household->canEdit($request->user()), 403);

        $validated = $request->validate([
            'file' => ['required', 'file', 'mimes:csv,txt', 'max:10240'],
            'account_id' => ['required', Rule::exists('accounts', 'id')->where(fn ($query) => $query->where('household_id', $household->id))],
        ]);

        $handle = fopen($validated['file']->getRealPath(), 'r');
        abort_if($handle === false, 422, 'Unable to read the CSV file.');

        $headers = fgetcsv($handle, escape: '\\');
        abort_if(! is_array($headers) || count($headers) === 0, 422, 'The CSV file is missing a header row.');

        $headers = array_map(fn ($header) => $this->normalizeHeader((string) $header), $headers);
        $dateIndex = array_search('date', $headers, true);
        $amountIndex = array_search('amount', $headers, true);
        abort_if($dateIndex === false || $amountIndex === false, 422, 'CSV must contain date and amount columns.');

        $descriptionIndex = $this->firstHeaderIndex($headers, ['payee', 'description', 'title', 'merchant']);
        $categoryIndex = $this->firstHeaderIndex($headers, ['category', 'category_name']);
        $typeIndex = $this->firstHeaderIndex($headers, ['type', 'transaction_type']);
        $notesIndex = $this->firstHeaderIndex($headers, ['notes', 'memo']);

        $imported = 0;
        $skipped = 0;
        $errors = [];
        $rowNumber = 1;

        DB::transaction(function () use (
            $handle,
            $household,
            $request,
            $validated,
            $dateIndex,
            $amountIndex,
            $descriptionIndex,
            $categoryIndex,
            $typeIndex,
            $notesIndex,
            &$imported,
            &$skipped,
            &$errors,
            &$rowNumber
        ): void {
            while (($row = fgetcsv($handle, escape: '\\')) !== false) {
                $rowNumber++;
                if (count($row) === 1 && trim((string) $row[0]) === '') {
                    continue;
                }

                try {
                    $dateValue = trim((string) ($row[$dateIndex] ?? ''));
                    $amountValue = trim((string) ($row[$amountIndex] ?? ''));
                    $date = $dateValue === '' ? null : Carbon::parse($dateValue);
                    $amountCents = $this->parseAmountCents($amountValue);

                    if (! $date || $amountCents <= 0) {
                        throw new \RuntimeException('Invalid date or amount.');
                    }

                    $payee = $descriptionIndex === false ? 'Imported transaction' : trim((string) ($row[$descriptionIndex] ?? 'Imported transaction'));
                    $type = $typeIndex === false
                        ? 'expense'
                        : strtolower(trim((string) ($row[$typeIndex] ?? 'expense')));
                    if (! in_array($type, ['income', 'expense', 'transfer'], true)) {
                        $type = $amountValue !== '' && str_starts_with(trim($amountValue), '-') ? 'expense' : 'income';
                    }

                    $dateString = $date->toDateString();
                    $hash = Transaction::computeImportHash($dateString, $amountCents, $payee, (int) $validated['account_id']);
                    if ($household->transactions()->where('import_hash', $hash)->exists()) {
                        $skipped++;

                        continue;
                    }

                    $categoryId = null;
                    if ($categoryIndex !== false) {
                        $categoryName = trim((string) ($row[$categoryIndex] ?? ''));
                        if ($categoryName !== '') {
                            $category = Category::where(function ($query) use ($household) {
                                $query->where('household_id', $household->id)->orWhereNull('household_id');
                            })->whereRaw('LOWER(name) = ?', [strtolower($categoryName)])->first();
                            $categoryId = $category?->id;
                        }
                    }

                    $notes = $notesIndex === false ? null : (trim((string) ($row[$notesIndex] ?? '')) ?: null);
                    $household->transactions()->create([
                        'account_id' => $validated['account_id'],
                        'category_id' => $categoryId,
                        'created_by' => $request->user()->id,
                        'amount_cents' => $amountCents,
                        'type' => $type,
                        'date' => $dateString,
                        'payee' => $payee ?: 'Imported transaction',
                        'notes' => $notes,
                        'import_hash' => $hash,
                    ]);
                    $imported++;
                } catch (\Throwable $error) {
                    $errors[] = ['row' => $rowNumber, 'message' => $error->getMessage()];
                }
            }
        });

        fclose($handle);

        return response()->json([
            'data' => [
                'imported' => $imported,
                'skipped' => $skipped,
                'errors' => $errors,
            ],
        ]);
    }

    private function normalizeHeader(string $header): string
    {
        return strtolower(trim(preg_replace('/[^a-z0-9]+/i', '_', $header) ?? $header, '_'));
    }

    private function firstHeaderIndex(array $headers, array $names): int|false
    {
        foreach ($names as $name) {
            $index = array_search($name, $headers, true);
            if ($index !== false) {
                return $index;
            }
        }

        return false;
    }

    private function parseAmountCents(string $value): int
    {
        $normalized = preg_replace('/[^0-9.,-]/', '', $value) ?? '';
        $normalized = str_replace(',', '', $normalized);
        $normalized = trim($normalized);
        if ($normalized === '' || ! is_numeric($normalized)) {
            return 0;
        }

        return (int) round(abs((float) $normalized) * 100);
    }
}
