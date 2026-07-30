import 'package:drift/drift.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:uuid/uuid.dart';

class BnplPlanDetails {
  const BnplPlanDetails({
    required this.id,
    required this.provider,
    required this.customProvider,
    required this.merchant,
    required this.purchaseAmountMinor,
    required this.purchaseDate,
    required this.status,
    required this.instalments,
  });

  final String id;
  final String provider;
  final String? customProvider;
  final String merchant;
  final int purchaseAmountMinor;
  final DateTime purchaseDate;
  final String status;
  final List<BnplInstalmentDetails> instalments;

  int get paidMinor => instalments
      .where((item) => item.isPaid)
      .fold(0, (sum, item) => sum + item.amountMinor);
  int get remainingMinor => purchaseAmountMinor - paidMinor;
  BnplInstalmentDetails? get nextInstalment =>
      instalments.where((item) => !item.isPaid).firstOrNull;
}

class BnplInstalmentDetails {
  const BnplInstalmentDetails({
    required this.id,
    required this.amountMinor,
    required this.dueDate,
    required this.isPaid,
    required this.paidAt,
  });

  final String id;
  final int amountMinor;
  final DateTime dueDate;
  final bool isPaid;
  final DateTime? paidAt;

  bool get isLate => !isPaid && dueDate.isBefore(DateTime.now());
}

class BnplDraft {
  const BnplDraft({
    this.id,
    required this.provider,
    this.customProvider,
    required this.merchant,
    required this.purchaseAmountMinor,
    required this.purchaseDate,
    required this.instalmentAmounts,
    required this.dueDates,
  });

  final String? id;
  final String provider;
  final String? customProvider;
  final String merchant;
  final int purchaseAmountMinor;
  final DateTime purchaseDate;
  final List<int> instalmentAmounts;
  final List<DateTime> dueDates;
}

class RecurringDetails {
  const RecurringDetails({
    required this.id,
    required this.name,
    required this.amountMinor,
    required this.recurrence,
    required this.intervalCount,
    required this.categoryId,
    required this.startDate,
    required this.endDate,
    required this.maxOccurrences,
    required this.nextPaymentDate,
    required this.isSubscription,
    required this.status,
    required this.occurrences,
  });

  final String id;
  final String name;
  final int amountMinor;
  final String recurrence;
  final int intervalCount;
  final String? categoryId;
  final DateTime startDate;
  final DateTime? endDate;
  final int? maxOccurrences;
  final DateTime nextPaymentDate;
  final bool isSubscription;
  final String status;
  final List<RecurringOccurrenceDetails> occurrences;

  int get lifetimePaidMinor => occurrences
      .where((item) => item.status == 'paid')
      .fold(0, (sum, item) => sum + item.amountMinor);
  int get monthlyEquivalentMinor =>
      recurrence == 'yearly' ? amountMinor ~/ 12 : amountMinor;
  RecurringOccurrenceDetails? get nextOccurrence =>
      occurrences.where((item) => item.status == 'upcoming').firstOrNull;
}

class RecurringOccurrenceDetails {
  const RecurringOccurrenceDetails({
    required this.id,
    required this.scheduledAt,
    required this.amountMinor,
    required this.status,
    required this.isOverride,
    required this.paidAt,
  });

  final String id;
  final DateTime scheduledAt;
  final int amountMinor;
  final String status;
  final bool isOverride;
  final DateTime? paidAt;
}

class RecurringDraft {
  const RecurringDraft({
    this.id,
    required this.name,
    required this.amountMinor,
    required this.recurrence,
    required this.intervalCount,
    required this.categoryId,
    required this.startDate,
    this.endDate,
    this.maxOccurrences,
    required this.isSubscription,
  });

  final String? id;
  final String name;
  final int amountMinor;
  final String recurrence;
  final int intervalCount;
  final String? categoryId;
  final DateTime startDate;
  final DateTime? endDate;
  final int? maxOccurrences;
  final bool isSubscription;
}

class CommitmentsRepository {
  CommitmentsRepository(this._database);

  final AppDatabase _database;

  Stream<List<BnplPlanDetails>> watchBnpl(String profileId) => _database
      .customSelect(
        'SELECT 1',
        readsFrom: {
          _database.bnplPlans,
          _database.bnplInstalments,
          _database.bnplPaymentHistory,
        },
      )
      .watch()
      .asyncMap((_) => loadBnpl(profileId));

