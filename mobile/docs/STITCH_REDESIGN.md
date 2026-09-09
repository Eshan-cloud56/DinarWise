# Stitch UI redesign

## Scope

The supplied dashboard, transactions, add-transaction PNGs and HTML, logo,
and GCC Wealth Companion DESIGN.md were used as the visual reference.
This is a presentation update: no financial repository, calculator, SQLite
schema/migration, Firebase service, or backend implementation was modified.
Pre-existing backend changes were left untouched.

## Design implementation

- Shared emerald (#0E4D3E), forest, ivory, warm porcelain, mint and gold tokens.
- Offline-bundled Inter, Plus Jakarta Sans and Noto Sans Arabic, with OFL licenses.
- Shared cards, amount formatting, branded headers, transaction tiles and navigation.
- Home: real balance/income/expense/goal totals, existing daily safe-to-spend,
  quick actions, existing upcoming commitments, local analytics breakdown with
  weekly/monthly/yearly selectors, recent transactions and planning links.
- History: existing persisted search, type/category/date/payment-method filters,
  sorting, paging, edit/delete/duplicate preserved. Advanced filters are expandable.
  Monthly cash flow uses the existing analytics calculator.
- Expense entry: category chips/custom category, existing merchant/notes/date/
  payment-method fields, existing attachment picker/viewer, number keypad and save.
- Income: the existing amount-only dialog/actions remain, restyled with a keypad.
- Home / Transactions / Add / Planning / Insights navigation. Settings remains
  accessible through the header. Existing planning tools are grouped on a new hub.
- Existing budgets, goals, bills, subscriptions, BNPL, security, settings and
  onboarding inherit the shared theme. Onboarding uses the supplied logo.
- Tutorial anchors remain attached to real controls and scroll into view.

## Intentional differences from the mockups

- No invented merchant data, person/photo, bank account, comparison percentage,
  open-banking connection, Sharia certification, or notification count.
- Transfer explains that account transfers do not exist; no fake ledger transfer.
- Income uses its existing dialog rather than changing income persistence.
- BNPL links to existing plan management; it does not split an expense.
- Receipt capture means manual camera/gallery attachment only. No OCR, ML Kit,
  AI tagging, or new AI backend wiring.
- The launch video and Android launcher icon were not replaced by this screen redesign.

## Verification

- flutter gen-l10n and dart format lib test.
- flutter analyze: no issues.
- Full Flutter suite: 52 tests passed, including four new UI tests.
- English and Arabic: income/expense save and balance, history search/back,
  320px screens at 200% text scale, onboarding and tutorial regression coverage.
- Existing repository, migration, analytics/telemetry and financial-calculation
  tests remain in the suite.
- UI previews can be regenerated with:
  flutter test --no-pub test/stitch_redesign_test.dart --dart-define=UI_PREVIEWS=true
  (outputs under build/ui-previews).
- Android debug build is a validation artifact, not a production release.

## Device review

Before distribution, check the actual Samsung camera/gallery permissions,
large-text keyboard interactions, gesture/system Back, and the full scrolling
dashboard on physical hardware. No device was reset or uninstalled for this work.
