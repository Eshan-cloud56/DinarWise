# DinarWise

DinarWise is an Arabic/English household-finance application designed around
salary cycles, shared budgets, BNPL visibility, and culturally relevant savings
goals. This repository contains the initial Flutter client and FastAPI service.

## Current foundation

- Flutter Material 3 shell with Riverpod, GoRouter, Dio, English/Arabic
  localization, and automatic RTL layout
- Global email/password registration and login with securely hashed passwords,
  persisted sessions, personal household creation, and login audit events
- FastAPI API with typed request/response models and PostgreSQL-ready SQLAlchemy
  models
- Household-scoped transaction authorization
- Natural-language expense draft extraction with Arabic digit normalization
- Mandatory confirmation contract before a draft can become a transaction
- Deterministic safe-to-spend calculation using integer minor currency units
- PostgreSQL, Redis, Docker, Alembic, and starter tests

The dashboard loads authenticated household transactions from the API. Manual
expense entry works without AI; structured AI extraction can be connected later.

## Run the backend

For the simplest local setup, the API uses SQLite and creates `dinarwise.db`
automatically:

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
cp .env.example .env
uvicorn app.main:app --reload
```

Open another terminal and run the Flutter app. Register from the login portal;
the API stores only a salted password hash, never the original password.

## Run the mobile app

Install Flutter stable, then:

```bash
cd mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:8000/api/v1
```

Android emulators generally reach the host at `10.0.2.2` rather than
`localhost`. Never pass an OpenAI key through `--dart-define` or store one in
Flutter.

## Capture boundary

`POST /api/v1/capture/text` creates a review-only draft. The API never writes an
AI extraction directly to `transactions`. `POST /api/v1/transactions` requires
`"confirmed": true`, and the backend checks membership in the target household.
Receipt and voice capture should follow this same boundary when their storage
and background worker adapters are added.

## Next implementation slice

1. Connect Supabase Auth and profile/household onboarding.
2. Extend the schema for savings goals, challenges, splits, and audit records.
3. Implement signed receipt uploads and an ARQ worker with strict structured AI
   output.
4. Replace dashboard fixtures with `/budgets/safe-to-spend` and transaction data.
5. Add encrypted offline transaction caching, push tokens, and scheduled
   reminders.