  Future<List<BnplPlanDetails>> loadBnpl(String profileId) async {
    final plans = await (_database.select(_database.bnplPlans)
          ..where((row) => row.profileId.equals(profileId))
          ..orderBy([(row) => OrderingTerm.desc(row.purchaseDate)]))
        .get();
    final result = <BnplPlanDetails>[];
    for (final plan in plans) {
      final instalments = await (_database.select(_database.bnplInstalments)
            ..where((row) => row.planId.equals(plan.id))
            ..orderBy([(row) => OrderingTerm.asc(row.dueDate)]))
          .get();
      result.add(
        BnplPlanDetails(
          id: plan.id,
          provider: plan.provider,
          customProvider: plan.customProvider,
          merchant: plan.merchant,
          purchaseAmountMinor: plan.purchaseAmountMinor,
          purchaseDate: plan.purchaseDate,
          status: plan.status,
          instalments: instalments
              .map(
                (row) => BnplInstalmentDetails(
                  id: row.id,
                  amountMinor: row.amountMinor,
                  dueDate: row.dueDate,
                  isPaid: row.isPaid,
                  paidAt: row.paidAt,
                ),
              )
              .toList(),
        ),
      );
    }
    return result;
  }

  Future<void> saveBnpl(String profileId, BnplDraft draft) async {
    if (draft.merchant.trim().isEmpty ||
        draft.purchaseAmountMinor <= 0 ||
        draft.instalmentAmounts.isEmpty ||
        draft.instalmentAmounts.length != draft.dueDates.length ||
        draft.instalmentAmounts.fold<int>(0, (a, b) => a + b) !=
            draft.purchaseAmountMinor) {
      throw const FormatException('invalid_bnpl');
    }
    await _database.transaction(() async {
      final id = draft.id ?? const Uuid().v4();
      if (draft.id != null) {
        final paid = await (_database.select(_database.bnplInstalments)
              ..where(
                (row) => row.planId.equals(id) & row.isPaid.equals(true),
              ))
            .get();
        if (paid.isNotEmpty) {
          final current = await (_database.select(_database.bnplPlans)
                ..where((row) => row.id.equals(id)))
              .getSingle();
          if (current.purchaseAmountMinor != draft.purchaseAmountMinor) {
            throw const FormatException('paid_plan_amount_locked');
          }
        } else {
          await (_database.delete(_database.bnplInstalments)
                ..where((row) => row.planId.equals(id)))
              .go();
        }
      }
      await _database.into(_database.bnplPlans).insertOnConflictUpdate(
            BnplPlansCompanion.insert(
              id: id,
              profileId: profileId,
              provider: draft.provider,
              merchant: draft.merchant.trim(),
              purchaseAmountMinor: draft.purchaseAmountMinor,
              instalmentCount: draft.instalmentAmounts.length,
              purchaseDate: draft.purchaseDate,
              customProvider: Value(draft.customProvider?.trim()),
              status: const Value('active'),
            ),
          );
      final existing = await (_database.select(_database.bnplInstalments)
            ..where((row) => row.planId.equals(id)))
          .get();
      if (existing.isEmpty) {
        for (var index = 0; index < draft.instalmentAmounts.length; index++) {
          await _database.into(_database.bnplInstalments).insert(
                BnplInstalmentsCompanion.insert(
                  id: const Uuid().v4(),
                  profileId: profileId,
                  planId: id,
                  amountMinor: draft.instalmentAmounts[index],
                  dueDate: draft.dueDates[index],
                ),
              );
        }
      }
    });
  }

