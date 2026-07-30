import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/planning/data/drift_planning_repository.dart';
import 'package:dinarwise/features/planning/data/planning_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final planningRepositoryProvider = Provider<PlanningRepository>(
  (ref) => DriftPlanningRepository(ref.watch(databaseProvider)),
);

final planningItemsProvider =
    StreamProvider.family<List<PlanningRecord>, String>(
  (ref, section) async* {
    final onboarding = await ref.watch(onboardingControllerProvider.future);
    yield* ref
        .watch(planningRepositoryProvider)
        .watchSection(onboarding.localProfileId, section);
  },
);
