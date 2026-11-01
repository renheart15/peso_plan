# Architecture — Peso Plan

> **Last updated:** 2026-10-28T16:50+08:00

---

## Repository Layout

```
peso_plan/
├── mobile/                    # Flutter app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── firebase_options.dart
│   │   └── core/
│   │       ├── api/           # Dio client, BankProvider interface
│   │       ├── constants/     # AppConstants, FlavorConfig
│   │       ├── database/      # Drift DB + tables + DAOs
│   │       ├── providers/     # Root Riverpod providers
│   │       ├── router/        # GoRouter config, AppRoutes
│   │       ├── theme/         # Material 3 theme, colour tokens
│   │       ├── utils/         # CurrencyFormatter, DateUtils
│   │       └── widgets/       # MainScaffold, shared widgets
│   │   └── features/          # Feature-first layout
│   │       ├── auth/
│   │       ├── dashboard/
│   │       ├── budget/
│   │       ├── transactions/
│   │       ├── accounts/
│   │       ├── goals/
│   │       ├── recurring/
│   │       ├── reports/
│   │       ├── settings/
│   │       ├── household/
│   │       └── onboarding/
│   ├── test/
│   │   ├── unit/
│   │   └── widget/
│   ├── integration_test/
│   └── assets/
│       ├── images/
│       ├── icons/
│       └── fonts/
├── backend/                   # Laravel 13 API
│   ├── app/
│   │   ├── Http/
│   │   │   ├── Controllers/Api/V1/
│   │   │   ├── Requests/      # Form Requests (validation)
│   │   │   └── Middleware/
│   │   ├── Models/
│   │   ├── Policies/          # HouseholdPolicy, etc.
│   │   └── Services/          # Business logic
│   ├── database/
│   │   ├── migrations/
│   │   └── seeders/
│   ├── routes/api.php
│   └── tests/Feature/
└── docs/
    ├── PROGRESS.md
    ├── CHANGELOG.md
    ├── DECISIONS.md
    ├── TESTING.md
    ├── ARCHITECTURE.md        (this file)
    └── store/                 # App store listing metadata
```

---

## Feature Folder Structure (per feature)

Each feature follows the same pattern:

```
features/<feature>/
├── data/
│   ├── <feature>_repository.dart   # API calls + local DB reads/writes
│   └── models/                     # JSON-serialisable data models
├── domain/
│   ├── <feature>_state.dart        # Immutable state class
│   └── entities/                   # Pure domain objects
└── presentation/
    ├── screens/                     # Full-page screens
    └── widgets/                     # Feature-specific widgets
```

---

## Data Model (Server)

### users
| Column | Type | Notes |
|--------|------|-------|
| id | bigint PK | |
| name | varchar(255) | |
| email | varchar(255) unique | |
| email_verified_at | timestamp nullable | |
| password | varchar(255) | bcrypt |
| remember_token | varchar(100) nullable | |
| created_at / updated_at | timestamp | |

### households
| Column | Type | Notes |
|--------|------|-------|
| id | bigint PK | |
| name | varchar(255) | |
| owner_id | bigint FK users | |
| created_at / updated_at | timestamp | |

### household_members
| Column | Type | Notes |
|--------|------|-------|
| id | bigint PK | |
| household_id | bigint FK | |
| user_id | bigint FK | |
| role | enum(owner, partner, viewer) | |
| created_at / updated_at | timestamp | |

### accounts
| Column | Type | Notes |
|--------|------|-------|
| id | bigint PK | |
| household_id | bigint FK | |
| name | varchar(255) | |
| type | enum(checking, savings, credit_card, cash, loan) | |
| balance_cents | bigint | integer cents |
| currency_code | char(3) | default PHP |
| is_active | boolean | default true |
| created_at / updated_at | timestamp | |

### categories
| Column | Type | Notes |
|--------|------|-------|
| id | bigint PK | |
| household_id | bigint FK nullable | null = system category |
| parent_id | bigint FK nullable | for subcategories |
| name | varchar(255) | |
| type | enum(income, expense) | |
| icon | varchar(50) nullable | icon name |
| color_hex | char(7) nullable | #RRGGBB |
| is_system | boolean | default false |
| created_at / updated_at | timestamp | |

