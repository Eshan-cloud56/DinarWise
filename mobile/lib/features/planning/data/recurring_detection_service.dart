import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/planning/data/commitments_repository.dart';
import 'package:dinarwise/features/planning/data/planning_providers.dart';

class RecurringSuggestion {
  const RecurringSuggestion({
    required this.merchant,
    required this.averageAmountMinor,
    required this.recurrence,
    this.intervalCount = 1,
    required this.confidence,
    this.categoryId,
    required this.lastTransactionDate,
    required this.suggestedNextDate,
    required this.occurrenceCount,
    this.isSubscription = true,
  });

  final String merchant;
  final int averageAmountMinor;
  final String recurrence; // 'monthly', 'weekly', 'yearly'
  final int intervalCount;
  final double confidence;
  final String? categoryId;
  final DateTime lastTransactionDate;
  final DateTime suggestedNextDate;
  final int occurrenceCount;
  final bool isSubscription;
}

class RecurringDetectionService {
  RecurringDetectionService({
    required this.expenseRepository,
    required this.commitmentsRepository,
    required this.preferences,
  });

  final ExpenseRepository expenseRepository;
  final CommitmentsRepository commitmentsRepository;
  final AppPreferences preferences;

  /// Analyzes local expense history and returns detected recurring suggestions
  Future<List<RecurringSuggestion>> detectRecurring(String profileId) async {
    // 1. Fetch all expenses
    final allExpenses = await expenseRepository.watchAll(profileId).first;
    final expenses = allExpenses
        .where((e) =>
            e.type == 'expense' &&
            e.merchant != null &&
            e.merchant!.trim().isNotEmpty)
        .toList();

    if (expenses.length < 2) return const [];

    // 2. Fetch existing active recurring rules
    final existingRecurring =
        await commitmentsRepository.loadRecurring(profileId);
    final activeNames = existingRecurring
        .where((r) => r.status == 'active')
        .map((r) => r.name.trim().toLowerCase())
        .toSet();

    // 3. Group expenses by normalized merchant
    final Map<String, List<ExpenseRecord>> byMerchant = {};
    for (final exp in expenses) {
      final key = exp.merchant!.trim().toLowerCase();
      byMerchant.putIfAbsent(key, () => []).add(exp);
    }

    final suggestions = <RecurringSuggestion>[];

    for (final entry in byMerchant.entries) {
      final normMerchant = entry.key;
      final group = entry.value;

      // Skip if already tracked
      if (activeNames.contains(normMerchant)) continue;

      // Skip if user dismissed
      if (preferences.isRecurringMerchantDismissed(normMerchant)) continue;

      // Need at least 2 occurrences
      if (group.length < 2) continue;

      // Sort chronological ascending
      group.sort((a, b) => a.transactedAt.compareTo(b.transactedAt));

      // Check amount similarity: amounts within 8% or difference <= 500 minor units
      final amounts = group.map((e) => e.amountMinor).toList();
      final minAmount = amounts.reduce((a, b) => a < b ? a : b);
      final maxAmount = amounts.reduce((a, b) => a > b ? a : b);
      final avgAmount =
          (amounts.reduce((a, b) => a + b) / amounts.length).round();

      final amountVariation =
          (maxAmount - minAmount) / (maxAmount > 0 ? maxAmount : 1);
      if (amountVariation > 0.08 && (maxAmount - minAmount) > 500) {
        continue;
      }

      // Check intervals between consecutive transactions
      final intervalsInDays = <int>[];
      for (var i = 1; i < group.length; i++) {
        final diff =
            group[i].transactedAt.difference(group[i - 1].transactedAt).inDays;
        intervalsInDays.add(diff);
      }

      final avgInterval =
          intervalsInDays.reduce((a, b) => a + b) / intervalsInDays.length;

      String? recurrence;
      final int intervalCount = 1;
      double confidence = 0.0;

      // Monthly: average interval ~25 to 35 days, all between 22 and 38 days
      if (avgInterval >= 25 &&
          avgInterval <= 35 &&
          intervalsInDays.every((d) => d >= 22 && d <= 38)) {
        recurrence = 'monthly';
        confidence = group.length >= 3 ? 0.95 : 0.8;
      }
      // Weekly: average interval ~6 to 8 days, all between 5 and 9 days
      else if (avgInterval >= 6 &&
          avgInterval <= 8 &&
          intervalsInDays.every((d) => d >= 5 && d <= 9)) {
        recurrence = 'weekly';
        confidence = group.length >= 3 ? 0.9 : 0.75;
      }
      // Yearly: average interval ~350 to 380 days
      else if (avgInterval >= 350 &&
          avgInterval <= 380 &&
          intervalsInDays.every((d) => d >= 340 && d <= 390)) {
        recurrence = 'yearly';
        confidence = 0.85;
      }

      if (recurrence != null && confidence >= 0.7) {
        final last = group.last;
        final DateTime nextDate = switch (recurrence) {
          'weekly' => last.transactedAt.add(const Duration(days: 7)),
          'yearly' => DateTime(last.transactedAt.year + 1,
              last.transactedAt.month, last.transactedAt.day),
          _ => DateTime(last.transactedAt.year, last.transactedAt.month + 1,
              last.transactedAt.day),
        };

        suggestions.add(
          RecurringSuggestion(
            merchant: group.last.merchant!,
            averageAmountMinor: avgAmount,
            recurrence: recurrence,
            intervalCount: intervalCount,
            confidence: confidence,
            categoryId: group.last.categoryId,
            lastTransactionDate: last.transactedAt,
            suggestedNextDate: nextDate,
            occurrenceCount: group.length,
          ),
        );
      }
    }

    return suggestions;
  }
}

final recurringDetectionServiceProvider =
    Provider<RecurringDetectionService>((ref) {
  return RecurringDetectionService(
    expenseRepository: ref.watch(expenseRepositoryProvider),
    commitmentsRepository: ref.watch(commitmentsRepositoryProvider),
    preferences: ref.watch(appPreferencesProvider),
  );
});

final recurringSuggestionsProvider =
    FutureProvider<List<RecurringSuggestion>>((ref) async {
  final onboarding = await ref.watch(onboardingControllerProvider.future);
  final service = ref.watch(recurringDetectionServiceProvider);
  return await service.detectRecurring(onboarding.localProfileId);
});
