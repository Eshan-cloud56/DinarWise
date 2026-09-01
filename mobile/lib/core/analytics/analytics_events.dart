/// Privacy-reviewed Firebase Analytics event and parameter names.
///
/// Never add amounts, balances, merchant names, notes, record/profile IDs,
/// receipt data, or user-created labels to an event parameter.
abstract final class AnalyticsEvents {
  static const onboardingStarted = 'onboarding_started';
  static const onboardingCompleted = 'onboarding_completed';
  static const privacyPolicyAccepted = 'privacy_policy_accepted';
  static const tutorialStarted = 'tutorial_started';
  static const tutorialStepViewed = 'tutorial_step_viewed';
  static const tutorialSkipped = 'tutorial_skipped';
  static const tutorialCompleted = 'tutorial_completed';
  static const tutorialReplayed = 'tutorial_replayed';
  static const languageChanged = 'language_changed';
  static const currencyChanged = 'currency_changed';
  static const incomeAddStarted = 'income_add_started';
  static const incomeAdded = 'income_added';
  static const incomeEdited = 'income_edited';
  static const incomeDeleted = 'income_deleted';
  static const incomeActionFailed = 'income_action_failed';
  static const expenseAddStarted = 'expense_add_started';
  static const expenseAdded = 'expense_added';
  static const expenseEdited = 'expense_edited';
  static const expenseDeleted = 'expense_deleted';
  static const expenseActionFailed = 'expense_action_failed';
  static const customCategoryCreated = 'custom_category_created';
  static const customCategoryEdited = 'custom_category_edited';
  static const customCategoryDeleted = 'custom_category_deleted';
  static const transactionsViewed = 'transactions_viewed';
  static const transactionSearchUsed = 'transaction_search_used';
  static const transactionFilterApplied = 'transaction_filter_applied';
  static const analyticsViewed = 'analytics_viewed';
  static const dashboardSummaryViewed = 'dashboard_summary_viewed';
  static const aiInformationViewed = 'ai_information_viewed';
  static const settingsViewed = 'settings_viewed';
  static const themeChanged = 'theme_changed';
  static const dataExportStarted = 'data_export_started';
  static const dataExportSucceeded = 'data_export_succeeded';
  static const dataExportFailed = 'data_export_failed';
}

abstract final class AnalyticsParameters {
  static const appLanguage = 'app_language';
  static const selectedLanguage = 'selected_language';
  static const selectedCurrency = 'selected_currency';
  static const tutorialVersion = 'tutorial_version';
  static const stepId = 'step_id';
  static const fromLanguage = 'from_language';
  static const toLanguage = 'to_language';
  static const fromCurrency = 'from_currency';
  static const toCurrency = 'to_currency';
  static const currency = 'currency';
  static const entrySource = 'entry_source';
  static const categoryType = 'category_type';
  static const action = 'action';
  static const reason = 'reason';
  static const filterType = 'filter_type';
  static const period = 'period';
  static const theme = 'theme';
  static const format = 'format';
}
