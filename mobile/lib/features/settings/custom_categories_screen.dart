import 'package:dinarwise/features/categories/custom_category_dialog.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomCategoriesScreen extends ConsumerWidget {
  const CustomCategoriesScreen({super.key});

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.categoryInUse)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
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
          final custom = items.where((item) => !item.isSystem).toList();
          if (custom.isEmpty) {
            return Center(child: Text(l10n.noCustomCategories));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: custom.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final category = custom[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.label_outline),
                  ),
                  title: Text(category.name),
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) {
                      if (action == 'rename') {
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
                        value: 'rename',
                        child: Text(l10n.rename),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(l10n.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
