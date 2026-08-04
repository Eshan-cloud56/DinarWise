# Dinar Wise: Expense AI Manager
## Functionality, Architecture, Privacy, Analytics, and Android Publishing Guide

**Application ID:** `com.sl.dinarwise.expensemanager`

**Platform in scope:** Android

**Current Flutter version declaration:** `0.1.0+1`

**Local database schema:** Drift/SQLite schema version 2

**Firebase project:** `dinnar-wise`
**Document date:** 4 August 2026

## 1. Product summary

Dinar Wise is a single-user, offline-first household finance application for Android. It helps one person record and manage household income, expenses, budgets, savings goals, bills, subscriptions, and buy-now-pay-later plans. Financial records remain in the private Drift/SQLite database on the device.

The application supports English and Arabic, including right-to-left layouts, and supports SAR, AED, KWD, BHD, QAR, and OMR. Firebase Analytics, Crashlytics, and Performance Monitoring are optional. Collection remains disabled until the user explicitly enables the applicable consent setting.

The application does not require login, registration, email, phone number, OTP, social login, or a cloud account.

## 2. User journey

### Fresh installation

1. Branded animated launch screen.
2. Language selection: English or العربية.
3. Privacy Policy consent.
4. Optional anonymous Analytics and diagnostic-data choices.
5. Currency selection.
6. Dashboard.

The Privacy Policy checkbox is mandatory before continuing. Analytics and diagnostic consent are separate and optional.

### Returning user

The startup resolver restores the selected language and currency, validates the stored Privacy Policy version, and opens the Dashboard directly when onboarding is complete. If the Privacy Policy version changes, the application requests consent again without requiring language selection again.

### Reset flow

Settings contains **Reset application data**. The user must confirm before local financial data and onboarding preferences are permanently deleted. Cancelling preserves all data. A completed reset returns to Language Selection.

## 3. Dashboard

The Dashboard is the main financial overview. It provides:

- Total expenses.
- Total income.
- Remaining balance.
- Recent transactions.
- Add Income action.
- Add Expense action.
- Safe-to-spend summary when a budget is configured.
- Upcoming bill or subscription information.
- Upcoming BNPL instalment information.
- Direct access to Analytics, AI information, Settings, History, Budgets, Savings Goals, BNPL, and Bills & Subscriptions.

The authoritative balance formula is:

`Remaining balance = Total income - Total expenses`

Amounts are stored in integer minor units rather than floating-point values.

## 4. Income and expense management

### Income

The user can add, edit, and delete income locally. Income must be greater than zero. Reducing or deleting income is blocked when the change would make the remaining balance negative.

### Expenses

The user can add, edit, duplicate, and delete expenses locally. The manual form supports:

- Merchant or seller.
- Amount.
- Category.
- Description or notes.
- Transaction date.
- Payment method.
- Optional receipt image.

Expenses must be greater than zero. An expense cannot exceed the available remaining balance, and the balance cannot become negative. Deleting an expense restores its amount. Editing an expense recalculates and validates the balance.

Balance validation and persistence use local database transactions so a rejected operation cannot partially modify the financial state.

## 5. Transaction history and spending calendar

The History feature supports:

- Search across merchant, notes, category, and amount.
- Income/expense filtering.
- Category filtering.
- Payment-method filtering.
- Custom date-range filtering.
- Newest, oldest, highest-amount, and lowest-amount sorting.
- Saved filter and view preferences.
- Date grouping with daily income, expense, and net totals.
- Editing, deletion, and duplication.
- Lazy/paginated data access suitable for larger transaction sets.
- Receipt attachment indicators.

The calendar view provides an offline monthly spending calendar, marks dates containing transactions, shows daily totals, and allows the user to open transactions for a selected date. Calendar preferences include first weekday and optional Hijri display.

## 6. Analytics and deterministic insights

The in-app Analytics screen calculates reports locally from SQLite records. It includes daily, weekly, monthly, and yearly views; income-versus-expense comparisons; category breakdowns; current-versus-previous-period comparisons; average daily spending; highest-spending merchant and category; trends; savings rate; and rule-based insights.

