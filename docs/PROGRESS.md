# Peso Plan — Progress Report

> **Last updated:** 2026-11-06T09:19+08:00
> **Current phase:** Phase 5 — Polish, Offline & Release (implementation and cloud deployment preparation complete; APNs, release signing, and physical-device QA remain external prerequisites)

---

## Latest Update

- Prepared the Laravel API for free cloud deployment on Render with a Docker image, PostgreSQL support, Apache configuration, automatic migrations, and the `/up` health endpoint.
- Added a Render Blueprint in `render.yaml`; the expected service is `peso-plan-api` with a Docker context rooted at `backend/`.
- Added build-time Flutter API configuration with `--dart-define=API_BASE_URL=...`; production builds no longer need a source-code change to target a deployed backend.
- Configured the Firebase Android and iOS app registrations for package/bundle ID `com.pesoplan.app` using Firebase project `peso-plan`.
- Moved the Flutter SDK out of a Windows username path and updated `android/local.properties`, allowing Android tooling to avoid paths containing spaces.
- Added Android core-library desugaring and Android compile SDK 36 support required by notification and file-picker dependencies.
- `flutter analyze` passes with 0 issues, and `flutter build apk --debug` produces an Android debug APK successfully.
- Removed the missing Inter asset declarations because the project currently uses `google_fonts` rather than bundled font files.

- Completed Phase 5 implementation: added real backend CSV/PDF exports, signed email-verification routing, auth feature coverage, report date-column/color-column fixes, and strengthened logout handling.
- Added DomPDF to Laravel for downloadable PDF transaction exports and connected Flutter export sharing to the live CSV/PDF API endpoints.
- Registered the existing `routes/api.php` file in Laravel's bootstrap configuration and verified all `/api/v1` routes; the Laravel suite now includes auth and transaction API coverage.
- Installed PHP 8.5 and Composer 2.8 in the Windows development environment and installed Laravel Boost.
- Fixed the manual transaction API contract: expense/income amounts are now sent as positive integer cents as required by Laravel, and the selected account is resolved to its API `account_id`.
- Fixed API transaction parsing so positive expense amounts from Laravel are displayed as negative values in app totals and transaction lists.
- Implemented the CSV transaction import API with header validation, date/amount parsing, category matching, SHA-256 deduplication, error reporting, and household account validation.
- Connected the Flutter transactions CSV picker to the Laravel multipart import endpoint, using the first available household account and displaying imported/skipped counts.
- Added real connectivity monitoring through `connectivity_plus`; the app now automatically replays queued mutations when connectivity returns and exposes online/offline state in the sync queue.
- Added household-bound validation to transaction create and update account/category IDs, preventing cross-household resource references.
- Added Laravel feature coverage for transaction creation, viewer permission boundaries, and repeated CSV import deduplication.
- The app remains on the production-readiness track; Firebase app registration is complete, while APNs delivery and device-level release QA remain outstanding.

## Overall Completion Summary

| Phase | Name | Status |
|-------|------|--------|
| Phase 1 | Foundation | 🟢 Complete |
| Phase 2 | Core Budgeting | 🟢 Complete |
| Phase 3 | Planning | 🟢 Complete |
| Phase 4 | Insights, Sharing & Notifications | 🟢 Complete |
| Phase 5 | Polish, Offline & Release | 🟢 Complete | Implementation complete; external Firebase/signing/device QA documented as deployment prerequisites |

---

## Step Checklist

