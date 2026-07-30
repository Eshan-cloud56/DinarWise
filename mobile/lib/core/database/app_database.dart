import 'package:drift/drift.dart';
import 'package:dinarwise/core/database/connection_native.dart';

part 'app_database.g.dart';

class FinancialTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get type => text().withDefault(const Constant('expense'))();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text().withDefault(const Constant('SAR'))();
  TextColumn get merchant => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get categoryId => text()();
  DateTimeColumn get transactedAt => dateTime()();
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get paymentMethodId => text().nullable()();
  TextColumn get receiptAttachmentId => text().nullable()();
  TextColumn get originalCurrency => text().nullable()();
  IntColumn get originalAmountMinor => integer().nullable()();
  TextColumn get exchangeRateId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ExpenseCategories extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get systemCode => text().nullable()();
  TextColumn get name => text()();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  IntColumn get iconCodePoint =>
      integer().withDefault(const Constant(0xe8cc))();
  IntColumn get colorValue =>
      integer().withDefault(const Constant(0xff607d8b))();
  TextColumn get emoji => text().nullable()();
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get name => text()();
  IntColumn get limitMinor => integer()();
  TextColumn get categoryId => text().nullable()();
  DateTimeColumn get startsOn => dateTime()();
  DateTimeColumn get endsOn => dateTime()();
  BoolColumn get isOverall => boolean().withDefault(const Constant(false))();
  TextColumn get rolloverMode => text().withDefault(const Constant('none'))();
  TextColumn get cycleType => text().withDefault(const Constant('monthly'))();
  IntColumn get payday => integer().nullable()();
  IntColumn get fixedCommitmentsMinor =>
      integer().withDefault(const Constant(0))();
  IntColumn get emergencyBufferMinor =>
      integer().withDefault(const Constant(0))();
  IntColumn get carriedAmountMinor =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SavingsGoals extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get name => text()();
  IntColumn get targetMinor => integer()();
  IntColumn get currentMinor => integer().withDefault(const Constant(0))();
  DateTimeColumn get targetDate => dateTime().nullable()();
  TextColumn get templateCode => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class GoalContributions extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get goalId => text()();
  IntColumn get amountMinor => integer()();
  DateTimeColumn get contributedAt => dateTime()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class BnplPlans extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get provider => text()();
  TextColumn get merchant => text()();
  IntColumn get purchaseAmountMinor => integer()();
  TextColumn get currency => text().withDefault(const Constant('SAR'))();
  IntColumn get instalmentCount => integer()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get customProvider => text().nullable()();
  DateTimeColumn get purchaseDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class BnplInstalments extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get planId => text()();
  IntColumn get amountMinor => integer()();
  DateTimeColumn get dueDate => dateTime()();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  DateTimeColumn get paidAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class RecurringPayments extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get name => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text().withDefault(const Constant('SAR'))();
  TextColumn get recurrence => text()();
  TextColumn get categoryId => text().nullable()();
  DateTimeColumn get nextPaymentDate => dateTime()();
  BoolColumn get isSubscription =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get maxOccurrences => integer().nullable()();
  IntColumn get generatedOccurrences =>
      integer().withDefault(const Constant(0))();
  IntColumn get intervalCount => integer().withDefault(const Constant(1))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get lastReconciledAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class FinancialPreferences extends Table {
  TextColumn get profileId => text()();
  IntColumn get monthlyIncomeMinor =>
      integer().withDefault(const Constant(0))();
  IntColumn get payday => integer().withDefault(const Constant(1))();
  TextColumn get currency => text().withDefault(const Constant('SAR'))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  TextColumn get defaultPaymentMethodId => text().nullable()();
  BoolColumn get widgetPrivacyEnabled =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {profileId};
}

class PaymentMethods extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get systemCode => text().nullable()();
  TextColumn get name => text()();
  TextColumn get iconName => text().withDefault(const Constant('payments'))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {profileId, name},
      ];
}

class ReceiptAttachments extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get transactionId => text()();
  TextColumn get filePath => text()();
  TextColumn get thumbnailPath => text().nullable()();
  TextColumn get mimeType => text()();
  IntColumn get sizeBytes => integer()();
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {transactionId},
      ];
}

class BudgetCategories extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get budgetId => text()();
  TextColumn get categoryId => text()();
  IntColumn get limitMinor => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {budgetId, categoryId},
      ];
}

