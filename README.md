# Peso Plan 💰

> A zero-based household budget app for the Philippines — built with **Laravel 13** (REST API) + **Flutter** (iOS & Android).

---

## Project Structure

```
peso_plan/
├── backend/      # Laravel 13 REST API
├── mobile/       # Flutter app (iOS + Android)
└── docs/         # Architecture, progress, decisions, testing docs
```

---

## Quick Start

### Prerequisites

| Tool | Required Version |
|------|-----------------|
| PHP | 8.2+ |
| Composer | 2.x |
| MySQL | 8.0+ (via Laragon or MAMP) |
| Flutter | 3.22+ |
| Dart | 3.4+ |
| Node.js | 18+ (for Firebase tools) |

---

### 1 — Backend Setup

```bash
# Install PHP dependencies
cd backend
composer install

# Copy environment file
copy .env.example .env   # Windows
# cp .env.example .env   # macOS/Linux

# Generate app key
php artisan key:generate
```

**Create the MySQL database** (via Laragon HeidiSQL, MySQL Workbench, or CLI):

```sql
CREATE DATABASE peso_plan CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

```bash
# Run all migrations
php artisan migrate

# Seed with demo data (optional but recommended for development)
php artisan db:seed

# Start the dev server
php artisan serve
# API will be available at http://localhost:8000/api/v1
```

**Demo credentials** (after seeding):
- Email: `demo@pesoplan.app`
- Password: `password`

---

### 2 — Flutter App Setup

```bash
cd mobile

# Get dependencies
flutter pub get

# Generate Drift database code (required before running)
dart run build_runner build --delete-conflicting-outputs

# Firebase is configured for project peso-plan and app ID com.pesoplan.app.

# Run on connected device / emulator
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1   # Android emulator
flutter run --dart-define=API_BASE_URL=http://localhost:8000/api/v1   # iOS simulator
```

> **Note:** The Android emulator loopback for the host machine is `10.0.2.2`, not `localhost`.

---

## Cloud Deployment

The Laravel API is prepared for Render using the repository-level `render.yaml` Blueprint.

1. Create a Render PostgreSQL database.
2. In Render, create the Blueprint from the repository or deploy the Docker service defined in `render.yaml`.
3. Set `APP_KEY` to the output of `php artisan key:generate --show` and set `APP_URL` to the public HTTPS service URL.
4. Set `DB_URL` to the Render PostgreSQL internal connection string. `DB_SSLMODE=require` is already configured.
5. The Docker entrypoint runs migrations and caches Laravel configuration before Apache starts. The health check is `GET /up`.

Build the Flutter app for the deployed API:

```powershell
cd mobile
flutter build apk --release --dart-define=API_BASE_URL=https://YOUR-SERVICE.onrender.com/api/v1 --dart-define=FLAVOR=production
flutter build ios --release --dart-define=API_BASE_URL=https://YOUR-SERVICE.onrender.com/api/v1 --dart-define=FLAVOR=production
```

Firebase uses project `peso-plan`, Android application ID `com.pesoplan.app`, and iOS bundle ID `com.pesoplan.app`. APNs delivery still requires the Apple APNs key to be uploaded in Firebase.

---

## API Reference

Base URL: `http://localhost:8000/api/v1`

All authenticated requests require `Authorization: Bearer <token>` header.

### Auth

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/register` | Register + create household |
| POST | `/auth/login` | Login, returns token |
| POST | `/auth/logout` | Revoke token |
| GET | `/auth/me` | Current user |
| POST | `/auth/forgot-password` | Send reset email |
| POST | `/auth/reset-password` | Reset with token |

### Household Resources (all require auth + membership)

| Resource | Endpoints |
|----------|-----------|
| Households | `/households` (CRUD) |
| Accounts | `/households/{id}/accounts` (CRUD) |
| Categories | `/households/{id}/categories` (CRUD) |
| Transactions | `/households/{id}/transactions` (CRUD + import + bulk-categorize) |
| Budgets | `/households/{id}/budgets` (CRUD) |
| Goals | `/households/{id}/goals` (CRUD) |
| Recurring Bills | `/households/{id}/recurring-bills` (CRUD) |
| Reports | `/households/{id}/reports/summary`, `category-breakdown`, `top-payees`, `cash-flow`, `export.csv`, `export.pdf` |

---

## Environment Variables

### Backend (`.env`)

| Key | Default | Description |
|-----|---------|-------------|
| `DB_DATABASE` | `peso_plan` | MySQL database name |
| `DB_USERNAME` | `root` | MySQL user |
| `DB_PASSWORD` | _(empty)_ | MySQL password |
| `CORS_ALLOWED_ORIGINS` | `http://localhost:8080` | Comma-separated allowed origins |
| `MAIL_MAILER` | `log` | Set to `smtp` for production |

### Flutter (`--dart-define`)

| Key | Example | Description |
|-----|---------|-------------|
| `API_BASE_URL` | `http://10.0.2.2:8000/api/v1` | Backend API base URL |
| `FLAVOR` | `dev` | App flavor: `dev`, `staging`, `production` |

---

## Running Tests

### Laravel

```bash
cd backend
php artisan test
```

### Flutter

```bash
cd mobile
flutter test
```

See [`docs/TESTING.md`](docs/TESTING.md) for full test status and coverage targets.

---

## Development Docs

| File | Description |
|------|-------------|
| [`docs/PROGRESS.md`](docs/PROGRESS.md) | Step-by-step progress tracker |
| [`docs/DECISIONS.md`](docs/DECISIONS.md) | Architecture Decision Records (ADRs) |
| [`docs/TESTING.md`](docs/TESTING.md) | Test status, coverage targets, QA checklist |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | System architecture overview |
| [`docs/CHANGELOG.md`](docs/CHANGELOG.md) | Version history |

---

## Architecture at a Glance

```
┌──────────────────────────────────────────────┐
│              Flutter App (mobile/)            │
│  ┌──────────┐  ┌────────────┐  ┌──────────┐ │
│  │ Riverpod │  │  go_router │  │  Drift   │ │
│  │  State   │  │    Nav     │  │  Local   │ │
│  └──────────┘  └────────────┘  │   DB     │ │
│        ↕  Dio (Bearer token)   └──────────┘ │
└─────────────────────┬────────────────────────┘
                      │ HTTPS / HTTP
┌─────────────────────▼────────────────────────┐
│         Laravel 13 API (backend/)             │
│  ┌────────────┐  ┌──────────┐  ┌──────────┐ │
│  │  Sanctum   │  │ Eloquent │  │ Policies │ │
│  │   Auth     │  │  Models  │  │  (RBAC)  │ │
│  └────────────┘  └──────────┘  └──────────┘ │
│              ↕ MySQL (peso_plan)              │
└──────────────────────────────────────────────┘
```

**Key decisions:**
- All money stored as **integer cents** (e.g., ₱1,234.56 → `123456`) — see ADR-001
- **Cache-then-network** with offline write queue — see ADR-004
- **Three-role household** model: `owner`, `partner`, `viewer` — see ADR-006

---

## License

Private / proprietary. All rights reserved.
