import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/payment_methods/payment_method_providers.dart';
import 'package:dinarwise/features/payment_methods/payment_method_repository.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  Future<String?> _nameDialog(
    BuildContext context, {
    String? initial,
  }) async {
    final controller = TextEditingController(text: initial);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.paymentMethod),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 50,
          decoration: InputDecoration(labelText: context.l10n.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final name = await _nameDialog(context);
    if (name == null || name.isEmpty) return;
    final onboarding = await ref.read(onboardingControllerProvider.future);
    try {
      await ref
          .read(paymentMethodRepositoryProvider)
          .create(onboarding.localProfileId, name);
    } on FormatException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.paymentMethodDuplicate)),
        );
      }
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    PaymentMethodDetails method,
    List<PaymentMethodDetails> methods,
  ) async {
    final repository = ref.read(paymentMethodRepositoryProvider);
    if (await repository.delete(method.id)) return;
    String? replacement =
        methods.where((item) => item.id != method.id).firstOrNull?.id;
    if (!context.mounted || replacement == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(context.l10n.reassignPaymentMethod),
          content: DropdownButtonFormField<String>(
            initialValue: replacement,
            items: methods
                .where((item) => item.id != method.id)
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
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.reassignAndDelete),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true) {
      await repository.delete(method.id, reassignTo: replacement);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.watch(paymentMethodsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.paymentMethods)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.add),
      ),
      body: methods.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(context.l10n.unknownError)),
        data: (items) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 6),
          itemBuilder: (_, index) {
            final method = items[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(_icon(method.systemCode)),
                ),
                title: Text(_label(context, method)),
                subtitle: Text(
                  context.l10n.usageCount(method.usageCount),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: context.l10n.defaultPaymentMethod,
                      icon: Icon(
                        method.isDefault ? Icons.star : Icons.star_border,
                      ),
                      onPressed: method.isDefault
                          ? null
                          : () async {
                              final onboarding = await ref
                                  .read(onboardingControllerProvider.future);
                              await ref
                                  .read(paymentMethodRepositoryProvider)
                                  .setDefault(
                                    onboarding.localProfileId,
                                    method.id,
                                  );
                            },
                    ),
                    PopupMenuButton<String>(
                      onSelected: (action) async {
                        if (action == 'rename') {
                          final name = await _nameDialog(
                            context,
                            initial: method.name,
                          );
                          if (name != null && name.isNotEmpty) {
                            await ref
                                .read(paymentMethodRepositoryProvider)
                                .rename(method.id, name);
                          }
                        } else {
                          await _delete(context, ref, method, items);
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'rename',
                          child: Text(context.l10n.rename),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(context.l10n.delete),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _label(BuildContext context, PaymentMethodDetails method) =>
      switch (method.systemCode) {
        'cash' => context.l10n.cash,
        'debit_card' => context.l10n.debitCard,
        'credit_card' => context.l10n.creditCard,
        'bank_transfer' => context.l10n.bankTransfer,
        'other' => context.l10n.other,
        _ => method.name.replaceAll('_', ' '),
      };

  IconData _icon(String? code) => switch (code) {
        'cash' => Icons.payments_outlined,
        'debit_card' || 'credit_card' || 'mada' => Icons.credit_card_outlined,
        'bank_transfer' => Icons.account_balance_outlined,
        _ => Icons.account_balance_wallet_outlined,
      };
}
