# DinarWise Firebase telemetry

## Configuration

Firebase project: `dinnar-wise`
Android application ID: `com.sl.dinarwise.expensemanager`

Packages:

- `firebase_core`
- `firebase_analytics`
- `firebase_crashlytics`
- `firebase_performance`

Android is configured through `android/app/google-services.json` and
`lib/firebase_options.dart`. Collection is disabled in `AndroidManifest.xml`
until local consent is applied. To add iOS, download `GoogleService-Info.plist`
for bundle ID `com.dinarwise.app.dinarwise`, then run:

```bash
flutterfire configure --project=dinnar-wise --platforms=android,ios
```

## Consent and privacy

Analytics and diagnostics are separate, optional choices during privacy
onboarding and in Settings. Both default to off and can be withdrawn. Analytics
controls Firebase Analytics. Diagnostics controls Crashlytics and Performance.
Firebase initialization failure never blocks the offline application.

Financial records remain exclusively in Drift/SQLite. Never send amounts,
balances, merchant names, descriptions, notes, receipts, contact details,
custom-category names, record IDs, or the local profile ID. A custom category is
reported only as `category_type=custom`. No Firebase user ID is set and no
advertising product or personalization is enabled.

## User properties

| Property | Allowed values |
|---|---|
| `app_language` | `en`, `ar` |
| `selected_currency` | ISO code, for example `SAR`, `AED`, `KWD` |
| `onboarding_status` | `completed`, `incomplete` |
| `custom_categories_used` | `true`, `false` |
| `app_theme` | `light`, `dark`, `system` |

## Event dictionary

| Event | Safe parameters | Purpose |
|---|---|---|
| `onboarding_started` | `app_language` | Onboarding began |
| `onboarding_completed` | `selected_language` | Onboarding completed |
| `privacy_consent_updated` | `analytics_allowed`, `diagnostics_allowed` | Optional consent changed |
| `language_changed` | `from_language`, `to_language` | Locale changed |
| `currency_changed` | `from_currency`, `to_currency` | Display currency changed |
| `income_add_started` | none | Manual income flow opened |
| `income_added` | `currency`, `entry_source` | Income saved successfully |
| `income_edited` | `currency` | Income edited successfully |
| `income_deleted` | `currency` | Income deleted successfully |
| `income_action_failed` | `action`, `reason` | Meaningful income failure |
| `expense_add_started` | none | Manual expense flow opened |
| `expense_added` | `category_type`, `currency`, `entry_source` | Expense saved successfully |
| `expense_edited` | `category_type`, `currency` | Expense edited successfully |
| `expense_deleted` | `category_type`, `currency` | Expense deleted successfully |
| `expense_action_failed` | `action`, `reason` | Meaningful expense failure |
| `custom_category_created` | none | Custom category saved |
| `custom_category_edited` | none | Custom category renamed |
| `custom_category_deleted` | none | Custom category removed |
| `transactions_viewed` | none | History viewed |
| `transaction_search_used` | none | Search used; query omitted |
| `transaction_filter_applied` | `filter_type` | A history filter was applied |
| `analytics_viewed` | `period` | Reports period viewed |
| `dashboard_summary_viewed` | none | Dashboard summary loaded |
| `ai_information_viewed` | none | Offline AI information opened |
| `settings_viewed` | none | Settings opened |
| `theme_changed` | `theme` | Theme changed when supported |
| `data_export_started` | `format` | Existing export started |
| `data_export_succeeded` | `format` | Existing export succeeded |
| `data_export_failed` | `format`, `reason` | Existing export failed |

Firebase automatically supplies `first_open`, `app_open`, `session_start`, and
`app_update`; DinarWise does not duplicate them.

## Performance traces

Approved trace names are `app_initialization`, `database_initialization`,
`dashboard_load`, `transactions_load`, `analytics_calculation`,
`transaction_search`, and `data_export`. No financial attributes are attached.

## Android DebugView

Connect the device or emulator, then run:

```bash
adb shell setprop debug.firebase.analytics.app com.sl.dinarwise.expensemanager
adb shell am force-stop com.sl.dinarwise.expensemanager
adb shell monkey -p com.sl.dinarwise.expensemanager 1
```

Open Firebase Console → Analytics → DebugView. Enable Analytics in DinarWise
Settings, then perform a test action. Disable DebugView afterward:

```bash
adb shell setprop debug.firebase.analytics.app .none.
```

Normal events are available under Firebase Console → Analytics → Events.
Crashes appear under Crashlytics, and traces under Performance. Initial console
data can take time to process; DebugView is the immediate validation tool.
