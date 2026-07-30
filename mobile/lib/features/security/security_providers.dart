import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/security/security_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final securityRepositoryProvider = Provider<SecurityRepository>(
  (ref) => SecurityRepository(ref.watch(databaseProvider)),
);

final securitySettingsProvider = StreamProvider<SecuritySettings>((ref) async* {
  final state = await ref.watch(onboardingControllerProvider.future);
  yield* ref.watch(securityRepositoryProvider).watch(state.localProfileId);
});
