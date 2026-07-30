# DinarWise

DinarWise is a single-user Arabic/English, offline-first household-finance
application for expenses, income, budgets, savings goals, BNPL plans, bills,
and subscriptions.
The repository contains a Flutter mobile application and a FastAPI service for
optional network-dependent AI features.

## Current application flow

```text
Application launch
→ Language selection
→ Privacy Policy consent
→ Dashboard
```

There is no login, registration, OTP, email verification, session, or logout.
A stable anonymous local profile ID is created once per installation.

## Mobile architecture

- Flutter Material 3 with Riverpod and GoRouter
- Generated English/Arabic localization from ARB files with automatic LTR/RTL
- SharedPreferences for locale, privacy consent/version/timestamp, onboarding
  completion, and the stable local profile ID
- Drift/SQLite repositories for all structured financial records
- Integer minor currency units for financial correctness
- Atomic balance validation where remaining balance equals total income minus
  total expenses and can never become negative
- Dio reserved for optional backend AI calls; manual finance features do not
  require the API or an internet connection

## Run the mobile app

```bash
cd mobile
flutter pub get
flutter run
```

Choose an Android emulator or a connected Android phone from VS Code. The core
application does not need the backend. Never pass an OpenAI key to Flutter.

## Run the optional backend

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
cp .env.example .env
uvicorn app.main:app --reload
```

The backend currently exposes deterministic text-draft extraction and
safe-to-spend calculation. AI keys remain backend-only. Capture responses are
review-only and always require user confirmation before the Flutter app stores
a transaction locally.

## Privacy Policy version

Change `currentPrivacyPolicyVersion` in
`mobile/lib/core/constants.dart` when the policy changes. Returning users keep
their selected language but must accept the new policy version.

## Verification

```bash
cd mobile
dart format .
flutter analyze
flutter test
flutter build apk --debug
```

Backend verification:

```bash
cd backend
.venv/bin/ruff check .
.venv/bin/pytest
```
