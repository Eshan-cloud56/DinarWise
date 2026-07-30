import 'package:drift/native.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/features/categories/data/drift_category_repository.dart';
import 'package:dinarwise/features/expenses/data/drift_expense_repository.dart';
import 'package:dinarwise/features/expenses/data/history_filter.dart';
import 'package:dinarwise/features/expenses/data/history_preferences_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DriftExpenseRepository expenses;
  late DriftCategoryRepository categories;
  const profileId = 'history-profile';

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    expenses = DriftExpenseRepository(database);
    categories = DriftCategoryRepository(database);
    await categories.ensureSystemCategories(profileId);
  });

  tearDown(() => database.close());

  test('searches, filters, sorts, paginates, and duplicates transactions',
      () async {
    final available = await categories.watchAll(profileId).first;
    final groceries =
        available.singleWhere((item) => item.systemCode == 'groceries');
    final shopping =
        available.singleWhere((item) => item.systemCode == 'shopping');
    await expenses.create(
      profileId: profileId,
      amountMinor: 100000,
      merchant: 'Salary',
      description: 'July pay',
      categoryId: shopping.id,
      transactedAt: DateTime(2026, 7, 1),
      type: 'income',
    );
    await expenses.create(
      profileId: profileId,
      amountMinor: 12500,
      merchant: 'Local Market',
      description: 'Fresh vegetables',
      categoryId: groceries.id,
      transactedAt: DateTime(2026, 7, 4),
    );
    await expenses.create(
      profileId: profileId,
      amountMinor: 4000,
      merchant: 'Book Shop',
      description: 'Notebook',
      categoryId: shopping.id,
      transactedAt: DateTime(2026, 7, 5),
    );

    var result = await expenses.search(
      profileId: profileId,
      filter: const TransactionHistoryFilter(search: 'market'),
    );
    expect(result.single.merchant, 'Local Market');

    result = await expenses.search(
      profileId: profileId,
      filter: const TransactionHistoryFilter(search: '125'),
    );
    expect(result.single.amountMinor, 12500);

    result = await expenses.search(
      profileId: profileId,
      filter: TransactionHistoryFilter(
        type: 'expense',
        categoryId: shopping.id,
        from: DateTime(2026, 7, 5),
        to: DateTime(2026, 7, 5),
      ),
    );
    expect(result.single.merchant, 'Book Shop');

    result = await expenses.search(
      profileId: profileId,
      filter: const TransactionHistoryFilter(
        type: 'expense',
        sort: TransactionHistorySort.highestAmount,
      ),
      limit: 1,
    );
    expect(result.single.amountMinor, 12500);

    await expenses.duplicate(result.single);
    final all = await expenses.watchAll(profileId).first;
    expect(
      all.where((item) => item.merchant == 'Local Market'),
      hasLength(2),
    );
  });

  test('remembers the complete selected history filter', () async {
    final repository = HistoryPreferencesRepository(database);
    final filter = TransactionHistoryFilter(
      search: 'groceries',
      type: 'expense',
      categoryId: 'category-id',
      paymentMethodId: 'payment-id',
      from: DateTime(2026, 6, 1),
      to: DateTime(2026, 6, 30),
      sort: TransactionHistorySort.oldest,
    );
    await repository.save(profileId, filter);
    final restored = await repository.load(profileId);

    expect(restored.search, filter.search);
    expect(restored.type, filter.type);
    expect(restored.categoryId, filter.categoryId);
    expect(restored.paymentMethodId, filter.paymentMethodId);
    expect(restored.from, filter.from);
    expect(restored.to, filter.to);
    expect(restored.sort, filter.sort);
  });
}
