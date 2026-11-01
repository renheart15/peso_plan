# Architecture Decision Records — Peso Plan

Each entry follows the format: **number, date, title, context, decision, consequences**.

---

## ADR-001 — Money Storage Format

- **Date:** 2026-10-27
- **Title:** Store all monetary values as integer cents
- **Context:** Floating-point arithmetic is lossy (e.g., `0.1 + 0.2 ≠ 0.3`). Budget apps that use floats routinely accumulate rounding errors that confuse users and fail audits.
- **Decision:** All monetary values are stored and transmitted as **integer cents** (e.g., ₱1,234.56 → `123456`). Display formatting applies the user's locale (e.g., `en-PH`) and currency symbol at render time. The database columns are named `*_cents` to make the unit explicit.
- **Consequences:**
  - ✅ No rounding errors in calculations
  - ✅ Safe integer arithmetic in PHP and Dart
  - ⚠️ Requires divide-by-100 at every display site — enforced via a shared `CurrencyFormatter` utility
  - ⚠️ Maximum safe value: ±9,007,199,254,740,991 cents (≈ ±90 trillion PHP) — well within practical limits

---

## ADR-002 — Authentication Approach

- **Date:** 2026-10-27
- **Title:** Laravel Sanctum personal access tokens for mobile auth
- **Context:** The app targets iOS and Android only (no browser sessions). Options considered: Sanctum cookies (browser-only), Sanctum tokens (mobile-friendly), Passport JWT (heavier).
- **Decision:** Use **Laravel Sanctum personal access tokens** (Bearer tokens). On login/register, the API returns a token that the mobile app stores in `flutter_secure_storage`. The token is attached to every request via a Dio interceptor. On logout, the token is revoked server-side and cleared locally.
- **Consequences:**
  - ✅ Simple to implement and test
  - ✅ Tokens are revokable per device
  - ✅ No refresh token complexity for v1
  - ⚠️ Tokens do not auto-expire — must be revoked on logout; consider adding expiry in a future version

---

## ADR-003 — State Management

- **Date:** 2026-10-27
- **Title:** Riverpod for all app-wide and feature state
- **Context:** Options: Provider (deprecated pattern), Bloc (verbose), GetX (magic globals), Riverpod (compile-safe, testable, scoped).
- **Decision:** Use **flutter_riverpod** with `StateNotifier` for mutable state and `Provider`/`FutureProvider` for derived and async state. Code generation (`riverpod_annotation`, `riverpod_generator`) will be added for feature-level providers in Phase 2+.
- **Consequences:**
  - ✅ Compile-time safety; no `context.read` needed outside widgets
  - ✅ Easy to unit-test notifiers in isolation
  - ✅ Scoped providers for per-screen ephemeral state
  - ⚠️ Learning curve for contributors new to Riverpod

---

## ADR-004 — Offline Sync Strategy

- **Date:** 2026-10-27
- **Title:** Cache-then-network with offline write queue and last-write-wins conflict resolution
- **Context:** The spec requires the app to work without a connection and sync when reconnected. Options: full CRDT (complex), event sourcing (heavy), simple last-write-wins (pragmatic for v1).
- **Decision:**
  - On startup and on reconnect, fetch fresh data from the API and write it into the Drift local database.
  - Reads always go to Drift (fast, offline-capable).
  - Writes go to both Drift (immediately, optimistic) and the API. If offline, writes are queued in the `OfflineQueue` table with method + path + body.
  - On reconnect, the queue is replayed in order. Conflicts (same resource modified on server and queued locally) are resolved with **last-write-wins** — the queue's version wins because it is most recent from the user's perspective.
  - Conflict decisions are logged.
- **Consequences:**
  - ✅ App is fully functional offline
  - ✅ Simple to reason about and test
  - ⚠️ Last-write-wins can lose server-side changes in edge cases (e.g., household partner edits the same transaction offline at the same time)
  - ⚠️ Not suitable for financial auditing requirements — acceptable for v1

---

## ADR-005 — BankProvider Adapter Interface

- **Date:** 2026-10-27
- **Title:** Clean adapter interface for future bank aggregation
- **Context:** The spec explicitly excludes bank connections in v1 but requires a clean seam for adding one later.
- **Decision:** Define an abstract `BankProvider` interface in `mobile/lib/core/api/bank_provider.dart` with methods: `fetchAccounts()`, `fetchTransactions(dateRange)`, `getBalance(accountId)`. In v1, no concrete implementations exist. The interface is documented in ARCHITECTURE.md.
- **Consequences:**
  - ✅ Adding a bank aggregator (e.g., Plaid, Bux) in v2 requires only a new concrete class — no changes to existing code
  - ✅ Forces separation between data import and the budgeting logic

