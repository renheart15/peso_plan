<?php

namespace Tests\Feature;

use App\Models\Account;
use App\Models\Household;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class TransactionApiTest extends TestCase
{
    use RefreshDatabase;

    private function createHouseholdWithOwner(): array
    {
        $owner = User::factory()->create();
        $household = Household::create(['name' => 'Test Household', 'owner_id' => $owner->id]);
        $household->members()->attach($owner->id, ['role' => 'owner']);
        $owner->update(['current_household_id' => $household->id]);
        $account = Account::create([
            'household_id' => $household->id,
            'name' => 'Checking',
            'type' => 'checking',
            'balance_cents' => 100000,
            'currency_code' => 'PHP',
        ]);

        return [$owner, $household, $account];
    }

    public function test_owner_can_create_a_transaction(): void
    {
        [$owner, $household, $account] = $this->createHouseholdWithOwner();
        Sanctum::actingAs($owner);

        $response = $this->postJson("/api/v1/households/{$household->id}/transactions", [
            'account_id' => $account->id,
            'amount_cents' => 250000,
            'type' => 'expense',
            'date' => '2026-10-28',
            'payee' => 'SM Hypermarket',
            'notes' => 'Groceries',
        ]);

        $response->assertCreated()->assertJsonPath('data.amount_cents', 250000);
        $this->assertDatabaseHas('transactions', ['payee' => 'SM Hypermarket', 'amount_cents' => 250000]);
    }

    public function test_viewer_cannot_create_a_transaction(): void
    {
        [$owner, $household, $account] = $this->createHouseholdWithOwner();
        $viewer = User::factory()->create();
        $household->members()->attach($viewer->id, ['role' => 'viewer']);
        Sanctum::actingAs($viewer);

        $response = $this->postJson("/api/v1/households/{$household->id}/transactions", [
            'account_id' => $account->id,
            'amount_cents' => 10000,
            'type' => 'expense',
            'date' => '2026-10-28',
        ]);

        $response->assertForbidden();
    }

    public function test_csv_import_is_deduplicated_and_returns_counts(): void
    {
        [$owner, $household, $account] = $this->createHouseholdWithOwner();
        Sanctum::actingAs($owner);

        $csv = "date,description,amount,type,category,notes\n2026-10-28,SM Hypermarket,-2500.00,expense,Groceries,Weekly groceries\n2026-10-28,SM Hypermarket,-2500.00,expense,Groceries,Weekly groceries\n";
        $file = UploadedFile::fake()->createWithContent('transactions.csv', $csv);

        $response = $this->post("/api/v1/households/{$household->id}/transactions/import", [
            'account_id' => $account->id,
            'file' => $file,
        ]);

        $response->assertOk()
            ->assertJsonPath('data.imported', 1)
            ->assertJsonPath('data.skipped', 1);
        $this->assertSame(1, Transaction::where('household_id', $household->id)->count());
    }
}