Authoritative accounting calculations never depend on AI or Firebase. Firebase Analytics measures privacy-safe product usage only; it does not calculate the user's finances.

## 7. Budgets and safe to spend

Budget functionality includes category and overall budgets, multiple categories, progress, amount spent, remaining amount, percentage used, overspending state, warning thresholds, rollover modes, monthly or salary-cycle periods, payday, fixed commitments, emergency buffer, history, and editing.

Safe-to-spend calculations account for available balance and planned commitments:

`Safe to spend = Remaining balance - upcoming bills - upcoming BNPL instalments - planned savings contributions - emergency buffer`

The Dashboard can display the result and remaining days until payday.

## 8. Savings goals

Savings goals support:

- Target amount and optional target date.
- Current saved amount and remaining amount.
- Add, edit, and delete contributions.
- Contribution history.
- Progress and completion state.
- Required weekly and monthly contributions.
- Templates for Emergency Fund, Travel, Wedding, Car, Education, Hajj, Umrah, Eid, and Custom Goal.
- Local milestone support through the notification architecture.

## 9. Bills, subscriptions, and recurring payments

Recurring records support daily, weekly, monthly, and yearly schedules; start date; optional end date; occurrence limits; interval count; upcoming occurrence; paid status; payment history; active or ended status; and subscription price history.

Occurrence reconciliation runs locally during application lifecycle events. Deterministic identifiers and database uniqueness rules prevent the same recurring occurrence from being created twice.

## 10. BNPL management

The BNPL feature tracks Tabby, Tamara, and custom providers without connecting to provider APIs. It supports merchant, purchase amount and date, instalment count, individual instalment amounts and dates, paid/unpaid state, payment history, next payment, outstanding amount, late status, and completed-plan status.

The sum of instalments must equal the purchase amount. Outstanding instalments are included in safe-to-spend calculations.

## 11. Categories and payment methods

System and custom expense categories are available offline. Custom names are preserved exactly as entered and are never automatically translated. Duplicate names are rejected case-insensitively. Categories support icons, colors or emoji, last-used information, usage ordering, and protected deletion when related records still exist.

Payment methods include Cash, Debit Card, Credit Card, Bank Transfer, Mada, STC Pay, Google Pay, Tabby, Tamara, Other, and custom options. The system supports a default method, recent/most-used ordering, renaming, deletion protection, and transaction filtering. These are descriptive labels only; there is no payment-provider integration.

## 12. Receipt attachments

Manual receipt handling works offline:

- Capture through the Android camera.
- Select from the Android gallery.
- Accept an Android shared image when supported by the installed build.
- Compress and store images in private application storage.
- Attach, replace, view, zoom, or remove an image without deleting the transaction.
- Display thumbnails and attachment indicators.
- Review total receipt storage and clear selected or all receipt files.

Receipt contents and images are never sent to Firebase.

## 13. Backup, export, security, and calculators

Data tools include CSV transaction export/import with validation and duplicate handling, PDF financial reports, and encrypted backup/restore with optional receipt images. Destructive restore operations require confirmation and are designed to roll back on failure.

Optional local security includes a numeric PIN, secure salted PIN hashing, Android biometric authentication when supported by the device, automatic-lock timeout, background locking, changing the PIN, and disabling protection after verification. No account is introduced.

Offline calculators include 50/30/20 budgeting, emergency fund, travel budget, debt payoff, savings goal, and compound interest. Calculator output does not change financial records unless the user explicitly confirms an applicable action.

## 14. Currency support

Supported Gulf currencies are:

- SAR — Saudi riyal.
- AED — UAE dirham.
- KWD — Kuwaiti dinar.
- BHD — Bahraini dinar.
- QAR — Qatari riyal.
- OMR — Omani rial.

Currency formatting uses the appropriate minor-unit precision. The database can store original transaction currency, original amount, and a manually entered or cached exchange rate with its date. Changing the display currency preserves financial records.

## 15. Localization and accessibility

