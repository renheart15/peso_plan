<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Household;
use App\Models\RecurringBill;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\Rule;

class RecurringBillController extends Controller
{
    /**
     * List all recurring bills for a household.
     */
    public function index(Household $household): JsonResponse
    {
        Gate::authorize('view', $household);

        $bills = $household->recurringBills()
            ->with('category')
            ->orderBy('next_due_date')
            ->get();

        return response()->json(['data' => $bills]);
    }

    /**
     * Create a new recurring bill.
     */
    public function store(Request $request, Household $household): JsonResponse
    {
        Gate::authorize('manageBudget', $household);

        $validated = $request->validate([
            'name' => ['required', 'string', 'max:120'],
            'amount_cents' => ['required', 'integer', 'min:1'],
            'frequency' => ['required', Rule::in(['daily', 'weekly', 'biweekly', 'monthly', 'quarterly', 'yearly'])],
            'next_due' => ['required', 'date'],
            'category_id' => ['nullable', 'integer', 'exists:categories,id'],
            'account_id' => ['nullable', 'integer', 'exists:accounts,id'],
            'auto_pay' => ['sometimes', 'boolean'],
            'notes' => ['nullable', 'string', 'max:500'],
        ]);

        $bill = $household->recurringBills()->create(array_merge(
            $validated,
            ['auto_pay' => $validated['auto_pay'] ?? false]
        ));

        return response()->json(['data' => $bill->load('category')], 201);
    }

    /**
     * Show a single recurring bill.
     */
    public function show(Household $household, RecurringBill $recurringBill): JsonResponse
    {
        Gate::authorize('view', $household);
        $this->authorizeBill($household, $recurringBill);

        return response()->json(['data' => $recurringBill->load('category')]);
    }

    /**
     * Update a recurring bill.
     */
    public function update(Request $request, Household $household, RecurringBill $recurringBill): JsonResponse
    {
        Gate::authorize('manageBudget', $household);
        $this->authorizeBill($household, $recurringBill);

        $validated = $request->validate([
            'name' => ['sometimes', 'string', 'max:120'],
            'amount_cents' => ['sometimes', 'integer', 'min:1'],
            'frequency' => ['sometimes', Rule::in(['daily', 'weekly', 'biweekly', 'monthly', 'quarterly', 'yearly'])],
            'next_due' => ['sometimes', 'date'],
            'category_id' => ['nullable', 'integer', 'exists:categories,id'],
            'account_id' => ['nullable', 'integer', 'exists:accounts,id'],
            'auto_pay' => ['sometimes', 'boolean'],
            'notes' => ['nullable', 'string', 'max:500'],
            'is_active' => ['sometimes', 'boolean'],
        ]);

        $recurringBill->update($validated);

        return response()->json(['data' => $recurringBill->fresh()->load('category')]);
    }

    /**
     * Delete a recurring bill.
     */
    public function destroy(Household $household, RecurringBill $recurringBill): JsonResponse
    {
        Gate::authorize('manageBudget', $household);
        $this->authorizeBill($household, $recurringBill);

        $recurringBill->delete();

        return response()->json(null, 204);
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private function authorizeBill(Household $household, RecurringBill $recurringBill): void
    {
        abort_unless($recurringBill->household_id === $household->id, 404);
    }
}