  Future<void> setInstalmentPaid({
    required String profileId,
    required String planId,
    required String instalmentId,
    required bool paid,
  }) async {
    await _database.transaction(() async {
      final instalment = await (_database.select(_database.bnplInstalments)
            ..where((row) => row.id.equals(instalmentId)))
          .getSingle();
      await (_database.update(_database.bnplInstalments)
            ..where((row) => row.id.equals(instalmentId)))
          .write(
        BnplInstalmentsCompanion(
          isPaid: Value(paid),
          paidAt: Value(paid ? DateTime.now() : null),
        ),
      );
      await _database.into(_database.bnplPaymentHistory).insert(
            BnplPaymentHistoryCompanion.insert(
              id: const Uuid().v4(),
              profileId: profileId,
              planId: planId,
              instalmentId: instalmentId,
              amountMinor: instalment.amountMinor,
              action: paid ? 'paid' : 'undo',
            ),
          );
      final unpaid = await (_database.select(_database.bnplInstalments)
            ..where(
              (row) => row.planId.equals(planId) & row.isPaid.equals(false),
            ))
          .get();
      await (_database.update(_database.bnplPlans)
            ..where((row) => row.id.equals(planId)))
          .write(
        BnplPlansCompanion(
          status: Value(unpaid.isEmpty ? 'completed' : 'active'),
        ),
      );
    });
  }

  Stream<List<BnplPaymentHistoryData>> watchBnplHistory(String planId) =>
      (_database.select(_database.bnplPaymentHistory)
            ..where((row) => row.planId.equals(planId))
            ..orderBy([(row) => OrderingTerm.desc(row.occurredAt)]))
          .watch();

  Stream<List<RecurringDetails>> watchRecurring(String profileId) => _database
      .customSelect(
        'SELECT 1',
        readsFrom: {
          _database.recurringPayments,
          _database.recurringOccurrences,
          _database.recurringPaymentHistory,
        },
      )
      .watch()
      .asyncMap((_) => loadRecurring(profileId));

  Future<List<RecurringDetails>> loadRecurring(String profileId) async {
    final rules = await (_database.select(_database.recurringPayments)
          ..where((row) => row.profileId.equals(profileId))
          ..orderBy([(row) => OrderingTerm.asc(row.nextPaymentDate)]))
        .get();
    final result = <RecurringDetails>[];
    for (final rule in rules) {
      final occurrences =
          await (_database.select(_database.recurringOccurrences)
                ..where((row) => row.recurringPaymentId.equals(rule.id))
                ..orderBy([(row) => OrderingTerm.asc(row.scheduledAt)]))
              .get();
      result.add(
        RecurringDetails(
          id: rule.id,
          name: rule.name,
          amountMinor: rule.amountMinor,
          recurrence: rule.recurrence,
          intervalCount: rule.intervalCount,
          categoryId: rule.categoryId,
          startDate: rule.startDate ?? rule.nextPaymentDate,
          endDate: rule.endDate,
          maxOccurrences: rule.maxOccurrences,
          nextPaymentDate: rule.nextPaymentDate,
          isSubscription: rule.isSubscription,
          status: rule.status,
          occurrences: occurrences
              .map(
                (row) => RecurringOccurrenceDetails(
                  id: row.id,
                  scheduledAt: row.scheduledAt,
                  amountMinor: row.amountMinor,
                  status: row.status,
                  isOverride: row.isOverride,
                  paidAt: row.paidAt,
                ),
              )
              .toList(),
        ),
      );
    }
    return result;
  }

  Future<void> saveRecurring(String profileId, RecurringDraft draft) async {
    if (draft.name.trim().isEmpty ||
        draft.amountMinor <= 0 ||
        draft.intervalCount <= 0) {
      throw const FormatException('invalid_recurring');
    }
    await _database.transaction(() async {
      final id = draft.id ?? const Uuid().v4();
      if (draft.id != null) {
        final current = await (_database.select(_database.recurringPayments)
              ..where((row) => row.id.equals(id)))
            .getSingle();
        if (current.amountMinor != draft.amountMinor &&
            current.isSubscription) {
          await _database.into(_database.subscriptionPriceHistory).insert(
                SubscriptionPriceHistoryCompanion.insert(
                  id: const Uuid().v4(),
                  profileId: profileId,
                  recurringPaymentId: id,
                  oldAmountMinor: current.amountMinor,
                  newAmountMinor: draft.amountMinor,
                ),
              );
        }
      }
      await _database.into(_database.recurringPayments).insertOnConflictUpdate(
            RecurringPaymentsCompanion.insert(
              id: id,
              profileId: profileId,
              name: draft.name.trim(),
              amountMinor: draft.amountMinor,
              recurrence: draft.recurrence,
              categoryId: Value(draft.categoryId),
              nextPaymentDate: draft.startDate,
              isSubscription: Value(draft.isSubscription),
              startDate: Value(draft.startDate),
              endDate: Value(draft.endDate),
              maxOccurrences: Value(draft.maxOccurrences),
              intervalCount: Value(draft.intervalCount),
              isActive: const Value(true),
              status: const Value('active'),
            ),
          );
      await reconcileRecurring(profileId,
          through: DateTime.now().add(const Duration(days: 90)));
    });
  }

