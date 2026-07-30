// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'DinarWise';

  @override
  String get loading => 'Loading…';

  @override
  String get languageSelectionTitle => 'Choose your language';

  @override
  String get languageSelectionSubtitle =>
      'You can change this later in Settings.';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get welcomeTitle => 'Welcome to DinarWise';

  @override
  String get welcomeSubtitle => 'Everyday money guidance, built for your life.';

  @override
  String get privacyConsentPrefix => 'I have read and agree to the ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyConsentSuffix => '.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get privacyOpenError =>
      'We couldn’t open the Privacy Policy. Please try again.';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get recordedExpenses => 'Recorded expenses';

  @override
  String get totalIncome => 'Total income';

  @override
  String get totalExpenses => 'Total expenses';

  @override
  String get remainingBalance => 'Remaining balance';

  @override
  String get yourRemainingBalanceIs => 'Your remaining balance is';

  @override
  String get addIncome => 'Add income';

  @override
  String get editIncome => 'Edit income';

  @override
  String get incomeAmount => 'Income amount';

  @override
  String get incomeSaved => 'Income saved successfully';

  @override
  String get incomeDeleted => 'Income deleted';

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
      zero: 'No transactions',
    );
    return '$_temp0';
  }

  @override
  String get recentTransactions => 'Recent transactions';

  @override
  String get addExpense => 'Add expense';

  @override
  String get addTransaction => 'Add transaction';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get noExpenses => 'No expenses yet';

  @override
  String get noExpensesDescription =>
      'Tap “Add expense” to record your first one.';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get noTransactionsDescription =>
      'Add income first, then record your household expenses.';

  @override
  String get merchant => 'Merchant';

  @override
  String get amount => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get date => 'Date';

  @override
  String get saveExpense => 'Save expense';

  @override
  String get saving => 'Saving…';

  @override
  String get expenseSaved => 'Expense saved successfully';

  @override
  String get transactionSaved => 'Transaction saved successfully';

  @override
  String get enterExpenseDetails => 'Enter expense details';

  @override
  String get enterTransactionDetails => 'Enter transaction details';

  @override
  String get manualExpenseHint =>
      'Manual tracking works without an internet connection.';

  @override
  String get enterMerchant => 'Enter the merchant';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String get insufficientBalance =>
      'This expense exceeds your remaining balance. Add income or enter a smaller amount.';

  @override
  String get incomeReductionBlocked =>
      'This income cannot be reduced or deleted because it would make your remaining balance negative.';

  @override
  String get transactionNotFound => 'This transaction no longer exists.';

  @override
  String get restaurants => 'Restaurants & cafés';

  @override
  String get groceries => 'Groceries';

  @override
  String get fuel => 'Fuel';

  @override
  String get transportation => 'Transportation';

  @override
  String get shopping => 'Shopping';

  @override
  String get healthcare => 'Healthcare';

  @override
  String get utilities => 'Utilities';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get bnplPayment => 'BNPL payment';

  @override
  String get other => 'Other';

  @override
  String get customCategory => 'Custom category';

  @override
  String get customCategoryName => 'Category name';

  @override
  String get createCustomCategory => 'Create custom category';

  @override
  String get customCategoryEmpty => 'Enter a category name';

  @override
  String get customCategoryTooLong =>
      'Category names can contain at most 50 characters';

  @override
  String get customCategoryDuplicate =>
      'A category with this name already exists';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get deleteExpenseTitle => 'Delete expense?';

  @override
  String get deleteExpenseMessage =>
      'This expense will be permanently deleted.';

  @override
  String get deleteTransactionTitle => 'Delete transaction?';

  @override
  String get deleteTransactionMessage =>
      'This transaction will be permanently deleted.';

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get rename => 'Rename';

  @override
  String get confirm => 'Confirm';

  @override
  String get tryAgain => 'Try again';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get customCategories => 'Custom categories';

  @override
  String get noCustomCategories => 'No custom categories yet';

  @override
  String get categoryInUse =>
      'This category is used by existing records. Move those records to another category before deleting it.';

  @override
  String get deleteCategoryTitle => 'Delete category?';

  @override
  String get deleteCategoryMessage =>
      'This custom category will be permanently deleted.';

  @override
  String get resetApplicationData => 'Reset application data';

  @override
  String get resetDataTitle => 'Permanently reset DinarWise?';

  @override
  String get resetDataMessage =>
      'This permanently deletes local expenses, income, budgets, goals, custom categories, BNPL plans, bills, subscriptions, and application settings. This action cannot be undone.';

  @override
  String get resetDataConfirmation => 'Delete all data';

  @override
  String get preferences => 'Preferences';

  @override
  String get financialPlanning => 'Financial planning';

  @override
  String get budgets => 'Budgets';

  @override
  String get savingsGoals => 'Savings goals';

  @override
  String get bnplPlans => 'BNPL plans';

  @override
  String get billsAndSubscriptions => 'Bills & subscriptions';

  @override
  String get comingSoon => 'No records yet';

  @override
  String get add => 'Add';

  @override
  String get name => 'Name';

  @override
  String get targetAmount => 'Target amount';

  @override
  String get purchaseAmount => 'Purchase amount';

  @override
  String get budgetLimit => 'Budget limit';

  @override
  String get dueDate => 'Due date';

  @override
  String get save => 'Save';

  @override
  String get recordCreated => 'Saved successfully';

  @override
  String get safeToSpend => 'Safe to spend';

  @override
  String get availableUntilPayday => 'Available until payday';

  @override
  String get dailySafeToSpend => 'Safe to spend today';

  @override
  String get salaryCycle => 'Salary cycle';

  @override
  String get reports => 'Reports';

  @override
  String get weeklySummary => 'Weekly summary';

  @override
  String get notifications => 'Notifications';

  @override
  String get offlineReady => 'Your financial records are available offline.';

  @override
  String get offlineAiMessage =>
      'This AI feature requires an internet connection. You can still add the expense manually.';

  @override
  String get addManually => 'Add manually';

  @override
  String get aiFeature => 'AI feature';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get allCategories => 'All categories';

  @override
  String get noResults => 'No results found';

  @override
  String get back => 'Back';

  @override
  String get close => 'Close';

  @override
  String get currencySar => 'SAR';

  @override
  String get unknownError => 'Something went wrong. Please try again.';

  @override
  String get databaseError =>
      'We couldn’t save your changes. Please try again.';

  @override
  String privacyVersion(String version) {
    return 'Privacy Policy version $version';
  }

  @override
  String get history => 'Transaction history';

  @override
  String get viewAll => 'View all';

  @override
  String get searchTransactions =>
      'Search merchant, notes, category, or amount';

  @override
  String get allTransactions => 'All';

  @override
  String get dateRange => 'Date range';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get newestFirst => 'Newest first';

  @override
  String get oldestFirst => 'Oldest first';

  @override
  String get highestAmountFirst => 'Highest amount first';

  @override
  String get lowestAmountFirst => 'Lowest amount first';

  @override
  String get loadMore => 'Load more';

  @override
  String get dailyIncome => 'Income';

  @override
  String get dailyExpense => 'Expenses';

  @override
  String get dailyNet => 'Net';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get transactionDuplicated => 'Transaction duplicated';

  @override
  String get noMatchingTransactions => 'No transactions match these filters';

  @override
  String get selectDateRange => 'Select date range';

  @override
  String get filters => 'Filters';

  @override
  String get analytics => 'Analytics & reports';

  @override
  String get customDateRange => 'Custom date range';

  @override
  String get averageDailySpending => 'Average daily spending';

  @override
  String get savingsRate => 'Savings rate';

  @override
  String get weekComparison => 'This week vs last week';

  @override
  String get monthComparison => 'This month vs last month';

  @override
  String get currentPeriod => 'Current';

  @override
  String get previousPeriod => 'Previous';

  @override
  String get monthlySpendingTrend => 'Monthly spending trend';

  @override
  String get categoryBreakdown => 'Category spending';

  @override
  String get localInsights => 'Offline insight';

  @override
  String get highestSpendingMerchant => 'Highest-spending merchant';

  @override
  String get highestSpendingCategory => 'Highest-spending category';

  @override
  String get notEnoughComparisonData =>
      'Add more transactions to see a period comparison.';

  @override
  String spendingIncreased(int percent) {
    return 'Your spending increased by $percent% compared with the previous month.';
  }

  @override
  String spendingDecreased(int percent) {
    return 'Your spending decreased by $percent% compared with the previous month.';
  }

  @override
  String get spendingCalendar => 'Spending calendar';

  @override
  String get calendarView => 'Calendar view';

  @override
  String get listView => 'List view';

  @override
  String get mondayFirst => 'Week starts Monday';

  @override
  String get sundayFirst => 'Week starts Sunday';

  @override
  String get showHijriDates => 'Show Hijri dates';
}
