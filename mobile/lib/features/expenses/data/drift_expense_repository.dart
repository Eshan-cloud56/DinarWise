import 'package:drift/drift.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/features/expenses/amount_parser.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/expenses/data/history_filter.dart';
import 'package:uuid/uuid.dart';

class DriftExpenseRepository implements ExpenseRepository {
  DriftExpenseRepository(this._database);

  final AppDatabase _database;

  ExpenseRecord _map(FinancialTransaction row) => ExpenseRecord(
        id: row.id,
        profileId: row.profileId,
        type: row.type,
        amountMinor: row.amountMinor,
        currency: row.currency,
        merchant: row.merchant,
        description: row.description,
        categoryId: row.categoryId,
        transactedAt: row.transactedAt,
        paymentMethodId: row.paymentMethodId,
        receiptAttachmentId: row.receiptAttachmentId,
      );

  @override
  Stream<List<ExpenseRecord>> watchAll(String profileId) {
    final query = _database.select(_database.financialTransactions)
      ..where((row) => row.profileId.equals(profileId))
      ..orderBy([(row) => OrderingTerm.desc(row.transactedAt)]);
    return query.watch().map((rows) => rows.map(_map).toList());
  }

  @override
  Stream<List<ExpenseRecord>> watchRecent(
    String profileId, {
    int limit = 5,
  }) {
    final query = _database.select(_database.financialTransactions)
      ..where((row) => row.profileId.equals(profileId))
      ..orderBy([(row) => OrderingTerm.desc(row.transactedAt)])
      ..limit(limit);
    return query.watch().map((rows) => rows.map(_map).toList());
  }

  @override
  Stream<FinancialSummary> watchSummary(String profileId) {
    return _database
        .customSelect(
          '''
            SELECT
              COALESCE(SUM(CASE WHEN type = 'income' THEN amount_minor ELSE 0 END), 0)
                AS total_income,
              COALESCE(SUM(CASE WHEN type = 'expense' THEN amount_minor ELSE 0 END), 0)
                AS total_expenses,
              COUNT(*) AS transaction_count
            FROM financial_transactions
            WHERE profile_id = ?
          ''',
          variables: [Variable<String>(profileId)],
          readsFrom: {_database.financialTransactions},
        )
        .watchSingle()
        .map(
          (row) => FinancialSummary(
            totalIncomeMinor: row.read<int>('total_income'),
            totalExpensesMinor: row.read<int>('total_expenses'),
            transactionCount: row.read<int>('transaction_count'),
          ),
        );
  }

