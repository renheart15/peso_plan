# Changelog

All notable changes to Peso Plan are documented here.  
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).  
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased] — Phase 5 implementation complete

### Mobile (Flutter) — Added & Updated
- **2026-10-28:** Completed Phase 5 export integration; CSV/PDF exports now download from the Laravel API for the selected range and share through the device file/share sheet instead of generating share-only sample text.
- **2026-10-28:** Fixed transaction API payload alignment by sending positive integer-cent values and resolved `account_id` from the selected account; expense responses are normalized to negative display values in the transaction model.
- **2026-10-28:** Added focused transaction income/expense model tests for API payload normalization.
- Project scaffolded with Flutter 3.47.1, targeting iOS and Android (`com.yourcompany.pesoplan`)
- Feature-first folder structure under `mobile/lib/` (11 features × data/domain/presentation)
- `pubspec.yaml` with full dependency set:
  - State: `flutter_riverpod 2.6.1`
  - Navigation: `go_router 14.8.1`
  - HTTP: `dio 5.7.0`
  - Local DB: `drift 2.31.0`, `drift_flutter 0.2.8`, `sqlite3_flutter_libs 0.5.42`
  - Charts: `fl_chart 0.69.2`
  - Push: `firebase_core 3.15.2`, `firebase_messaging 15.2.10`, `flutter_local_notifications 18.0.1`
  - Auth: `flutter_secure_storage 9.2.4`
  - Fonts: `google_fonts 6.3.3`
  - Utilities: `intl`, `equatable`, `connectivity_plus`, `file_picker`, `share_plus`, `csv`, `crypto`
  - Dev: `build_runner 2.15.1`, `drift_dev 2.31.0`, `mocktail 1.0.4`, `mockito 5.6.4`
- **Core: API client** — Dio with `_AuthInterceptor` (Bearer token, 401 auto-clear), flavor-aware base URL, `dioErrorMessage` parser
- **Core: Constants** — `AppConstants` (all storage keys, defaults, types) + `FlavorConfig` (dev/staging/prod URLs via `--dart-define=FLAVOR=`)
- **Core: Router** — GoRouter with auth redirect guard, ShellRoute for bottom nav, all Phase 1–5 named routes
- **Core: Theme** — Material 3 light/dark theme, Inter font, deep teal-green brand palette, `AppColors` semantic extensions, `CardThemeData` compliance
- **Core: Providers** — 7 root Riverpod providers (secureStorage, apiClient, authRepository, authState, themeMode, currencyCode, budgetMode)
- **Core: Drift database** — `AppDatabase` with 9 local tables: `LocalUsers`, `LocalHouseholds`, `LocalAccounts`, `LocalCategories`, `LocalTransactions`, `LocalBudgets`, `LocalGoals`, `LocalRecurringBills`, `OfflineQueue`
- **Drift code generation** — Executed `build_runner` generating full 7,000+ line `app_database.g.dart` with DAOs, tables, and companions
- **Core: MainScaffold** — Bottom NavigationBar with gradient centre add-transaction button
- **Auth feature** — `AuthState` (Equatable), `AuthNotifier` (StateNotifier, auto-restores session from secure storage on startup), `AuthRepository` (full API surface)
- **Auth screens** — Login, Register, ForgotPassword (with sent-confirmation state), VerifyEmail; `AuthLogo` + `AuthTextField` shared widgets
- **Dashboard screen** — Safe-to-spend card, income/expense quick stats, empty states for budget/bills/goals
- **Onboarding screen** — 3-page PageView with animated pill-dots indicator and skip
- **Settings screen** — Profile tile, 8 preference rows, sign-out with AlertDialog confirmation
- **Stub screens** — Budget, Transactions, AddTransaction (with optional `transactionId`), Goals, Accounts, Reports, Household (compilable)
- **Budget screen** — Implemented monthly budget dashboard with simple/zero-based toggle, totals summary, category allocation cards, and progress indicators
- **Transactions screen** — Added recent-activity list, summary cards, category filters, and CSV import flow for the core budgeting flow
- **Transaction form** — Added add/edit transaction form fields for amount, date, account, category, type, and notes
- **CSV import support** — Added CSV file picker, parsing, and preview integration to the transactions screen
- **Auto-categorisation** — Added merchant matching rules, confidence scoring, and a preview screen to suggest categories before import
- **Goals screen** — Added savings and debt-goal summary cards, progress indicators, and sample sinking-fund tracking UI
- **Debt payoff planner** — Added strategy toggle, debt summary, payoff list, and monthly plan sequence for debt reduction
- **Recurring bills** — Added bills overview, total due summary, auto-pay status, and recurring-payment tracking UI
- **Reports screen** — Added cash-flow charting and category mix breakdown for monthly insights
- **Cash-flow forecast** — Added forecast summary cards and trend visualization for spending expectations
- **Household sharing** — Added household member list and activity feed for family budget visibility
- **Accounts overview** — Added net-balance summary and account cards for all wallet types
- **Notifications center** — Added a dedicated notification feed with delivery preferences and budget/household alerts
- **Export center** — Added format/date selection, export summary, and share-ready CSV/PDF sample output for reports and settings
- **Sync queue** — Added an offline sync dashboard with queue stats, retry states, and manual sync actions for future backend replay
- **Offline replay** — Added queue replay logic to send pending writes back to the API, mark retries, and clear synced items from the local offline queue
- **Transaction save flow** — Added a working save path for manual transactions, with inline validation and graceful offline queueing when the backend is unavailable
- **Goal save flow** — Added a working save form for new savings and debt goals, with API-first creation and offline queue fallback when the backend is unreachable
- **Accessibility & release prep** — Added accessibility preferences, higher-contrast controls, and a release-readiness checklist for launch prep
- **App info & release prep** — Added a build and launch status screen with version metadata and pending production tasks for the next milestone
- **Settings & release prep** — Added user settings, export actions, and onboarding/release scaffolding touches
- **Reports + household state** — Wired report and household summary screens to provider/repository APIs with safe mock fallbacks while the Laravel API contracts are finalized
- **API contract alignment** — Added the missing household summary route in Laravel and aligned payload parsing between Flutter and the backend so provider-backed report and household screens can use live data correctly
- **Dashboard data integration** — Replaced static dashboard placeholders with real provider-backed summary values for spend, upcoming bills, budget progress, and goals
- **`firebase_options.dart`** — Placeholder stub; requires `flutterfire configure` before release

