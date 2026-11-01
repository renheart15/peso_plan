<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Budget;
use App\Models\Household;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BudgetController extends Controller
{
    public function index(Request $request, Household $household): JsonResponse
    {
        abort_unless($household->isMember($request->user()), 403);
        $validated = $request->validate([
            'year' => ['required', 'integer', 'min:2000', 'max:2100'],
            'month' => ['required', 'integer', 'min:1', 'max:12'],
        ]);

        $budgets = $household->budgets()
            ->with('category')
            ->where('year', $validated['year'])
            ->where('month', $validated['month'])
            ->get();

        return response()->json(['data' => $budgets]);
    }

    public function store(Request $request, Household $household): JsonResponse
    {
        abort_unless($household->canEdit($request->user()), 403);
        $validated = $request->validate([
            'category_id' => ['required', 'exists:categories,id'],
            'year' => ['required', 'integer'],
            'month' => ['required', 'integer', 'min:1', 'max:12'],
            'planned_cents' => ['required', 'integer', 'min:0'],
        ]);

        $budget = $household->budgets()->updateOrCreate(
            [
                'category_id' => $validated['category_id'],
                'year' => $validated['year'],
                'month' => $validated['month'],
            ],
            ['planned_cents' => $validated['planned_cents']]
        );

        return response()->json(['data' => $budget->load('category')], 201);
    }

    public function update(Request $request, Household $household, Budget $budget): JsonResponse
    {
        abort_unless($household->canEdit($request->user()), 403);
        abort_if($budget->household_id !== $household->id, 404);
        $validated = $request->validate(['planned_cents' => ['required', 'integer', 'min:0']]);
        $budget->update($validated);

        return response()->json(['data' => $budget->load('category')]);
    }

    public function destroy(Request $request, Household $household, Budget $budget): JsonResponse
    {
        abort_unless($household->canEdit($request->user()), 403);
        abort_if($budget->household_id !== $household->id, 404);
        $budget->delete();

        return response()->json(null, 204);
    }
}
