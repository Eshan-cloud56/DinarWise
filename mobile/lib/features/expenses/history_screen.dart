import 'package:dio/dio.dart';
import 'package:dinarwise/core/widgets/dinar_form.dart';
import 'dart:async';
import 'package:dinarwise/core/widgets/dinar_widgets.dart';
import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/features/analytics/analytics_calculator.dart';
import 'package:dinarwise/features/smart_search/data/smart_search_service.dart';
import 'package:dinarwise/features/smart_search/domain/smart_search_heuristic.dart';

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
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:dinarwise/features/payment_methods/payment_method_providers.dart';
import 'package:dinarwise/features/payment_methods/payment_method_repository.dart';
import 'package:dinarwise/features/smart_search/widgets/smart_search_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HistoryLaunchArgs {
  const HistoryLaunchArgs({
    this.categoryId,
    this.searchQuery,
    this.smartSearchResult,
  });

  final String? categoryId;
  final String? searchQuery;
  final SmartSearchResult? smartSearchResult;
}

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({
    this.initialCategoryId,
    this.initialSearch,
    this.initialSmartSearchResult,
    super.key,
  });

  final String? initialCategoryId;
  final String? initialSearch;
  final SmartSearchResult? initialSmartSearchResult;

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
  CancelToken? _smartSearchCancelToken;
  SmartSearchResult? _smartSearchResult;
  bool _isSmartSearching = false;
  String? _smartSearchError;
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

    if (widget.initialSearch != null && widget.initialSearch!.isNotEmpty) {
      _searchController.text = widget.initialSearch!;
      _filter = _filter.copyWith(search: widget.initialSearch!);
    }
    if (widget.initialSmartSearchResult != null) {
      _smartSearchResult = widget.initialSmartSearchResult;
      _items = widget.initialSmartSearchResult!.items;
    }

    Future<void>.microtask(_initialize);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _smartSearchCancelToken?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    try {
      final onboarding = await ref.read(onboardingControllerProvider.future);
      final preferences =
          HistoryPreferencesRepository(ref.read(databaseProvider));
      final saved = await preferences.load(onboarding.localProfileId);
      if (!mounted) return;
      _profileId = onboarding.localProfileId;

      if (widget.initialSmartSearchResult != null) {
        _filter = saved.copyWith(
          categoryId: widget.initialCategoryId,
          search: widget.initialSearch ?? '',
          type: 'expense',
        );
        _searchController.text = widget.initialSearch ?? '';
        return;
      }

      if (widget.initialSearch != null && widget.initialSearch!.isNotEmpty) {
        _filter = saved.copyWith(
          categoryId: widget.initialCategoryId,
          search: widget.initialSearch!,
          type: 'expense',
        );
        _searchController.text = widget.initialSearch!;
        await _load(reset: true);
        return;
      }

      _filter = (widget.initialCategoryId == null
              ? saved.copyWith(search: '')
              : saved.copyWith(categoryId: widget.initialCategoryId, search: ''))
          .copyWith(type: 'expense');
      _searchController.clear();
      await _load(reset: true);
    } finally {
      if (mounted) {
        setState(() => _initializing = false);
      }
    }
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
    AppLocalizations? l10n;
    try {
      if (mounted) l10n = AppLocalizations.of(context);
    } catch (_) {}
    final matchingCategoryIds = resolveCategorySearchIds(
      query: _filter.search,
      categories: categories,
      l10n: l10n,
    );
    try {
      final result = await ref.read(performanceServiceProvider).trace(
            _filter.search.trim().isEmpty
                ? PerformanceTraces.transactionsLoad
                : PerformanceTraces.transactionSearch,
            () => ref.read(expenseRepositoryProvider).search(
                  profileId: profileId,
                  filter: _filter.copyWith(type: 'expense'),
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
    _smartSearchCancelToken?.cancel();

    final query = value.trim();
    if (query.isEmpty) {
      setState(() {
        _smartSearchResult = null;
        _isSmartSearching = false;
        _smartSearchError = null;
      });
      _apply(_filter.copyWith(search: ''));
      return;
    }

    if (isNaturalLanguageQuery(query)) {
      // Clear previous search results immediately to avoid flashing stale results
      setState(() {
        _smartSearchResult = null;
        _smartSearchError = null;
      });

      // Guard against incomplete intermediate typing states
      if (!isCompleteNaturalLanguageQuery(query)) {
        setState(() {
          _isSmartSearching = false;
        });
        return;
      }

      _smartSearchCancelToken = CancelToken();
      final cancelToken = _smartSearchCancelToken;
      _debounce = Timer(
        const Duration(milliseconds: 700),
        () async {
          final profileId = _profileId;
          if (profileId == null) return;
          setState(() {
            _isSmartSearching = true;
            _smartSearchError = null;
          });
          ref.read(analyticsServiceProvider).transactionSearchUsed();
          try {
            final categories =
                ref.read(categoriesProvider).valueOrNull ?? const [];
            final result =
                await ref.read(smartSearchServiceProvider).executeSmartSearch(
                      query: query,
                      locale: Localizations.localeOf(context).languageCode,
                      profileId: profileId,
                      existingCategories: categories,
                      cancelToken: cancelToken,
                    );
            if (!mounted) return;
            setState(() {
              _smartSearchResult = result;
              _isSmartSearching = false;
              _smartSearchError = null;
            });
          } on DioException catch (e) {
            if (e.type == DioExceptionType.cancel) return;
            if (!mounted) return;
            setState(() {
              _isSmartSearching = false;
              _smartSearchError =
                  Localizations.localeOf(context).languageCode.startsWith('ar')
                      ? 'البحث الذكي غير متاح حالياً. تحقق من الاتصال وحاول مجدداً.'
                      : 'Smart Search is unavailable. Check connection and try again.';
            });
          } catch (_) {
            if (!mounted) return;
            setState(() {
              _isSmartSearching = false;
              _smartSearchError =
                  Localizations.localeOf(context).languageCode.startsWith('ar')
                      ? 'البحث الذكي غير متاح حالياً. تحقق من الاتصال وحاول مجدداً.'
                      : 'Smart Search is unavailable. Check connection and try again.';
            });
          }
        },
      );
    } else {
      setState(() {
        _smartSearchResult = null;
        _isSmartSearching = false;
        _smartSearchError = null;
      });
      _debounce = Timer(
        const Duration(milliseconds: 300),
        () {
          if (query.isNotEmpty) {
            ref.read(analyticsServiceProvider).transactionSearchUsed();
          }
          _apply(_filter.copyWith(search: query));
        },
      );
    }
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
                      isSmartSearching: _isSmartSearching,
                      onSortChanged: (sort) =>
                          _apply(_filter.copyWith(sort: sort)),
                      onChooseDates: _chooseDates,
                      onClear: () {
                        _searchController.clear();
                        setState(() {
                          _smartSearchResult = null;
                          _smartSearchError = null;
                        });
                        _apply(const TransactionHistoryFilter());
                      },
                    ),
                  ),
                  if (_smartSearchResult != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: SmartSearchSummaryCard(
                          result: _smartSearchResult!,
                          currencySpec: currencySpec,
                          onClear: () {
                            _searchController.clear();
                            setState(() {
                              _smartSearchResult = null;
                              _smartSearchError = null;
                            });
                            _apply(const TransactionHistoryFilter());
                          },
                        ),
                      ),
                    )
                  else if (_isSmartSearching)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  else if (_smartSearchError != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .errorContainer
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.error),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _smartSearchError!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else if (_searchController.text.trim().isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: _CashFlowCard(
                          records:
                              ref.watch(expensesProvider).valueOrNull ?? const [],
                        ),
                      ),
                    ),
                  if ((_smartSearchResult != null
                          ? _smartSearchResult!.items.isEmpty
                          : _items.isEmpty) &&
                      !_loading &&
                      !_isSmartSearching)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text(l10n.noMatchingTransactions)),
                    )
                  else
                    ..._groupSlivers(
                      categories,
                      currency,
                      currencySpec,
                      _smartSearchResult?.items,
                    ),
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
    GulfCurrency currencySpec, [
    List<ExpenseRecord>? customItems,
  ]) {
    final itemsToDisplay = customItems ?? _items;
    final categoryById = {
      for (final category in categories) category.id: category
    };
    final groups = <DateTime, List<ExpenseRecord>>{};
    for (final item in itemsToDisplay) {
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
    this.isSmartSearching = false,
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
  final bool isSmartSearching;

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
              suffixIcon: isSmartSearching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : (searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: onClear,
                        )
                      : null),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                for (final option in [
                  ('expense', l10n.expense),
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
                    child: DinarDropdownField<String>(
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
                    child: DinarDropdownField<TransactionHistorySort>(
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
              DinarDropdownField<String>(
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
