# Architecture decisions

## Local-first trust boundary

The Flutter application has no authentication boundary. It creates one stable
anonymous profile ID and stores it in device preferences. Core financial data
is stored locally in Drift/SQLite and scoped to that ID. Widgets depend on
repository interfaces rather than accessing Drift directly.

Only optional AI capture and guidance cross the network boundary. Flutter never
contains an OpenAI API key. The FastAPI service receives only the minimum input
needed for an individual AI operation.

## Startup resolver

One Riverpod controller loads preferences before GoRouter is created:

1. No locale: language selection.
2. Locale selected but consent missing or outdated: privacy consent.
3. Current consent stored: dashboard.

Router redirects apply the same rules to deep links. Onboarding completion uses
route replacement so Android Back cannot return to completed onboarding.

## Persistence

SharedPreferences stores only:

- selected locale;
- privacy accepted flag, policy version, and ISO-8601 timestamp;
- onboarding completion;
- stable local profile ID.

Drift/SQLite stores transactions, categories, budgets, savings goals and
contributions, BNPL plans and instalments, recurring payments, and financial
preferences. Money is persisted in integer minor units.

Income and expense mutations execute inside Drift transactions. Each mutation
calculates the proposed totals before writing. Expenses that exceed the
remaining balance and income reductions that would overdraw the balance are
rejected before any row changes.

## Localization

`app_en.arb` and `app_ar.arb` are the source of all system-generated UI text.
Flutter's generated localization delegate applies locale directionality
globally. System category codes are localized at display time; merchant names,
notes, and custom category names remain exactly as entered.

## AI capture lifecycle

1. Flutter sends an explicit AI request to FastAPI when online.
2. FastAPI validates and normalizes the response.
3. Flutter displays a review draft.
4. Only user confirmation writes the transaction to the local database.

Core manual tracking remains available when the backend or internet is
unavailable.