The application uses Flutter localization resources and centralized ARB files for English and Arabic. Arabic enables RTL layout throughout the application. System-generated labels, errors, forms, dialogs, empty states, analytics text, Firebase consent explanations, notification text, and settings text are localized. User-entered merchant names, notes, custom categories, and goal names remain unchanged.

The interface uses safe areas, scalable text, touch-friendly controls, and layout mirroring where appropriate.

## 16. Optional AI behavior

Core finance features do not require AI or internet access. When no secure backend is configured, the application shows a friendly offline/manual-entry explanation.

Any future receipt extraction, voice transcription, screenshot extraction, categorization, or assistant functionality must call a secure Python backend. An OpenAI API key must never be embedded in Flutter. AI-extracted transactions must be reviewed before saving.

## 17. Firebase on Android only

Firebase is configured only for Android package `com.sl.dinarwise.expensemanager`. The application uses:

- Firebase Core.
- Firebase Analytics.
- Firebase Crashlytics.
- Firebase Performance Monitoring.

No Firebase Authentication, Firestore, Realtime Database, or Cloud Storage is used. Financial data remains exclusively in local Drift/SQLite storage.

### Consent behavior

- Anonymous Analytics defaults to disabled.
- Diagnostics, Crashlytics, and Performance default to disabled.
- The user may opt in during privacy onboarding or later in Settings.
- The user may withdraw either consent at any time.
- Firebase initialization or reporting failure never blocks the offline application.

### Data that must never be transmitted to Firebase

- Exact income, expense, balance, budget, or goal amounts.
- Merchant names.
- Notes or descriptions.
- Receipt contents or images.
- Names, emails, or phone numbers.
- Custom category names.
- Database record IDs.
- Local profile ID.

Firebase receives only privacy-safe events such as screen names, successful action types, language, selected currency, generic built-in category identifiers, and technical performance/crash context. Custom categories are reported only as `category_type=custom`. No custom Firebase user ID, advertising personalization, or advertising identifier is configured.

## 18. Firebase event inventory

Events implemented include onboarding start/completion, privacy-consent changes, language and currency changes, income/expense add-start/success/edit/delete/failure, custom-category create/edit/delete, transaction History/search/filter use, Analytics view, Dashboard summary view, AI information view, Settings view, and existing export start/success/failure.

Firebase automatic events such as `first_open`, `app_open`, `session_start`, and `app_update` are not manually duplicated.

Performance traces cover application initialization, database initialization, Dashboard load, transaction load, analytics calculation, search, and existing data export.

## 19. Local technical architecture

- **UI framework:** Flutter Material.
- **State management and dependency injection:** Riverpod.
- **Routing:** GoRouter with a centralized onboarding resolver and consent guards.
- **Structured local storage:** Drift over SQLite, schema version 2.
- **Simple preferences:** SharedPreferences.
- **Localization:** `flutter_localizations`, `intl`, and ARB resources.
- **Identifiers:** UUIDs and one stable locally stored profile ID.
- **Money:** integer minor units.
- **Notifications:** local, timezone-aware Android notifications.
- **Receipts:** private application file storage.
- **Telemetry:** optional Firebase services for Android only.

The schema includes transactions, categories, budgets, budget-category links, budget history, savings goals, contributions, BNPL plans and instalments, recurring payments and occurrences, payment histories, subscription price history, payment methods, receipt attachments, notification schedules, exchange rates, security preferences, financial preferences, and UI preferences.

## 20. Current verification status

The latest verified development build completed these commands successfully on 4 August 2026:

- `flutter analyze` — no issues found.
- `flutter test` — all 36 tests passed.
- `flutter build apk --debug` — successful.

The generated debug APK is suitable for direct device testing. It is not the artifact that should be submitted to Google Play.

## 21. Critical production-release blockers

Before Play Store publication, complete all of the following:

