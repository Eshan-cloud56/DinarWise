import 'package:drift/drift.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/features/planning/data/planning_repository.dart';
import 'package:uuid/uuid.dart';

class DriftPlanningRepository implements PlanningRepository {
  DriftPlanningRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<PlanningRecord>> watchSection(
    String profileId,
    String section,
  ) {
    return switch (section) {
      'budgets' => (_database.select(_database.budgets)
            ..where((row) => row.profileId.equals(profileId)))
          .watch()
          .map(
            (rows) => rows
                .map(
                  (row) => PlanningRecord(
                    id: row.id,
                    section: section,
                    name: row.name,
                    amountMinor: row.limitMinor,
                    date: row.endsOn,
                    categoryId: row.categoryId,
                  ),
                )
                .toList(),
          ),
      'goals' => (_database.select(_database.savingsGoals)
            ..where((row) => row.profileId.equals(profileId)))
          .watch()
          .map(
            (rows) => rows
                .map(
                  (row) => PlanningRecord(
                    id: row.id,
                    section: section,
                    name: row.name,
                    amountMinor: row.targetMinor,
                    date: row.targetDate,
                  ),
                )
                .toList(),
          ),
      'bnpl' => (_database.select(_database.bnplPlans)
            ..where((row) => row.profileId.equals(profileId)))
          .watch()
          .map(
            (rows) => rows
                .map(
                  (row) => PlanningRecord(
                    id: row.id,
                    section: section,
                    name: row.merchant,
                    amountMinor: row.purchaseAmountMinor,
                    date: row.purchaseDate,
                  ),
                )
                .toList(),
          ),
      _ => (_database.select(_database.recurringPayments)
            ..where((row) => row.profileId.equals(profileId)))
          .watch()
          .map(
            (rows) => rows
                .map(
                  (row) => PlanningRecord(
                    id: row.id,
                    section: 'recurring',
                    name: row.name,
                    amountMinor: row.amountMinor,
                    date: row.nextPaymentDate,
                    categoryId: row.categoryId,
                  ),
                )
                .toList(),
          ),
    };
  }

  @override
  Future<void> create({
    required String profileId,
    required String section,
    required String name,
    required int amountMinor,
    required DateTime date,
    String? categoryId,
  }) async {
    final id = const Uuid().v4();
    switch (section) {
      case 'budgets':
        await _database.into(_database.budgets).insert(
              BudgetsCompanion.insert(
                id: id,
                profileId: profileId,
                name: name.trim(),
                limitMinor: amountMinor,
                categoryId: Value(categoryId),
                startsOn: DateTime(date.year, date.month),
                endsOn: DateTime(date.year, date.month + 1, 0),
              ),
            );
      case 'goals':
        await _database.into(_database.savingsGoals).insert(
              SavingsGoalsCompanion.insert(
                id: id,
                profileId: profileId,
                name: name.trim(),
                targetMinor: amountMinor,
                targetDate: Value(date),
              ),
            );
      case 'bnpl':
        await _database.transaction(() async {
          const instalmentCount = 4;
          await _database.into(_database.bnplPlans).insert(
                BnplPlansCompanion.insert(
                  id: id,
                  profileId: profileId,
                  provider: 'local',
                  merchant: name.trim(),
                  purchaseAmountMinor: amountMinor,
                  instalmentCount: instalmentCount,
                  purchaseDate: date,
                ),
              );
          final baseAmount = amountMinor ~/ instalmentCount;
          final remainder = amountMinor % instalmentCount;
          for (var index = 0; index < instalmentCount; index++) {
            final dueMonth = DateTime(date.year, date.month + index + 1);
            final lastDay = DateTime(dueMonth.year, dueMonth.month + 1, 0).day;
            final dueDay = date.day > lastDay ? lastDay : date.day;
            await _database.into(_database.bnplInstalments).insert(
                  BnplInstalmentsCompanion.insert(
                    id: const Uuid().v4(),
                    profileId: profileId,
                    planId: id,
                    amountMinor: baseAmount +
                        (index == instalmentCount - 1 ? remainder : 0),
                    dueDate: DateTime(
                      dueMonth.year,
                      dueMonth.month,
                      dueDay,
                    ),
                  ),
                );
          }
        });
      default:
        await _database.into(_database.recurringPayments).insert(
              RecurringPaymentsCompanion.insert(
                id: id,
                profileId: profileId,
                name: name.trim(),
                amountMinor: amountMinor,
                recurrence: 'monthly',
                categoryId: Value(categoryId),
                nextPaymentDate: date,
                isSubscription: const Value(true),
              ),
            );
    }
  }

  @override
  Future<void> delete(String section, String id) async {
    switch (section) {
      case 'budgets':
        await (_database.delete(_database.budgets)
              ..where((row) => row.id.equals(id)))
            .go();
      case 'goals':
        await (_database.delete(_database.savingsGoals)
              ..where((row) => row.id.equals(id)))
            .go();
      case 'bnpl':
        await _database.transaction(() async {
          await (_database.delete(_database.bnplInstalments)
                ..where((row) => row.planId.equals(id)))
              .go();
          await (_database.delete(_database.bnplPlans)
                ..where((row) => row.id.equals(id)))
              .go();
        });
      default:
        await (_database.delete(_database.recurringPayments)
              ..where((row) => row.id.equals(id)))
            .go();
    }
  }
}
