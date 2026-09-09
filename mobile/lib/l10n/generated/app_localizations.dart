import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @saveIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Save income'**
  String get saveIncomeLabel;

  /// No description provided for @brandTitle.
  ///
  /// In en, this message translates to:
  /// **'DinarWise'**
  String get brandTitle;

  /// No description provided for @transactionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get transactionsLabel;

  /// No description provided for @planningLabel.
  ///
  /// In en, this message translates to:
  /// **'Planning'**
  String get planningLabel;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @homeLabel.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeLabel;

  /// No description provided for @dashboardWelcome.
  ///
  /// In en, this message translates to:
  /// **'Your household, in balance.'**
  String get dashboardWelcome;

  /// No description provided for @localRecordsLabel.
  ///
  /// In en, this message translates to:
  /// **'Financial records stored on this device'**
  String get localRecordsLabel;

  /// No description provided for @availableToSpend.
  ///
  /// In en, this message translates to:
  /// **'Available to spend'**
  String get availableToSpend;

  /// No description provided for @safeToSpendToday.
  ///
  /// In en, this message translates to:
  /// **'Safe to spend today'**
  String get safeToSpendToday;

  /// No description provided for @quickServices.
  ///
  /// In en, this message translates to:
  /// **'Quick services'**
  String get quickServices;

  /// No description provided for @scanBill.
  ///
  /// In en, this message translates to:
  /// **'Scan bill'**
  String get scanBill;

  /// No description provided for @transferLabel.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transferLabel;

  /// No description provided for @transferUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Transfers between accounts are not available. DinarWise currently tracks household income and expenses without bank-account transfers.'**
  String get transferUnavailable;

  /// No description provided for @smartInsights.
  ///
  /// In en, this message translates to:
  /// **'Smart insights'**
  String get smartInsights;

  /// No description provided for @spendingBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Spending breakdown'**
  String get spendingBreakdown;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent expenses'**
  String get recentActivity;

  /// No description provided for @insightsLabel.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insightsLabel;

  /// No description provided for @cashFlow.
  ///
  /// In en, this message translates to:
  /// **'Monthly cash flow'**
  String get cashFlow;

  /// No description provided for @netSavings.
  ///
  /// In en, this message translates to:
  /// **'Net savings'**
  String get netSavings;

  /// No description provided for @savedInGoals.
  ///
  /// In en, this message translates to:
  /// **'Saved in goals'**
  String get savedInGoals;

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'/ day'**
  String get perDay;

  /// No description provided for @manualReceiptHint.
  ///
  /// In en, this message translates to:
  /// **'Attach a receipt and use private on-device Smart Scan, or continue manually.'**
  String get manualReceiptHint;

  /// No description provided for @monthPace.
  ///
  /// In en, this message translates to:
  /// **'Month progress'**
  String get monthPace;

  /// No description provided for @saveExpenseLabel.
  ///
  /// In en, this message translates to:
  /// **'Save expense'**
  String get saveExpenseLabel;

  /// No description provided for @splitBnplLabel.
  ///
  /// In en, this message translates to:
  /// **'Split / BNPL plans'**
  String get splitBnplLabel;

  /// No description provided for @manageBnplHint.
  ///
  /// In en, this message translates to:
  /// **'Manage instalments in BNPL planning. This does not split the current expense.'**
  String get manageBnplHint;

  /// No description provided for @thisMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonthLabel;

  /// No description provided for @paymentMethodUnknown.
  ///
  /// In en, this message translates to:
  /// **'No payment method'**
  String get paymentMethodUnknown;

  /// No description provided for @backspaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete last digit'**
  String get backspaceLabel;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Dinar Wise: Expense AI Manager'**
  String get appName;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @languageSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageSelectionTitle;

  /// No description provided for @languageSelectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this later in Settings.'**
  String get languageSelectionSubtitle;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to DinarWise'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everyday money guidance, built for your life.'**
  String get welcomeSubtitle;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyAcknowledgementPrefix.
  ///
  /// In en, this message translates to:
  /// **'By tapping Get Started, you acknowledge that you have read and agree to the '**
  String get privacyAcknowledgementPrefix;

  /// No description provided for @privacyAcknowledgementSuffix.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get privacyAcknowledgementSuffix;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @privacyOpenError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t open the Privacy Policy. Please try again.'**
  String get privacyOpenError;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @recordedExpenses.
  ///
  /// In en, this message translates to:
  /// **'Recorded expenses'**
  String get recordedExpenses;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total income'**
  String get totalIncome;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total expenses'**
  String get totalExpenses;

  /// No description provided for @remainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Remaining balance'**
  String get remainingBalance;

  /// No description provided for @yourRemainingBalanceIs.
  ///
  /// In en, this message translates to:
  /// **'Your remaining balance is'**
  String get yourRemainingBalanceIs;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get addIncome;

  /// No description provided for @editIncome.
  ///
  /// In en, this message translates to:
  /// **'Edit income'**
  String get editIncome;

  /// No description provided for @incomeAmount.
  ///
  /// In en, this message translates to:
  /// **'Income amount'**
  String get incomeAmount;

  /// No description provided for @incomeSaved.
  ///
  /// In en, this message translates to:
  /// **'Income saved successfully'**
  String get incomeSaved;

  /// No description provided for @incomeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Income deleted'**
  String get incomeDeleted;

  /// No description provided for @transactionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No transactions} =1{1 transaction} other{{count} transactions}}'**
  String transactionCount(int count);

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent expenses'**
  String get recentTransactions;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpense;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addTransaction;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @noExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get noExpenses;

  /// No description provided for @noExpensesDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap “Add expense” to record your first one.'**
  String get noExpensesDescription;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get noTransactions;

  /// No description provided for @noTransactionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Your saved expenses will appear here.'**
  String get noTransactionsDescription;

  /// No description provided for @merchant.
  ///
  /// In en, this message translates to:
  /// **'Merchant'**
  String get merchant;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @saveExpense.
  ///
  /// In en, this message translates to:
  /// **'Save expense'**
  String get saveExpense;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @expenseSaved.
  ///
  /// In en, this message translates to:
  /// **'Expense saved successfully'**
  String get expenseSaved;

  /// No description provided for @transactionSaved.
  ///
  /// In en, this message translates to:
  /// **'Expense saved successfully'**
  String get transactionSaved;

  /// No description provided for @enterExpenseDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter expense details'**
  String get enterExpenseDetails;

  /// No description provided for @enterTransactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter expense details'**
  String get enterTransactionDetails;

  /// No description provided for @manualExpenseHint.
  ///
  /// In en, this message translates to:
  /// **'Manual tracking works without an internet connection.'**
  String get manualExpenseHint;

  /// No description provided for @enterMerchant.
  ///
  /// In en, this message translates to:
  /// **'Enter the merchant'**
  String get enterMerchant;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @insufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'This expense exceeds your remaining balance. Add income or enter a smaller amount.'**
  String get insufficientBalance;

  /// No description provided for @incomeReductionBlocked.
  ///
  /// In en, this message translates to:
  /// **'This income cannot be reduced or deleted because it would make your remaining balance negative.'**
  String get incomeReductionBlocked;

  /// No description provided for @transactionNotFound.
  ///
  /// In en, this message translates to:
  /// **'This expense no longer exists.'**
  String get transactionNotFound;

  /// No description provided for @restaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants & cafés'**
  String get restaurants;

  /// No description provided for @groceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get groceries;

  /// No description provided for @fuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get fuel;

  /// No description provided for @transportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get transportation;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @healthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get healthcare;

  /// No description provided for @utilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get utilities;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @bnplPayment.
  ///
  /// In en, this message translates to:
  /// **'BNPL payment'**
  String get bnplPayment;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @customCategory.
  ///
  /// In en, this message translates to:
  /// **'Custom category'**
  String get customCategory;

  /// No description provided for @customCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get customCategoryName;

  /// No description provided for @createCustomCategory.
  ///
  /// In en, this message translates to:
  /// **'Create custom category'**
  String get createCustomCategory;

  /// No description provided for @customCategoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter a category name'**
  String get customCategoryEmpty;

  /// No description provided for @customCategoryTooLong.
  ///
  /// In en, this message translates to:
  /// **'Category names can contain at most 50 characters'**
  String get customCategoryTooLong;

  /// No description provided for @customCategoryDuplicate.
  ///
  /// In en, this message translates to:
  /// **'A category with this name already exists'**
  String get customCategoryDuplicate;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete expense?'**
  String get deleteExpenseTitle;

  /// No description provided for @deleteExpenseMessage.
  ///
  /// In en, this message translates to:
  /// **'This expense will be permanently deleted.'**
  String get deleteExpenseMessage;

  /// No description provided for @deleteTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete expense?'**
  String get deleteTransactionTitle;

  /// No description provided for @deleteTransactionMessage.
  ///
  /// In en, this message translates to:
  /// **'This expense will be permanently deleted.'**
  String get deleteTransactionMessage;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get editTransaction;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @customCategories.
  ///
  /// In en, this message translates to:
  /// **'Custom categories'**
  String get customCategories;

  /// No description provided for @noCustomCategories.
  ///
  /// In en, this message translates to:
  /// **'No custom categories yet'**
  String get noCustomCategories;

  /// No description provided for @categoryInUse.
  ///
  /// In en, this message translates to:
  /// **'This category is used by existing records. Move those records to another category before deleting it.'**
  String get categoryInUse;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete category?'**
  String get deleteCategoryTitle;

  /// No description provided for @deleteCategoryMessage.
  ///
  /// In en, this message translates to:
  /// **'This custom category will be permanently deleted.'**
  String get deleteCategoryMessage;

  /// No description provided for @resetApplicationData.
  ///
  /// In en, this message translates to:
  /// **'Reset application data'**
  String get resetApplicationData;

  /// No description provided for @resetDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently reset DinarWise?'**
  String get resetDataTitle;

  /// No description provided for @resetDataMessage.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes local expenses, income, budgets, goals, custom categories, BNPL plans, bills, subscriptions, and application settings. This action cannot be undone.'**
  String get resetDataMessage;

  /// No description provided for @resetDataConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get resetDataConfirmation;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @financialPlanning.
  ///
  /// In en, this message translates to:
  /// **'Financial planning'**
  String get financialPlanning;

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @savingsGoals.
  ///
  /// In en, this message translates to:
  /// **'Savings goals'**
  String get savingsGoals;

  /// No description provided for @bnplPlans.
  ///
  /// In en, this message translates to:
  /// **'BNPL plans'**
  String get bnplPlans;

  /// No description provided for @billsAndSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Bills & subscriptions'**
  String get billsAndSubscriptions;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get comingSoon;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @targetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get targetAmount;

  /// No description provided for @purchaseAmount.
  ///
  /// In en, this message translates to:
  /// **'Purchase amount'**
  String get purchaseAmount;

  /// No description provided for @budgetLimit.
  ///
  /// In en, this message translates to:
  /// **'Budget limit'**
  String get budgetLimit;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @recordCreated.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get recordCreated;

  /// No description provided for @safeToSpend.
  ///
  /// In en, this message translates to:
  /// **'Safe to spend'**
  String get safeToSpend;

  /// No description provided for @availableUntilPayday.
  ///
  /// In en, this message translates to:
  /// **'Available until payday'**
  String get availableUntilPayday;

  /// No description provided for @dailySafeToSpend.
  ///
  /// In en, this message translates to:
  /// **'Safe to spend today'**
  String get dailySafeToSpend;

  /// No description provided for @salaryCycle.
  ///
  /// In en, this message translates to:
  /// **'Salary cycle'**
  String get salaryCycle;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @weeklySummary.
  ///
  /// In en, this message translates to:
  /// **'Weekly summary'**
  String get weeklySummary;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @offlineReady.
  ///
  /// In en, this message translates to:
  /// **'Your financial records are available offline.'**
  String get offlineReady;

  /// No description provided for @offlineAiMessage.
  ///
  /// In en, this message translates to:
  /// **'This AI feature requires an internet connection. You can still add the expense manually.'**
  String get offlineAiMessage;

  /// No description provided for @addManually.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get addManually;

  /// No description provided for @aiFeature.
  ///
  /// In en, this message translates to:
  /// **'AI feature'**
  String get aiFeature;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get allCategories;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @currencySar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get currencySar;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get unknownError;

  /// No description provided for @databaseError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t save your changes. Please try again.'**
  String get databaseError;

  /// No description provided for @privacyVersion.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy version {version}'**
  String privacyVersion(String version);

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'Expense history'**
  String get history;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @searchTransactions.
  ///
  /// In en, this message translates to:
  /// **'Search merchant, notes, category, or amount'**
  String get searchTransactions;

  /// No description provided for @allTransactions.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allTransactions;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get dateRange;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @newestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get newestFirst;

  /// No description provided for @oldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get oldestFirst;

  /// No description provided for @highestAmountFirst.
  ///
  /// In en, this message translates to:
  /// **'Highest amount first'**
  String get highestAmountFirst;

  /// No description provided for @lowestAmountFirst.
  ///
  /// In en, this message translates to:
  /// **'Lowest amount first'**
  String get lowestAmountFirst;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @dailyIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get dailyIncome;

  /// No description provided for @dailyExpense.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get dailyExpense;

  /// No description provided for @dailyNet.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get dailyNet;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @transactionDuplicated.
  ///
  /// In en, this message translates to:
  /// **'Expense duplicated'**
  String get transactionDuplicated;

  /// No description provided for @noMatchingTransactions.
  ///
  /// In en, this message translates to:
  /// **'No expenses match these filters'**
  String get noMatchingTransactions;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select date range'**
  String get selectDateRange;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics & reports'**
  String get analytics;

  /// No description provided for @customDateRange.
  ///
  /// In en, this message translates to:
  /// **'Custom date range'**
  String get customDateRange;

  /// No description provided for @averageDailySpending.
  ///
  /// In en, this message translates to:
  /// **'Average daily spending'**
  String get averageDailySpending;

  /// No description provided for @savingsRate.
  ///
  /// In en, this message translates to:
  /// **'Savings rate'**
  String get savingsRate;

  /// No description provided for @weekComparison.
  ///
  /// In en, this message translates to:
  /// **'This week vs last week'**
  String get weekComparison;

  /// No description provided for @monthComparison.
  ///
  /// In en, this message translates to:
  /// **'This month vs last month'**
  String get monthComparison;

  /// No description provided for @currentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentPeriod;

  /// No description provided for @previousPeriod.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousPeriod;

  /// No description provided for @monthlySpendingTrend.
  ///
  /// In en, this message translates to:
  /// **'Monthly spending trend'**
  String get monthlySpendingTrend;

  /// No description provided for @categoryBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Category spending'**
  String get categoryBreakdown;

  /// No description provided for @localInsights.
  ///
  /// In en, this message translates to:
  /// **'Offline insight'**
  String get localInsights;

  /// No description provided for @highestSpendingMerchant.
  ///
  /// In en, this message translates to:
  /// **'Highest-spending merchant'**
  String get highestSpendingMerchant;

  /// No description provided for @highestSpendingCategory.
  ///
  /// In en, this message translates to:
  /// **'Highest-spending category'**
  String get highestSpendingCategory;

  /// No description provided for @notEnoughComparisonData.
  ///
  /// In en, this message translates to:
  /// **'Add more transactions to see a period comparison.'**
  String get notEnoughComparisonData;

  /// No description provided for @spendingIncreased.
  ///
  /// In en, this message translates to:
  /// **'Your spending increased by {percent}% compared with the previous month.'**
  String spendingIncreased(int percent);

  /// No description provided for @spendingDecreased.
  ///
  /// In en, this message translates to:
  /// **'Your spending decreased by {percent}% compared with the previous month.'**
  String spendingDecreased(int percent);

  /// No description provided for @spendingCalendar.
  ///
  /// In en, this message translates to:
  /// **'Spending calendar'**
  String get spendingCalendar;

  /// No description provided for @calendarView.
  ///
  /// In en, this message translates to:
  /// **'Calendar view'**
  String get calendarView;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get listView;

  /// No description provided for @mondayFirst.
  ///
  /// In en, this message translates to:
  /// **'Week starts Monday'**
  String get mondayFirst;

  /// No description provided for @sundayFirst.
  ///
  /// In en, this message translates to:
  /// **'Week starts Sunday'**
  String get sundayFirst;

  /// No description provided for @showHijriDates.
  ///
  /// In en, this message translates to:
  /// **'Show Hijri dates'**
  String get showHijriDates;

  /// No description provided for @addBudget.
  ///
  /// In en, this message translates to:
  /// **'Add budget'**
  String get addBudget;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get editBudget;

  /// No description provided for @overallBudget.
  ///
  /// In en, this message translates to:
  /// **'Overall budget'**
  String get overallBudget;

  /// No description provided for @rollover.
  ///
  /// In en, this message translates to:
  /// **'Monthly rollover'**
  String get rollover;

  /// No description provided for @noRollover.
  ///
  /// In en, this message translates to:
  /// **'No rollover'**
  String get noRollover;

  /// No description provided for @carryUnused.
  ///
  /// In en, this message translates to:
  /// **'Carry unused amount'**
  String get carryUnused;

  /// No description provided for @carryUnusedAndOverspending.
  ///
  /// In en, this message translates to:
  /// **'Carry unused amount and overspending'**
  String get carryUnusedAndOverspending;

  /// No description provided for @budgetCycle.
  ///
  /// In en, this message translates to:
  /// **'Budget cycle'**
  String get budgetCycle;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @payday.
  ///
  /// In en, this message translates to:
  /// **'Payday'**
  String get payday;

  /// No description provided for @fixedCommitments.
  ///
  /// In en, this message translates to:
  /// **'Fixed commitments'**
  String get fixedCommitments;

  /// No description provided for @emergencyBuffer.
  ///
  /// In en, this message translates to:
  /// **'Emergency buffer'**
  String get emergencyBuffer;

  /// No description provided for @budgetHistory.
  ///
  /// In en, this message translates to:
  /// **'Budget history'**
  String get budgetHistory;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistory;

  /// No description provided for @amountSpent.
  ///
  /// In en, this message translates to:
  /// **'Amount spent'**
  String get amountSpent;

  /// No description provided for @amountRemaining.
  ///
  /// In en, this message translates to:
  /// **'Amount remaining'**
  String get amountRemaining;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'used'**
  String get used;

  /// No description provided for @budgetOverspent.
  ///
  /// In en, this message translates to:
  /// **'This budget has been exceeded.'**
  String get budgetOverspent;

  /// No description provided for @budgetWarning.
  ///
  /// In en, this message translates to:
  /// **'You have used {percent}% of this budget.'**
  String budgetWarning(int percent);

  /// No description provided for @daysUntilPayday.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Payday is today} =1{1 day until payday} other{{count} days until payday}}'**
  String daysUntilPayday(int count);

  /// No description provided for @upcomingBills.
  ///
  /// In en, this message translates to:
  /// **'Upcoming bills'**
  String get upcomingBills;

  /// No description provided for @upcomingBnpl.
  ///
  /// In en, this message translates to:
  /// **'Upcoming BNPL'**
  String get upcomingBnpl;

  /// No description provided for @plannedSavings.
  ///
  /// In en, this message translates to:
  /// **'Planned savings'**
  String get plannedSavings;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @goalCompleted.
  ///
  /// In en, this message translates to:
  /// **'Goal completed'**
  String get goalCompleted;

  /// No description provided for @requiredWeekly.
  ///
  /// In en, this message translates to:
  /// **'Required weekly'**
  String get requiredWeekly;

  /// No description provided for @requiredMonthly.
  ///
  /// In en, this message translates to:
  /// **'Required monthly'**
  String get requiredMonthly;

  /// No description provided for @addContribution.
  ///
  /// In en, this message translates to:
  /// **'Add contribution'**
  String get addContribution;

  /// No description provided for @noContributions.
  ///
  /// In en, this message translates to:
  /// **'No contributions yet'**
  String get noContributions;

  /// No description provided for @addGoal.
  ///
  /// In en, this message translates to:
  /// **'Add savings goal'**
  String get addGoal;

  /// No description provided for @editGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit savings goal'**
  String get editGoal;

  /// No description provided for @goalTemplate.
  ///
  /// In en, this message translates to:
  /// **'Goal template'**
  String get goalTemplate;

  /// No description provided for @targetDate.
  ///
  /// In en, this message translates to:
  /// **'Target date'**
  String get targetDate;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @emergencyFund.
  ///
  /// In en, this message translates to:
  /// **'Emergency Fund'**
  String get emergencyFund;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @wedding.
  ///
  /// In en, this message translates to:
  /// **'Wedding'**
  String get wedding;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @hajj.
  ///
  /// In en, this message translates to:
  /// **'Hajj'**
  String get hajj;

  /// No description provided for @umrah.
  ///
  /// In en, this message translates to:
  /// **'Umrah'**
  String get umrah;

  /// No description provided for @eid.
  ///
  /// In en, this message translates to:
  /// **'Eid'**
  String get eid;

  /// No description provided for @customGoal.
  ///
  /// In en, this message translates to:
  /// **'Custom Goal'**
  String get customGoal;

  /// No description provided for @addBnplPlan.
  ///
  /// In en, this message translates to:
  /// **'Add BNPL plan'**
  String get addBnplPlan;

  /// No description provided for @editBnplPlan.
  ///
  /// In en, this message translates to:
  /// **'Edit BNPL plan'**
  String get editBnplPlan;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @customProvider.
  ///
  /// In en, this message translates to:
  /// **'Custom provider'**
  String get customProvider;

  /// No description provided for @providerName.
  ///
  /// In en, this message translates to:
  /// **'Provider name'**
  String get providerName;

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase date'**
  String get purchaseDate;

  /// No description provided for @paidAmount.
  ///
  /// In en, this message translates to:
  /// **'Paid amount'**
  String get paidAmount;

  /// No description provided for @totalOutstandingBnpl.
  ///
  /// In en, this message translates to:
  /// **'Total outstanding BNPL'**
  String get totalOutstandingBnpl;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @latePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment is late'**
  String get latePayment;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get paymentHistory;

  /// No description provided for @markedPaid.
  ///
  /// In en, this message translates to:
  /// **'Marked as paid'**
  String get markedPaid;

  /// No description provided for @paymentUndone.
  ///
  /// In en, this message translates to:
  /// **'Payment status undone'**
  String get paymentUndone;

  /// No description provided for @instalmentNumber.
  ///
  /// In en, this message translates to:
  /// **'Instalment {number}'**
  String instalmentNumber(int number);

  /// No description provided for @instalmentTotalError.
  ///
  /// In en, this message translates to:
  /// **'The instalments must total exactly the purchase amount.'**
  String get instalmentTotalError;

  /// No description provided for @addRecurring.
  ///
  /// In en, this message translates to:
  /// **'Add bill or subscription'**
  String get addRecurring;

  /// No description provided for @editRecurring.
  ///
  /// In en, this message translates to:
  /// **'Edit bill or subscription'**
  String get editRecurring;

  /// No description provided for @recurrence.
  ///
  /// In en, this message translates to:
  /// **'Recurrence'**
  String get recurrence;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @every.
  ///
  /// In en, this message translates to:
  /// **'Repeat every'**
  String get every;

  /// No description provided for @isSubscription.
  ///
  /// In en, this message translates to:
  /// **'This is a subscription'**
  String get isSubscription;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @maxOccurrences.
  ///
  /// In en, this message translates to:
  /// **'Number of occurrences (optional)'**
  String get maxOccurrences;

  /// No description provided for @lifetimePaid.
  ///
  /// In en, this message translates to:
  /// **'Lifetime amount paid'**
  String get lifetimePaid;

  /// No description provided for @monthlyEquivalent.
  ///
  /// In en, this message translates to:
  /// **'Monthly equivalent'**
  String get monthlyEquivalent;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @markAsPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get markAsPaid;

  /// No description provided for @editOneOccurrence.
  ///
  /// In en, this message translates to:
  /// **'Edit this occurrence'**
  String get editOneOccurrence;

  /// No description provided for @stopRecurring.
  ///
  /// In en, this message translates to:
  /// **'Stop recurring rule'**
  String get stopRecurring;

  /// No description provided for @ended.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get ended;

  /// No description provided for @nextBill.
  ///
  /// In en, this message translates to:
  /// **'Next bill or subscription'**
  String get nextBill;

  /// No description provided for @nextBnplPayment.
  ///
  /// In en, this message translates to:
  /// **'Next BNPL payment'**
  String get nextBnplPayment;

  /// No description provided for @incomeVsExpense.
  ///
  /// In en, this message translates to:
  /// **'Income versus expenses'**
  String get incomeVsExpense;

  /// No description provided for @spendingCharts.
  ///
  /// In en, this message translates to:
  /// **'Spending charts'**
  String get spendingCharts;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get paymentMethods;

  /// No description provided for @allPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'All payment methods'**
  String get allPaymentMethods;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @debitCard.
  ///
  /// In en, this message translates to:
  /// **'Debit Card'**
  String get debitCard;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer;

  /// No description provided for @paymentMethodDuplicate.
  ///
  /// In en, this message translates to:
  /// **'A payment method with this name already exists.'**
  String get paymentMethodDuplicate;

  /// No description provided for @reassignPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Move transactions before deleting'**
  String get reassignPaymentMethod;

  /// No description provided for @reassignAndDelete.
  ///
  /// In en, this message translates to:
  /// **'Move and delete'**
  String get reassignAndDelete;

  /// No description provided for @usageCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Not used} =1{Used once} other{Used {count} times}}'**
  String usageCount(int count);

  /// No description provided for @categoryAppearance.
  ///
  /// In en, this message translates to:
  /// **'Icon and color'**
  String get categoryAppearance;

  /// No description provided for @sortCategories.
  ///
  /// In en, this message translates to:
  /// **'Category ordering'**
  String get sortCategories;

  /// No description provided for @mostUsed.
  ///
  /// In en, this message translates to:
  /// **'Most used'**
  String get mostUsed;

  /// No description provided for @recentlyUsed.
  ///
  /// In en, this message translates to:
  /// **'Recently used'**
  String get recentlyUsed;

  /// No description provided for @alphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get alphabetical;

  /// No description provided for @reassignCategory.
  ///
  /// In en, this message translates to:
  /// **'Move related records before deleting'**
  String get reassignCategory;

  /// No description provided for @defaultPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Default payment method'**
  String get defaultPaymentMethod;

  /// No description provided for @attachReceipt.
  ///
  /// In en, this message translates to:
  /// **'Attach or Smart Scan Receipt'**
  String get attachReceipt;

  /// No description provided for @takeReceiptPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take receipt photo'**
  String get takeReceiptPhoto;

  /// No description provided for @chooseReceiptPhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseReceiptPhoto;

  /// No description provided for @receiptAttached.
  ///
  /// In en, this message translates to:
  /// **'Receipt attached'**
  String get receiptAttached;

  /// No description provided for @tapToView.
  ///
  /// In en, this message translates to:
  /// **'Tap to view'**
  String get tapToView;

  /// No description provided for @removeReceipt.
  ///
  /// In en, this message translates to:
  /// **'Remove receipt'**
  String get removeReceipt;

  /// No description provided for @receiptPickError.
  ///
  /// In en, this message translates to:
  /// **'The receipt image could not be opened. Please try another image.'**
  String get receiptPickError;

  /// No description provided for @receiptStorage.
  ///
  /// In en, this message translates to:
  /// **'Receipt storage'**
  String get receiptStorage;

  /// No description provided for @storageUsed.
  ///
  /// In en, this message translates to:
  /// **'Storage used'**
  String get storageUsed;

  /// No description provided for @clearAllReceipts.
  ///
  /// In en, this message translates to:
  /// **'Clear all receipt images'**
  String get clearAllReceipts;

  /// No description provided for @clearAllReceiptsMessage.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes all saved receipt images. Transactions will be kept.'**
  String get clearAllReceiptsMessage;

  /// No description provided for @noReceipts.
  ///
  /// In en, this message translates to:
  /// **'No receipt images saved'**
  String get noReceipts;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable local reminders'**
  String get enableNotifications;

  /// No description provided for @notificationPermissionHint.
  ///
  /// In en, this message translates to:
  /// **'Bills, subscriptions, BNPL, budgets and goals'**
  String get notificationPermissionHint;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Local reminders are enabled.'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission was not granted.'**
  String get notificationsDenied;

  /// No description provided for @backupAndExport.
  ///
  /// In en, this message translates to:
  /// **'Backup, import and export'**
  String get backupAndExport;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export transactions as CSV'**
  String get exportCsv;

  /// No description provided for @importCsv.
  ///
  /// In en, this message translates to:
  /// **'Import transactions from CSV'**
  String get importCsv;

  /// No description provided for @monthlyPdf.
  ///
  /// In en, this message translates to:
  /// **'Share monthly PDF report'**
  String get monthlyPdf;

  /// No description provided for @encryptedBackup.
  ///
  /// In en, this message translates to:
  /// **'Create encrypted backup'**
  String get encryptedBackup;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore encrypted backup'**
  String get restoreBackup;

  /// No description provided for @backupPassword.
  ///
  /// In en, this message translates to:
  /// **'Backup password'**
  String get backupPassword;

  /// No description provided for @minimumSixCharacters.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get minimumSixCharacters;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'The operation could not be completed'**
  String get operationFailed;

  /// No description provided for @importPreview.
  ///
  /// In en, this message translates to:
  /// **'Import preview'**
  String get importPreview;

  /// No description provided for @importLabel.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importLabel;

  /// No description provided for @importPreviewCounts.
  ///
  /// In en, this message translates to:
  /// **'{valid} valid, {invalid} invalid, {duplicates} duplicates'**
  String importPreviewCounts(int valid, int invalid, int duplicates);

  /// No description provided for @restoreReplacesData.
  ///
  /// In en, this message translates to:
  /// **'Restoring replaces all current local financial data. If validation fails, your existing data will remain unchanged.'**
  String get restoreReplacesData;

  /// No description provided for @applicationSecurity.
  ///
  /// In en, this message translates to:
  /// **'Application security'**
  String get applicationSecurity;

  /// No description provided for @applicationPin.
  ///
  /// In en, this message translates to:
  /// **'Application PIN'**
  String get applicationPin;

  /// No description provided for @pinStoredSecurely.
  ///
  /// In en, this message translates to:
  /// **'Your PIN is salted and securely hashed; it is never stored as plain text.'**
  String get pinStoredSecurely;

  /// No description provided for @createPin.
  ///
  /// In en, this message translates to:
  /// **'Create PIN'**
  String get createPin;

  /// No description provided for @verifyCurrentPin.
  ///
  /// In en, this message translates to:
  /// **'Verify current PIN'**
  String get verifyCurrentPin;

  /// No description provided for @pinRequirements.
  ///
  /// In en, this message translates to:
  /// **'Use a numeric PIN containing 4 to 8 digits.'**
  String get pinRequirements;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @useBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face'**
  String get useBiometrics;

  /// No description provided for @fingerprintOrFace.
  ///
  /// In en, this message translates to:
  /// **'Use Android biometric authentication when supported'**
  String get fingerprintOrFace;

  /// No description provided for @biometricsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available on this device.'**
  String get biometricsUnavailable;

  /// No description provided for @lockInBackground.
  ///
  /// In en, this message translates to:
  /// **'Lock when app is in the background'**
  String get lockInBackground;

  /// No description provided for @autoLockTimeout.
  ///
  /// In en, this message translates to:
  /// **'Automatic-lock timeout'**
  String get autoLockTimeout;

  /// No description provided for @immediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get immediately;

  /// No description provided for @seconds30.
  ///
  /// In en, this message translates to:
  /// **'30 seconds'**
  String get seconds30;

  /// No description provided for @minute1.
  ///
  /// In en, this message translates to:
  /// **'1 minute'**
  String get minute1;

  /// No description provided for @minutes5.
  ///
  /// In en, this message translates to:
  /// **'5 minutes'**
  String get minutes5;

  /// No description provided for @appLocked.
  ///
  /// In en, this message translates to:
  /// **'DinarWise is locked'**
  String get appLocked;

  /// No description provided for @incorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get incorrectPin;

  /// No description provided for @unlockDinarWise.
  ///
  /// In en, this message translates to:
  /// **'Unlock DinarWise'**
  String get unlockDinarWise;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @offlineCalculators.
  ///
  /// In en, this message translates to:
  /// **'Offline financial calculators'**
  String get offlineCalculators;

  /// No description provided for @calculator.
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get calculator;

  /// No description provided for @budgetCalculator.
  ///
  /// In en, this message translates to:
  /// **'50/30/20 budget calculator'**
  String get budgetCalculator;

  /// No description provided for @emergencyCalculator.
  ///
  /// In en, this message translates to:
  /// **'Emergency-fund calculator'**
  String get emergencyCalculator;

  /// No description provided for @travelCalculator.
  ///
  /// In en, this message translates to:
  /// **'Travel-budget calculator'**
  String get travelCalculator;

  /// No description provided for @debtCalculator.
  ///
  /// In en, this message translates to:
  /// **'Debt-payoff calculator'**
  String get debtCalculator;

  /// No description provided for @goalCalculator.
  ///
  /// In en, this message translates to:
  /// **'Savings-goal calculator'**
  String get goalCalculator;

  /// No description provided for @compoundCalculator.
  ///
  /// In en, this message translates to:
  /// **'Compound-interest calculator'**
  String get compoundCalculator;

  /// No description provided for @needs.
  ///
  /// In en, this message translates to:
  /// **'Needs (50%)'**
  String get needs;

  /// No description provided for @wants.
  ///
  /// In en, this message translates to:
  /// **'Wants (30%)'**
  String get wants;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings (20%)'**
  String get savings;

  /// No description provided for @monthlyEssentials.
  ///
  /// In en, this message translates to:
  /// **'Monthly essential costs'**
  String get monthlyEssentials;

  /// No description provided for @monthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly income'**
  String get monthlyIncome;

  /// No description provided for @currentSaved.
  ///
  /// In en, this message translates to:
  /// **'Current saved amount'**
  String get currentSaved;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @lodging.
  ///
  /// In en, this message translates to:
  /// **'Lodging'**
  String get lodging;

  /// No description provided for @dailyCost.
  ///
  /// In en, this message translates to:
  /// **'Daily cost'**
  String get dailyCost;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @bufferPercent.
  ///
  /// In en, this message translates to:
  /// **'Buffer (%)'**
  String get bufferPercent;

  /// No description provided for @debtBalance.
  ///
  /// In en, this message translates to:
  /// **'Debt balance'**
  String get debtBalance;

  /// No description provided for @annualRate.
  ///
  /// In en, this message translates to:
  /// **'Annual interest rate (%)'**
  String get annualRate;

  /// No description provided for @monthlyPayment.
  ///
  /// In en, this message translates to:
  /// **'Monthly payment'**
  String get monthlyPayment;

  /// No description provided for @paymentTooLow.
  ///
  /// In en, this message translates to:
  /// **'The payment is too low to repay this debt.'**
  String get paymentTooLow;

  /// No description provided for @monthCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month} other{{count} months}}'**
  String monthCount(int count);

  /// No description provided for @startingAmount.
  ///
  /// In en, this message translates to:
  /// **'Starting amount'**
  String get startingAmount;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @monthlyContribution.
  ///
  /// In en, this message translates to:
  /// **'Monthly contribution'**
  String get monthlyContribution;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @calculatorDoesNotSave.
  ///
  /// In en, this message translates to:
  /// **'Calculator results do not change your financial records.'**
  String get calculatorDoesNotSave;

  /// No description provided for @chooseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Choose your currency'**
  String get chooseCurrency;

  /// No description provided for @chooseCurrencyDescription.
  ///
  /// In en, this message translates to:
  /// **'DinarWise will use this currency for your income, expenses, budgets and reports.'**
  String get chooseCurrencyDescription;

  /// No description provided for @decimalPlaces.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 decimal place} other{{count} decimal places}}'**
  String decimalPlaces(int count);

  /// No description provided for @privacyAtGlance.
  ///
  /// In en, this message translates to:
  /// **'Your privacy at a glance'**
  String get privacyAtGlance;

  /// No description provided for @privacyLocalRecords.
  ///
  /// In en, this message translates to:
  /// **'Financial records stay on this device.'**
  String get privacyLocalRecords;

  /// No description provided for @privacySafeTelemetry.
  ///
  /// In en, this message translates to:
  /// **'Privacy-safe usage and diagnostic information helps improve DinarWise.'**
  String get privacySafeTelemetry;

  /// No description provided for @privacyNeverSent.
  ///
  /// In en, this message translates to:
  /// **'Exact amounts, merchants, notes and receipts are never sent to Firebase.'**
  String get privacyNeverSent;

  /// No description provided for @readFullPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read full Privacy Policy'**
  String get readFullPrivacyPolicy;

  /// Requires final owner/legal review before production release.
  ///
  /// In en, this message translates to:
  /// **'DinarWise automatically uses Firebase Analytics for app opens, sessions, screens and privacy-safe feature interactions. Firebase Crashlytics and Performance Monitoring automatically collect privacy-safe crash, error and performance information. Telemetry may be transmitted to Firebase/Google when internet is available. Exact financial records, amounts, balances, merchants, notes and receipts remain local and are not sent. DinarWise does not use Firebase Authentication or cloud synchronization. Advertising identification and personalization are disabled.'**
  String get firebasePrivacyExplanation;

  /// No description provided for @replayAppTutorial.
  ///
  /// In en, this message translates to:
  /// **'Replay app tutorial'**
  String get replayAppTutorial;

  /// No description provided for @tutorialDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard summary'**
  String get tutorialDashboardTitle;

  /// No description provided for @tutorialDashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'See your remaining balance, total income and total expenses at a glance.'**
  String get tutorialDashboardDescription;

  /// No description provided for @tutorialIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get tutorialIncomeTitle;

  /// No description provided for @tutorialIncomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Add household income before recording expenses so DinarWise can protect your remaining balance.'**
  String get tutorialIncomeDescription;

  /// No description provided for @tutorialExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Add an expense'**
  String get tutorialExpenseTitle;

  /// No description provided for @tutorialExpenseDescription.
  ///
  /// In en, this message translates to:
  /// **'Record the merchant, category, date and optional notes for each expense.'**
  String get tutorialExpenseDescription;

  /// No description provided for @tutorialTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent expenses'**
  String get tutorialTransactionsTitle;

  /// No description provided for @tutorialTransactionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Use View All to review, edit, delete, search and filter your expenses.'**
  String get tutorialTransactionsDescription;

  /// No description provided for @tutorialAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get tutorialAnalyticsTitle;

  /// No description provided for @tutorialAnalyticsDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore spending insights, trends and category summaries calculated from your local records.'**
  String get tutorialAnalyticsDescription;

  /// No description provided for @tutorialCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get tutorialCategoriesTitle;

  /// No description provided for @tutorialCategoriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Open Settings to manage built-in categories and create your own custom categories.'**
  String get tutorialCategoriesDescription;

  /// No description provided for @tutorialSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tutorialSettingsTitle;

  /// No description provided for @tutorialSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage language, currency and other app preferences, including theme options when supported.'**
  String get tutorialSettingsDescription;

  /// No description provided for @tutorialNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tutorialNext;

  /// No description provided for @tutorialBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get tutorialBack;

  /// No description provided for @tutorialSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tutorialSkip;

  /// No description provided for @tutorialFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get tutorialFinish;

  /// No description provided for @smartReceiptModel.
  ///
  /// In en, this message translates to:
  /// **'Smart Receipt model'**
  String get smartReceiptModel;

  /// No description provided for @smartReceiptModelNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Smart Receipt Scan is not yet configured for public model distribution. You can continue entering this expense manually.'**
  String get smartReceiptModelNotConfigured;

  /// No description provided for @smartReceiptUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This device cannot run the on-device Smart Receipt model. Manual expense entry remains available.'**
  String get smartReceiptUnsupported;

  /// No description provided for @smartReceiptModelRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose the licensed Gemma 3n E2B model file. It will be verified and stored privately on this device.'**
  String get smartReceiptModelRequired;

  /// No description provided for @smartReceiptModelError.
  ///
  /// In en, this message translates to:
  /// **'The model could not be verified or imported.'**
  String get smartReceiptModelError;

  /// No description provided for @importModel.
  ///
  /// In en, this message translates to:
  /// **'Import verified model'**
  String get importModel;

  /// No description provided for @manualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual entry'**
  String get manualEntry;

  /// No description provided for @smartScanFailed.
  ///
  /// In en, this message translates to:
  /// **'The receipt could not be read. Retry or enter the expense manually.'**
  String get smartScanFailed;

  /// No description provided for @reviewReceiptDetails.
  ///
  /// In en, this message translates to:
  /// **'Review detected details'**
  String get reviewReceiptDetails;

  /// No description provided for @lowConfidenceReview.
  ///
  /// In en, this message translates to:
  /// **'Some details are uncertain. Review every field before using them.'**
  String get lowConfidenceReview;

  /// No description provided for @useDetectedDetails.
  ///
  /// In en, this message translates to:
  /// **'Use these details'**
  String get useDetectedDetails;

  /// No description provided for @detectedCurrencyMismatch.
  ///
  /// In en, this message translates to:
  /// **'The receipt currency differs from your selected currency. The amount was not filled.'**
  String get detectedCurrencyMismatch;

  /// No description provided for @receiptTotalsInconsistent.
  ///
  /// In en, this message translates to:
  /// **'The detected receipt totals are inconsistent. The amount was not filled.'**
  String get receiptTotalsInconsistent;

  /// No description provided for @processingReceipt.
  ///
  /// In en, this message translates to:
  /// **'Reading this receipt privately on your device…'**
  String get processingReceipt;

  /// No description provided for @smartScan.
  ///
  /// In en, this message translates to:
  /// **'Smart scan'**
  String get smartScan;

  /// No description provided for @arabicMixedReceipt.
  ///
  /// In en, this message translates to:
  /// **'Arabic / mixed receipt'**
  String get arabicMixedReceipt;

  /// No description provided for @receiptTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get receiptTotal;

  /// No description provided for @receiptSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get receiptSubtotal;

  /// No description provided for @receiptTax.
  ///
  /// In en, this message translates to:
  /// **'VAT / tax'**
  String get receiptTax;

  /// No description provided for @receiptCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get receiptCurrency;

  /// No description provided for @receiptTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get receiptTime;

  /// No description provided for @cardLastFour.
  ///
  /// In en, this message translates to:
  /// **'Card last 4 digits'**
  String get cardLastFour;

  /// No description provided for @invoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice / receipt number'**
  String get invoiceNumber;

  /// No description provided for @receiptLineItems.
  ///
  /// In en, this message translates to:
  /// **'Reliable line items'**
  String get receiptLineItems;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
