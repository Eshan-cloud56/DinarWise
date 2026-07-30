import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/expenses/data/calendar_calculator.dart';
import 'package:dinarwise/features/expenses/data/calendar_preferences_repository.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/expenses/data/history_filter.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class SpendingCalendarScreen extends ConsumerStatefulWidget {
  const SpendingCalendarScreen({super.key});

  @override
  ConsumerState<SpendingCalendarScreen> createState() =>
      _SpendingCalendarScreenState();
}

class _SpendingCalendarScreenState
    extends ConsumerState<SpendingCalendarScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  int _firstWeekday = DateTime.monday;
  bool _showHijri = false;
  bool _loading = true;
  String? _profileId;
  List<ExpenseRecord> _records = const [];

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_initialize);
  }

  Future<void> _initialize() async {
    final onboarding = await ref.read(onboardingControllerProvider.future);
    final preferences =
        await CalendarPreferencesRepository(ref.read(databaseProvider))
            .load(onboarding.localProfileId);
    if (!mounted) return;
    _profileId = onboarding.localProfileId;
    _month = DateTime(preferences.month.year, preferences.month.month);
    _firstWeekday = preferences.firstWeekday;
    _showHijri = preferences.showHijri;
    await _load();
  }

  Future<void> _load() async {
    final profileId = _profileId;
    if (profileId == null) return;
    setState(() => _loading = true);
    final start = DateTime(_month.year, _month.month);
    final end = DateTime(_month.year, _month.month + 1)
        .subtract(const Duration(days: 1));
    final records = await ref.read(expenseRepositoryProvider).search(
          profileId: profileId,
          filter: TransactionHistoryFilter(from: start, to: end),
          limit: 10000,
        );
    if (!mounted) return;
    setState(() {
      _records = records;
      _loading = false;
    });
    await _savePreferences();
  }

  Future<void> _savePreferences() async {
    final profileId = _profileId;
    if (profileId == null) return;
    await CalendarPreferencesRepository(ref.read(databaseProvider)).save(
      profileId,
      CalendarPreferences(
        month: _month,
        firstWeekday: _firstWeekday,
        showHijri: _showHijri,
      ),
    );
  }

  Future<void> _moveMonth(int delta) async {
    _month = DateTime(_month.year, _month.month + delta);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.spendingCalendar),
        actions: [
          IconButton(
            tooltip: context.l10n.listView,
            onPressed: () => context.go('/history'),
            icon: const Icon(Icons.view_list_outlined),
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'sunday' || value == 'monday') {
                setState(
                  () => _firstWeekday =
                      value == 'sunday' ? DateTime.sunday : DateTime.monday,
                );
              } else if (value == 'hijri') {
                setState(() => _showHijri = !_showHijri);
              }
              await _savePreferences();
            },
            itemBuilder: (_) => [
              CheckedPopupMenuItem(
                value: 'monday',
                checked: _firstWeekday == DateTime.monday,
                child: Text(context.l10n.mondayFirst),
              ),
              CheckedPopupMenuItem(
                value: 'sunday',
                checked: _firstWeekday == DateTime.sunday,
                child: Text(context.l10n.sundayFirst),
              ),
              CheckedPopupMenuItem(
                value: 'hijri',
                checked: _showHijri,
                child: Text(context.l10n.showHijriDates),
              ),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => _moveMonth(-1),
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Expanded(
                        child: Text(
                          DateFormat.yMMMM(
                            Localizations.localeOf(context).toLanguageTag(),
                          ).format(_month),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _moveMonth(1),
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
                _WeekdayHeader(firstWeekday: _firstWeekday),
                Expanded(
                  child: _CalendarGrid(
                    month: _month,
                    firstWeekday: _firstWeekday,
                    showHijri: _showHijri,
                    records: _records,
                    categories: categories,
                  ),
                ),
              ],
            ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader({required this.firstWeekday});

  final int firstWeekday;

  @override
  Widget build(BuildContext context) {
    final monday = DateTime(2026, 1, 5);
    final start = firstWeekday == DateTime.monday
        ? monday
        : monday.subtract(const Duration(days: 1));
    return Row(
      children: List.generate(
        7,
        (index) => Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              DateFormat.E(
                Localizations.localeOf(context).toLanguageTag(),
              ).format(start.add(Duration(days: index))),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.month,
    required this.firstWeekday,
    required this.showHijri,
    required this.records,
    required this.categories,
  });

  final DateTime month;
  final int firstWeekday;
  final bool showHijri;
  final List<ExpenseRecord> records;
  final List<CategoryRecord> categories;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month);
    final offset =
        firstWeekday == DateTime.monday ? first.weekday - 1 : first.weekday % 7;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final cells = ((offset + daysInMonth + 6) ~/ 7) * 7;
    final byDay = calculateCalendarDays(records);
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: .72,
      ),
      itemCount: cells,
      itemBuilder: (context, index) {
        final day = index - offset + 1;
        if (day < 1 || day > daysInMonth) return const SizedBox.shrink();
        final summary = byDay[DateTime(month.year, month.month, day)];
        return _CalendarDay(
          date: DateTime(month.year, month.month, day),
          summary: summary,
          showHijri: showHijri,
          categories: categories,
        );
      },
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.date,
    required this.summary,
    required this.showHijri,
    required this.categories,
  });

  final DateTime date;
  final CalendarDaySummary? summary;
  final bool showHijri;
  final List<CategoryRecord> categories;

  @override
  Widget build(BuildContext context) {
    final records = summary?.records ?? const <ExpenseRecord>[];
    final net = summary?.netMinor ?? 0;
    final categoryId = summary?.mostUsedCategoryId;
    final category =
        categories.where((item) => item.id == categoryId).firstOrNull;
    return InkWell(
      onTap: records.isEmpty
          ? null
          : () => showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                builder: (_) => _DayTransactions(date: date, records: records),
              ),
      borderRadius: BorderRadius.circular(10),
      child: Card(
        margin: const EdgeInsets.all(2),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Text('$date'.substring(8, 10).replaceFirst(RegExp(r'^0'), '')),
              if (showHijri)
                Text(
                  _hijriDay(date),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              if (records.isNotEmpty) ...[
                const SizedBox(height: 2),
                Icon(_categoryIcon(category?.systemCode), size: 15),
                const Spacer(),
                FittedBox(
                  child: Text(
                    '${net >= 0 ? '+' : ''}${(net / 100).toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: net >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String? code) => switch (code) {
        'groceries' => Icons.shopping_cart_outlined,
        'restaurants' => Icons.restaurant_outlined,
        'transportation' || 'fuel' => Icons.directions_car_outlined,
        'utilities' => Icons.bolt_outlined,
        'subscriptions' => Icons.subscriptions_outlined,
        _ => Icons.category_outlined,
      };

  String _hijriDay(DateTime date) {
    final hijri = HijriCalendar.fromDate(date);
    return '${hijri.hDay}';
  }
}

class _DayTransactions extends StatelessWidget {
  const _DayTransactions({required this.date, required this.records});

  final DateTime date;
  final List<ExpenseRecord> records;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          children: [
            Text(
              DateFormat.yMMMMd(
                Localizations.localeOf(context).toLanguageTag(),
              ).format(date),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (_, index) {
                  final record = records[index];
                  return ListTile(
                    title: Text(
                      record.merchant?.trim().isNotEmpty == true
                          ? record.merchant!
                          : record.type == 'income'
                              ? context.l10n.income
                              : context.l10n.expense,
                    ),
                    subtitle: Text(record.description ?? ''),
                    trailing: Text(
                      '${record.type == 'income' ? '+' : '-'}'
                      '${(record.amountMinor / 100).toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
}
