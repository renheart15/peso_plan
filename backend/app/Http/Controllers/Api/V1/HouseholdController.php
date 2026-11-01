<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Household\CreateHouseholdRequest;
use App\Http\Requests\Household\InviteMemberRequest;
use App\Http\Requests\Household\UpdateHouseholdRequest;
use App\Http\Requests\Household\UpdateMemberRoleRequest;
use App\Models\Household;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class HouseholdController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $households = $request->user()
            ->households()
            ->withPivot('role')
            ->get()
            ->map(fn ($h) => [
                'id' => $h->id,
                'name' => $h->name,
                'role' => $h->pivot->role,
            ]);

        return response()->json(['data' => $households]);
    }

    public function store(CreateHouseholdRequest $request): JsonResponse
    {
        $user = $request->user();

        $household = Household::create([
            'name' => $request->name,
            'owner_id' => $user->id,
        ]);

        $household->members()->attach($user->id, ['role' => 'owner']);

        return response()->json(['data' => $this->payload($household, 'owner')], 201);
    }

    public function show(Request $request, Household $household): JsonResponse
    {
        $this->authorizeHousehold($request->user(), $household);

        $role = $household->members()
            ->where('users.id', $request->user()->id)
            ->value('role');

        return response()->json(['data' => $this->payload($household, $role)]);
    }

    public function summary(Request $request, Household $household): JsonResponse
    {
        $this->authorizeHousehold($request->user(), $household);

        $members = $household->members()
            ->select('users.id', 'users.name', 'household_members.role')
            ->get()
            ->map(function (User $member) {
                return [
                    'id' => $member->id,
                    'name' => $member->name,
                    'role' => $member->pivot->role ?? 'viewer',
                    'avatar' => $this->memberInitials($member->name),
                    'color_hex' => $this->memberColor($member->pivot->role ?? 'viewer'),
                ];
            })
            ->values();

        $sharedCashCents = (int) $household->accounts()->sum('balance_cents');

        $activity = $household->transactions()
            ->with('account', 'category')
            ->latest('created_at')
            ->limit(3)
            ->get()
            ->map(function (Transaction $transaction) {
                $title = $transaction->payee ? 'Transaction posted' : 'Account update';
                $amount = number_format(abs($transaction->amount_cents) / 100, 2, '.', ',');
                $detail = $transaction->payee
                    ? $transaction->payee.' • ₱'.$amount
                    : ($transaction->category?->name ?? 'Category update').' • ₱'.$amount;

                return [
                    'title' => $title,
                    'detail' => $detail,
                    'time_label' => $transaction->created_at?->diffForHumans(now(), true),
                ];
            })
            ->values();

        return response()->json([
            'data' => [
                'shared_cash_cents' => $sharedCashCents,
                'members' => $members,
                'activity' => $activity,
            ],
        ]);
    }

    public function update(UpdateHouseholdRequest $request, Household $household): JsonResponse
    {
        $this->authorizeEditHousehold($request->user(), $household);
        $household->update($request->validated());

        return response()->json(['data' => $this->payload($household)]);
    }

    public function destroy(Request $request, Household $household): JsonResponse
    {
        $this->authorizeOwnerHousehold($request->user(), $household);
        $household->delete();

        return response()->json(null, 204);
    }

    public function invite(InviteMemberRequest $request, Household $household): JsonResponse
    {
        $this->authorizeOwnerHousehold($request->user(), $household);

        $invitee = User::where('email', $request->email)->firstOrFail();

        if ($household->isMember($invitee)) {
            return response()->json(['message' => 'User is already a member.'], 422);
        }

        $household->members()->attach($invitee->id, ['role' => $request->role ?? 'viewer']);

        return response()->json(['message' => 'Member invited.']);
    }

    public function removeMember(Request $request, Household $household, User $user): JsonResponse
    {
        $this->authorizeOwnerHousehold($request->user(), $household);

        if ($user->id === $household->owner_id) {
            return response()->json(['message' => 'Cannot remove the owner.'], 422);
        }

        $household->members()->detach($user->id);

        return response()->json(null, 204);
    }

    public function updateRole(UpdateMemberRoleRequest $request, Household $household, User $user): JsonResponse
    {
        $this->authorizeOwnerHousehold($request->user(), $household);

        $household->members()->updateExistingPivot($user->id, ['role' => $request->role]);

        return response()->json(['message' => 'Role updated.']);
    }

    // ── Helpers ──────────────────────────────────────────────────

    private function payload(Household $household, ?string $role = null): array
    {
        return [
            'id' => $household->id,
            'name' => $household->name,
            'role' => $role,
        ];
    }

    private function memberInitials(string $name): string
    {
        $parts = preg_split('/\s+/', trim($name)) ?: ['U'];
        if (count($parts) === 1) {
            return strtoupper(substr($parts[0], 0, 1));
        }

        return strtoupper(substr($parts[0], 0, 1).substr(end($parts), 0, 1));
    }

    private function memberColor(?string $role): string
    {
        return match ($role) {
            'owner' => '#1A6B4A',
            'partner' => '#0E7C86',
            default => '#B7791F',
        };
    }

    private function authorizeHousehold(User $user, Household $household): void
    {
        abort_unless($household->isMember($user), 403, 'Not a member of this household.');
    }

    private function authorizeEditHousehold(User $user, Household $household): void
    {
        abort_unless($household->canEdit($user), 403, 'Edit permission required.');
    }

    private function authorizeOwnerHousehold(User $user, Household $household): void
    {
        abort_unless($household->isOwner($user), 403, 'Owner permission required.');
    }
}