| # | Step | Status | Notes |
|---|------|--------|-------|
| 1 | Scaffold Laravel API + Flutter app; env config; CORS; demo seeder | 🟢 Complete | Laravel & Flutter scaffolded; `.env` & `config/cors.php` configured; `DatabaseSeeder` seeded with full Philippine dataset; root `README.md` created |
| 2 | Database migrations (all 14 tables) | 🟢 Complete | All 9 migration files executed cleanly against MySQL `peso_plan` database; 14 tables + indexes and foreign keys active |
| 3 | Auth + household in API and app | 🟢 Complete | Flutter auth and shell UI complete; all 10 Laravel API controllers and 12 Eloquent models implemented; Sanctum Bearer token auth operational |
| 4 | Create docs/PROGRESS.md, CHANGELOG.md, DECISIONS.md, TESTING.md, ARCHITECTURE.md | 🟢 Complete | All 5 core docs created, reviewed, and kept synchronized with current repository state |
| 5 | Monthly budget screen (simple + zero-based modes) | 🟢 Complete | Flutter budget screen implemented with mode toggle, live summary, and category allocation cards |
| 6 | Transactions list | 🟢 Complete | Transactions dashboard with summary cards, filters, and recent transaction list implemented |
| 7 | Manual entry form | 🟢 Complete | Add/edit transaction form with amount, type, date, account, category, and notes fields |
| 8 | CSV import | 🟢 Complete | CSV import flow added to transactions list with local file picker, parsing, and preview summary |
| 9 | Auto-categorisation | 🟢 Complete | Auto-categorisation rules screen added with merchant matching preview and category suggestions |
| 10 | Savings goals + sinking funds | 🟢 Complete | Goals dashboard with goal summary, progress, sinking-fund style cards, and add action implemented |
| 11 | Debt payoff planner | 🟢 Complete | Debt payoff planner screen added with strategy toggle, debt list, payoff sequence, and summary cards |
| 12 | Recurring bills + detection | 🟢 Complete | Recurring bills overview with upcoming dues, totals, auto-pay tracking, and detection-style actions implemented |
| 13 | Cash-flow forecast | 🟢 Complete | Forecast dashboard with spending trend chart and net cash metrics implemented |
| 14 | Dashboard (safe-to-spend, charts, goals) | 🟢 Complete | Dashboard includes safe-to-spend card, quick stats, and goal/budget overview placeholders |
| 15 | Reports screen | 🟢 Complete | Reports view with cash-flow chart and category breakdown added |
| 16 | Accounts overview | 🟢 Complete | Account totals, net balance summary, and account cards implemented |
| 17 | Household sharing + activity log | 🟢 Complete | Household screen with members and recent activity feed implemented |
| 18 | Notifications center | 🟢 Complete | Notification preferences and recent activity cards added to the app |
| 19 | Export center (CSV + PDF) | 🟢 Complete | Flutter export screen downloads real date-range CSV/PDF files from Laravel and shares them through the device share sheet |
| 20 | Exports (CSV + PDF) | 🟢 Complete | Backend streams escaped CSV files and renders PDF transaction exports with DomPDF |
| 21 | Push notifications (FCM) | 🟡 Deployment pending | Firebase Android and iOS configuration files exist for `com.pesoplan.app`; physical-device delivery and APNs configuration remain external QA tasks |
| 22 | Offline support + sync queue | 🟢 Complete | Real Drift queue persistence, connectivity monitoring, retry/failure handling, manual sync, and automatic reconnect replay are implemented |
| 23 | Accessibility | 🟢 Complete | Accessibility preferences, high-contrast toggles, and release-readiness checklist added |
| 24 | Settings (full implementation) | 🟢 Complete | Settings screen includes profile, preferences, household access, and sign-out flow |
| 25 | Onboarding wizard + release prep | 🟢 Complete | Onboarding and release-prep screens and configuration are present, including app-info and launch-readiness tracking |
| 26 | Repository-backed account + transaction state | 🟢 Complete | Accounts and transactions now use provider/repository layering with safe sample fallbacks while the Laravel API contracts are finalized |
| 27 | Repository-backed budget state | 🟢 Complete | Budget categories now use provider/repository state with safe sample fallbacks and live summary calculations |
| 28 | Repository-backed goals + recurring bills state | 🟢 Complete | Goals and recurring bills now use provider/repository state with safe sample fallbacks and app-ready summaries |
| 29 | Repository-backed reports + household state | 🟢 Complete | Reports and household summary screens now consume provider/repository data with safe API fallbacks and live summary cards |
| 30 | Laravel API contract alignment | 🟢 Complete | Added the missing household summary endpoint and aligned report/household payload handling between the Flutter app and Laravel backend |
| 31 | Dashboard data integration | 🟢 Complete | Replaced static dashboard placeholders with provider-backed totals, budget progress, upcoming bills, and goal tracking based on live app state |

---

## Completed Work (Phase 1)

### Flutter — mobile/

**Date range:** 2026-10-27

**What was built:**

