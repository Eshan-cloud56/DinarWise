import 'package:drift/drift.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/features/planning/data/planning_calculations.dart';
import 'package:uuid/uuid.dart';

class BudgetDetails {
  const BudgetDetails({
    required this.id,
    required this.name,
    required this.limitMinor,
    required this.startsOn,
    required this.endsOn,
    required this.isOverall,
    required this.rolloverMode,
    required this.cycleType,
    required this.payday,
    required this.fixedCommitmentsMinor,
    required this.emergencyBufferMinor,
    required this.carriedAmountMinor,
    required this.categoryIds,
    required this.spentMinor,
  });

  final String id;
  final String name;
  final int limitMinor;
  final DateTime startsOn;
  final DateTime endsOn;
  final bool isOverall;
  final String rolloverMode;
  final String cycleType;
  final int? payday;
  final int fixedCommitmentsMinor;
  final int emergencyBufferMinor;
  final int carriedAmountMinor;
  final List<String> categoryIds;
  final int spentMinor;

  BudgetProgress get progress => BudgetProgress(
        limitMinor: limitMinor,
        spentMinor: spentMinor,
        carriedMinor: carriedAmountMinor,
      );
}

class BudgetDraft {
  const BudgetDraft({
    this.id,
    required this.name,
    required this.limitMinor,
    required this.startsOn,
    required this.endsOn,
    required this.isOverall,
    required this.rolloverMode,
    required this.cycleType,
    this.payday,
    required this.fixedCommitmentsMinor,
    required this.emergencyBufferMinor,
    required this.categoryIds,
  });

  final String? id;
  final String name;
  final int limitMinor;
  final DateTime startsOn;
  final DateTime endsOn;
  final bool isOverall;
  final String rolloverMode;
  final String cycleType;
  final int? payday;
  final int fixedCommitmentsMinor;
  final int emergencyBufferMinor;
  final List<String> categoryIds;
}

class SafeToSpendSnapshot {
  const SafeToSpendSnapshot({
    required this.amountMinor,
    required this.upcomingBillsMinor,
    required this.upcomingBnplMinor,
    required this.plannedSavingsMinor,
    required this.emergencyBufferMinor,
    required this.daysUntilPayday,
  });

  final int amountMinor;
  final int upcomingBillsMinor;
  final int upcomingBnplMinor;
  final int plannedSavingsMinor;
  final int emergencyBufferMinor;
  final int daysUntilPayday;

  int get dailyMinor =>
      daysUntilPayday <= 0 ? amountMinor : amountMinor ~/ daysUntilPayday;
}

class GoalDetails {
  const GoalDetails({
    required this.id,
    required this.name,
    required this.targetMinor,
    required this.currentMinor,
    required this.targetDate,
    required this.templateCode,
    required this.completedAt,
  });

  final String id;
  final String name;
  final int targetMinor;
  final int currentMinor;
  final DateTime? targetDate;
  final String? templateCode;
  final DateTime? completedAt;

  GoalProgress get progress => GoalProgress(
        targetMinor: targetMinor,
        savedMinor: currentMinor,
        targetDate: targetDate,
      );
}

class GoalContributionDetails {
  const GoalContributionDetails({
    required this.id,
    required this.amountMinor,
    required this.contributedAt,
    required this.note,
  });

  final String id;
  final int amountMinor;
  final DateTime contributedAt;
  final String? note;
}

class AdvancedPlanningRepository {
  AdvancedPlanningRepository(this._database);

  final AppDatabase _database;