  Future<void> reconcileRecurring(
    String profileId, {
    DateTime? through,
  }) async {
    final horizon = through ?? DateTime.now().add(const Duration(days: 60));
    final rules = await (_database.select(_database.recurringPayments)
          ..where((row) =>
              row.profileId.equals(profileId) &
              row.isActive.equals(true) &
              row.status.equals('active')))
        .get();
    for (final rule in rules) {
      var date = rule.startDate ?? rule.nextPaymentDate;
      var generated = 0;
      while (!date.isAfter(horizon) &&
          (rule.endDate == null || !date.isAfter(rule.endDate!)) &&
          (rule.maxOccurrences == null || generated < rule.maxOccurrences!)) {
        final deterministicId = '${rule.id}:${date.toIso8601String()}';
        await _database.into(_database.recurringOccurrences).insert(
              RecurringOccurrencesCompanion.insert(
                id: deterministicId,
                profileId: profileId,
                recurringPaymentId: rule.id,
                scheduledAt: date,
                amountMinor: rule.amountMinor,
              ),
              mode: InsertMode.insertOrIgnore,
            );
        generated++;
        date = _nextDate(date, rule.recurrence, rule.intervalCount);
      }
      final upcoming = await (_database.select(_database.recurringOccurrences)
            ..where((row) =>
                row.recurringPaymentId.equals(rule.id) &
                row.status.equals('upcoming'))
            ..orderBy([(row) => OrderingTerm.asc(row.scheduledAt)])
            ..limit(1))
          .getSingleOrNull();
      await (_database.update(_database.recurringPayments)
            ..where((row) => row.id.equals(rule.id)))
          .write(
        RecurringPaymentsCompanion(
          generatedOccurrences: Value(generated),
          nextPaymentDate: Value(upcoming?.scheduledAt ?? date),
          lastReconciledAt: Value(DateTime.now()),
        ),
      );
    }
  }

  DateTime _nextDate(DateTime date, String recurrence, int interval) =>
      switch (recurrence) {
        'daily' => date.add(Duration(days: interval)),
        'weekly' => date.add(Duration(days: 7 * interval)),
        'yearly' => DateTime(date.year + interval, date.month, date.day),
        _ => DateTime(date.year, date.month + interval, date.day),
      };

  Future<void> markOccurrencePaid({
    required String profileId,
    required String recurringId,
    required String occurrenceId,
  }) async {
    await _database.transaction(() async {
      final occurrence = await (_database.select(_database.recurringOccurrences)
            ..where((row) => row.id.equals(occurrenceId)))
          .getSingle();
      if (occurrence.status == 'paid') return;
      final paidAt = DateTime.now();
      await (_database.update(_database.recurringOccurrences)
            ..where((row) => row.id.equals(occurrenceId)))
          .write(
        RecurringOccurrencesCompanion(
          status: const Value('paid'),
          paidAt: Value(paidAt),
        ),
      );
      await _database.into(_database.recurringPaymentHistory).insert(
            RecurringPaymentHistoryCompanion.insert(
              id: const Uuid().v4(),
              profileId: profileId,
              recurringPaymentId: recurringId,
              occurrenceId: occurrenceId,
              amountMinor: occurrence.amountMinor,
              paidAt: paidAt,
            ),
          );
    });
  }

  Future<void> editOccurrence(String id, int amountMinor) =>
      (_database.update(_database.recurringOccurrences)
            ..where((row) => row.id.equals(id)))
          .write(
        RecurringOccurrencesCompanion(
          amountMinor: Value(amountMinor),
          isOverride: const Value(true),
        ),
      );

  Future<void> stopRecurring(String id) =>
      (_database.update(_database.recurringPayments)
            ..where((row) => row.id.equals(id)))
          .write(
        const RecurringPaymentsCompanion(
          isActive: Value(false),
          status: Value('ended'),
        ),
      );
}