1. Replace debug signing with a protected production upload key.
2. Never commit the keystore or `key.properties` secrets to Git.
3. Increase the application version from `0.1.0+1` to the intended first production version and increment the build number for every update.
4. Build and test a signed release Android App Bundle (`.aab`).
5. Confirm the final app icon, adaptive icon, feature graphic, phone screenshots, descriptions, support email, and privacy-policy URL.
6. Complete Play Console App content declarations, including Data safety, content rating, target audience, ads declaration, and app access.
7. Declare optional Firebase Analytics, Crashlytics, and Performance collection accurately, including third-party SDK handling.
8. Test through the Play Console internal track before production.
9. Confirm Google Play target API requirements at submission time.
10. Review the current Privacy Policy and Play Store disclosure with qualified legal/privacy counsel for target countries.

The current Gradle release block uses the debug signing configuration. Do not publish that configuration.

## 22. Create the production upload key

Run this once on the release owner’s secure Mac:

```bash
keytool -genkeypair -v \
  -keystore dinarwise-upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias dinarwise-upload
```

Store the keystore and passwords in an encrypted password manager and secure backup. Loss of the upload key creates an account-recovery process and can delay updates.

Create `mobile/android/key.properties` locally:

```properties
storePassword=REPLACE_WITH_SECURE_PASSWORD
keyPassword=REPLACE_WITH_SECURE_PASSWORD
keyAlias=dinarwise-upload
storeFile=/ABSOLUTE/SECURE/PATH/dinarwise-upload-keystore.jks
```

Configure `android/app/build.gradle.kts` to load that file and use the release signing configuration. Ensure `.gitignore` excludes `key.properties`, `*.jks`, and `*.keystore`.

## 23. Build the Play Store bundle

From the Flutter project root:

```bash
cd "/Users/macbook/Documents/Dinar Wise/mobile"
dart format .
flutter analyze
flutter test
flutter build appbundle --release
```

The expected output is:

`build/app/outputs/bundle/release/app-release.aab`

Google Play requires Android App Bundles for new applications and uses the bundle to generate optimized APKs for supported devices.

## 24. Play Console publishing procedure

1. Create or verify the Google Play Developer account.
2. Open Play Console and choose **All apps → Create app**.
3. Use the store name **Dinar Wise: Expense AI Manager**.
4. Choose the default language, App, Free/Paid status, support email, and required declarations.
5. Confirm package name `com.sl.dinarwise.expensemanager`. Package names are unique and permanent after use.
6. Complete the Main store listing: short description, full description, icon, feature graphic, screenshots, category, tags, and contact details.
7. Complete **Policy and programs → App content**, including Privacy Policy, Data safety, Ads, App access, Target audience, Content rating, and any applicable financial-feature declarations.
8. Enroll in Play App Signing.
9. Open **Test and release → Internal testing**, create a release, upload `app-release.aab`, add release notes, and add testers.
10. Install the Play-delivered build from the tester link and repeat the complete acceptance checklist.
11. Review Pre-launch report, Android Vitals, Crashlytics, Performance, Firebase Analytics DebugView/Events, permissions, and device compatibility.
12. If the developer account is subject to Google’s closed-testing requirement, complete the required testing duration and tester participation before applying for production access.
13. Create the Production release, choose countries/regions, review errors and warnings, and submit for review.
14. Use staged rollout for the first public release where practical, then monitor stability and expand gradually.

## 25. Store listing asset checklist

- Final Android launcher and adaptive icons.
- 512 × 512 high-resolution Play icon.
- 1024 × 500 feature graphic.
- At least two representative phone screenshots; provide English and Arabic sets when useful.
- Clear short and full descriptions that do not overpromise AI behavior.
- Support email and optional website.
- Public Privacy Policy URL: `https://sites.google.com/view/silvesterstudio-privacy-policy/home`.
- Release notes for English and Arabic.

Avoid claims such as “completely offline” without qualification. Core financial data and operations are offline; optional Firebase usage and diagnostic information may be transmitted after consent when internet is available.

## 26. Data safety guidance

The Play Console Data safety form must reflect the exact behavior of the submitted build and every embedded SDK. Firebase collection is optional and consent-controlled, but it still requires accurate disclosure when enabled. Review Firebase’s current SDK data-disclosure documentation while completing the form.

