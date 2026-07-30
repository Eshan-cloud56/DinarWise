import 'package:dinarwise/features/categories/custom_category_dialog.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomCategoriesScreen extends ConsumerStatefulWidget {
  const CustomCategoriesScreen({super.key});

  @override
  ConsumerState<CustomCategoriesScreen> createState() =>
      _CustomCategoriesScreenState();
}

class _CustomCategoriesScreenState
    extends ConsumerState<CustomCategoriesScreen> {
  String _sort = 'most_used';

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    CategoryRecord category,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteCategoryTitle),
        content: Text(l10n.deleteCategoryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final result =
        await ref.read(categoryRepositoryProvider).deleteCustom(category.id);
    if (result == DeleteCategoryResult.inUse && context.mounted) {
      final categories = ref.read(categoriesProvider).valueOrNull ?? const [];
      String? replacement =
          categories.where((item) => item.id != category.id).firstOrNull?.id;
      if (replacement == null) return;
      final move = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(l10n.reassignCategory),
            content: DropdownButtonFormField<String>(
              initialValue: replacement,
              items: categories
                  .where((item) => item.id != category.id)
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.id,
                      child: Text(item.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => replacement = value),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.reassignAndDelete),
              ),
            ],
          ),
        ),
      );
      if (move == true) {
        await ref
            .read(categoryRepositoryProvider)
            .reassignAndDelete(category.id, replacement!);
      }
    }
  }

  Future<void> _appearance(
    BuildContext context,
    WidgetRef ref,
    CategoryRecord category,
  ) async {
    const icons = [
      Icons.label_outline,
      Icons.restaurant_outlined,
      Icons.shopping_cart_outlined,
      Icons.directions_car_outlined,
      Icons.home_outlined,
      Icons.health_and_safety_outlined,
      Icons.flight_outlined,
      Icons.school_outlined,
    ];
    const colors = [
      0xff607d8b,
      0xff008577,
      0xffe67e22,
      0xff3498db,
      0xff9b59b6,
      0xffe74c3c,
      0xff27ae60,
      0xff34495e,
    ];
    var icon = category.iconCodePoint;
    var color = category.colorValue;
    final save = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(context.l10n.categoryAppearance),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                children: icons
                    .map(
                      (item) => IconButton.filledTonal(
                        isSelected: item.codePoint == icon,
                        onPressed: () => setState(() => icon = item.codePoint),
                        icon: Icon(item),
                      ),
                    )
                    .toList(),
              ),
              Wrap(
                children: colors
                    .map(
                      (item) => IconButton(
                        onPressed: () => setState(() => color = item),
                        icon: Icon(
                          item == color
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: Color(item),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.save),
            ),
          ],
        ),
      ),
    );
    if (save == true) {
      await ref.read(categoryRepositoryProvider).updateAppearance(
            category.id,
            iconCodePoint: icon,
            colorValue: color,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currency = ref
        .watch(selectedCurrencyProvider)
        .formatter(Localizations.localeOf(context).toLanguageTag());
    final categories = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customCategories)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showCustomCategoryDialog(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.add),
      ),
      body: categories.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.unknownError)),
        data: (items) {
          final sorted = [...items];
          if (_sort == 'alphabetical') {
            sorted.sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            );
          } else if (_sort == 'recent') {
            sorted.sort(
              (a, b) => (b.lastUsedAt ?? DateTime(1970))
                  .compareTo(a.lastUsedAt ?? DateTime(1970)),
            );
          } else {
            sorted.sort((a, b) => b.usageCount.compareTo(a.usageCount));
          }
          if (sorted.isEmpty) {
            return Center(child: Text(l10n.noCustomCategories));
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: DropdownButtonFormField<String>(
                  initialValue: _sort,
                  decoration: InputDecoration(labelText: l10n.sortCategories),
                  items: [
                    DropdownMenuItem(
                      value: 'most_used',
                      child: Text(l10n.mostUsed),
                    ),
                    DropdownMenuItem(
                      value: 'recent',
                      child: Text(l10n.recentlyUsed),
                    ),
                    DropdownMenuItem(
                      value: 'alphabetical',
                      child: Text(l10n.alphabetical),
                    ),
                  ],
                  onChanged: (value) => setState(() => _sort = value!),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: sorted.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final category = sorted[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Color(category.colorValue).withAlpha(40),
                          child: Icon(
                            _categoryIcon(category.iconCodePoint),
                            color: Color(category.colorValue),
                          ),
                        ),
                        title: Text(category.name),
                        subtitle: Text(
                          '${l10n.usageCount(category.usageCount)} • '
                          '${currency.format(category.spendingMinor / 100)}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (action) {
                            if (action == 'appearance') {
                              _appearance(context, ref, category);
                            } else if (action == 'rename') {
                              showCustomCategoryDialog(
                                context,
                                ref,
                                existing: category,
                              );
                            } else {
                              _delete(context, ref, category);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'appearance',
                              child: Text(l10n.categoryAppearance),
                            ),
                            if (!category.isSystem)
                              PopupMenuItem(
                                value: 'rename',
                                child: Text(l10n.rename),
                              ),
                            if (!category.isSystem)
                              PopupMenuItem(
                                value: 'delete',
                                child: Text(l10n.delete),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _categoryIcon(int codePoint) => [
        Icons.label_outline,
        Icons.restaurant_outlined,
        Icons.shopping_cart_outlined,
        Icons.directions_car_outlined,
        Icons.home_outlined,
        Icons.health_and_safety_outlined,
        Icons.flight_outlined,
        Icons.school_outlined,
      ].firstWhere(
        (icon) => icon.codePoint == codePoint,
        orElse: () => Icons.label_outline,
      );
}
