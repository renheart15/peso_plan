<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Goal;
use App\Models\Household;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;

class GoalController extends Controller
{
    /**
     * List all savings goals for a household.
     */
    public function index(Household $household): JsonResponse
    {
        Gate::authorize('view', $household);

        $goals = $household->goals()
            ->orderBy('target_date')
            ->get();

        return response()->json(['data' => $goals]);
    }

    /**
     * Create a new savings goal.
     */
    public function store(Request $request, Household $household): JsonResponse
    {
        Gate::authorize('manageBudget', $household);

        $validated = $request->validate([
            'name' => ['required', 'string', 'max:120'],
            'target_cents' => ['required', 'integer', 'min:1'],
            'current_cents' => ['sometimes', 'integer', 'min:0'],
            'due_date' => ['nullable', 'date'],
            'type' => ['required', 'string', 'in:savings,debt'],
            'notes' => ['nullable', 'string', 'max:500'],
        ]);

        $goal = $household->goals()->create(array_merge(
            $validated,
            ['current_cents' => $validated['current_cents'] ?? 0]
        ));

        return response()->json(['data' => $goal], 201);
    }

    /**
     * Show a single savings goal.
     */
    public function show(Household $household, Goal $goal): JsonResponse
    {
        Gate::authorize('view', $household);
        $this->authorizeGoal($household, $goal);

        return response()->json(['data' => $goal]);
    }

    /**
     * Update a savings goal (partial or full).
     */
    public function update(Request $request, Household $household, Goal $goal): JsonResponse
    {
        Gate::authorize('manageBudget', $household);
        $this->authorizeGoal($household, $goal);

        $validated = $request->validate([
            'name' => ['sometimes', 'string', 'max:120'],
            'target_cents' => ['sometimes', 'integer', 'min:1'],
            'current_cents' => ['sometimes', 'integer', 'min:0'],
            'due_date' => ['nullable', 'date'],
            'type' => ['sometimes', 'string', 'in:savings,debt'],
            'notes' => ['nullable', 'string', 'max:500'],
        ]);

        $goal->update($validated);

        return response()->json(['data' => $goal->fresh()]);
    }

    /**
     * Delete a savings goal.
     */
    public function destroy(Household $household, Goal $goal): JsonResponse
    {
        Gate::authorize('manageBudget', $household);
        $this->authorizeGoal($household, $goal);

        $goal->delete();

        return response()->json(null, 204);
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private function authorizeGoal(Household $household, Goal $goal): void
    {
        abort_unless($goal->household_id === $household->id, 404);
    }
}
