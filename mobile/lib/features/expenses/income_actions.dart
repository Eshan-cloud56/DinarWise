import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/diagnostics/crash_reporting_service.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
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
  final onboarding = await ref.read(onboardingControllerProvider.future);
  final analytics = ref.read(analyticsServiceProvider);
  analytics.screen(income == null ? 'add_income' : 'edit_income');
  if (income == null) analytics.incomeAddStarted();
  final currency = GulfCurrency.fromCode(onboarding.currencyCode);
  if (!context.mounted) return;
  final result = await showIncomeDialog(
    context,
    initialAmount: income == null ? null : currency.toMajor(income.amountMinor),
    currencyCode: currency.code,
    decimalDigits: currency.decimalDigits,
  );
  if (result == null || !context.mounted) return;

  final repository = ref.read(expenseRepositoryProvider);
  try {
    if (result.delete) {
      await repository.delete(income!.id);
      analytics.incomeDeleted(currency.code);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.incomeDeleted)),
        );
      }
      return;
    }

    final amountMinor = currency.toMinor(result.amount!);
    if (income != null) {
      await repository.update(
        ExpenseRecord(
          id: income.id,
          profileId: income.profileId,
          type: 'income',
          amountMinor: amountMinor,
          currency: currency.code,
          merchant: income.merchant,
          description: income.description,
          categoryId: income.categoryId,
          transactedAt: income.transactedAt,
        ),
      );
      analytics.incomeEdited(currency.code);
    } else {
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
        currency: currency.code,
      );
      analytics.incomeAdded(currency.code);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.incomeSaved)),
      );
    }
  } on TransactionValidationException catch (exception) {
    analytics.incomeFailed(
      result.delete ? 'delete' : (income == null ? 'add' : 'edit'),
      switch (exception.failure) {
        TransactionValidationFailure.amountMustBePositive => 'invalid_amount',
        TransactionValidationFailure.incomeReductionWouldOverdraw =>
          'negative_balance',
        TransactionValidationFailure.insufficientBalance => 'negative_balance',
        TransactionValidationFailure.notFound => 'database_error',
      },
    );
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
  } catch (_, stack) {
    analytics.incomeFailed(
      result.delete ? 'delete' : (income == null ? 'add' : 'edit'),
      'database_error',
    );
    ref.read(crashReportingServiceProvider)
      ..setSafeContext(
        screen: income == null ? 'add_income' : 'edit_income',
        operation: result.delete
            ? 'income_delete'
            : (income == null ? 'income_create' : 'income_update'),
      )
      ..recordUnexpected(
        StateError(
          result.delete
              ? 'income_delete_failed'
              : (income == null
                  ? 'income_create_failed'
                  : 'income_update_failed'),
        ),
        stack,
      );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.databaseError)),
      );
    }
  }
}