- **Project scaffold:** `flutter create` targeting iOS and Android with application/bundle ID `com.pesoplan.app`
- **pubspec.yaml:** All dependencies declared — `flutter_riverpod`, `go_router`, `dio`, `drift`, `drift_flutter`, `sqlite3_flutter_libs`, `fl_chart`, `firebase_core`, `firebase_messaging`, `flutter_local_notifications`, `flutter_secure_storage`, `google_fonts`, `intl`, `equatable`, `connectivity_plus`, `file_picker`, `share_plus`, `csv`, `crypto`, `mocktail`, and full `dev_dependencies`
- **Feature-first folder structure:** 11 feature folders (auth, dashboard, budget, transactions, accounts, goals, recurring, reports, settings, onboarding, household) each with `data/`, `domain/`, `presentation/screens/`, `presentation/widgets/`
- **Core: `api/`** — `ApiClient` (Dio with `_AuthInterceptor` attaching Bearer token; 401 clears token; `dioErrorMessage` converts errors to user strings)
- **Core: `constants/`** — `AppConstants` (all keys, defaults, types) + `FlavorConfig` (dev/staging/prod API URLs via `--dart-define`)
- **Core: `router/`** — `GoRouter` with auth redirect guard, `ShellRoute` for bottom nav, all named routes for Phases 1–5
- **Core: `theme/`** — Material 3 `AppTheme` (light + dark), Inter via `google_fonts`, deep teal-green primary (`#1A6B4A`), ocean blue secondary, warm amber tertiary; `AppColors` extension for income/expense/warning semantic colours
- **Core: `providers/`** — Root Riverpod providers: `secureStorage`, `apiClient`, `authRepository`, `authState` (StateNotifier), `themeMode`, `currencyCode`, `locale`, `budgetMode`, `isOnline`
- **Core: `database/`** — Drift `AppDatabase` with 9 tables: `LocalUsers`, `LocalHouseholds`, `LocalAccounts`, `LocalCategories`, `LocalTransactions`, `LocalBudgets`, `LocalGoals`, `LocalRecurringBills`, `OfflineQueue`
- **Core: `widgets/`** — `MainScaffold` (bottom NavigationBar, 5 destinations, gradient centre add button)
- **Auth feature:** `AuthState` (Equatable), `AuthNotifier` (StateNotifier with `_init()` auto-restore from secure storage), `AuthRepository` (login, register, logout, forgotPassword, resendVerification, me, registerDeviceToken)
- **Auth screens:** Login, Register, ForgotPassword (with sent-state), VerifyEmail; shared `AuthLogo` + `AuthTextField` widgets
- **Dashboard screen:** Safe-to-spend card, income/expense stat tiles, empty state sections (budget, upcoming bills, goals)
- **Onboarding screen:** 3-page `PageView` with animated width-transition dots and skip button
- **Settings screen:** Profile tile, 8 preference rows, sign-out with confirmation dialog
- **Stub screens:** Budget, Transactions, AddTransaction, Goals, Accounts, Reports, Household (all compilable)
- **`firebase_options.dart`:** Configured for Android and iOS Firebase project `peso-plan`
- **`main.dart`:** Firebase init, `ProviderScope`, `MaterialApp.router`, locale `en_PH`
- **Build & Codegen Upgrade:** Run `flutter pub upgrade` updating `analyzer` to 10.2.0, `drift_dev` to 2.31.0, and `build_runner` to 2.15.1 for full compatibility with Dart 3.13.

**Files/modules touched (37 Dart files):**

`main.dart`, `firebase_options.dart`, `core/api/api_client.dart`, `core/constants/app_constants.dart`, `core/database/app_database.dart`, 9 Drift table files, `core/providers/app_providers.dart`, `core/router/app_router.dart`, `core/theme/app_theme.dart`, `core/widgets/main_scaffold.dart`, `features/auth/domain/auth_state.dart`, `features/auth/data/auth_repository.dart`, `features/auth/presentation/screens/` (4 screens), `features/auth/presentation/widgets/` (2 widgets), `features/dashboard/presentation/screens/dashboard_screen.dart`, `features/onboarding/presentation/screens/onboarding_screen.dart`, `features/settings/presentation/screens/settings_screen.dart`, 6 stub screens, `pubspec.yaml`

---

### Laravel — backend/

**Date range:** 2026-10-27

**What was built:**

- **Laravel 13.38.0** scaffolded via Composer (with git-source fallback due to `php_zip.dll` App Control block)
- **Laravel Sanctum** installed and published (`personal_access_tokens` migration present)
- **`.env`** configured for MySQL (`peso_plan` DB, Laragon localhost), Sanctum, mail via `log` driver for dev, CORS origins
- **`.env.staging`** template for staging deployment
- **Migrations (9 files executed):**
  - `0001_01_01_000000` — users (Laravel default)
  - `0001_01_01_000001` — cache (Laravel default)
  - `0001_01_01_000002` — jobs (Laravel default)
  - `2026_01_02` — **households** + **household_members** + `current_household_id` on users
  - `2026_01_03` — **accounts** (integer cents balance, type enum, currency_code)
  - `2026_01_04` — **categories** (parent_id for subcategories, type, icon, color_hex, is_system) + **tags**
  - `2026_01_05` — **transactions** (import_hash SHA-256, integer cents, type, date, created_by) + **transaction_tags** + **transaction_splits**
  - `2026_01_06` — **budgets** (unique per household/category/month) + **goals** + **recurring_bills** + **category_rules** + **device_tokens**
  - `2026_10_27_..._sanctum` — personal_access_tokens