class BudgetHistory extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get budgetId => text()();
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get periodEnd => dateTime()();
  IntColumn get limitMinor => integer()();
  IntColumn get spentMinor => integer()();
  IntColumn get carriedMinor => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class RecurringOccurrences extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get recurringPaymentId => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  IntColumn get amountMinor => integer()();
  TextColumn get status => text().withDefault(const Constant('upcoming'))();
  TextColumn get transactionId => text().nullable()();
  BoolColumn get isOverride => boolean().withDefault(const Constant(false))();
  DateTimeColumn get paidAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {recurringPaymentId, scheduledAt},
      ];
}

class RecurringPaymentHistory extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get recurringPaymentId => text()();
  TextColumn get occurrenceId => text()();
  IntColumn get amountMinor => integer()();
  DateTimeColumn get paidAt => dateTime()();
  TextColumn get transactionId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SubscriptionPriceHistory extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get recurringPaymentId => text()();
  IntColumn get oldAmountMinor => integer()();
  IntColumn get newAmountMinor => integer()();
  DateTimeColumn get changedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class BnplPaymentHistory extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get planId => text()();
  TextColumn get instalmentId => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get action => text()();
  DateTimeColumn get occurredAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class NotificationSchedules extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get recordType => text()();
  TextColumn get recordId => text()();
  TextColumn get notificationType => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  TextColumn get locale => text().withDefault(const Constant('en'))();
  TextColumn get status => text().withDefault(const Constant('scheduled'))();
  DateTimeColumn get deliveredAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {recordType, recordId, notificationType, scheduledAt},
      ];
}

class ExchangeRates extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get baseCurrency => text()();
  TextColumn get quoteCurrency => text()();
  IntColumn get rateMicros => integer()();
  DateTimeColumn get rateDate => dateTime()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {profileId, baseCurrency, quoteCurrency, rateDate},
      ];
}

class SecurityPreferences extends Table {
  TextColumn get profileId => text()();
  TextColumn get pinHash => text().nullable()();
  TextColumn get pinSalt => text().nullable()();
  BoolColumn get biometricEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get autoLockSeconds => integer().withDefault(const Constant(0))();
  BoolColumn get lockOnBackground =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {profileId};
}

class UiPreferences extends Table {
  TextColumn get profileId => text()();
  TextColumn get historySearch => text().withDefault(const Constant(''))();
  TextColumn get historyType => text().withDefault(const Constant('all'))();
  TextColumn get historyCategoryId => text().nullable()();
  TextColumn get historyPaymentMethodId => text().nullable()();
  DateTimeColumn get historyFrom => dateTime().nullable()();
  DateTimeColumn get historyTo => dateTime().nullable()();
  TextColumn get historySort => text().withDefault(const Constant('newest'))();
  TextColumn get historyView => text().withDefault(const Constant('list'))();
  DateTimeColumn get calendarMonth => dateTime().nullable()();
  IntColumn get firstWeekday => integer().withDefault(const Constant(1))();
  BoolColumn get showHijri => boolean().withDefault(const Constant(false))();
  TextColumn get categorySort =>
      text().withDefault(const Constant('most_used'))();

  @override
  Set<Column<Object>> get primaryKey => {profileId};
}

