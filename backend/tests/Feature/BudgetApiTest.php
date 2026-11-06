<?php

namespace Tests\Feature;

use App\Models\Account;
use App\Models\Budget;
use App\Models\Category;
use App\Models\Household;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class BudgetApiTest extends TestCase
{
    use RefreshDatabase;

    // ── Helpers ──────────────────────────────────────────────────

    /**
     * Create a household with an owner, an account, and a category.
     * Returns [$household, $owner, $account, $category].
     */
    private function createHouseholdWithOwner(): array
    {
        $owner = User::factory()->create();
        $household = Household::create(['name' => 'Budget Household', 'owner_id' => $owner->id]);
        $household->members()->attach($owner->id, ['role' => 'owner']);
        $owner->update(['current_household_id' => $household->id]);

        $account = Account::create([
            'household_id'  => $household->id,
            'name'          => 'Checking',
            'type'          => 'checking',
            'balance_cents' => 50000,
            'currency_code' => 'PHP',
        ]);

        $category = Category::create([
            'household_id' => $household->id,
            'name'         => 'Groceries',
            'type'         => 'expense',
            'is_system'    => false,
        ]);

        return [$household, $owner, $account, $category];
    }

    /**
     * Attach an extra user to the household with the given role.
     */
    private function addMember(Household $household, string $role): User
    {
        $user = User::factory()->create();
        $household->members()->attach($user->id, ['role' => $role]);

        return $user;
    }

    // ── Tests ────────────────────────────────────────────────────

    public function test_member_can_list_budgets(): void
    {
        [$household, $owner, , $category] = $this->createHouseholdWithOwner();
        Budget::create([
            'household_id'  => $household->id,
            'category_id'   => $category->id,
            'year'          => 2026,
            'month'         => 11,
            'planned_cents' => 10000,
        ]);
        Sanctum::actingAs($owner);

        $this->getJson("/api/v1/households/{$household->id}/budgets?year=2026&month=11")
            ->assertOk()
            ->assertJsonStructure(['data' => [['id', 'planned_cents']]]);
    }

    public function test_non_member_cannot_list_budgets(): void
    {
        [$household] = $this->createHouseholdWithOwner();
        $outsider = User::factory()->create();
        Sanctum::actingAs($outsider);

        $this->getJson("/api/v1/households/{$household->id}/budgets?year=2026&month=11")
            ->assertForbidden();
    }

    public function test_owner_can_create_budget(): void
    {
        [$household, $owner, , $category] = $this->createHouseholdWithOwner();
        Sanctum::actingAs($owner);

        $this->postJson("/api/v1/households/{$household->id}/budgets", [
            'category_id'   => $category->id,
            'year'          => 2026,
            'month'         => 11,
            'planned_cents' => 15000,
        ])->assertCreated()
            ->assertJsonPath('data.planned_cents', 15000);

        $this->assertDatabaseHas('budgets', [
            'household_id'  => $household->id,
            'category_id'   => $category->id,
            'year'          => 2026,
            'month'         => 11,
            'planned_cents' => 15000,
        ]);
    }

    public function test_viewer_cannot_create_budget(): void
    {
        [$household, , , $category] = $this->createHouseholdWithOwner();
        $viewer = $this->addMember($household, 'viewer');
        Sanctum::actingAs($viewer);

        $this->postJson("/api/v1/households/{$household->id}/budgets", [
            'category_id'   => $category->id,
            'year'          => 2026,
            'month'         => 11,
            'planned_cents' => 15000,
        ])->assertForbidden();
    }

    public function test_owner_can_update_budget(): void
    {
        [$household, $owner, , $category] = $this->createHouseholdWithOwner();
        $budget = Budget::create([
            'household_id'  => $household->id,
            'category_id'   => $category->id,
            'year'          => 2026,
            'month'         => 11,
            'planned_cents' => 10000,
        ]);
        Sanctum::actingAs($owner);

        $this->putJson("/api/v1/households/{$household->id}/budgets/{$budget->id}", [
            'planned_cents' => 20000,
        ])->assertOk()
            ->assertJsonPath('data.planned_cents', 20000);

        $this->assertDatabaseHas('budgets', ['id' => $budget->id, 'planned_cents' => 20000]);
    }

    public function test_owner_can_delete_budget(): void
    {
        [$household, $owner, , $category] = $this->createHouseholdWithOwner();
        $budget = Budget::create([
            'household_id'  => $household->id,
            'category_id'   => $category->id,
            'year'          => 2026,
            'month'         => 11,
            'planned_cents' => 10000,
        ]);
        Sanctum::actingAs($owner);

        $this->deleteJson("/api/v1/households/{$household->id}/budgets/{$budget->id}")
            ->assertNoContent();

        $this->assertDatabaseMissing('budgets', ['id' => $budget->id]);
    }

    public function test_budget_is_upserted_not_duplicated(): void
    {
        [$household, $owner, , $category] = $this->createHouseholdWithOwner();
        Sanctum::actingAs($owner);

        $payload = [
            'category_id'   => $category->id,
            'year'          => 2026,
            'month'         => 11,
            'planned_cents' => 5000,
        ];

        // First POST — creates record
        $this->postJson("/api/v1/households/{$household->id}/budgets", $payload)
            ->assertCreated();

        // Second POST with updated amount — should update, not insert
        $this->postJson("/api/v1/households/{$household->id}/budgets", array_merge($payload, [
            'planned_cents' => 9999,
        ]))->assertCreated()
            ->assertJsonPath('data.planned_cents', 9999);

        // Only one row should exist
        $count = Budget::where([
            'household_id' => $household->id,
            'category_id'  => $category->id,
            'year'         => 2026,
            'month'        => 11,
        ])->count();

        $this->assertSame(1, $count);
    }
}