### API (Laravel) — Added & Updated
- **2026-10-28:** Added real PDF transaction export with DomPDF and fixed report queries to use the `transactions.date` and `categories.color_hex` columns.
- **2026-10-28:** Added signed email-verification routing and auth feature coverage for registration, login, invalid credentials, profile, and logout.
- **2026-10-28:** Implemented CSV transaction import with date/amount parsing, category lookup, row error reporting, and SHA-256 duplicate detection.
- **2026-10-28:** Connected the Flutter CSV picker to the API multipart import endpoint and added imported/skipped result feedback.
- **2026-10-28:** Added automatic connectivity monitoring and offline queue replay when the device reconnects.
- **2026-10-28:** Added transaction API feature tests covering owner creation, viewer access denial, and CSV deduplication.
- **2026-10-28:** Registered `routes/api.php` with the Laravel 13 application bootstrap using the `api` prefix; all 56 `/api/v1` routes now appear in `route:list`.
- **2026-10-28:** Installed Laravel Boost as a development dependency and enabled Boost agent guidelines.
- **Laravel 13.38.0** scaffolded via Composer in `/backend`
- **Laravel Sanctum** installed; `personal_access_tokens` migration published
- **`.env`** — Configured for MySQL (`peso_plan` DB, Laragon localhost), Sanctum config, mail via `log` for dev, CORS origins set
- **`.env.staging`** — Template for staging deployment
- **Migrations (9 executed files):**
  - Laravel defaults: `users`, `cache`, `jobs`
  - Custom: `households` + `household_members` + `current_household_id` on users
  - Custom: `accounts` (integer cents, type enum, currency_code)
  - Custom: `categories` (parent_id, type, icon, color_hex, is_system) + `tags`
  - Custom: `transactions` (import_hash SHA-256 unique index, integer cents, date, created_by) + `transaction_tags` + `transaction_splits`
  - Custom: `budgets` (unique per household/category/month) + `goals` + `recurring_bills` + `category_rules` + `device_tokens`
  - Sanctum: `personal_access_tokens`
  - Ran `php artisan migrate:fresh --seed` successfully against MySQL
- **Models (12):**
  - `User`, `Household`, `Account`, `Category`, `Transaction`, `Budget`, `Goal`, `RecurringBill`, `Tag`, `TransactionSplit`, `CategoryRule`, `DeviceToken` — with relationships, casts, and helpers
- **Controllers (10 in `App\Http\Controllers\Api\V1`):**
  - `AuthController`, `HouseholdController`, `AccountController`, `CategoryController`, `TransactionController`, `BudgetController`, `GoalController`, `RecurringBillController`, `DeviceTokenController`, `ReportController`
- **Form Requests (8):** Login, Register, ForgotPassword, ResetPassword, CreateHousehold, UpdateHousehold, InviteMember, UpdateMemberRole
- **CORS Config:** Configured `config/cors.php` for `api/*` and `sanctum/csrf-cookie` with exposed `Content-Disposition` header
- **Database Seeder (`DatabaseSeeder.php`):** Full demo dataset with user (`demo@pesoplan.app`), Dela Cruz household, 3 accounts, 14 categories, monthly budgets, 60 days of realistic Philippine transactions, goals, and recurring bills
- **API routes** — Full v1 route file: public auth + all authenticated household-scoped resources

### Docs — Added & Updated
- `README.md` (root) — Full multi-stack setup guide, prerequisites, architecture summary, and API reference
- `docs/PROGRESS.md` — Living status report updated to ~95% Phase 1 completion
- `docs/CHANGELOG.md` — Detailed record of all Phase 1 implementations
- `docs/DECISIONS.md` — 10 ADRs covering data formats, auth, state, sync, permissions, and framework versions
- `docs/TESTING.md` — Status, testing commands, coverage targets, manual QA checklist, and database verification
- `docs/ARCHITECTURE.md` — Data model schema (14 tables), API routes, Flutter feature architecture, and offline sync design

---

## [0.1.0] — Phase 1 Complete
> Will be tagged when all Phase 1 acceptance criteria pass (migrations run, app compiles and launches on iOS simulator and Android emulator, register/login/logout work end-to-end).

### Mobile (Flutter)
- Foundation: auth flows, navigation, Drift database schema, Material 3 theme, offline queue table structure

### API (Laravel)
- Foundation: all 14-table schema, auth endpoints with Sanctum, household CRUD, core controllers, Form Request validation, demo seeder

---

## Planned for [0.2.0] — Phase 2 (Core Budgeting)
- Monthly budget screen (simple + zero-based modes)
- Transactions list with filters, swipe actions, inline edit
- Manual entry form with smart defaults and native keyboard/date picker
- CSV import with column mapping, preview, deduplication, and undo
- Auto-categorisation via `category_rules`
