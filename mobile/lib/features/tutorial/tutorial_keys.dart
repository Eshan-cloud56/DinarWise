/// Versioned tutorial keys for SharedPreferences.
///
/// Bump the version suffix when a tutorial's content changes significantly
/// so returning users see the updated version.
abstract final class TutorialKeys {
  static const home = 'tutorial_home_v2';
  static const history = 'tutorial_history_v1';
  static const smartSearch = 'tutorial_smart_search_v1';
  static const smartReceipt = 'tutorial_smart_receipt_v1';
  static const voiceExpense = 'tutorial_voice_expense_v1';
  static const smsDetection = 'tutorial_sms_detection_v1';
  static const spendingAlerts = 'tutorial_spending_alerts_v1';
  static const addExpense = 'tutorial_add_expense_v1';
  static const planning = 'tutorial_planning_v1';
  static const bottomNav = 'tutorial_bottom_nav_v1';
  static const homeWidget = 'tutorial_home_widget_v1';

  /// All tutorial keys for bulk operations (replay all, etc.).
  static const all = [
    home,
    history,
    smartSearch,
    smartReceipt,
    voiceExpense,
    smsDetection,
    spendingAlerts,
    addExpense,
    planning,
    bottomNav,
    homeWidget,
  ];
}