@DriftDatabase(
  tables: [
    FinancialTransactions,
    ExpenseCategories,
    Budgets,
    SavingsGoals,
    GoalContributions,
    BnplPlans,
    BnplInstalments,
    RecurringPayments,
    FinancialPreferences,
    PaymentMethods,
    ReceiptAttachments,
    BudgetCategories,
    BudgetHistory,
    RecurringOccurrences,
    RecurringPaymentHistory,
    SubscriptionPriceHistory,
    BnplPaymentHistory,
    NotificationSchedules,
    ExchangeRates,
    SecurityPreferences,
    UiPreferences,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
          await _createPerformanceIndexes();
        },
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(
              financialTransactions,
              financialTransactions.paymentMethodId,
            );
            await migrator.addColumn(
              financialTransactions,
              financialTransactions.receiptAttachmentId,
            );
            await migrator.addColumn(
              financialTransactions,
              financialTransactions.originalCurrency,
            );
            await migrator.addColumn(
              financialTransactions,
              financialTransactions.originalAmountMinor,
            );
            await migrator.addColumn(
              financialTransactions,
              financialTransactions.exchangeRateId,
            );
            await migrator.addColumn(
              expenseCategories,
              expenseCategories.emoji,
            );
            await migrator.addColumn(
              expenseCategories,
              expenseCategories.lastUsedAt,
            );
            await migrator.addColumn(budgets, budgets.isOverall);
            await migrator.addColumn(budgets, budgets.rolloverMode);
            await migrator.addColumn(budgets, budgets.cycleType);
            await migrator.addColumn(budgets, budgets.payday);
            await migrator.addColumn(
              budgets,
              budgets.fixedCommitmentsMinor,
            );
            await migrator.addColumn(
              budgets,
              budgets.emergencyBufferMinor,
            );
            await migrator.addColumn(budgets, budgets.carriedAmountMinor);
            await migrator.addColumn(budgets, budgets.isActive);
            await migrator.addColumn(
              savingsGoals,
              savingsGoals.templateCode,
            );
            await migrator.addColumn(
              savingsGoals,
              savingsGoals.completedAt,
            );
            await migrator.addColumn(
              goalContributions,
              goalContributions.note,
            );
            await migrator.addColumn(bnplPlans, bnplPlans.status);
            await migrator.addColumn(
              bnplPlans,
              bnplPlans.customProvider,
            );
            await migrator.addColumn(
              recurringPayments,
              recurringPayments.startDate,
            );
            await migrator.addColumn(
              recurringPayments,
              recurringPayments.endDate,
            );
            await migrator.addColumn(
              recurringPayments,
              recurringPayments.maxOccurrences,
            );
            await migrator.addColumn(
              recurringPayments,
              recurringPayments.generatedOccurrences,
            );
            await migrator.addColumn(
              recurringPayments,
              recurringPayments.intervalCount,
            );
            await migrator.addColumn(
              recurringPayments,
              recurringPayments.status,
            );
            await migrator.addColumn(
              recurringPayments,
              recurringPayments.lastReconciledAt,
            );
            await migrator.addColumn(
              financialPreferences,
              financialPreferences.defaultPaymentMethodId,
            );
            await migrator.addColumn(
              financialPreferences,
              financialPreferences.widgetPrivacyEnabled,
            );
            await migrator.createTable(paymentMethods);
            await migrator.createTable(receiptAttachments);
            await migrator.createTable(budgetCategories);
            await migrator.createTable(budgetHistory);
            await migrator.createTable(recurringOccurrences);
            await migrator.createTable(recurringPaymentHistory);
            await migrator.createTable(subscriptionPriceHistory);
            await migrator.createTable(bnplPaymentHistory);
            await migrator.createTable(notificationSchedules);
            await migrator.createTable(exchangeRates);
            await migrator.createTable(securityPreferences);
            await migrator.createTable(uiPreferences);
            await _createPerformanceIndexes();
          }
        },
        beforeOpen: (_) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _createPerformanceIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_transactions_profile_date '
      'ON financial_transactions(profile_id, transacted_at DESC)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_transactions_profile_type '
      'ON financial_transactions(profile_id, type)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_transactions_profile_amount '
      'ON financial_transactions(profile_id, amount_minor)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_transactions_profile_category '
      'ON financial_transactions(profile_id, category_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_transactions_payment_method '
      'ON financial_transactions(payment_method_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_transactions_merchant_nocase '
      'ON financial_transactions(merchant COLLATE NOCASE)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_transactions_description_nocase '
      'ON financial_transactions(description COLLATE NOCASE)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_recurring_occurrence_schedule '
      'ON recurring_occurrences(profile_id, scheduled_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_bnpl_instalment_due '
      'ON bnpl_instalments(profile_id, due_date, is_paid)',
    );
  }

  Future<void> clearAllFinancialData() async {
    await transaction(() async {
      await delete(notificationSchedules).go();
      await delete(bnplPaymentHistory).go();
      await delete(subscriptionPriceHistory).go();
      await delete(recurringPaymentHistory).go();
      await delete(recurringOccurrences).go();
      await delete(budgetHistory).go();
      await delete(budgetCategories).go();
      await delete(receiptAttachments).go();
      await delete(goalContributions).go();
      await delete(bnplInstalments).go();
      await delete(financialTransactions).go();
      await delete(budgets).go();
      await delete(savingsGoals).go();
      await delete(bnplPlans).go();
      await delete(recurringPayments).go();
      await delete(paymentMethods).go();
      await delete(exchangeRates).go();
      await delete(securityPreferences).go();
      await delete(uiPreferences).go();
      await delete(expenseCategories).go();
      await delete(financialPreferences).go();
    });
  }
}
