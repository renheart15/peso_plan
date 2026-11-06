# Testing Status — Peso Plan

> **Last updated:** 2026-11-06T09:19+08:00
> **Current phase:** Phase 5 — Offline, Firebase, cloud deployment, and release validation

---

## How to Run Tests

### Flutter — Unit & Widget Tests
```bash
cd mobile
flutter pub get
dart run build_runner build                                 # generates Drift *.g.dart (completed)
flutter test
```

### Flutter — Integration Tests (requires connected device or emulator)
```bash
cd mobile
flutter test integration_test/
```

### PHP — PHPUnit (Laravel API)
```bash
cd backend
php artisan test
# With coverage (requires Xdebug or PCOV)
php artisan test --coverage --min=80
```

---

## Current Test Status

### Flutter

| Suite | Total | Passing | Failing | Coverage |
|-------|-------|---------|---------|----------|
| Unit tests | 1 | 1 | 0 | Smoke pass |
| Widget tests | 1 | 1 | 0 | Smoke pass |
| Integration tests | 0 | 0 | 0 | — |

> **Status:** Drift `app_database.g.dart` successfully generated via `build_runner`. `flutter analyze` passes with 0 issues, and the Android debug APK builds successfully. Added focused transaction API normalization tests and cloud API configuration support. Use a Flutter SDK location without spaces on Windows when native package builds are required.

### Laravel / PHPUnit

| Suite | Total | Passing | Failing | Coverage |
|-------|-------|---------|---------|----------|
| Feature tests | 9 | 9 | 0 | Auth, transaction, and CSV coverage |
| Unit tests | 0 | 0 | 0 | — |

> **Status:** MySQL `peso_plan` database created, all 9 migrations executed, all 10 controllers & 12 models in place, and the demo database seeder is working. Laravel Boost and DomPDF are installed; the auth and transaction feature suites pass 9 tests / 25 assertions, and `route:list --path=api/v1` confirms the registered API routes.

---

## Target Coverage (per spec)

| Area | Target | Current | Phase |
|------|--------|---------|-------|
| Budget calculations (cents arithmetic, zero-based) | 90%+ | 0% | Phase 2 |
| Debt payoff planner (snowball / avalanche math) | 90%+ | 0% | Phase 3 |
| CSV import deduplication (`import_hash` logic) | 90%+ | 0% | Phase 2 |
| Household permission boundaries (API) | 100% | 0% | Phase 1/2 |
| Offline sync queue (enqueue, replay, conflict) | 80%+ | 25% | Phase 5 |

---

## Pre-Conditions to Enable Testing

### Flutter
- [x] **`flutter pub get` & `flutter pub upgrade`** — resolved and upgraded dependencies
- [x] **`dart run build_runner build`** — generated `app_database.g.dart` (76 build outputs)
- [x] **`flutter analyze`** — passes with 0 issues
- [x] **Android Firebase configuration** — `google-services.json`, package ID, Gradle plugin, and Flutter options configured for `com.pesoplan.app`
- [x] **iOS Firebase configuration** — Bundle ID and `GoogleService-Info.plist` configured for `com.pesoplan.app`
- [ ] **Firebase delivery verification** — upload the Apple APNs key and verify Android/iOS notifications on physical devices
- [x] **Android debug build** — core desugaring and compile SDK 36 configured; APK builds successfully

### Laravel
- [x] **Create MySQL database:** `CREATE DATABASE peso_plan CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
- [x] **Run migrations:** `php artisan migrate` (all 9 migration files executed)
- [x] **Run seeder:** `php artisan db:seed` (`DatabaseSeeder.php` seeded with Philippine dataset)
- [x] **Write models:** `Tag`, `TransactionSplit`, `CategoryRule`, `DeviceToken`, `User`, `Household`, `Account`, `Category`, `Transaction`, `Budget`, `Goal`, `RecurringBill`
- [x] **Write controllers:** All 10 controllers implemented in `app/Http/Controllers/Api/V1`

---

## Manual QA Checklist (Phase 1 Acceptance)

### Device / Simulator
- [ ] **iOS Simulator** — Launch app, confirm Login screen renders, no crash
- [ ] **Android Emulator** — Launch app, confirm Login screen renders, no crash
- [ ] **Real device (optional for Phase 1)** — Deferred to Phase 4 (FCM testing)

### Auth Flow (end-to-end)
- [ ] Register new user → household created → lands on Onboarding screen
- [ ] Login with existing credentials → lands on Dashboard screen
- [ ] Logout → token revoked → returns to Login screen
- [ ] Token persists across app restarts (reopening app without re-login)
- [ ] Invalid credentials → error message shown (not a crash)
- [ ] Forgot password → email dispatched (check `storage/logs/laravel.log` in dev)

### API (manual via Postman / curl)
- [ ] `POST /api/v1/auth/register` → 201 with token + user
- [ ] `POST /api/v1/auth/login` → 200 with token
- [ ] `GET /api/v1/auth/me` with Bearer token → 200 with user payload
- [ ] `POST /api/v1/auth/logout` → 200, token revoked
- [ ] `GET /api/v1/households` with Bearer token → 200 with list
- [ ] Attempt `GET /api/v1/households/{id}` for a household the user is NOT in → 403

### Permission Boundary Tests (must pass before marking Step 3 Done)
- [ ] Viewer cannot POST/PUT/DELETE transactions
- [ ] Partner can POST/PUT/DELETE transactions
- [ ] Non-member cannot read any household resource
- [ ] Only owner can invite/remove members

---

## Known Blocking Conditions

| ID | Condition | Root Cause | Status / Fix |
|----|-----------|------------|--------------|
| F-01 | Flutter app does not compile | Drift `.g.dart` files not generated | ✅ **RESOLVED** — Generated via `build_runner` (wrote 76 outputs) |
| F-02 | Firebase configuration is incomplete | Platform configuration and notification delivery still require external Firebase/APNs verification | 🟡 Android/iOS files configured; physical-device delivery pending |
| F-03 | Laravel tests fail to connect | `peso_plan` MySQL database not created | ✅ **RESOLVED** — Database created & seeded |
| F-04 | `php artisan route:list` fails | Missing controllers | ✅ **RESOLVED** — All 10 controllers implemented |