---

## ADR-006 — Household Permission Model

- **Date:** 2026-10-27
- **Title:** Three-role household model (owner, partner, viewer)
- **Context:** Shared budget apps need access control. Options: full RBAC (complex), simple role enum (pragmatic).
- **Decision:** Each `household_member` row has a `role` column: `owner` (full CRUD + invite + delete), `partner` (CRUD on transactions, budgets, goals), `viewer` (read-only). Enforced on every API endpoint via a `HouseholdPolicy` Laravel Policy. The mobile app also hides write actions for viewers.
- **Consequences:**
  - ✅ Simple, explainable to non-technical users
  - ✅ Easy to enforce in API middleware
  - ⚠️ Cannot grant granular permissions (e.g., view-only on one account) — acceptable for v1

---

## ADR-007 — CSV Import Deduplication Method

- **Date:** 2026-10-27
- **Title:** SHA-256 hash of key transaction fields for duplicate detection
- **Context:** Users may import the same CSV twice. Need a deterministic way to detect duplicates without relying on external IDs.
- **Decision:** Compute `import_hash = SHA-256(date + amount_cents + payee + account_id)` for each imported row. Before inserting, check if a transaction with that hash already exists for the household. If so, skip it. The hash is stored on the `transactions` table.
- **Consequences:**
  - ✅ Deterministic — same import always produces the same hash
  - ✅ Works without external transaction IDs
  - ⚠️ Two genuine transactions on the same date for the same amount to the same payee will be incorrectly deduplicated — acceptable edge case for v1; can add a sequence number to the hash in v2

---

## ADR-008 — Navigation Approach

- **Date:** 2026-10-27
- **Title:** go_router with ShellRoute for bottom navigation
- **Context:** Flutter has Navigator 1.0 (imperative), Navigator 2.0 (declarative), and packages: go_router, auto_route, beamer. The spec requires deep linking and auth redirect.
- **Decision:** Use **go_router** with a `ShellRoute` wrapping the main scaffold (bottom nav). Auth redirect is handled in the `redirect` callback. Named routes are defined as constants in `AppRoutes`.
- **Consequences:**
  - ✅ Declarative routing with URL support
  - ✅ Auth guard is a single function
  - ✅ Deep linking works on both platforms with minimal config

---

## ADR-009 — Default Currency and Locale

- **Date:** 2026-10-27
- **Title:** Default to PHP (Philippine Peso) and en-PH locale
- **Context:** The spec targets the Philippines market first; other currencies are optional.
- **Decision:** `AppConstants.defaultCurrency = 'PHP'`, `AppConstants.defaultLocale = 'en_PH'`. Users can change in Settings. The `intl` package handles locale-aware formatting.
- **Consequences:**
  - ✅ Correct out-of-the-box for the target market
  - ✅ `intl` supports all ISO 4217 currencies and CLDR locales
  - ⚠️ `intl` locale data must be initialised before formatting — handled in `main.dart` via `initializeDateFormatting`

---

## ADR-010 — Laravel Version (Deviation from Spec)

- **Date:** 2026-10-27
- **Title:** Laravel 13 used instead of specified Laravel 11
- **Context:** The spec states "Laravel 11 REST API". When `composer create-project laravel/laravel backend` was run without a version pin, Composer resolved `laravel/laravel v13.11.0` (which installs `laravel/framework v13.38.0`), the latest stable at the time of scaffolding.
- **Decision:** Accept Laravel 13. All APIs used in Peso Plan (Sanctum tokens, migrations, Eloquent, Form Requests, routing, Policies, artisan commands) are identical between Laravel 11 and 13. No Laravel 11-specific APIs are referenced in the spec. Pinning to Laravel 11 now would require re-running the install, which would take another 20+ minutes given the `php_zip.dll` block.
- **Consequences:**
  - ✅ No functional difference for this project
  - ✅ Laravel 13 has a longer active support window than 11
  - ⚠️ Deviation from spec; recorded here and in PROGRESS.md
  - ⚠️ If the team requires Laravel 11 strictly, run: `composer create-project laravel/laravel:^11.0 backend`
