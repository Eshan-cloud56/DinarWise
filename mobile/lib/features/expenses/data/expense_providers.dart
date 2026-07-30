import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/categories/data/drift_category_repository.dart';
import 'package:dinarwise/features/expenses/data/drift_expense_repository.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => DriftCategoryRepository(ref.watch(databaseProvider)),
);

final expenseRepositoryProvider = Provider<ExpenseRepository>(
  (ref) => DriftExpenseRepository(ref.watch(databaseProvider)),
);

final categoriesProvider = StreamProvider<List<CategoryRecord>>((ref) async* {
  final onboarding = await ref.watch(onboardingControllerProvider.future);
  final repository = ref.watch(categoryRepositoryProvider);
  await repository.ensureSystemCategories(onboarding.localProfileId);
  yield* repository.watchAll(onboarding.localProfileId);
});

final expensesProvider = StreamProvider<List<ExpenseRecord>>((ref) async* {
  final onboarding = await ref.watch(onboardingControllerProvider.future);
  yield* ref
      .watch(expenseRepositoryProvider)
      .watchAll(onboarding.localProfileId);
});

final recentTransactionsProvider =
    StreamProvider<List<ExpenseRecord>>((ref) async* {
  final onboarding = await ref.watch(onboardingControllerProvider.future);
  yield* ref
      .watch(expenseRepositoryProvider)
      .watchRecent(onboarding.localProfileId);
});

final financialSummaryProvider = StreamProvider<FinancialSummary>((ref) async* {
  final onboarding = await ref.watch(onboardingControllerProvider.future);
  yield* ref
      .watch(expenseRepositoryProvider)
      .watchSummary(onboarding.localProfileId);
});
