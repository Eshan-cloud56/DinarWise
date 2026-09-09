import 'dart:async';
import 'package:dinarwise/core/widgets/dinar_widgets.dart';
import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/features/analytics/analytics_calculator.dart';

import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/core/performance/performance_service.dart';
import 'package:dinarwise/features/categories/category_localization.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/expenses/data/history_filter.dart';
import 'package:dinarwise/features/expenses/data/history_preferences_repository.dart';
import 'package:dinarwise/features/expenses/income_actions.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:dinarwise/features/payment_methods/payment_method_providers.dart';
import 'package:dinarwise/features/payment_methods/payment_method_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({this.initialCategoryId, super.key});

  final String? initialCategoryId;

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  static const _pageSize = 50;

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  TransactionHistoryFilter _filter = const TransactionHistoryFilter();
  List<ExpenseRecord> _items = const [];
  String? _profileId;
  Timer? _debounce;
  bool _initializing = true;
  bool _loading = false;
  bool _hasMore = false;

  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider)
      ..screen('transactions')
      ..transactionsViewed();
    _scrollController.addListener(_onScroll);
    Future<void>.microtask(_initialize);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    final onboarding = await ref.read(onboardingControllerProvider.future);
    final preferences =
        HistoryPreferencesRepository(ref.read(databaseProvider));
    final saved = await preferences.load(onboarding.localProfileId);
    if (!mounted) return;
    _profileId = onboarding.localProfileId;
    _filter = widget.initialCategoryId == null
        ? saved
        : saved.copyWith(categoryId: widget.initialCategoryId);
    _searchController.text = saved.search;
    setState(() => _initializing = false);
    await _load(reset: true);
  }

  void _onScroll() {
    if (_hasMore && !_loading && _scrollController.position.extentAfter < 320) {
      _load();
    }
  }

  Future<void> _load({bool reset = false}) async {
    final profileId = _profileId;
    if (profileId == null || _loading) return;
    setState(() => _loading = true);
    final categories = ref.read(categoriesProvider).valueOrNull ?? const [];
    final needle = _filter.search.trim().toLowerCase();
    final matchingCategoryIds = needle.isEmpty
        ? <String>{}
        : categories
            .where(
              (category) =>
                  localizedCategoryName(context.l10n, category)
                      .toLowerCase()
                      .contains(needle) ||
                  category.name.toLowerCase().contains(needle),
            )
            .map((category) => category.id)
            .toSet();
    try {
      final result = await ref.read(performanceServiceProvider).trace(
            _filter.search.trim().isEmpty
                ? PerformanceTraces.transactionsLoad
                : PerformanceTraces.transactionSearch,
            () => ref.read(expenseRepositoryProvider).search(
                  profileId: profileId,
                  filter: _filter,
                  categorySearchIds: matchingCategoryIds,
                  limit: _pageSize,
                  offset: reset ? 0 : _items.length,
                ),
          );
      if (!mounted) return;
      setState(() {
        _items = reset ? result : [..._items, ...result];
        _hasMore = result.length == _pageSize;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _apply(TransactionHistoryFilter filter) async {
    setState(() => _filter = filter);
    final profileId = _profileId;
    if (profileId != null) {
      await HistoryPreferencesRepository(ref.read(databaseProvider))
          .save(profileId, filter);
    }
    await _load(reset: true);
  }

  void _searchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        if (value.trim().isNotEmpty) {
          ref.read(analyticsServiceProvider).transactionSearchUsed();
        }
        _apply(_filter.copyWith(search: value));
      },
    );
  }

  Future<void> _chooseDates() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 20),
      lastDate: DateTime(now.year + 5),
      initialDateRange: _filter.from != null && _filter.to != null
          ? DateTimeRange(start: _filter.from!, end: _filter.to!)
          : null,
    );
    if (range != null) {
      ref.read(analyticsServiceProvider).transactionFilterApplied('date');
      await _apply(_filter.copyWith(from: range.start, to: range.end));
    }
  }

  Future<void> _duplicate(ExpenseRecord item) async {
    try {
      await ref.read(expenseRepositoryProvider).duplicate(item);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.transactionDuplicated)),
      );
      await _load(reset: true);
    } on TransactionValidationException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.insufficientBalance)),
      );
    }
  }

  Future<void> _delete(ExpenseRecord item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.deleteTransactionTitle),
        content: Text(context.l10n.deleteTransactionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(expenseRepositoryProvider).delete(item.id);
      final analytics = ref.read(analyticsServiceProvider);
      if (item.type == 'income') {
        analytics.incomeDeleted(item.currency);
      } else {
        final category = (ref.read(categoriesProvider).valueOrNull ?? const [])
            .where((value) => value.id == item.categoryId)
            .firstOrNull;
        analytics.expenseDeleted(
          category?.isSystem == true
              ? (category?.systemCode ?? 'other')
              : 'custom',
          item.currency,
        );
      }
      await _load(reset: true);
    } on TransactionValidationException {
      final analytics = ref.read(analyticsServiceProvider);
      if (item.type == 'income') {
        analytics.incomeFailed('delete', 'negative_balance');
      } else {
        analytics.expenseFailed('delete', 'unknown');
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.incomeReductionBlocked)),
      );
    }
  }

  Future<void> _open(ExpenseRecord item) async {
    if (item.type == 'income') {
      await manageIncome(context, ref, income: item);
    } else {
      await context.push('/capture', extra: item);
    }
    await _load(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const [];
    final paymentMethods =
        ref.watch(paymentMethodsProvider).valueOrNull ?? const [];
    final currencySpec = GulfCurrency.fromCode(
      ref.watch(onboardingControllerProvider).requireValue.currencyCode,
    );
    final currency = currencySpec.formatter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return Scaffold(
      bottomNavigationBar: const DinarBottomNav(selected: 1),
      appBar: DinarHeader(
        subtitle: l10n.history,
        actions: [
          IconButton(
            tooltip: l10n.calendarView,
            onPressed: () => context.go('/history/calendar'),
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ],
      ),
      body: _initializing
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _load(reset: true),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: _FilterPanel(
                      filter: _filter,
                      categories: categories,
                      paymentMethods: paymentMethods,
                      searchController: _searchController,
                      onSearchChanged: _searchChanged,
                      onTypeChanged: (type) {
                        ref
                            .read(analyticsServiceProvider)
                            .transactionFilterApplied('transaction_type');
                        _apply(_filter.copyWith(type: type));
                      },
                      onCategoryChanged: (id) {
                        ref
                            .read(analyticsServiceProvider)
                            .transactionFilterApplied('category');
                        _apply(
                          _filter.copyWith(
                            categoryId: id,
                            clearCategory: id == null,
                          ),
                        );
                      },
                      onPaymentMethodChanged: (id) => _apply(
                        _filter.copyWith(
                          paymentMethodId: id,
                          clearPaymentMethod: id == null,
                        ),
                      ),
                      onSortChanged: (sort) =>
                          _apply(_filter.copyWith(sort: sort)),
                      onChooseDates: _chooseDates,
                      onClear: () {
                        _searchController.clear();
                        _apply(const TransactionHistoryFilter());
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: _CashFlowCard(
                              records:
                                  ref.watch(expensesProvider).valueOrNull ??
                                      const []))),
                  if (_items.isEmpty && !_loading)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text(l10n.noMatchingTransactions)),
                    )
                  else
                    ..._groupSlivers(categories, currency, currencySpec),
                  if (_loading)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
                ],
              ),
            ),
    );
  }

  List<Widget> _groupSlivers(
    List<CategoryRecord> categories,
    NumberFormat currency,
    GulfCurrency currencySpec,
  ) {
    final categoryById = {
      for (final category in categories) category.id: category
    };
    final groups = <DateTime, List<ExpenseRecord>>{};
    for (final item in _items) {
      final date = DateTime(
        item.transactedAt.year,
        item.transactedAt.month,
        item.transactedAt.day,
      );
      groups.putIfAbsent(date, () => []).add(item);
    }
    return [
      for (final entry in groups.entries) ...[
        SliverToBoxAdapter(
          child: _DailyHeader(
            date: entry.key,
            items: entry.value,
            currency: currency,
            currencySpec: currencySpec,
          ),
        ),
        SliverList.builder(
          itemCount: entry.value.length,
          itemBuilder: (context, index) {
            final item = entry.value[index];
            final category = categoryById[item.categoryId];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: DinarTransactionTile(
                item: item,
                category: category,
                method:
                    (ref.watch(paymentMethodsProvider).valueOrNull ?? const [])
                        .where((m) => m.id == item.paymentMethodId)
                        .firstOrNull,
                onTap: () => _open(item),
                menu: PopupMenuButton<String>(
                  onSelected: (action) {
                    if (action == 'duplicate') _duplicate(item);
                    if (action == 'delete') _delete(item);
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                        value: 'duplicate',
                        child: Text(context.l10n.duplicate)),
                    PopupMenuItem(
                        value: 'delete', child: Text(context.l10n.delete)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ];
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.filter,
    required this.categories,
    required this.paymentMethods,
    required this.searchController,
    required this.onSearchChanged,
    required this.onTypeChanged,
    required this.onCategoryChanged,
    required this.onPaymentMethodChanged,
    required this.onSortChanged,
    required this.onChooseDates,
    required this.onClear,
  });

  final TransactionHistoryFilter filter;
  final List<CategoryRecord> categories;
  final List<PaymentMethodDetails> paymentMethods;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onPaymentMethodChanged;
  final ValueChanged<TransactionHistorySort> onSortChanged;
  final VoidCallback onChooseDates;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l10n.searchTransactions,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                for (final option in [
                  ('all', l10n.allTransactions),
                  ('expense', l10n.expense),
                  ('income', l10n.income)
                ])
                  Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: ChoiceChip(
                        label: Text(option.$2),
                        selected: filter.type == option.$1,
                        selectedColor: DinarColors.green,
                        labelStyle: TextStyle(
                            color: filter.type == option.$1
                                ? Colors.white
                                : DinarColors.ink),
                        onSelected: (_) => onTypeChanged(option.$1),
                      )),
              ])),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(l10n.filter),
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: filter.categoryId ?? '',
                      decoration: InputDecoration(labelText: l10n.category),
                      items: [
                        DropdownMenuItem(
                          value: '',
                          child: Text(l10n.allCategories),
                        ),
                        ...categories.map(
                          (category) => DropdownMenuItem(
                            value: category.id,
                            child: Text(localizedCategoryName(l10n, category)),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          onCategoryChanged(value == '' ? null : value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<TransactionHistorySort>(
                      isExpanded: true,
                      initialValue: filter.sort,
                      decoration: InputDecoration(labelText: l10n.filter),
                      items: [
                        DropdownMenuItem(
                          value: TransactionHistorySort.newest,
                          child: Text(l10n.newestFirst),
                        ),
                        DropdownMenuItem(
                          value: TransactionHistorySort.oldest,
                          child: Text(l10n.oldestFirst),
                        ),
                        DropdownMenuItem(
                          value: TransactionHistorySort.highestAmount,
                          child: Text(l10n.highestAmountFirst),
                        ),
                        DropdownMenuItem(
                          value: TransactionHistorySort.lowestAmount,
                          child: Text(l10n.lowestAmountFirst),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) onSortChanged(value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: filter.paymentMethodId ?? '',
                decoration: InputDecoration(labelText: l10n.paymentMethod),
                items: [
                  DropdownMenuItem(
                    value: '',
                    child: Text(l10n.allPaymentMethods,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  ...paymentMethods.map(
                    (method) => DropdownMenuItem(
                      value: method.id,
                      child: Text(paymentLabel(context, method),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
                onChanged: (value) =>
                    onPaymentMethodChanged(value == '' ? null : value),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 12,
                children: [
                  TextButton.icon(
                    onPressed: onChooseDates,
                    icon: const Icon(Icons.date_range_outlined),
                    label: Text(
                      filter.from == null
                          ? l10n.dateRange
                          : '${DateFormat.yMd(Localizations.localeOf(context).toLanguageTag()).format(filter.from!)} – '
                              '${DateFormat.yMd(Localizations.localeOf(context).toLanguageTag()).format(filter.to!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: onClear,
                    child: Text(l10n.clearFilters),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DailyHeader extends StatelessWidget {
  const _DailyHeader({
    required this.date,
    required this.items,
    required this.currency,
    required this.currencySpec,
  });

  final DateTime date;
  final List<ExpenseRecord> items;
  final NumberFormat currency;
  final GulfCurrency currencySpec;

  @override
  Widget build(BuildContext context) {
    final income = items
        .where((item) => item.type == 'income')
        .fold<int>(0, (sum, item) => sum + item.amountMinor);
    final expenses = items
        .where((item) => item.type == 'expense')
        .fold<int>(0, (sum, item) => sum + item.amountMinor);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat.yMMMMd(
              Localizations.localeOf(context).toLanguageTag(),
            ).format(date),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 12,
            children: [
              Text(
                '${context.l10n.dailyIncome}: ${currency.format(currencySpec.toMajor(income))}',
              ),
              Text(
                '${context.l10n.dailyExpense}: '
                '${currency.format(currencySpec.toMajor(expenses))}',
              ),
              Text(
                '${context.l10n.dailyNet}: '
                '${currency.format(currencySpec.toMajor(income - expenses))}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CashFlowCard extends StatelessWidget {
  const _CashFlowCard({required this.records});
  final List<ExpenseRecord> records;
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final summary = const AnalyticsCalculator().calculate(records,
        from: DateTime(now.year, now.month),
        to: DateTime(now.year, now.month + 1, 0));
    final l = context.l10n;
    final metrics = [
      (l.totalIncome, summary.totalIncomeMinor, DinarColors.green),
      (l.totalExpenses, summary.totalExpenseMinor, const Color(0xFFBA1A1A)),
      (
        l.netSavings,
        summary.totalIncomeMinor - summary.totalExpenseMinor,
        DinarColors.green
      )
    ];
    return DinarCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Icon(Icons.circle, size: 8, color: DinarColors.gold),
        const SizedBox(width: 8),
        Expanded(
            child:
                Text(l.cashFlow, style: Theme.of(context).textTheme.titleSmall))
      ]),
      const SizedBox(height: 6),
      Text(
          DateFormat.yMMMM(Localizations.localeOf(context).toLanguageTag())
              .format(now),
          style: const TextStyle(fontSize: 12, color: DinarColors.muted)),
      const SizedBox(height: 16),
      Wrap(spacing: 22, runSpacing: 14, children: [
        for (final m in metrics)
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m.$1,
                style: const TextStyle(fontSize: 11, color: DinarColors.muted)),
            const SizedBox(height: 6),
            FinancialAmount(m.$2, size: 18, color: m.$3)
          ])
      ]),
      const SizedBox(height: 18),
      ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: summary.totalIncomeMinor + summary.totalExpenseMinor == 0
                ? 0
                : summary.totalIncomeMinor /
                    (summary.totalIncomeMinor + summary.totalExpenseMinor),
            backgroundColor: DinarColors.gold,
            color: DinarColors.green,
            minHeight: 6,
          )),
    ]));
  }
}