  Stream<List<BudgetDetails>> watchBudgets(String profileId) {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _database.budgets,
            _database.budgetCategories,
            _database.financialTransactions,
          },
        )
        .watch()
        .asyncMap((_) => loadBudgets(profileId));
  }

  Future<List<BudgetDetails>> loadBudgets(String profileId) async {
    final budgets = await (_database.select(_database.budgets)
          ..where((row) =>
              row.profileId.equals(profileId) & row.isActive.equals(true))
          ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
        .get();
    final result = <BudgetDetails>[];
    for (final budget in budgets) {
      final links = await (_database.select(_database.budgetCategories)
            ..where((row) => row.budgetId.equals(budget.id)))
          .get();
      final categoryIds = links.map((row) => row.categoryId).toList();
      final transactionQuery =
          _database.selectOnly(_database.financialTransactions)
            ..addColumns([_database.financialTransactions.amountMinor.sum()])
            ..where(
              _database.financialTransactions.profileId.equals(profileId) &
                  _database.financialTransactions.type.equals('expense') &
                  _database.financialTransactions.transactedAt
                      .isBiggerOrEqualValue(budget.startsOn) &
                  _database.financialTransactions.transactedAt
                      .isSmallerOrEqualValue(
                    budget.endsOn.add(const Duration(days: 1)),
                  ),
            );
      if (!budget.isOverall && categoryIds.isNotEmpty) {
        transactionQuery.where(
          _database.financialTransactions.categoryId.isIn(categoryIds),
        );
      } else if (!budget.isOverall && budget.categoryId != null) {
        transactionQuery.where(
          _database.financialTransactions.categoryId.equals(budget.categoryId!),
        );
      }
      final spent = await transactionQuery
          .map(
            (row) =>
                row.read(_database.financialTransactions.amountMinor.sum()) ??
                0,
          )
          .getSingle();
      result.add(
        BudgetDetails(
          id: budget.id,
          name: budget.name,
          limitMinor: budget.limitMinor,
          startsOn: budget.startsOn,
          endsOn: budget.endsOn,
          isOverall: budget.isOverall,
          rolloverMode: budget.rolloverMode,
          cycleType: budget.cycleType,
          payday: budget.payday,
          fixedCommitmentsMinor: budget.fixedCommitmentsMinor,
          emergencyBufferMinor: budget.emergencyBufferMinor,
          carriedAmountMinor: budget.carriedAmountMinor,
          categoryIds: categoryIds.isEmpty && budget.categoryId != null
              ? [budget.categoryId!]
              : categoryIds,
          spentMinor: spent,
        ),
      );
    }
    return result;
  }

  Future<void> saveBudget(String profileId, BudgetDraft draft) async {
    if (draft.name.trim().isEmpty || draft.limitMinor <= 0) {
      throw const FormatException('invalid_budget');
    }
    await _database.transaction(() async {
      final id = draft.id ?? const Uuid().v4();
      if (draft.id != null) {
        final current = await (_database.select(_database.budgets)
              ..where((row) => row.id.equals(id)))
            .getSingle();
        final spent = (await loadBudgets(profileId))
            .where((budget) => budget.id == id)
            .firstOrNull
            ?.spentMinor;
        await _database.into(_database.budgetHistory).insert(
              BudgetHistoryCompanion.insert(
                id: const Uuid().v4(),
                profileId: profileId,
                budgetId: id,
                periodStart: current.startsOn,
                periodEnd: current.endsOn,
                limitMinor: current.limitMinor,
                spentMinor: spent ?? 0,
                carriedMinor: Value(current.carriedAmountMinor),
              ),
            );
      }
      await _database.into(_database.budgets).insertOnConflictUpdate(
            BudgetsCompanion.insert(
              id: id,
              profileId: profileId,
              name: draft.name.trim(),
              limitMinor: draft.limitMinor,
              categoryId: Value(
                draft.categoryIds.length == 1 ? draft.categoryIds.single : null,
              ),
              startsOn: draft.startsOn,
              endsOn: draft.endsOn,
              isOverall: Value(draft.isOverall),
              rolloverMode: Value(draft.rolloverMode),
              cycleType: Value(draft.cycleType),
              payday: Value(draft.payday),
              fixedCommitmentsMinor: Value(draft.fixedCommitmentsMinor),
              emergencyBufferMinor: Value(draft.emergencyBufferMinor),
            ),
          );
      await (_database.delete(_database.budgetCategories)
            ..where((row) => row.budgetId.equals(id)))
          .go();
      for (final categoryId in draft.categoryIds) {
        await _database.into(_database.budgetCategories).insert(
              BudgetCategoriesCompanion.insert(
                id: const Uuid().v4(),
                profileId: profileId,
                budgetId: id,
                categoryId: categoryId,
              ),
            );
      }
      if (draft.payday != null) {
        await _database.into(_database.financialPreferences).insert(
              FinancialPreferencesCompanion.insert(
                profileId: profileId,
                payday: Value(draft.payday!),
              ),
              mode: InsertMode.insertOrIgnore,
            );
        await (_database.update(_database.financialPreferences)
              ..where((row) => row.profileId.equals(profileId)))
            .write(FinancialPreferencesCompanion(payday: Value(draft.payday!)));
      }
    });
  }

  Future<void> deleteBudget(String id) =>
      (_database.delete(_database.budgets)..where((row) => row.id.equals(id)))
          .go();

  Stream<List<BudgetHistoryData>> watchBudgetHistory(String budgetId) =>
      (_database.select(_database.budgetHistory)
            ..where((row) => row.budgetId.equals(budgetId))
            ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
          .watch();

  Stream<List<GoalDetails>> watchGoals(String profileId) =>
      (_database.select(_database.savingsGoals)
            ..where((row) => row.profileId.equals(profileId))
            ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
          .watch()
          .map(
            (rows) => rows
                .map(
                  (row) => GoalDetails(
                    id: row.id,
                    name: row.name,
                    targetMinor: row.targetMinor,
                    currentMinor: row.currentMinor,
                    targetDate: row.targetDate,
                    templateCode: row.templateCode,
                    completedAt: row.completedAt,
                  ),
                )
                .toList(),
          );

  Future<void> saveGoal({
    required String profileId,
    String? id,
    required String name,
    required int targetMinor,
    required DateTime? targetDate,
    required String? templateCode,
  }) async {
    if (name.trim().isEmpty || targetMinor <= 0) {
      throw const FormatException('invalid_goal');
    }
    if (id == null) {
      await _database.into(_database.savingsGoals).insert(
            SavingsGoalsCompanion.insert(
              id: const Uuid().v4(),
              profileId: profileId,
              name: name.trim(),
              targetMinor: targetMinor,
              targetDate: Value(targetDate),
              templateCode: Value(templateCode),
            ),
          );
    } else {
      final current = await (_database.select(_database.savingsGoals)
            ..where((row) => row.id.equals(id)))
          .getSingle();
      await (_database.update(_database.savingsGoals)
            ..where((row) => row.id.equals(id)))
          .write(
        SavingsGoalsCompanion(
          name: Value(name.trim()),
          targetMinor: Value(targetMinor),
          targetDate: Value(targetDate),
          templateCode: Value(templateCode),
          completedAt: Value(
              current.currentMinor >= targetMinor ? DateTime.now() : null),
        ),
      );
    }
  }

  Stream<List<GoalContributionDetails>> watchContributions(String goalId) =>
      (_database.select(_database.goalContributions)
            ..where((row) => row.goalId.equals(goalId))
            ..orderBy([(row) => OrderingTerm.desc(row.contributedAt)]))
          .watch()
          .map(
            (rows) => rows
                .map(
                  (row) => GoalContributionDetails(
                    id: row.id,
                    amountMinor: row.amountMinor,
                    contributedAt: row.contributedAt,
                    note: row.note,
                  ),
                )
                .toList(),
          );

  Future<void> saveContribution({
    required String profileId,
    required String goalId,
    String? contributionId,
    required int amountMinor,
    required DateTime date,
    String? note,
  }) async {
    if (amountMinor <= 0) throw const FormatException('invalid_contribution');
    await _database.transaction(() async {
      final goal = await (_database.select(_database.savingsGoals)
            ..where((row) => row.id.equals(goalId)))
          .getSingle();
      var adjusted = goal.currentMinor;
      if (contributionId != null) {
        final old = await (_database.select(_database.goalContributions)
              ..where((row) => row.id.equals(contributionId)))
            .getSingle();
        adjusted -= old.amountMinor;
        await (_database.update(_database.goalContributions)
              ..where((row) => row.id.equals(contributionId)))
            .write(
          GoalContributionsCompanion(
            amountMinor: Value(amountMinor),
            contributedAt: Value(date),
            note: Value(note?.trim()),
          ),
        );
      } else {
        await _database.into(_database.goalContributions).insert(
              GoalContributionsCompanion.insert(
                id: const Uuid().v4(),
                profileId: profileId,
                goalId: goalId,
                amountMinor: amountMinor,
                contributedAt: date,
                note: Value(note?.trim()),
              ),
            );
      }
      adjusted += amountMinor;
      await (_database.update(_database.savingsGoals)
            ..where((row) => row.id.equals(goalId)))
          .write(
        SavingsGoalsCompanion(
          currentMinor: Value(adjusted),
          completedAt:
              Value(adjusted >= goal.targetMinor ? DateTime.now() : null),
        ),
      );
    });
  }

  Future<void> deleteContribution(String contributionId) async {
    await _database.transaction(() async {
      final contribution = await (_database.select(_database.goalContributions)
            ..where((row) => row.id.equals(contributionId)))
          .getSingle();
      final goal = await (_database.select(_database.savingsGoals)
            ..where((row) => row.id.equals(contribution.goalId)))
          .getSingle();
      final adjusted =
          (goal.currentMinor - contribution.amountMinor).clamp(0, 1 << 62);
      await (_database.delete(_database.goalContributions)
            ..where((row) => row.id.equals(contributionId)))
          .go();
      await (_database.update(_database.savingsGoals)
            ..where((row) => row.id.equals(goal.id)))
          .write(
        SavingsGoalsCompanion(
          currentMinor: Value(adjusted),
          completedAt: const Value(null),
        ),
      );
    });
  }

  Future<SafeToSpendSnapshot> safeToSpend(String profileId) async {
    final now = DateTime.now();
    final preferences = await (_database.select(_database.financialPreferences)
          ..where((row) => row.profileId.equals(profileId)))
        .getSingleOrNull();
    final payday = preferences?.payday ?? 1;
    var nextPayday = DateTime(now.year, now.month, payday);
    if (!nextPayday.isAfter(now)) {
      final nextMonth = DateTime(now.year, now.month + 1);
      final lastDay = DateTime(nextMonth.year, nextMonth.month + 1, 0).day;
      nextPayday = DateTime(
        nextMonth.year,
        nextMonth.month,
        payday > lastDay ? lastDay : payday,
      );
    }
    final transactions =
        await (_database.select(_database.financialTransactions)
              ..where((row) => row.profileId.equals(profileId)))
            .get();
    var income = 0;
    var expenses = 0;
    for (final transaction in transactions) {
      if (transaction.type == 'income') {
        income += transaction.amountMinor;
      } else {
        expenses += transaction.amountMinor;
      }
    }
    final recurring = await (_database.select(_database.recurringPayments)
          ..where((row) =>
              row.profileId.equals(profileId) &
              row.isActive.equals(true) &
              row.nextPaymentDate.isBiggerOrEqualValue(now) &
              row.nextPaymentDate.isSmallerOrEqualValue(nextPayday)))
        .get();
    final instalments = await (_database.select(_database.bnplInstalments)
          ..where((row) =>
              row.profileId.equals(profileId) &
              row.isPaid.equals(false) &
              row.dueDate.isBiggerOrEqualValue(now) &
              row.dueDate.isSmallerOrEqualValue(nextPayday)))
        .get();
    final goals = await (_database.select(_database.savingsGoals)
          ..where((row) =>
              row.profileId.equals(profileId) & row.completedAt.isNull()))
        .get();
    final budgets = await (_database.select(_database.budgets)
          ..where((row) =>
              row.profileId.equals(profileId) & row.isActive.equals(true)))
        .get();
    final upcomingBills =
        recurring.fold<int>(0, (sum, row) => sum + row.amountMinor);
    final upcomingBnpl =
        instalments.fold<int>(0, (sum, row) => sum + row.amountMinor);
    final plannedSavings = goals.fold<int>(0, (sum, row) {
      return sum +
          GoalProgress(
            targetMinor: row.targetMinor,
            savedMinor: row.currentMinor,
            targetDate: row.targetDate,
          ).requiredMonthlyMinor;
    });
    final emergencyBuffer = budgets.fold<int>(
      0,
      (maximum, row) => row.emergencyBufferMinor > maximum
          ? row.emergencyBufferMinor
          : maximum,
    );
    return SafeToSpendSnapshot(
      amountMinor: calculateSafeToSpend(
        remainingBalanceMinor: income - expenses,
        upcomingBillsMinor: upcomingBills,
        upcomingBnplMinor: upcomingBnpl,
        plannedSavingsMinor: plannedSavings,
        emergencyBufferMinor: emergencyBuffer,
      ),
      upcomingBillsMinor: upcomingBills,
      upcomingBnplMinor: upcomingBnpl,
      plannedSavingsMinor: plannedSavings,
      emergencyBufferMinor: emergencyBuffer,
      daysUntilPayday: nextPayday.difference(now).inDays + 1,
    );
  }

  Stream<SafeToSpendSnapshot> watchSafeToSpend(String profileId) {
    return _database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _database.financialTransactions,
            _database.recurringPayments,
            _database.bnplInstalments,
            _database.savingsGoals,
            _database.budgets,
            _database.financialPreferences,
          },
        )
        .watch()
        .asyncMap((_) => safeToSpend(profileId));
  }
}
