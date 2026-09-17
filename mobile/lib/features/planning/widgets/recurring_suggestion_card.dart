import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/features/planning/data/commitments_repository.dart';
import 'package:dinarwise/features/planning/data/planning_providers.dart';
import 'package:dinarwise/features/planning/data/recurring_detection_service.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';

class RecurringSuggestionCard extends ConsumerWidget {
  const RecurringSuggestionCard({
    required this.suggestion,
    super.key,
  });

  final RecurringSuggestion suggestion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final onboarding = ref.watch(onboardingControllerProvider).valueOrNull;
    final currencyCode = onboarding?.currencyCode ?? 'SAR';
    final currency = GulfCurrency.fromCode(currencyCode);
    final majorAmount = currency.toMajor(suggestion.averageAmountMinor);
    final formattedAmount = NumberFormat('#,##0.##').format(majorAmount);

    final frequencyLabel = switch (suggestion.recurrence) {
      'weekly' => l10n.frequencyWeekly,
      'yearly' => l10n.frequencyYearly,
      _ => l10n.frequencyMonthly,
    };

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: DinarColors.forest.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DinarColors.green.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: DinarColors.green.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: DinarColors.green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.recurringSuggestionTitle,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: DinarColors.green,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      suggestion.merchant,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                '$formattedAmount $currencyCode',
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: DinarColors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.recurringSuggestionBody(frequencyLabel),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async {
                  await ref
                      .read(appPreferencesProvider)
                      .dismissRecurringMerchant(suggestion.merchant);
                  ref.invalidate(recurringSuggestionsProvider);
                },
                child: Text(
                  l10n.smsActionDismiss,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: DinarColors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                icon: const Icon(Icons.check, size: 16),
                label: Text(l10n.trackAutomatically),
                onPressed: () async {
                  if (onboarding == null) return;
                  final repo = ref.read(commitmentsRepositoryProvider);
                  await repo.saveRecurring(
                    onboarding.localProfileId,
                    RecurringDraft(
                      name: suggestion.merchant,
                      amountMinor: suggestion.averageAmountMinor,
                      recurrence: suggestion.recurrence,
                      intervalCount: suggestion.intervalCount,
                      categoryId: suggestion.categoryId,
                      startDate: suggestion.suggestedNextDate,
                      isSubscription: true,
                    ),
                  );
                  ref.invalidate(recurringDetailsProvider);
                  ref.invalidate(recurringSuggestionsProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.recurringTrackSuccess),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
