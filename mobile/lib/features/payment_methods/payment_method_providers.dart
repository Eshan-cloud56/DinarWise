import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/payment_methods/payment_method_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentMethodRepositoryProvider = Provider<PaymentMethodRepository>(
  (ref) => PaymentMethodRepository(ref.watch(databaseProvider)),
);

final paymentMethodsProvider =
    StreamProvider<List<PaymentMethodDetails>>((ref) async* {
  final onboarding = await ref.watch(onboardingControllerProvider.future);
  final repository = ref.watch(paymentMethodRepositoryProvider);
  await repository.ensureDefaults(onboarding.localProfileId);
  yield* repository.watchAll(onboarding.localProfileId);
});
