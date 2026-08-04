import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<CategoryRecord?> showCustomCategoryDialog(
  BuildContext context,
  WidgetRef ref, {
  CategoryRecord? existing,
}) async {
  final controller = TextEditingController(text: existing?.name ?? '');
  String? errorText;
  final result = await showDialog<CategoryRecord>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) {
        final l10n = context.l10n;
        return AlertDialog(
          title: Text(
            existing == null ? l10n.createCustomCategory : l10n.rename,
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: l10n.customCategoryName,
              errorText: errorText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty) {
                  setState(() => errorText = l10n.customCategoryEmpty);
                  return;
                }
                if (name.length > 50) {
                  setState(() => errorText = l10n.customCategoryTooLong);
                  return;
                }
                try {
                  final repository = ref.read(categoryRepositoryProvider);
                  if (existing == null) {
                    final onboarding =
                        await ref.read(onboardingControllerProvider.future);
                    final created = await repository.createCustom(
                      onboarding.localProfileId,
                      name,
                    );
                    ref.read(analyticsServiceProvider)
                      ..customCategoryCreated()
                      ..setCustomCategoriesUsed(true);
                    if (context.mounted) Navigator.pop(context, created);
                  } else {
                    await repository.renameCustom(existing.id, name);
                    ref.read(analyticsServiceProvider).customCategoryEdited();
                    if (context.mounted) {
                      Navigator.pop(
                        context,
                        CategoryRecord(
                          id: existing.id,
                          name: name,
                          systemCode: null,
                          isSystem: false,
                        ),
                      );
                    }
                  }
                } on FormatException catch (error) {
                  setState(() {
                    errorText = error.message == 'duplicate_category_name'
                        ? l10n.customCategoryDuplicate
                        : l10n.customCategoryEmpty;
                  });
                }
              },
              child: Text(existing == null ? l10n.create : l10n.rename),
            ),
          ],
        );
      },
    ),
  );
  controller.dispose();
  return result;
}
