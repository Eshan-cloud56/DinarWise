import 'package:drift/drift.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:uuid/uuid.dart';

const systemCategoryCodes = [
  'restaurants',
  'groceries',
  'fuel',
  'transportation',
  'shopping',
  'healthcare',
  'utilities',
  'subscriptions',
  'bnpl',
  'other',
];

class DriftCategoryRepository implements CategoryRepository {
  DriftCategoryRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<CategoryRecord>> watchAll(String profileId) {
    return _database
        .customSelect(
          '''
            SELECT c.*,
              COUNT(t.id) AS usage_count,
              COALESCE(SUM(CASE WHEN t.type = 'expense'
                THEN t.amount_minor ELSE 0 END), 0) AS spending_total,
              MAX(t.transacted_at) AS transaction_last_used
            FROM expense_categories c
            LEFT JOIN financial_transactions t ON t.category_id = c.id
            WHERE c.profile_id = ?
            GROUP BY c.id
            ORDER BY usage_count DESC,
              COALESCE(transaction_last_used, c.last_used_at) DESC, c.name
          ''',
          variables: [Variable(profileId)],
          readsFrom: {
            _database.expenseCategories,
            _database.financialTransactions,
          },
        )
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => CategoryRecord(
                  id: row.read<String>('id'),
                  name: row.read<String>('name'),
                  systemCode: row.readNullable<String>('system_code'),
                  isSystem: row.read<bool>('is_system'),
                  iconCodePoint: row.read<int>('icon_code_point'),
                  colorValue: row.read<int>('color_value'),
                  usageCount: row.read<int>('usage_count'),
                  spendingMinor: row.read<int>('spending_total'),
                  lastUsedAt:
                      row.readNullable<DateTime>('transaction_last_used') ??
                          row.readNullable<DateTime>('last_used_at'),
                ),
              )
              .toList(),
        );
  }

  @override
  Future<void> ensureSystemCategories(String profileId) async {
    final existingCount =
        await (_database.selectOnly(_database.expenseCategories)
              ..addColumns([_database.expenseCategories.id.count()])
              ..where(
                _database.expenseCategories.profileId.equals(profileId) &
                    _database.expenseCategories.isSystem.equals(true),
              ))
            .map(
              (row) => row.read(_database.expenseCategories.id.count()) ?? 0,
            )
            .getSingle();
    if (existingCount >= systemCategoryCodes.length) return;

    await _database.batch((batch) {
      for (final code in systemCategoryCodes) {
        batch.insert(
          _database.expenseCategories,
          ExpenseCategoriesCompanion.insert(
            id: '$profileId:$code',
            profileId: profileId,
            systemCode: Value(code),
            name: code,
            isSystem: const Value(true),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  @override
  Future<CategoryRecord> createCustom(String profileId, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > 50) {
      throw const FormatException('invalid_category_name');
    }
    final existing = await (_database.select(_database.expenseCategories)
          ..where((row) => row.profileId.equals(profileId)))
        .get();
    if (existing.any(
      (row) => row.name.trim().toLowerCase() == trimmed.toLowerCase(),
    )) {
      throw const FormatException('duplicate_category_name');
    }
    final record = CategoryRecord(
      id: const Uuid().v4(),
      name: trimmed,
      systemCode: null,
      isSystem: false,
    );
    await _database.into(_database.expenseCategories).insert(
          ExpenseCategoriesCompanion.insert(
            id: record.id,
            profileId: profileId,
            name: record.name,
          ),
        );
    return record;
  }

  @override
  Future<void> renameCustom(String categoryId, String name) async {
    final current = await (_database.select(_database.expenseCategories)
          ..where((row) => row.id.equals(categoryId)))
        .getSingle();
    if (current.isSystem) throw const FormatException('system_category');
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > 50) {
      throw const FormatException('invalid_category_name');
    }
    final peers = await (_database.select(_database.expenseCategories)
          ..where((row) => row.profileId.equals(current.profileId)))
        .get();
    if (peers.any(
      (row) =>
          row.id != categoryId &&
          row.name.trim().toLowerCase() == trimmed.toLowerCase(),
    )) {
      throw const FormatException('duplicate_category_name');
    }
    await (_database.update(_database.expenseCategories)
          ..where((row) => row.id.equals(categoryId)))
        .write(ExpenseCategoriesCompanion(name: Value(trimmed)));
  }

  @override
  Future<void> updateAppearance(
    String categoryId, {
    required int iconCodePoint,
    required int colorValue,
  }) {
    return (_database.update(_database.expenseCategories)
          ..where((row) => row.id.equals(categoryId)))
        .write(
      ExpenseCategoriesCompanion(
        iconCodePoint: Value(iconCodePoint),
        colorValue: Value(colorValue),
      ),
    );
  }

  @override
  Future<DeleteCategoryResult> deleteCustom(String categoryId) async {
    final category = await (_database.select(_database.expenseCategories)
          ..where((row) => row.id.equals(categoryId)))
        .getSingle();
    if (category.isSystem) return DeleteCategoryResult.systemCategory;
    final transactionCount = await (_database
            .selectOnly(_database.financialTransactions)
          ..addColumns([_database.financialTransactions.id.count()])
          ..where(
            _database.financialTransactions.categoryId.equals(categoryId),
          ))
        .map((row) => row.read(_database.financialTransactions.id.count()) ?? 0)
        .getSingle();
    final budgetCount = await (_database.selectOnly(_database.budgets)
          ..addColumns([_database.budgets.id.count()])
          ..where(_database.budgets.categoryId.equals(categoryId)))
        .map((row) => row.read(_database.budgets.id.count()) ?? 0)
        .getSingle();
    final recurringCount =
        await (_database.selectOnly(_database.recurringPayments)
              ..addColumns([_database.recurringPayments.id.count()])
              ..where(
                _database.recurringPayments.categoryId.equals(categoryId),
              ))
            .map(
              (row) => row.read(_database.recurringPayments.id.count()) ?? 0,
            )
            .getSingle();
    if (transactionCount + budgetCount + recurringCount > 0) {
      return DeleteCategoryResult.inUse;
    }
    await (_database.delete(_database.expenseCategories)
          ..where((row) => row.id.equals(categoryId)))
        .go();
    return DeleteCategoryResult.deleted;
  }

  @override
  Future<void> reassignAndDelete(
    String categoryId,
    String replacementCategoryId,
  ) async {
    await _database.transaction(() async {
      await (_database.update(_database.financialTransactions)
            ..where((row) => row.categoryId.equals(categoryId)))
          .write(
        FinancialTransactionsCompanion(
          categoryId: Value(replacementCategoryId),
        ),
      );
      await (_database.update(_database.budgets)
            ..where((row) => row.categoryId.equals(categoryId)))
          .write(BudgetsCompanion(categoryId: Value(replacementCategoryId)));
      await (_database.update(_database.budgetCategories)
            ..where((row) => row.categoryId.equals(categoryId)))
          .write(
        BudgetCategoriesCompanion(categoryId: Value(replacementCategoryId)),
      );
      await (_database.update(_database.recurringPayments)
            ..where((row) => row.categoryId.equals(categoryId)))
          .write(
        RecurringPaymentsCompanion(
          categoryId: Value(replacementCategoryId),
        ),
      );
      await (_database.delete(_database.expenseCategories)
            ..where((row) => row.id.equals(categoryId)))
          .go();
    });
  }
}