### tags
| Column | Type | Notes |
|--------|------|-------|
| id | bigint PK | |
| household_id | bigint FK | |
| name | varchar(100) | |
| created_at / updated_at | timestamp | |

### transactions
| Column | Type | Notes |
|--------|------|-------|
| id | bigint PK | |
| household_id | bigint FK | |
| account_id | bigint FK | |
| category_id | bigint FK nullable | |
| amount_cents | bigint | always positive |
| type | enum(income, expense, transfer) | |
| date | date | |
| payee | varchar(255) nullable | |
| notes | text nullable | |
| import_hash | char(64) nullable | SHA-256 for deduplication |
| created_by | bigint FK users | |
| created_at / updated_at | timestamp | |

### transaction_tags (pivot)
| Column | Type |
|--------|------|
| transaction_id | bigint FK |
| tag_id | bigint FK |

### transaction_splits
| Column | Type | Notes |
|--------|------|-------|
| id | bigint PK | |
| transaction_id | bigint FK | |
| category_id | bigint FK | |
| amount_cents | bigint | |
| notes | text nullable | |

### budgets
| Column | Type | Notes |
|--------|------|-------|
| id | bigint PK | |
| household_id | bigint FK | |
| category_id | bigint FK | |
| year | smallint | |
| month | tinyint | 1–12 |
| planned_cents | bigint | |
| created_at / updated_at | timestamp | |

### goals
| Column | Type | Notes |
|--------|------|-------|
| id | bigint PK | |
| household_id | bigint FK | |
| name | varchar(255) | |
| target_cents | bigint | |
| current_cents | bigint | |
| due_date | date nullable | |
| type | enum(savings, debt) | |
| notes | text nullable | |
| created_at / updated_at | timestamp | |

### recurring_bills
| Column | Type | Notes |
|--------|------|-------|
| id | bigint PK | |
| household_id | bigint FK | |
| name | varchar(255) | |
| amount_cents | bigint | |
| frequency | enum(daily, weekly, biweekly, monthly, quarterly, yearly) | |
| next_due | date | |
| category_id | bigint FK nullable | |
| auto_pay | boolean | default false |
| created_at / updated_at | timestamp | |

### category_rules
| Column | Type | Notes |
|--------|------|-------|
| id | bigint PK | |
| household_id | bigint FK | |
| match_pattern | varchar(255) | regex or substring |
| category_id | bigint FK | |
| created_at / updated_at | timestamp | |

### device_tokens
| Column | Type | Notes |
|--------|------|-------|
| id | bigint PK | |
| user_id | bigint FK | |
| token | text | FCM token |
| platform | enum(ios, android) | |
| created_at / updated_at | timestamp | |

---

## API Routes (v1)

Base path: `/api/v1`

### Auth
| Method | Path | Description |
|--------|------|-------------|
| POST | `/auth/register` | Register + create household |
| POST | `/auth/login` | Login, returns Sanctum token |
| POST | `/auth/logout` | Revoke token |
| POST | `/auth/forgot-password` | Send reset link |
| POST | `/auth/reset-password` | Reset with token |
| POST | `/auth/email/resend` | Resend verification email |
| GET | `/auth/email/verify/{id}/{hash}` | Signed email verification endpoint |
| GET | `/auth/me` | Current user profile |

### Households
| Method | Path | Description |
|--------|------|-------------|
| GET | `/households` | List user's households |
| POST | `/households` | Create household |
| GET | `/households/{id}` | Get household |
| PUT | `/households/{id}` | Update household |
| POST | `/households/{id}/invite` | Invite by email |
| DELETE | `/households/{id}/members/{userId}` | Remove member |

### Accounts
| Method | Path |
|--------|------|
| GET | `/households/{hid}/accounts` |
| POST | `/households/{hid}/accounts` |
| GET | `/households/{hid}/accounts/{id}` |
| PUT | `/households/{hid}/accounts/{id}` |
| DELETE | `/households/{hid}/accounts/{id}` |

### Categories
| Method | Path |
|--------|------|
| GET | `/households/{hid}/categories` |
| POST | `/households/{hid}/categories` |
| PUT | `/households/{hid}/categories/{id}` |
| DELETE | `/households/{hid}/categories/{id}` |