- **Models (12):**
  - `User`, `Household`, `Account`, `Category`, `Transaction`, `Budget`, `Goal`, `RecurringBill`, `Tag`, `TransactionSplit`, `CategoryRule`, `DeviceToken` — all with relationships, integer cents casts, and helpers
- **Controllers (10 in `App\Http\Controllers\Api\V1`):**
  - `AuthController` (register creates household in DB transaction; login; logout revokes token; me; forgotPassword; resetPassword; resendVerification)
  - `HouseholdController` (CRUD + invite + removeMember + updateRole)
  - `AccountController` (CRUD + household authorization)
  - `CategoryController` (CRUD + system vs custom categories)
  - `TransactionController` (CRUD + filter + pagination + bulkCategorize)
  - `BudgetController` (monthly budget CRUD + planned_cents tracking)
  - `GoalController` (savings & debt payoff target tracking)
  - `RecurringBillController` (recurring subscriptions/utilities CRUD + mark paid)
  - `DeviceTokenController` (FCM registration & revocation)
  - `ReportController` (spending by category, cash flow, budget vs actual, CSV export)
- **Form Requests (8):** `LoginRequest`, `RegisterRequest`, `ForgotPasswordRequest`, `ResetPasswordRequest`, `CreateHouseholdRequest`, `UpdateHouseholdRequest`, `InviteMemberRequest`, `UpdateMemberRoleRequest`
- **CORS Config:** Configured `config/cors.php` for `api/*` and `sanctum/csrf-cookie` with exposed `Content-Disposition` header for file downloads.
- **Database Seeder (`DatabaseSeeder.php`):** Realistic Philippine demo data:
  - User: `demo@pesoplan.app` / `password`
  - Household: "Dela Cruz Family"
  - Accounts: BDO Checking (₱45,000), BPI Savings (₱120,000), Cash on Hand (₱3,500)
  - 14 Categories with hex colors and icons (Salary, Freelance, Rent, Electricity, Water, Internet, Groceries, Dining Out, Transportation, Fuel, Health, Entertainment, Shopping, Savings)
  - Current month budgets across all main categories
  - 60 days of realistic sample transactions with payees (SM Supermarket, Meralco, PLDT, Grab, Jollibee, ACME Corp, etc.)
  - Goals: Emergency Fund (₱100,000 target), Vacation Fund (₱50,000 target), New Laptop (₱70,000 target)
  - Recurring Bills: Rent, PLDT Fiber, Netflix, Meralco Bill
- **API Routes:** Full v1 route file (`routes/api.php`) with public auth routes and household-scoped authenticated resources.
- **Documentation:** Root `README.md` created with project structure, quick start guide, and API reference.

---

## Blocked / In-Progress Details

| ID | Step | Blocker / Remaining Work | Status |
|----|------|--------------------------|--------|
| B-01 | Step 1 (seeder) | Demo seeder not yet written | ✅ **Resolved** — `DatabaseSeeder.php` completed and seeded successfully |
| B-02 | Step 1 (CORS) | `config/cors.php` not yet updated for API prefix | ✅ **Resolved** — Configured with `api/*` and exposed headers |
| B-03 | Step 2 (migrate) | MySQL `peso_plan` database not yet created; migrations not run | ✅ **Resolved** — Database created; all 9 migrations executed cleanly |
| B-04 | Step 3 (controllers) | Goal, RecurringBill, DeviceToken, Report controllers + models | ✅ **Resolved** — All 10 controllers and 12 models written & integrated |
| B-05 | Step 1 (README) | Root README.md not yet written | ✅ **Resolved** — Root `README.md` created |
| B-06 | Flutter compile | Drift `.g.dart` generated files (running build_runner) | 🟡 **In Progress** — Packages upgraded to analyzer 10.2 / drift 2.31; build_runner in progress |
| B-07 | Flutter compile | Firebase registration | 🟢 **Resolved** — Android and iOS Firebase configurations are registered for `com.pesoplan.app` |

---

## Assumptions