Do not mechanically copy a generic declaration. The publisher is responsible for confirming collection, sharing, purposes, optionality, encryption in transit, deletion behavior, and retention based on the final build and current policies.

## 27. Pre-release acceptance checklist

### Onboarding and privacy

- Fresh install follows Language → Privacy → Currency → Dashboard.
- Mandatory Privacy Policy checkbox gates continuation.
- Optional Analytics and Diagnostics choices default off.
- Returning user opens Dashboard directly.
- Updated policy version requests consent again.

### Finance and offline behavior

- Add, edit, duplicate, and delete income/expenses in airplane mode.
- Overspending and negative-balance operations are blocked.
- Data survives application restart and device reboot.
- Budgets, safe to spend, goals, recurring records, and BNPL totals reconcile correctly.
- Custom categories and payment methods persist.
- Receipt operations work offline.
- CSV/PDF/backup/restore operations are verified with representative data.

### Language and currency

- English is LTR and Arabic is RTL.
- No untranslated system text appears on primary Arabic screens.
- Arabic content does not clip at large text scales.
- All six currencies use correct precision and formatting.
- Changing language or currency does not delete records.

### Android and Firebase

- Camera, gallery, notification, biometric, and shared-image behaviors are tested on supported devices.
- Analytics remains silent before consent and stops after withdrawal.
- DebugView receives privacy-safe events after consent.
- Crashlytics and Performance respect diagnostic consent.
- No amount, merchant, note, receipt, record ID, or local profile ID appears in Firebase.
- Release build installs through Play internal testing.
- App startup, ANR, crash-free users, and performance traces are monitored.

## 28. Monitoring after launch

Use Firebase Console for anonymous consented product usage, screen/event activity, Crashlytics, and Performance Monitoring. Use Play Console for acquisition, installs, active devices, store conversion, ratings, reviews, crashes, ANRs, and device compatibility.

Production Analytics reports are aggregated and may take time to process. DinarWise does not set a custom Firebase user ID, so the publisher cannot identify a specific person. This is intentional privacy protection.

For each update:

1. Increment the version/build number.
2. Run format, analyzer, tests, and release build.
3. Upload the signed AAB using the same upload key.
4. Use internal or closed testing.
5. Review telemetry and Android Vitals.
6. Roll out gradually.

## 29. Instructions for another GPT or developer

When using this document as implementation context, instruct the model or developer to inspect the repository before changing it. They must preserve Drift schema migrations, integer minor-unit money handling, local profile behavior, English/Arabic localization, RTL support, privacy consent, and the stable Android application ID.

They must not:

- Rebuild the application from scratch.
- Add login or Firebase Authentication.
- Move financial data to Firebase.
- embed secrets or an OpenAI key in Flutter.
- Send sensitive financial or user-entered data to Analytics or Crashlytics.
- Delete the local database during migration.
- Change the package name after Play Store registration.
- Commit upload keystores or passwords.
- Claim commands passed unless they were actually run.

## 30. Authoritative references

- Flutter Android deployment: https://docs.flutter.dev/deployment/android
- Android publishing overview: https://developer.android.com/studio/publish/
- Android app signing: https://developer.android.com/studio/publish/app-signing
- Upload an Android App Bundle: https://developer.android.com/studio/publish/upload-bundle
- Play Console app setup: https://support.google.com/googleplay/android-developer/answer/9859152
- Play testing tracks: https://support.google.com/googleplay/android-developer/answer/9845334
- Prepare and roll out a release: https://support.google.com/googleplay/android-developer/answer/9859348
- Google Play Data safety: https://support.google.com/googleplay/android-developer/answer/10787469
- Firebase Analytics for Flutter: https://firebase.google.com/docs/analytics/get-started?platform=flutter
- Firebase Crashlytics for Flutter: https://firebase.google.com/docs/crashlytics/get-started?platform=flutter
- Firebase Performance for Flutter: https://firebase.google.com/docs/perf-mon/get-started-flutter

---

**Release note:** This document describes the inspected repository as of 4 August 2026. Google Play and Firebase requirements can change. Re-check the linked official documentation immediately before submission.
