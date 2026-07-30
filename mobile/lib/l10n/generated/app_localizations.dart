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

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'DinarWise'**
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

  /// No description provided for @privacyConsentPrefix.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the '**
  String get privacyConsentPrefix;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyConsentSuffix.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get privacyConsentSuffix;

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
  /// **'Recent transactions'**
  String get recentTransactions;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpense;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
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
  /// **'No transactions yet'**
  String get noTransactions;

  /// No description provided for @noTransactionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Add income first, then record your household expenses.'**
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
  /// **'Transaction saved successfully'**
  String get transactionSaved;

  /// No description provided for @enterExpenseDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter expense details'**
  String get enterExpenseDetails;

  /// No description provided for @enterTransactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter transaction details'**
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
  /// **'This transaction no longer exists.'**
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
  /// **'Delete transaction?'**
  String get deleteTransactionTitle;

  /// No description provided for @deleteTransactionMessage.
  ///
  /// In en, this message translates to:
  /// **'This transaction will be permanently deleted.'**
  String get deleteTransactionMessage;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
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
  /// **'Transaction history'**
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
  /// **'Transaction duplicated'**
  String get transactionDuplicated;

  /// No description provided for @noMatchingTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions match these filters'**
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
