import 'package:flutter/material.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/smart_search/data/smart_search_service.dart';

class SmartSearchSummaryCard extends StatelessWidget {
  const SmartSearchSummaryCard({
    required this.result,
    required this.currencySpec,
    required this.onClear,
    super.key,
  });

  final SmartSearchResult result;
  final GulfCurrency currencySpec;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic =
        Localizations.localeOf(context).languageCode.startsWith('ar');
    final totalText = result.formattedTotal(
      currencySpec: currencySpec,
      locale: Localizations.localeOf(context).toLanguageTag(),
    );
    final countText = isArabic
        ? '${result.count} ${result.count == 1 ? "مصروف" : "مصروفات"}'
        : '${result.count} ${result.count == 1 ? "expense" : "expenses"}';

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  result.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onClear,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  '${isArabic ? "الإجمالي" : "Total"}: $totalText',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  countText,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
