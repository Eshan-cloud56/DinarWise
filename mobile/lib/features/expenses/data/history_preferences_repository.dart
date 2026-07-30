import 'package:drift/drift.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/features/expenses/data/history_filter.dart';

class HistoryPreferencesRepository {
  HistoryPreferencesRepository(this._database);

  final AppDatabase _database;

  Future<TransactionHistoryFilter> load(String profileId) async {
    final row = await (_database.select(_database.uiPreferences)
          ..where((item) => item.profileId.equals(profileId)))
        .getSingleOrNull();
    if (row == null) return const TransactionHistoryFilter();
    return TransactionHistoryFilter(
      search: row.historySearch,
      type: row.historyType,
      categoryId: row.historyCategoryId,
      paymentMethodId: row.historyPaymentMethodId,
      from: row.historyFrom,
      to: row.historyTo,
      sort: TransactionHistorySort.values.firstWhere(
        (value) => value.name == row.historySort,
        orElse: () => TransactionHistorySort.newest,
      ),
    );
  }

  Future<void> save(String profileId, TransactionHistoryFilter filter) {
    return _database.transaction(() async {
      await _database.into(_database.uiPreferences).insert(
            UiPreferencesCompanion.insert(profileId: profileId),
            mode: InsertMode.insertOrIgnore,
          );
      await (_database.update(_database.uiPreferences)
            ..where((row) => row.profileId.equals(profileId)))
          .write(
        UiPreferencesCompanion(
          historySearch: Value(filter.search),
          historyType: Value(filter.type),
          historyCategoryId: Value(filter.categoryId),
          historyPaymentMethodId: Value(filter.paymentMethodId),
          historyFrom: Value(filter.from),
          historyTo: Value(filter.to),
          historySort: Value(filter.sort.name),
        ),
      );
    });
  }
}
