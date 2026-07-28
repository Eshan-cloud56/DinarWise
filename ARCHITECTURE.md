# Architecture decisions

## Trust boundary

Flutter communicates only with FastAPI. Supabase JWTs identify users; every
household-scoped query must join through `household_members`. Private object
paths stay in PostgreSQL and clients receive short-lived signed URLs only.

## Financial correctness

All persisted money uses integer minor units (`amount_minor`) to avoid
floating-point rounding. Safe-to-spend, totals, forecasts, and comparisons are
calculated in Python. AI receives only sanitized calculated facts when asked to
explain a weekly summary.

## AI capture lifecycle

1. Flutter uploads or sends text to FastAPI.
2. FastAPI stores private media and queues an extraction job.
3. The worker asks the AI provider for schema-constrained output.
4. FastAPI validates and normalizes dates, currencies, Arabic digits, and amount.
5. Flutter shows confidence-aware review.
6. Only a user-confirmed request creates a verified transaction.

Confidence levels are `normal` at 0.85+, `uncertain` at 0.60–0.84, and `manual`
below 0.60. Confidence changes presentation, never the confirmation requirement.

## Modules

- `mobile`: presentation, device integrations, secure token storage, offline cache
- `backend/app/api`: HTTP boundary and authorization
- `backend/app/services`: deterministic domain and capture normalization logic
- `backend/app/models`: household-scoped PostgreSQL persistence
- Future worker: receipt/voice processing, reminders, and weekly summaries