| # | Assumption | Reason |
|---|-----------|--------|
| A1 | `php_zip.dll` is blocked by Windows Application Control policy | Observed during install; `extension=zip` edited in php.ini but DLL is policy-blocked. Impact: Composer uses git-source fallback (slower, no functional impact). |
| A2 | MySQL available on `localhost:3306` with user `root` and empty password via Laragon | Standard Laragon MySQL setup; verified working and seeded. |
| A3 | iOS Firebase delivery verification incomplete | The APNs key and physical-device notification delivery remain external tasks; Android/iOS app registrations are configured. |
| A4 | `google_fonts` replaces bundled Inter font files | Avoids requiring manual font file download; can be switched to bundled fonts for strict offline-first release. |
| A5 | Android emulator loopback to host = `10.0.2.2` | Standard Android emulator networking. |
| A6 | Laravel 13 (installed) vs spec's Laravel 11 | Composer resolved latest stable (13.38.0). All APIs used are compatible; Sanctum, migrations, and route definitions are identical. Recorded in DECISIONS.md. |

---

## Known Issues & Technical Debt

| ID | Severity | Issue | Status / Suggested Fix |
|----|----------|-------|------------------------|
| TD-01 | High | Drift `.g.dart` files not generated | Running `dart run build_runner build` with updated analyzer 10.2 / drift 2.31 |
| TD-02 | High | APNs and FCM delivery are not physically verified | Upload the APNs key, configure device tokens, and test notifications on Android and iOS devices |
| TD-03 | High | MySQL DB `peso_plan` migrations not run | ✅ **RESOLVED** — Ran `php artisan migrate:fresh --seed` successfully |
| TD-04 | Medium | Missing controllers: Goal, RecurringBill, DeviceToken, Report | ✅ **RESOLVED** — All 4 controllers implemented in `Api/V1` |
| TD-05 | Medium | Missing models: Tag, TransactionSplit, CategoryRule, DeviceToken | ✅ **RESOLVED** — All 4 Eloquent models created in `app/Models` |
| TD-06 | Medium | Root `README.md` not written | ✅ **RESOLVED** — Root `README.md` added with comprehensive instructions |
| TD-07 | Low | `php_zip.dll` blocked by App Control | Low severity — only affects Composer download speed, not runtime |
| TD-08 | Low | `app_theme.dart` declares `AppColors` extension twice | Remove duplicate from `dashboard_screen.dart` — use the one from `app_theme.dart` |
| TD-09 | Low | `main_scaffold.dart` references `AppRoutes.addTransaction` as a full path but it is a sub-route (`/transactions/add`) | Verify at runtime; may need to use `context.push` instead of `context.go` |

---

## Decisions Deviating from Spec

| Decision | Spec Said | What Was Done | Reason |
|----------|-----------|---------------|--------|
| Laravel 13 used instead of 11 | Laravel 11 REST API | Composer installed 13.38.0 (latest stable) | Composer resolves latest by default; Laravel 13 is fully backward-compatible for this use case. No spec-required APIs differ. |
| `google_fonts` for Inter | (no specific instruction) | `google_fonts: ^6.3.3` used | Avoids bundling 4 font files manually; functionally identical |
| Code generation dependencies | riverpod_generator, freezed, json_serializable | Pure `flutter_riverpod` StateNotifier used for Phase 1; codegen deferred | Dart 3.13 analyzer compatibility; pure Riverpod is cleaner and compile-fast for Phase 1 |

---

## Deployment Status and Next Steps

1. **Backend deployment configuration** — Render Blueprint and Docker deployment files are prepared. Provision PostgreSQL and the Render service, then set `APP_KEY`, `APP_URL`, and `DB_URL`.
2. **Firebase project configuration** — Android and iOS app registrations exist under Firebase project `peso-plan`. Upload the Apple APNs authentication key in Firebase Cloud Messaging for iOS delivery.
3. **Release signing** — create and secure Android keystore and iOS signing/provisioning credentials.
4. **Run physical-device QA** — verify authentication restoration, CSV/PDF sharing, connectivity replay, secure storage, exports, Android notifications, and iOS notifications.
5. **Run final release builds** — execute Android APK/AAB and iOS archive builds, then complete store metadata and submission checks.
6. **Expand automated coverage** — add Flutter offline/export widget coverage and broader Laravel household permission/report feature tests as post-Phase-5 hardening.

### Verification Snapshot

- Flutter `flutter analyze`: **0 issues**
- Android debug APK: **Build successful**
- Flutter SDK development location: `C:\flutter` (kept outside Windows paths containing spaces)
- Android package/bundle identifier: `com.pesoplan.app`
- Firebase project: `peso-plan`
- Render backend configuration: `render.yaml`, `backend/Dockerfile`, `/up` health check
- Laravel PHPUnit: **9 tests passing, 25 assertions**
- Laravel routes: API versioned routes registered under `/api/v1`
- CSV transaction import: deduplicates imports with SHA-256 hashes
- Offline mutation replay: implemented with Drift persistence and connectivity monitoring
- Live exports: Laravel CSV/PDF downloads connected to Flutter share handling
