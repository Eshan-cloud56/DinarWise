import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/receipts/receipt_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final receiptRepositoryProvider = Provider<ReceiptRepository>(
  (ref) => ReceiptRepository(ref.watch(databaseProvider)),
);

final receiptStorageProvider = FutureProvider<int>((ref) async {
  final state = await ref.watch(onboardingControllerProvider.future);
  return ref.watch(receiptRepositoryProvider).storageUsed(state.localProfileId);
});