### Transactions
| Method | Path | Notes |
|--------|------|-------|
| GET | `/households/{hid}/transactions` | Filters: date, account, category, tag, search |
| POST | `/households/{hid}/transactions` | |
| GET | `/households/{hid}/transactions/{id}` | |
| PUT | `/households/{hid}/transactions/{id}` | |
| DELETE | `/households/{hid}/transactions/{id}` | |
| POST | `/households/{hid}/transactions/import` | CSV import |
| POST | `/households/{hid}/transactions/bulk-categorize` | Bulk categorise |

### Budgets
| Method | Path |
|--------|------|
| GET | `/households/{hid}/budgets?year=&month=` |
| POST | `/households/{hid}/budgets` |
| PUT | `/households/{hid}/budgets/{id}` |
| DELETE | `/households/{hid}/budgets/{id}` |

### Goals
| Method | Path |
|--------|------|
| GET | `/households/{hid}/goals` |
| POST | `/households/{hid}/goals` |
| PUT | `/households/{hid}/goals/{id}` |
| DELETE | `/households/{hid}/goals/{id}` |

### Recurring Bills
| Method | Path |
|--------|------|
| GET | `/households/{hid}/recurring-bills` |
| POST | `/households/{hid}/recurring-bills` |
| PUT | `/households/{hid}/recurring-bills/{id}` |
| DELETE | `/households/{hid}/recurring-bills/{id}` |

### Reports
| Method | Path |
|--------|------|
| GET | `/households/{hid}/reports/summary` | Monthly summary |
| GET | `/households/{hid}/reports/category-breakdown` | By category |
| GET | `/households/{hid}/reports/top-payees` | Top payees |
| GET | `/households/{hid}/reports/cash-flow` | Cash-flow forecast |
| GET | `/households/{hid}/reports/export.csv` | CSV export |
| GET | `/households/{hid}/reports/export.pdf` | DomPDF transaction export with `from` and `to` date parameters |

### Notifications
| Method | Path |
|--------|------|
| POST | `/device-tokens` | Register FCM token |
| DELETE | `/device-tokens/{token}` | Remove token |
| GET | `/notification-preferences` | Get user prefs |
| PUT | `/notification-preferences` | Update prefs |

---

## Offline Sync Design

```
┌─────────────┐   read    ┌─────────────────┐
│  UI Widgets │ ────────► │  Drift (SQLite)  │
└─────────────┘           └─────────────────┘
       │ write                    ▲
       ▼                          │ sync on connect
┌─────────────┐           ┌─────────────────┐
│ Repository  │ ─online─► │  Laravel API    │
│             │ ─offline─►│  OfflineQueue   │
└─────────────┘           └─────────────────┘
```

1. **Reads** always serve from Drift for instant load.
2. **Writes** are written to Drift immediately (optimistic) and POSTed to the API.
3. **If offline**, writes are appended to the `OfflineQueue` table.
4. **On reconnect** (via `connectivity_plus`), the queue is replayed in FIFO order.
5. **Conflicts**: last-write-wins. The queued write overwrites the server state. See ADR-004.
6. **Sync status** indicator shown in the app bar during replay.

---

## BankProvider Adapter Interface

```dart
// mobile/lib/core/api/bank_provider.dart (stub — not yet implemented)
abstract class BankProvider {
  Future<List<ExternalAccount>> fetchAccounts();
  Future<List<ExternalTransaction>> fetchTransactions(DateTimeRange range);
  Future<int> getBalanceCents(String externalAccountId);
}
```

No concrete implementations in v1. To add a bank aggregator (e.g., Brankas, Plaid):
1. Create a class that implements `BankProvider`
2. Register it in the DI container
3. Wire it to the import flow in `TransactionsRepository`

---

## Flutter Folder Structure (feature-first)

Each feature is self-contained:
- `data/` — repositories (API + Drift), data models, JSON serialisation
- `domain/` — state classes, entities, business rules
- `presentation/` — screens and widgets

Shared code lives in `core/`. No feature imports another feature's internals — only `core/` is shared.
