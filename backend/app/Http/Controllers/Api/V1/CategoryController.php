<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Household;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function index(Request $request, Household $household): JsonResponse
    {
        abort_unless($household->isMember($request->user()), 403);
        // Include system categories (household_id = null) plus household's own
        $categories = Category::where(function ($q) use ($household) {
            $q->where('household_id', $household->id)
                ->orWhereNull('household_id');
        })->get();

        return response()->json(['data' => $categories]);
    }

    public function store(Request $request, Household $household): JsonResponse
    {
        abort_unless($household->canEdit($request->user()), 403);
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'type' => ['required', 'in:income,expense'],
            'parent_id' => ['nullable', 'exists:categories,id'],
            'icon' => ['nullable', 'string', 'max:50'],
            'color_hex' => ['nullable', 'string', 'regex:/^#[0-9A-Fa-f]{6}$/'],
        ]);
        $category = $household->categories()->create($validated);

        return response()->json(['data' => $category], 201);
    }

    public function update(Request $request, Household $household, Category $category): JsonResponse
    {
        abort_unless($household->canEdit($request->user()), 403);
        abort_if($category->household_id !== $household->id, 403, 'Cannot edit system categories.');
        $validated = $request->validate([
            'name' => ['sometimes', 'string', 'max:255'],
            'icon' => ['nullable', 'string'],
            'color_hex' => ['nullable', 'string', 'regex:/^#[0-9A-Fa-f]{6}$/'],
        ]);
        $category->update($validated);

        return response()->json(['data' => $category]);
    }

    public function destroy(Request $request, Household $household, Category $category): JsonResponse
    {
        abort_unless($household->canEdit($request->user()), 403);
        abort_if($category->is_system, 403, 'Cannot delete system categories.');
        abort_if($category->household_id !== $household->id, 403);
        $category->delete();

        return response()->json(null, 204);
    }
}
