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
  String? _selected = 'SAR';
  String _searchQuery = '';
  bool _saving = false;

  Future<void> _continue() async {
    final selected = _selected;
    if (selected == null || _saving) return;
    setState(() => _saving = true);
    final state = await ref.read(onboardingControllerProvider.future);
    final database = ref.read(databaseProvider);
    await database.transaction(() async {
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
    final isSearching = _searchQuery.trim().isNotEmpty;
    final displayedCurrencies = isSearching
        ? AppCurrency.search(_searchQuery)
        : AppCurrency.allCurrencies;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                  child: Column(
                    children: [
                      Icon(
                        Icons.currency_exchange_rounded,
                        size: 56,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        context.l10n.chooseCurrency,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        context.l10n.chooseCurrencyDescription,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        key: const ValueKey('currencySearchField'),
                        decoration: InputDecoration(
                          hintText: language == 'ar'
                              ? 'ابحث عن العملة (الرمز أو الاسم)...'
                              : 'Search currency (code, name, symbol)...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (val) => setState(() => _searchQuery = val),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: displayedCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = displayedCurrencies[index];
                      final isGcc = currency.isGcc;
                      final isSelected = _selected == currency.code;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: isSelected ? 2 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant.withAlpha(80),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: ListTile(
                          onTap: () => setState(() => _selected = currency.code),
                          leading: Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Row(
                            children: [
                              Text(
                                currency.name(language),
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              if (isGcc) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'GCC',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Text(
                            '${currency.code} • ${currency.symbol}',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
