<?php

namespace Database\Seeders;

use App\Models\Account;
use App\Models\Budget;
use App\Models\Category;
use App\Models\Goal;
use App\Models\Household;
use App\Models\RecurringBill;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the database with realistic demo data for Peso Plan.
     *
     * Demo credentials:
     *   Email:    demo@pesoplan.app
     *   Password: password
     */
    public function run(): void
    {
        // ── 1. Demo User ──────────────────────────────────────────────────────
        $user = User::firstOrCreate(
            ['email' => 'demo@pesoplan.app'],
            [
                'name' => 'Juan dela Cruz',
                'password' => Hash::make('password'),
                'email_verified_at' => now(),
            ]
        );

        // ── 2. Household ──────────────────────────────────────────────────────
        $household = Household::create([
            'name' => 'Dela Cruz Family',
            'owner_id' => $user->id,
        ]);

        // Attach user as owner
        $household->members()->attach($user->id, ['role' => 'owner']);

        // Set current household on user
        $user->update(['current_household_id' => $household->id]);

        // ── 3. Accounts ───────────────────────────────────────────────────────
        $checking = Account::create([
            'household_id' => $household->id,
            'name' => 'BDO Checking',
            'type' => 'checking',
            'balance_cents' => 45_000_00, // ₱45,000.00
            'currency_code' => 'PHP',
        ]);

        $savings = Account::create([
            'household_id' => $household->id,
            'name' => 'BPI Savings',
            'type' => 'savings',
            'balance_cents' => 120_000_00, // ₱120,000.00
            'currency_code' => 'PHP',
        ]);

        $cash = Account::create([
            'household_id' => $household->id,
            'name' => 'Cash on Hand',
            'type' => 'cash',
            'balance_cents' => 3_500_00, // ₱3,500.00
            'currency_code' => 'PHP',
        ]);

        // ── 4. Categories ─────────────────────────────────────────────────────
        $catMap = [];

        $categoryData = [
            // Income
            ['name' => 'Salary',          'type' => 'income',  'icon' => 'attach_money',    'color_hex' => '#22C55E'],
            ['name' => 'Freelance',        'type' => 'income',  'icon' => 'laptop',           'color_hex' => '#10B981'],
            ['name' => 'Investment',       'type' => 'income',  'icon' => 'trending_up',      'color_hex' => '#06B6D4'],

            // Housing
            ['name' => 'Rent',             'type' => 'expense', 'icon' => 'home',             'color_hex' => '#6366F1'],
            ['name' => 'Electricity',      'type' => 'expense', 'icon' => 'bolt',             'color_hex' => '#F59E0B'],
            ['name' => 'Water',            'type' => 'expense', 'icon' => 'water_drop',       'color_hex' => '#3B82F6'],
            ['name' => 'Internet',         'type' => 'expense', 'icon' => 'wifi',             'color_hex' => '#8B5CF6'],

            // Food
            ['name' => 'Groceries',        'type' => 'expense', 'icon' => 'shopping_basket',  'color_hex' => '#EC4899'],
            ['name' => 'Dining Out',       'type' => 'expense', 'icon' => 'restaurant',       'color_hex' => '#F97316'],

            // Transport
            ['name' => 'Transportation',   'type' => 'expense', 'icon' => 'directions_bus',   'color_hex' => '#14B8A6'],
            ['name' => 'Fuel',             'type' => 'expense', 'icon' => 'local_gas_station', 'color_hex' => '#EF4444'],

            // Personal
            ['name' => 'Health',           'type' => 'expense', 'icon' => 'favorite',         'color_hex' => '#E11D48'],
            ['name' => 'Entertainment',    'type' => 'expense', 'icon' => 'movie',            'color_hex' => '#A855F7'],
            ['name' => 'Shopping',         'type' => 'expense', 'icon' => 'shopping_bag',     'color_hex' => '#F43F5E'],
            ['name' => 'Education',        'type' => 'expense', 'icon' => 'school',           'color_hex' => '#0EA5E9'],

            // Savings & Goals
            ['name' => 'Savings',          'type' => 'expense', 'icon' => 'savings',          'color_hex' => '#22D3EE'],
            ['name' => 'Emergency Fund',   'type' => 'expense', 'icon' => 'emergency',        'color_hex' => '#F59E0B'],

            // Miscellaneous
            ['name' => 'Miscellaneous',    'type' => 'expense', 'icon' => 'more_horiz',       'color_hex' => '#6B7280'],
        ];

        foreach ($categoryData as $cat) {
            $catMap[$cat['name']] = Category::create(array_merge($cat, ['household_id' => $household->id]));
        }

        // ── 5. Monthly Budgets (current month) ────────────────────────────────
        $year = (int) now()->format('Y');
        $month = (int) now()->format('n');

        $budgetData = [
            'Rent' => 15_000_00,
            'Groceries' => 8_000_00,
            'Electricity' => 2_500_00,
            'Water' => 500_00,
            'Internet' => 1_500_00,
            'Transportation' => 3_000_00,
            'Dining Out' => 2_000_00,
            'Health' => 1_500_00,
            'Entertainment' => 1_000_00,
            'Shopping' => 2_000_00,
            'Savings' => 5_000_00,
            'Miscellaneous' => 2_000_00,
        ];

        foreach ($budgetData as $catName => $cents) {
            Budget::create([
                'household_id' => $household->id,
                'category_id' => $catMap[$catName]->id,
                'year' => $year,
                'month' => $month,
                'planned_cents' => $cents,
            ]);
        }

        // ── 6. Sample Transactions (past 60 days) ─────────────────────────────
        $transactions = [
            // Income
            ['date' => -30, 'type' => 'income',  'cat' => 'Salary',        'amount' => 35_000_00, 'payee' => 'ACME Corp',       'account' => $checking, 'notes' => 'Monthly salary'],
            ['date' => -30, 'type' => 'income',  'cat' => 'Freelance',     'amount' => 5_000_00,  'payee' => 'Client A',        'account' => $checking, 'notes' => 'Logo design project'],
            ['date' => -1,  'type' => 'income',  'cat' => 'Salary',        'amount' => 35_000_00, 'payee' => 'ACME Corp',       'account' => $checking, 'notes' => 'Monthly salary'],

            // Housing
            ['date' => -29, 'type' => 'expense', 'cat' => 'Rent',          'amount' => 15_000_00, 'payee' => 'Landlord',        'account' => $checking],
            ['date' => -14, 'type' => 'expense', 'cat' => 'Electricity',   'amount' => 2_100_00,  'payee' => 'Meralco',         'account' => $checking],
            ['date' => -14, 'type' => 'expense', 'cat' => 'Water',         'amount' => 450_00,    'payee' => 'MWSS',            'account' => $checking],
            ['date' => -28, 'type' => 'expense', 'cat' => 'Internet',      'amount' => 1_299_00,  'payee' => 'PLDT',            'account' => $checking],

            // Food
            ['date' => -28, 'type' => 'expense', 'cat' => 'Groceries',     'amount' => 3_200_00,  'payee' => 'SM Supermarket',  'account' => $cash],
            ['date' => -21, 'type' => 'expense', 'cat' => 'Groceries',     'amount' => 2_800_00,  'payee' => 'Robinsons',       'account' => $cash],
            ['date' => -14, 'type' => 'expense', 'cat' => 'Groceries',     'amount' => 1_900_00,  'payee' => 'Puregold',        'account' => $cash],
            ['date' => -7,  'type' => 'expense', 'cat' => 'Groceries',     'amount' => 2_400_00,  'payee' => 'SM Supermarket',  'account' => $cash],
            ['date' => -25, 'type' => 'expense', 'cat' => 'Dining Out',    'amount' => 850_00,    'payee' => 'Jollibee',        'account' => $cash],
            ['date' => -18, 'type' => 'expense', 'cat' => 'Dining Out',    'amount' => 1_200_00,  'payee' => 'Mang Inasal',     'account' => $cash],
            ['date' => -10, 'type' => 'expense', 'cat' => 'Dining Out',    'amount' => 650_00,    'payee' => 'McDo',            'account' => $cash],

            // Transport
            ['date' => -27, 'type' => 'expense', 'cat' => 'Transportation', 'amount' => 500_00,    'payee' => 'Grab',            'account' => $checking],
            ['date' => -20, 'type' => 'expense', 'cat' => 'Transportation', 'amount' => 700_00,    'payee' => 'MRT + Bus',       'account' => $cash],
            ['date' => -15, 'type' => 'expense', 'cat' => 'Fuel',          'amount' => 1_800_00,  'payee' => 'Petron',          'account' => $checking],

            // Personal
            ['date' => -22, 'type' => 'expense', 'cat' => 'Health',        'amount' => 500_00,    'payee' => 'Mercury Drug',    'account' => $cash],
            ['date' => -16, 'type' => 'expense', 'cat' => 'Entertainment', 'amount' => 750_00,    'payee' => 'Netflix',         'account' => $checking],
            ['date' => -12, 'type' => 'expense', 'cat' => 'Shopping',      'amount' => 1_800_00,  'payee' => 'Lazada',          'account' => $checking],
            ['date' => -5,  'type' => 'expense', 'cat' => 'Shopping',      'amount' => 600_00,    'payee' => 'Shopee',          'account' => $checking],

            // Savings contribution (transfer to savings)
            ['date' => -28, 'type' => 'expense', 'cat' => 'Savings',       'amount' => 5_000_00,  'payee' => 'BPI Savings',     'account' => $checking, 'notes' => 'Monthly savings transfer'],
        ];

        foreach ($transactions as $t) {
            Transaction::create([
                'household_id' => $household->id,
                'account_id' => $t['account']->id,
                'category_id' => $catMap[$t['cat']]->id,
                'created_by' => $user->id,
                'type' => $t['type'],
                'amount_cents' => $t['amount'],
                'payee' => $t['payee'],
                'notes' => $t['notes'] ?? null,
                'date' => now()->addDays($t['date'])->toDateString(),
            ]);
        }

        // ── 7. Savings Goals ─────────────────────────────────────────────────
        Goal::create([
            'household_id' => $household->id,
            'name' => 'Emergency Fund',
            'type' => 'savings',
            'target_cents' => 100_000_00,
            'current_cents' => 42_000_00,
            'due_date' => now()->addMonths(8)->toDateString(),
            'notes' => 'Target: 3 months of expenses',
        ]);

        Goal::create([
            'household_id' => $household->id,
            'name' => 'Vacation Fund',
            'type' => 'savings',
            'target_cents' => 50_000_00,
            'current_cents' => 12_000_00,
            'due_date' => now()->addMonths(6)->toDateString(),
            'notes' => 'Boracay trip with family',
        ]);

        Goal::create([
            'household_id' => $household->id,
            'name' => 'New Laptop',
            'type' => 'savings',
            'target_cents' => 70_000_00,
            'current_cents' => 25_000_00,
            'due_date' => now()->addMonths(5)->toDateString(),
        ]);

        // ── 8. Recurring Bills ────────────────────────────────────────────────
        RecurringBill::create([
            'household_id' => $household->id,
            'name' => 'Rent',
            'amount_cents' => 15_000_00,
            'frequency' => 'monthly',
            'next_due' => now()->addMonth()->startOfMonth()->toDateString(),
            'category_id' => $catMap['Rent']->id,
            'auto_pay' => false,
        ]);

        RecurringBill::create([
            'household_id' => $household->id,
            'name' => 'PLDT Fiber',
            'amount_cents' => 1_299_00,
            'frequency' => 'monthly',
            'next_due' => now()->addDays(5)->toDateString(),
            'category_id' => $catMap['Internet']->id,
            'auto_pay' => true,
        ]);

        RecurringBill::create([
            'household_id' => $household->id,
            'name' => 'Netflix',
            'amount_cents' => 549_00,
            'frequency' => 'monthly',
            'next_due' => now()->addDays(14)->toDateString(),
            'category_id' => $catMap['Entertainment']->id,
            'auto_pay' => true,
        ]);

        RecurringBill::create([
            'household_id' => $household->id,
            'name' => 'Meralco Bill',
            'amount_cents' => 2_500_00,
            'frequency' => 'monthly',
            'next_due' => now()->addDays(10)->toDateString(),
            'category_id' => $catMap['Electricity']->id,
            'auto_pay' => false,
        ]);

        $this->command->info('✅ Peso Plan demo data seeded successfully.');
        $this->command->line('   Email:    demo@pesoplan.app');
        $this->command->line('   Password: password');
    }
}
