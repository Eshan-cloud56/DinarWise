import 'package:drift/drift.dart';
import 'package:dinarwise/core/database/app_database.dart';

class CalendarPreferences {
  const CalendarPreferences({
    required this.month,
    required this.firstWeekday,
    required this.showHijri,
  });

  final DateTime month;
  final int firstWeekday;
  final bool showHijri;
}

class CalendarPreferencesRepository {
  CalendarPreferencesRepository(this._database);

  final AppDatabase _database;

  Future<CalendarPreferences> load(String profileId) async {
    final row = await (_database.select(_database.uiPreferences)
          ..where((item) => item.profileId.equals(profileId)))
        .getSingleOrNull();
    final now = DateTime.now();
    return CalendarPreferences(
      month: row?.calendarMonth ?? DateTime(now.year, now.month),
      firstWeekday: row?.firstWeekday ?? DateTime.monday,
      showHijri: row?.showHijri ?? false,
    );
  }

  Future<void> save(String profileId, CalendarPreferences preferences) {
    return _database.transaction(() async {
      await _database.into(_database.uiPreferences).insert(
            UiPreferencesCompanion.insert(profileId: profileId),
            mode: InsertMode.insertOrIgnore,
          );
      await (_database.update(_database.uiPreferences)
            ..where((row) => row.profileId.equals(profileId)))
          .write(
        UiPreferencesCompanion(
          historyView: const Value('calendar'),
          calendarMonth: Value(preferences.month),
          firstWeekday: Value(preferences.firstWeekday),
          showHijri: Value(preferences.showHijri),
        ),
      );
    });
  }
}
