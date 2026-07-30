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

  CategoryRecord _map(ExpenseCategory row) => CategoryRecord(
        id: row.id,
        name: row.name,
        systemCode: row.systemCode,
        isSystem: row.isSystem,
      );

  @override
  Stream<List<CategoryRecord>> watchAll(String profileId) {
    final query = _database.select(_database.expenseCategories)
      ..where((row) => row.profileId.equals(profileId))
      ..orderBy([
        (row) => OrderingTerm.desc(row.isSystem),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.watch().map((rows) => rows.map(_map).toList());
  }

  @override
  Future<void> ensureSystemCategories(String profileId) async {
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
}
