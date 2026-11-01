<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Account;
use App\Models\Household;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AccountController extends Controller
{
    public function index(Request $request, Household $household): JsonResponse
    {
        $this->requireMember($request->user(), $household);

        return response()->json(['data' => $household->accounts()->where('is_active', true)->get()]);
    }

    public function store(Request $request, Household $household): JsonResponse
    {
        $this->requireEdit($request->user(), $household);
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'type' => ['required', 'in:checking,savings,credit_card,cash,loan'],
            'balance_cents' => ['required', 'integer'],
            'currency_code' => ['nullable', 'string', 'size:3'],
        ]);
        $account = $household->accounts()->create($validated);

        return response()->json(['data' => $account], 201);
    }

    public function show(Request $request, Household $household, Account $account): JsonResponse
    {
        $this->requireMember($request->user(), $household);
        $this->assertBelongs($account, $household);

        return response()->json(['data' => $account]);
    }

    public function update(Request $request, Household $household, Account $account): JsonResponse
    {
        $this->requireEdit($request->user(), $household);
        $this->assertBelongs($account, $household);
        $validated = $request->validate([
            'name' => ['sometimes', 'string', 'max:255'],
            'balance_cents' => ['sometimes', 'integer'],
            'is_active' => ['sometimes', 'boolean'],
        ]);
        $account->update($validated);

        return response()->json(['data' => $account]);
    }

    public function destroy(Request $request, Household $household, Account $account): JsonResponse
    {
        $this->requireEdit($request->user(), $household);
        $this->assertBelongs($account, $household);
        $account->update(['is_active' => false]); // soft-deactivate

        return response()->json(null, 204);
    }

    private function requireMember($user, Household $h): void
    {
        abort_unless($h->isMember($user), 403);
    }

    private function requireEdit($user, Household $h): void
    {
        abort_unless($h->canEdit($user), 403, 'Edit permission required.');
    }

    private function assertBelongs(Account $account, Household $household): void
    {
        abort_if($account->household_id !== $household->id, 404);
    }
}
