import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/expenses/income_dialog.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> manageIncome(
  BuildContext context,
  WidgetRef ref, {
  ExpenseRecord? income,
}) async {
  final result = await showIncomeDialog(
    context,
    initialAmount: income == null ? null : income.amountMinor / 100,
  );
  if (result == null || !context.mounted) return;

  final repository = ref.read(expenseRepositoryProvider);
  try {
    if (result.delete) {
      await repository.delete(income!.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.incomeDeleted)),
        );
      }
      return;
    }

    final amountMinor = (result.amount! * 100).round();
    if (income != null) {
      await repository.update(
        ExpenseRecord(
          id: income.id,
          profileId: income.profileId,
          type: 'income',
          amountMinor: amountMinor,
          currency: income.currency,
          merchant: income.merchant,
          description: income.description,
          categoryId: income.categoryId,
          transactedAt: income.transactedAt,
        ),
      );
    } else {
      final onboarding = await ref.read(onboardingControllerProvider.future);
      final categories = await ref.read(categoriesProvider.future);
      final category = categories.firstWhere(
        (item) => item.systemCode == 'other',
        orElse: () => categories.first,
      );
      await repository.create(
        profileId: onboarding.localProfileId,
        amountMinor: amountMinor,
        merchant: '',
        description: '',
        categoryId: category.id,
        transactedAt: DateTime.now(),
        type: 'income',
      );
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.incomeSaved)),
      );
    }
  } on TransactionValidationException catch (exception) {
    if (!context.mounted) return;
    final message = switch (exception.failure) {
      TransactionValidationFailure.incomeReductionWouldOverdraw =>
        context.l10n.incomeReductionBlocked,
      TransactionValidationFailure.amountMustBePositive =>
        context.l10n.enterValidAmount,
      TransactionValidationFailure.notFound => context.l10n.transactionNotFound,
      TransactionValidationFailure.insufficientBalance =>
        context.l10n.insufficientBalance,
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.databaseError)),
      );
    }
  }
}
