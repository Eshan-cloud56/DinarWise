import 'package:dinarwise/features/expenses/data/history_filter.dart';

class ExpenseRecord {
  const ExpenseRecord({
    required this.id,
    required this.profileId,
    required this.type,
    required this.amountMinor,
    required this.currency,
    required this.merchant,
    required this.description,
    required this.categoryId,
    required this.transactedAt,
    this.paymentMethodId,
    this.receiptAttachmentId,
  });

  final String id;
  final String profileId;
  final String type;
  final int amountMinor;
  final String currency;
  final String? merchant;
  final String? description;
  final String categoryId;
  final DateTime transactedAt;
  final String? paymentMethodId;
  final String? receiptAttachmentId;
}

enum TransactionValidationFailure {
  amountMustBePositive,
  insufficientBalance,
  incomeReductionWouldOverdraw,
  notFound,
}

class TransactionValidationException implements Exception {
  const TransactionValidationException(this.failure);

  final TransactionValidationFailure failure;
}

class FinancialSummary {
  const FinancialSummary({
    required this.totalIncomeMinor,
    required this.totalExpensesMinor,
    this.transactionCount = 0,
  });

  final int totalIncomeMinor;
  final int totalExpensesMinor;
  final int transactionCount;

  int get remainingBalanceMinor => totalIncomeMinor - totalExpensesMinor;
}

abstract interface class ExpenseRepository {
  Stream<List<ExpenseRecord>> watchAll(String profileId);
  Stream<List<ExpenseRecord>> watchRecent(String profileId, {int limit = 5});
  Stream<FinancialSummary> watchSummary(String profileId);
  Future<List<ExpenseRecord>> search({
    required String profileId,
    required TransactionHistoryFilter filter,
    Set<String> categorySearchIds = const {},
    int limit = 50,
    int offset = 0,
  });
  Future<void> duplicate(ExpenseRecord transaction);
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
  });
  Future<void> update(ExpenseRecord expense);
  Future<void> delete(String expenseId);
}
