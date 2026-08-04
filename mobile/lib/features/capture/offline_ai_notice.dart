import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Future<void> showOfflineAiNotice(BuildContext context, WidgetRef ref) {
  final analytics = ref.read(analyticsServiceProvider);
  analytics.screen('ai_information');
  analytics.aiInformationViewed();
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      final l10n = sheetContext.l10n;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 44,
                color: Theme.of(sheetContext).colorScheme.primary,
              ),
              const SizedBox(height: 14),
              Text(
                l10n.aiFeature,
                style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.offlineAiMessage,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  context.push('/capture');
                },
                icon: const Icon(Icons.edit_outlined),
                label: Text(l10n.addManually),
              ),
            ],
          ),
        ),
      );
    },
  );
}
