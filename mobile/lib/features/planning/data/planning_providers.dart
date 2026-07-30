import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/planning/data/drift_planning_repository.dart';
import 'package:dinarwise/features/planning/data/advanced_planning_repository.dart';
import 'package:dinarwise/features/planning/data/commitments_repository.dart';
import 'package:dinarwise/features/planning/data/planning_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final planningRepositoryProvider = Provider<PlanningRepository>(
  (ref) => DriftPlanningRepository(ref.watch(databaseProvider)),
);

final advancedPlanningRepositoryProvider = Provider<AdvancedPlanningRepository>(
  (ref) => AdvancedPlanningRepository(ref.watch(databaseProvider)),
);

final safeToSpendProvider = StreamProvider<SafeToSpendSnapshot>((ref) async* {
  final onboarding = await ref.watch(onboardingControllerProvider.future);
  yield* ref
      .watch(advancedPlanningRepositoryProvider)
      .watchSafeToSpend(onboarding.localProfileId);
});

final commitmentsRepositoryProvider = Provider<CommitmentsRepository>(
  (ref) => CommitmentsRepository(ref.watch(databaseProvider)),
);

final bnplDetailsProvider =
    StreamProvider.autoDispose<List<BnplPlanDetails>>((ref) async* {
  final onboarding = await ref.watch(onboardingControllerProvider.future);
  yield* ref
      .watch(commitmentsRepositoryProvider)
      .watchBnpl(onboarding.localProfileId);
});

final recurringDetailsProvider =
    StreamProvider.autoDispose<List<RecurringDetails>>((ref) async* {
  final onboarding = await ref.watch(onboardingControllerProvider.future);
  final repository = ref.watch(commitmentsRepositoryProvider);
  await repository.reconcileRecurring(onboarding.localProfileId);
  yield* repository.watchRecurring(onboarding.localProfileId);
});

final planningItemsProvider =
    StreamProvider.family<List<PlanningRecord>, String>(
  (ref, section) async* {
    final onboarding = await ref.watch(onboardingControllerProvider.future);
    yield* ref
        .watch(planningRepositoryProvider)
        .watchSection(onboarding.localProfileId, section);
  },
);
