<?php

namespace Tests\Feature;

use App\Models\Household;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class HouseholdPermissionTest extends TestCase
{
    use RefreshDatabase;

    // ── Helpers ──────────────────────────────────────────────────

    /**
     * Create a household with an owner already attached as a member.
     */
    private function createHousehold(string $name = 'Test Household'): array
    {
        $owner = User::factory()->create();
        $household = Household::create(['name' => $name, 'owner_id' => $owner->id]);
        $household->members()->attach($owner->id, ['role' => 'owner']);
        $owner->update(['current_household_id' => $household->id]);

        return [$household, $owner];
    }

    /**
     * Create a user and attach them to the household with the given role.
     */
    private function addMember(Household $household, string $role): User
    {
        $user = User::factory()->create();
        $household->members()->attach($user->id, ['role' => $role]);
        $user->update(['current_household_id' => $household->id]);

        return $user;
    }

    // ── Tests ────────────────────────────────────────────────────

    public function test_non_member_cannot_read_household(): void
    {
        [$household] = $this->createHousehold();
        $outsider = User::factory()->create();
        Sanctum::actingAs($outsider);

        $this->getJson("/api/v1/households/{$household->id}")->assertForbidden();
    }

    public function test_viewer_can_read_household(): void
    {
        [$household] = $this->createHousehold();
        $viewer = $this->addMember($household, 'viewer');
        Sanctum::actingAs($viewer);

        $this->getJson("/api/v1/households/{$household->id}")->assertOk();
    }

    public function test_viewer_cannot_update_household(): void
    {
        [$household] = $this->createHousehold();
        $viewer = $this->addMember($household, 'viewer');
        Sanctum::actingAs($viewer);

        $this->putJson("/api/v1/households/{$household->id}", ['name' => 'New Name'])
            ->assertForbidden();
    }

    public function test_partner_cannot_update_household(): void
    {
        [$household] = $this->createHousehold();
        $partner = $this->addMember($household, 'partner');
        Sanctum::actingAs($partner);

        $this->putJson("/api/v1/households/{$household->id}", ['name' => 'New Name'])
            ->assertForbidden();
    }

    public function test_owner_can_update_household(): void
    {
        [$household, $owner] = $this->createHousehold();
        Sanctum::actingAs($owner);

        $this->putJson("/api/v1/households/{$household->id}", ['name' => 'Updated Name'])
            ->assertOk()
            ->assertJsonPath('data.name', 'Updated Name');
    }

    public function test_owner_can_invite_member(): void
    {
        [$household, $owner] = $this->createHousehold();
        $invitee = User::factory()->create();
        Sanctum::actingAs($owner);

        $this->postJson("/api/v1/households/{$household->id}/invite", [
            'email' => $invitee->email,
            'role'  => 'viewer',
        ])->assertOk();

        $this->assertTrue($household->fresh()->isMember($invitee));
    }

    public function test_non_owner_cannot_invite_member(): void
    {
        [$household] = $this->createHousehold();
        $viewer = $this->addMember($household, 'viewer');
        $outsider = User::factory()->create();
        Sanctum::actingAs($viewer);

        $this->postJson("/api/v1/households/{$household->id}/invite", [
            'email' => $outsider->email,
            'role'  => 'viewer',
        ])->assertForbidden();
    }

    public function test_owner_can_remove_member(): void
    {
        [$household, $owner] = $this->createHousehold();
        $viewer = $this->addMember($household, 'viewer');
        Sanctum::actingAs($owner);

        $this->deleteJson("/api/v1/households/{$household->id}/members/{$viewer->id}")
            ->assertNoContent();

        $this->assertFalse($household->fresh()->isMember($viewer));
    }

    public function test_owner_cannot_remove_themselves(): void
    {
        [$household, $owner] = $this->createHousehold();
        Sanctum::actingAs($owner);

        $this->deleteJson("/api/v1/households/{$household->id}/members/{$owner->id}")
            ->assertUnprocessable();
    }

    public function test_household_summary_accessible_by_member(): void
    {
        [$household, $owner] = $this->createHousehold();
        $viewer = $this->addMember($household, 'viewer');
        Sanctum::actingAs($viewer);

        $response = $this->getJson("/api/v1/households/{$household->id}/summary");

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    'shared_cash_cents',
                    'members',
                    'activity',
                ],
            ]);
    }
}
