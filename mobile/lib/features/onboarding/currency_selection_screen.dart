import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CurrencySelectionScreen extends ConsumerStatefulWidget {
  const CurrencySelectionScreen({super.key});

  @override
  ConsumerState<CurrencySelectionScreen> createState() =>
      _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState
    extends ConsumerState<CurrencySelectionScreen> {
  String? _selected;
  bool _saving = false;

  Future<void> _continue() async {
    final selected = _selected;
    if (selected == null || _saving) return;
    setState(() => _saving = true);
    final state = await ref.read(onboardingControllerProvider.future);
    final database = ref.read(databaseProvider);
    await database.transaction(() async {
      await (database.update(database.financialTransactions)
            ..where((row) => row.profileId.equals(state.localProfileId)))
          .write(FinancialTransactionsCompanion(currency: Value(selected)));
      await database.into(database.financialPreferences).insertOnConflictUpdate(
            FinancialPreferencesCompanion.insert(
              profileId: state.localProfileId,
              currency: Value(selected),
            ),
          );
    });
    await ref
        .read(onboardingControllerProvider.notifier)
        .selectCurrency(selected);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.currency_exchange_rounded,
                    size: 68,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.l10n.chooseCurrency,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.chooseCurrencyDescription,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  for (final currency in GulfCurrency.supported)
                    Card(
                      child: ListTile(
                        onTap: () => setState(() => _selected = currency.code),
                        leading: Icon(
                          _selected == currency.code
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(currency.name(language)),
                        subtitle: Text(
                          '${currency.code} • ${currency.symbol} • '
                          '${context.l10n.decimalPlaces(currency.decimalDigits)}',
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _selected == null || _saving ? null : _continue,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: _saving
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(context.l10n.continueLabel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
