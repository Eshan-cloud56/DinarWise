// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Dinar Wise: Expense AI Manager';

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

  @override
  String get addBudget => 'Add budget';

  @override
  String get editBudget => 'Edit budget';

  @override
  String get overallBudget => 'Overall budget';

  @override
  String get rollover => 'Monthly rollover';

  @override
  String get noRollover => 'No rollover';

  @override
  String get carryUnused => 'Carry unused amount';

  @override
  String get carryUnusedAndOverspending =>
      'Carry unused amount and overspending';

  @override
  String get budgetCycle => 'Budget cycle';

  @override
  String get monthly => 'Monthly';

  @override
  String get payday => 'Payday';

  @override
  String get fixedCommitments => 'Fixed commitments';

  @override
  String get emergencyBuffer => 'Emergency buffer';

  @override
  String get budgetHistory => 'Budget history';

  @override
  String get noHistory => 'No history yet';

  @override
  String get amountSpent => 'Amount spent';

  @override
  String get amountRemaining => 'Amount remaining';

  @override
  String get used => 'used';

  @override
  String get budgetOverspent => 'This budget has been exceeded.';

  @override
  String budgetWarning(int percent) {
    return 'You have used $percent% of this budget.';
  }

  @override
  String daysUntilPayday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days until payday',
      one: '1 day until payday',
      zero: 'Payday is today',
    );
    return '$_temp0';
  }

  @override
  String get upcomingBills => 'Upcoming bills';

  @override
  String get upcomingBnpl => 'Upcoming BNPL';

  @override
  String get plannedSavings => 'Planned savings';

  @override
  String get remaining => 'Remaining';

  @override
  String get goalCompleted => 'Goal completed';

  @override
  String get requiredWeekly => 'Required weekly';

  @override
  String get requiredMonthly => 'Required monthly';

  @override
  String get addContribution => 'Add contribution';

  @override
  String get noContributions => 'No contributions yet';

  @override
  String get addGoal => 'Add savings goal';

  @override
  String get editGoal => 'Edit savings goal';

  @override
  String get goalTemplate => 'Goal template';

  @override
  String get targetDate => 'Target date';

  @override
  String get optional => 'Optional';

  @override
  String get emergencyFund => 'Emergency Fund';

  @override
  String get travel => 'Travel';

  @override
  String get wedding => 'Wedding';

  @override
  String get car => 'Car';

  @override
  String get education => 'Education';

  @override
  String get hajj => 'Hajj';

  @override
  String get umrah => 'Umrah';

  @override
  String get eid => 'Eid';

  @override
  String get customGoal => 'Custom Goal';

  @override
  String get addBnplPlan => 'Add BNPL plan';

  @override
  String get editBnplPlan => 'Edit BNPL plan';

  @override
  String get provider => 'Provider';

  @override
  String get customProvider => 'Custom provider';

  @override
  String get providerName => 'Provider name';

  @override
  String get purchaseDate => 'Purchase date';

  @override
  String get paidAmount => 'Paid amount';

  @override
  String get totalOutstandingBnpl => 'Total outstanding BNPL';

  @override
  String get completed => 'Completed';

  @override
  String get latePayment => 'Payment is late';

  @override
  String get paymentHistory => 'Payment history';

  @override
  String get markedPaid => 'Marked as paid';

  @override
  String get paymentUndone => 'Payment status undone';

  @override
  String instalmentNumber(int number) {
    return 'Instalment $number';
  }

  @override
  String get instalmentTotalError =>
      'The instalments must total exactly the purchase amount.';

  @override
  String get addRecurring => 'Add bill or subscription';

  @override
  String get editRecurring => 'Edit bill or subscription';

  @override
  String get recurrence => 'Recurrence';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get yearly => 'Yearly';

  @override
  String get every => 'Repeat every';

  @override
  String get isSubscription => 'This is a subscription';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'End date';

  @override
  String get maxOccurrences => 'Number of occurrences (optional)';

  @override
  String get lifetimePaid => 'Lifetime amount paid';

  @override
  String get monthlyEquivalent => 'Monthly equivalent';

  @override
  String get paid => 'Paid';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get markAsPaid => 'Mark as paid';

  @override
  String get editOneOccurrence => 'Edit this occurrence';

  @override
  String get stopRecurring => 'Stop recurring rule';

  @override
  String get ended => 'Ended';

  @override
  String get nextBill => 'Next bill or subscription';

  @override
  String get nextBnplPayment => 'Next BNPL payment';

  @override
  String get incomeVsExpense => 'Income versus expenses';

  @override
  String get spendingCharts => 'Spending charts';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get paymentMethods => 'Payment methods';

  @override
  String get allPaymentMethods => 'All payment methods';

  @override
  String get cash => 'Cash';

  @override
  String get debitCard => 'Debit Card';

  @override
  String get creditCard => 'Credit Card';

  @override
  String get bankTransfer => 'Bank Transfer';

  @override
  String get paymentMethodDuplicate =>
      'A payment method with this name already exists.';

  @override
  String get reassignPaymentMethod => 'Move transactions before deleting';

  @override
  String get reassignAndDelete => 'Move and delete';

  @override
  String usageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Used $count times',
      one: 'Used once',
      zero: 'Not used',
    );
    return '$_temp0';
  }

  @override
  String get categoryAppearance => 'Icon and color';

  @override
  String get sortCategories => 'Category ordering';

  @override
  String get mostUsed => 'Most used';

  @override
  String get recentlyUsed => 'Recently used';

  @override
  String get alphabetical => 'Alphabetical';

  @override
  String get reassignCategory => 'Move related records before deleting';

  @override
  String get defaultPaymentMethod => 'Default payment method';

  @override
  String get attachReceipt => 'Attach receipt';

  @override
  String get takeReceiptPhoto => 'Take receipt photo';

  @override
  String get chooseReceiptPhoto => 'Choose from gallery';

  @override
  String get receiptAttached => 'Receipt attached';

  @override
  String get tapToView => 'Tap to view';

  @override
  String get removeReceipt => 'Remove receipt';

  @override
  String get receiptPickError =>
      'The receipt image could not be opened. Please try another image.';

  @override
  String get receiptStorage => 'Receipt storage';

  @override
  String get storageUsed => 'Storage used';

  @override
  String get clearAllReceipts => 'Clear all receipt images';

  @override
  String get clearAllReceiptsMessage =>
      'This permanently removes all saved receipt images. Transactions will be kept.';

  @override
  String get noReceipts => 'No receipt images saved';

  @override
  String get enableNotifications => 'Enable local reminders';

  @override
  String get notificationPermissionHint =>
      'Bills, subscriptions, BNPL, budgets and goals';

  @override
  String get notificationsEnabled => 'Local reminders are enabled.';

  @override
  String get notificationsDenied => 'Notification permission was not granted.';

  @override
  String get backupAndExport => 'Backup, import and export';

  @override
  String get exportCsv => 'Export transactions as CSV';

  @override
  String get importCsv => 'Import transactions from CSV';

  @override
  String get monthlyPdf => 'Share monthly PDF report';

  @override
  String get encryptedBackup => 'Create encrypted backup';

  @override
  String get restoreBackup => 'Restore encrypted backup';

  @override
  String get backupPassword => 'Backup password';

  @override
  String get minimumSixCharacters => 'At least 6 characters';

  @override
  String get restore => 'Restore';

  @override
  String get continueLabel => 'Continue';

  @override
  String get operationFailed => 'The operation could not be completed';

  @override
  String get importPreview => 'Import preview';

  @override
  String get importLabel => 'Import';

  @override
  String importPreviewCounts(int valid, int invalid, int duplicates) {
    return '$valid valid, $invalid invalid, $duplicates duplicates';
  }

  @override
  String get restoreReplacesData =>
      'Restoring replaces all current local financial data. If validation fails, your existing data will remain unchanged.';

  @override
  String get applicationSecurity => 'Application security';

  @override
  String get applicationPin => 'Application PIN';

  @override
  String get pinStoredSecurely =>
      'Your PIN is salted and securely hashed; it is never stored as plain text.';

  @override
  String get createPin => 'Create PIN';

  @override
  String get verifyCurrentPin => 'Verify current PIN';

  @override
  String get pinRequirements => 'Use a numeric PIN containing 4 to 8 digits.';

  @override
  String get changePin => 'Change PIN';

  @override
  String get useBiometrics => 'Use fingerprint or face';

  @override
  String get fingerprintOrFace =>
      'Use Android biometric authentication when supported';

  @override
  String get biometricsUnavailable =>
      'Biometric authentication is not available on this device.';

  @override
  String get lockInBackground => 'Lock when app is in the background';

  @override
  String get autoLockTimeout => 'Automatic-lock timeout';

  @override
  String get immediately => 'Immediately';

  @override
  String get seconds30 => '30 seconds';

  @override
  String get minute1 => '1 minute';

  @override
  String get minutes5 => '5 minutes';

  @override
  String get appLocked => 'DinarWise is locked';

  @override
  String get incorrectPin => 'Incorrect PIN';

  @override
  String get unlockDinarWise => 'Unlock DinarWise';

  @override
  String get unlock => 'Unlock';

  @override
  String get offlineCalculators => 'Offline financial calculators';

  @override
  String get calculator => 'Calculator';

  @override
  String get budgetCalculator => '50/30/20 budget calculator';

  @override
  String get emergencyCalculator => 'Emergency-fund calculator';

  @override
  String get travelCalculator => 'Travel-budget calculator';

  @override
  String get debtCalculator => 'Debt-payoff calculator';

  @override
  String get goalCalculator => 'Savings-goal calculator';

  @override
  String get compoundCalculator => 'Compound-interest calculator';

  @override
  String get needs => 'Needs (50%)';

  @override
  String get wants => 'Wants (30%)';

  @override
  String get savings => 'Savings (20%)';

  @override
  String get monthlyEssentials => 'Monthly essential costs';

  @override
  String get monthlyIncome => 'Monthly income';

  @override
  String get currentSaved => 'Current saved amount';

  @override
  String get months => 'Months';

  @override
  String get transport => 'Transport';

  @override
  String get lodging => 'Lodging';

  @override
  String get dailyCost => 'Daily cost';

  @override
  String get days => 'Days';

  @override
  String get bufferPercent => 'Buffer (%)';

  @override
  String get debtBalance => 'Debt balance';

  @override
  String get annualRate => 'Annual interest rate (%)';

  @override
  String get monthlyPayment => 'Monthly payment';

  @override
  String get paymentTooLow => 'The payment is too low to repay this debt.';

  @override
  String monthCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String get startingAmount => 'Starting amount';

  @override
  String get years => 'Years';

  @override
  String get monthlyContribution => 'Monthly contribution';

  @override
  String get calculate => 'Calculate';

  @override
  String get result => 'Result';

  @override
  String get calculatorDoesNotSave =>
      'Calculator results do not change your financial records.';

  @override
  String get chooseCurrency => 'Choose your currency';

  @override
  String get chooseCurrencyDescription =>
      'DinarWise will use this currency for your income, expenses, budgets and reports.';

  @override
  String decimalPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count decimal places',
      one: '1 decimal place',
    );
    return '$_temp0';
  }

  @override
  String get firebasePrivacyExplanation =>
      'Your financial records remain on this device. If you opt in, anonymous usage or diagnostic information may be sent to Firebase/Google when an internet connection is available. DinarWise never sends amounts, balances, merchants, notes, receipts, or identifying information.';

  @override
  String get allowAnonymousAnalytics => 'Allow anonymous analytics';

  @override
  String get allowAnonymousAnalyticsHint =>
      'Help improve DinarWise by sharing privacy-safe feature usage.';

  @override
  String get allowDiagnostics => 'Allow diagnostic data';

  @override
  String get allowDiagnosticsHint =>
      'Share privacy-safe crash and performance information.';
}
