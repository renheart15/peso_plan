<?php

use App\Http\Controllers\Api\V1\AccountController;
use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\BudgetController;
use App\Http\Controllers\Api\V1\CategoryController;
use App\Http\Controllers\Api\V1\DeviceTokenController;
use App\Http\Controllers\Api\V1\GoalController;
use App\Http\Controllers\Api\V1\HouseholdController;
use App\Http\Controllers\Api\V1\NotificationController;
use App\Http\Controllers\Api\V1\RecurringBillController;
use App\Http\Controllers\Api\V1\ReportController;
use App\Http\Controllers\Api\V1\TransactionController;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Peso Plan API Routes  — v1
|--------------------------------------------------------------------------
|
| Auth endpoints are public; all others require a valid Sanctum token.
| Household-scoped resources enforce membership + role via policies.
|
*/

Route::prefix('v1')->group(function () {

    // ── Public auth routes ────────────────────────────────────────
    Route::prefix('auth')->group(function () {
        Route::get('email/verify/{id}/{hash}', function (Request $request, int $id, string $hash) {
            $user = User::findOrFail($id);
            if (! hash_equals(sha1($user->getEmailForVerification()), $hash)) {
                abort(403, 'Invalid verification link.');
            }
            if (! $user->hasVerifiedEmail()) {
                $user->markEmailAsVerified();
            }

            return response()->json(['message' => 'Email verified.']);
        })->middleware('signed')->name('verification.verify');

        Route::post('register', [AuthController::class, 'register']);
        Route::post('login', [AuthController::class, 'login']);
        Route::post('forgot-password', [AuthController::class, 'forgotPassword']);
        Route::post('reset-password', [AuthController::class, 'resetPassword']);
    });

    // ── Authenticated routes ─────────────────────────────────────
    Route::middleware('auth:sanctum')->group(function () {

        // Current user
        Route::get('auth/me', [AuthController::class, 'me']);
        Route::post('auth/logout', [AuthController::class, 'logout']);
        Route::post('auth/email/resend', [AuthController::class, 'resendVerification']);

        // Device tokens (FCM)
        Route::post('device-tokens', [DeviceTokenController::class, 'store']);
        Route::delete('device-tokens/{token}', [DeviceTokenController::class, 'destroy']);

        // Households
        Route::apiResource('households', HouseholdController::class);
        Route::get('households/{household}/summary', [HouseholdController::class, 'summary']);
        Route::post('households/{household}/invite', [HouseholdController::class, 'invite']);
        Route::delete('households/{household}/members/{user}', [HouseholdController::class, 'removeMember']);
        Route::put('households/{household}/members/{user}/role', [HouseholdController::class, 'updateRole']);

        // Household-scoped resources
        Route::prefix('households/{household}')->group(function () {

            // Accounts
            Route::apiResource('accounts', AccountController::class);

            // Categories
            Route::apiResource('categories', CategoryController::class);

            // Transactions
            Route::apiResource('transactions', TransactionController::class);
            Route::post('transactions/import', [TransactionController::class, 'import']);
            Route::post('transactions/bulk-categorize', [TransactionController::class, 'bulkCategorize']);

            // Budgets
            Route::apiResource('budgets', BudgetController::class);

            // Goals
            Route::apiResource('goals', GoalController::class);

            // Recurring bills
            Route::apiResource('recurring-bills', RecurringBillController::class);

            // Push notifications (send to household members)
            Route::post('notifications/send', [NotificationController::class, 'send']);

            // Reports
            Route::prefix('reports')->group(function () {
                Route::get('summary', [ReportController::class, 'summary']);
                Route::get('category-breakdown', [ReportController::class, 'categoryBreakdown']);
                Route::get('top-payees', [ReportController::class, 'topPayees']);
                Route::get('cash-flow', [ReportController::class, 'cashFlow']);
                Route::get('export.csv', [ReportController::class, 'exportCsv']);
                Route::get('export.pdf', [ReportController::class, 'exportPdf']);
            });
        });
    });
});