  @override
  Future<List<ExpenseRecord>> search({
    required String profileId,
    required TransactionHistoryFilter filter,
    Set<String> categorySearchIds = const {},
    int limit = 50,
    int offset = 0,
  }) async {
    final transactions = _database.financialTransactions;
    final categories = _database.expenseCategories;
    final query = _database.select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
    ]);
    query.where(transactions.profileId.equals(profileId));

    final search = filter.search.trim().toLowerCase();
    if (search.isNotEmpty) {
      Expression<bool> searchExpression =
          transactions.merchant.lower().like('%$search%') |
              transactions.description.lower().like('%$search%') |
              categories.name.lower().like('%$search%');
      final parsedAmount = parseLocalizedAmount(search);
      if (parsedAmount != null) {
        searchExpression = searchExpression |
            transactions.amountMinor.equals((parsedAmount * 100).round()) |
            transactions.amountMinor.equals((parsedAmount * 1000).round());
      }
      if (categorySearchIds.isNotEmpty) {
        searchExpression =
            searchExpression | transactions.categoryId.isIn(categorySearchIds);
      }
      query.where(searchExpression);
    }
    if (filter.type != 'all') {
      query.where(transactions.type.equals(filter.type));
    }
    if (filter.categoryId != null) {
      query.where(transactions.categoryId.equals(filter.categoryId!));
    }
    if (filter.paymentMethodId != null) {
      query.where(
        transactions.paymentMethodId.equals(filter.paymentMethodId!),
      );
    }
    if (filter.from != null) {
      final start = DateTime(
        filter.from!.year,
        filter.from!.month,
        filter.from!.day,
      );
      query.where(transactions.transactedAt.isBiggerOrEqualValue(start));
    }
    if (filter.to != null) {
      final endExclusive = DateTime(
        filter.to!.year,
        filter.to!.month,
        filter.to!.day + 1,
      );
      query.where(transactions.transactedAt.isSmallerThanValue(endExclusive));
    }
    query.orderBy([
      switch (filter.sort) {
        TransactionHistorySort.newest =>
          OrderingTerm.desc(transactions.transactedAt),
        TransactionHistorySort.oldest =>
          OrderingTerm.asc(transactions.transactedAt),
        TransactionHistorySort.highestAmount =>
          OrderingTerm.desc(transactions.amountMinor),
        TransactionHistorySort.lowestAmount =>
          OrderingTerm.asc(transactions.amountMinor),
      },
      OrderingTerm.desc(transactions.createdAt),
    ]);
    query.limit(limit, offset: offset);
    final rows = await query.get();
    return rows.map((row) => _map(row.readTable(transactions))).toList();
  }

  @override
  Future<void> duplicate(ExpenseRecord transaction) {
    return create(
      profileId: transaction.profileId,
      amountMinor: transaction.amountMinor,
      merchant: transaction.merchant ?? '',
      description: transaction.description ?? '',
      categoryId: transaction.categoryId,
      transactedAt: DateTime.now(),
      type: transaction.type,
      currency: transaction.currency,
      paymentMethodId: transaction.paymentMethodId,
    );
  }

  FinancialSummary _summaryForRows(Iterable<FinancialTransaction> rows) {
    var totalIncomeMinor = 0;
    var totalExpensesMinor = 0;
    for (final row in rows) {
      if (row.type == 'income') {
        totalIncomeMinor += row.amountMinor;
      } else if (row.type == 'expense') {
        totalExpensesMinor += row.amountMinor;
      }
    }
    return FinancialSummary(
      totalIncomeMinor: totalIncomeMinor,
      totalExpensesMinor: totalExpensesMinor,
    );
  }

  Future<List<FinancialTransaction>> _profileRows(String profileId) {
    return (_database.select(_database.financialTransactions)
          ..where((row) => row.profileId.equals(profileId)))
        .get();
  }

  void _validateAmount(int amountMinor) {
    if (amountMinor <= 0) {
      throw const TransactionValidationException(
        TransactionValidationFailure.amountMustBePositive,
      );
    }
  }

  void _validateProposedBalance({
    required Iterable<FinancialTransaction> existingRows,
    required String proposedType,
    required int proposedAmountMinor,
    String? excludedId,
    required TransactionValidationFailure failure,
  }) {
    final summary = _summaryForRows(
      existingRows.where((row) => row.id != excludedId),
    );
    final proposedIncome = summary.totalIncomeMinor +
        (proposedType == 'income' ? proposedAmountMinor : 0);
    final proposedExpenses = summary.totalExpensesMinor +
        (proposedType == 'expense' ? proposedAmountMinor : 0);
    if (proposedExpenses > proposedIncome) {
      throw TransactionValidationException(failure);
    }
  }

  @override
  Future<String> create({
    required String profileId,
    required int amountMinor,
    required String merchant,
    required String description,
    required String categoryId,
    required DateTime transactedAt,
    String type = 'expense',
    String currency = 'SAR',
    String? paymentMethodId,
  }) async {
    _validateAmount(amountMinor);
    final id = const Uuid().v4();
    await _database.transaction(() async {
      final rows = await _profileRows(profileId);
      _validateProposedBalance(
        existingRows: rows,
        proposedType: type,
        proposedAmountMinor: amountMinor,
        failure: TransactionValidationFailure.insufficientBalance,
      );
      await _database.into(_database.financialTransactions).insert(
            FinancialTransactionsCompanion.insert(
              id: id,
              profileId: profileId,
              amountMinor: amountMinor,
              merchant: Value(merchant.trim()),
              description:
                  Value(description.trim().isEmpty ? null : description.trim()),
              categoryId: categoryId,
              transactedAt: transactedAt,
              type: Value(type),
              currency: Value(currency),
              paymentMethodId: Value(paymentMethodId),
            ),
          );
    });
    return id;
  }

  @override
  Future<void> update(ExpenseRecord expense) async {
    _validateAmount(expense.amountMinor);
    await _database.transaction(() async {
      final rows = await _profileRows(expense.profileId);
      final existing = rows.where((row) => row.id == expense.id).firstOrNull;
      if (existing == null) {
        throw const TransactionValidationException(
          TransactionValidationFailure.notFound,
        );
      }
      _validateProposedBalance(
        existingRows: rows,
        excludedId: expense.id,
        proposedType: expense.type,
        proposedAmountMinor: expense.amountMinor,
        failure: existing.type == 'income'
            ? TransactionValidationFailure.incomeReductionWouldOverdraw
            : TransactionValidationFailure.insufficientBalance,
      );
      await (_database.update(_database.financialTransactions)
            ..where((row) => row.id.equals(expense.id)))
          .write(
        FinancialTransactionsCompanion(
          type: Value(expense.type),
          amountMinor: Value(expense.amountMinor),
          currency: Value(expense.currency),
          merchant: Value(expense.merchant?.trim()),
          description: Value(expense.description?.trim()),
          categoryId: Value(expense.categoryId),
          transactedAt: Value(expense.transactedAt),
          paymentMethodId: Value(expense.paymentMethodId),
          receiptAttachmentId: Value(expense.receiptAttachmentId),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  @override
  Future<void> delete(String expenseId) async {
    await _database.transaction(() async {
      final existing = await (_database.select(_database.financialTransactions)
            ..where((row) => row.id.equals(expenseId)))
          .getSingleOrNull();
      if (existing == null) {
        throw const TransactionValidationException(
          TransactionValidationFailure.notFound,
        );
      }
      if (existing.type == 'income') {
        final rows = await _profileRows(existing.profileId);
        _validateProposedBalance(
          existingRows: rows,
          excludedId: existing.id,
          proposedType: 'income',
          proposedAmountMinor: 0,
          failure: TransactionValidationFailure.incomeReductionWouldOverdraw,
        );
      }
      await (_database.delete(_database.financialTransactions)
            ..where((row) => row.id.equals(expenseId)))
          .go();
    });
  }
}
