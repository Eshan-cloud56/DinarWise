import 'package:dinarwise/features/categories/category_localization.dart';
import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/performance/performance_service.dart';
import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/core/widgets/dinar_widgets.dart';
import 'package:dinarwise/features/analytics/analytics_calculator.dart';
import 'package:dinarwise/features/payment_methods/payment_method_providers.dart';
import 'package:dinarwise/features/planning/data/advanced_planning_repository.dart';
import 'package:dinarwise/features/planning/planning_hub_screen.dart';
import 'package:intl/intl.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/capture/offline_ai_notice.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/expenses/income_actions.dart';
import 'package:dinarwise/features/planning/data/planning_providers.dart';
import 'package:dinarwise/features/tutorial/dashboard_tutorial.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({
    this.openIncome = false,
    super.key,
  });

  final bool openIncome;

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _summaryLogged = false;
  String _breakdownPeriod = 'monthly';
  bool _tutorialScheduled = false;
  final _summaryKey = GlobalKey();
  final _addIncomeKey = GlobalKey();
  final _addExpenseKey = GlobalKey();
  final _transactionsKey = GlobalKey();
  final _analyticsKey = GlobalKey();
  final _settingsKey = GlobalKey();

  DashboardTutorialAnchors get _tutorialAnchors => DashboardTutorialAnchors(
        dashboardSummary: _summaryKey,
        addIncome: _addIncomeKey,
        addExpense: _addExpenseKey,
        transactions: _transactionsKey,
        analytics: _analyticsKey,
        settings: _settingsKey,
      );

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(performanceServiceProvider).trace(
        PerformanceTraces.dashboardLoad,
        () async {
          await ref.read(financialSummaryProvider.future);
          await ref.read(recentTransactionsProvider.future);
        },
      ),
    );
    if (widget.openIncome) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) manageIncome(context, ref);
      });
    }
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showTutorialIfNeeded());
  }

  Future<void> _showTutorialIfNeeded() async {
    if (!mounted || _tutorialScheduled || widget.openIncome) return;
    final preferences = ref.read(appPreferencesProvider);
    final replayRequest = ref.read(tutorialReplayRequestProvider);
    final replayed = replayRequest > 0;
    if (!replayed && preferences.dashboardTutorialCompletedV1) {
      return;
    }
    if (replayed) {
      ref.read(tutorialReplayRequestProvider.notifier).state = 0;
    }
    _tutorialScheduled = true;
    await showDashboardTutorial(
      context: context,
      anchors: _tutorialAnchors,
      preferences: preferences,
      analytics: ref.read(analyticsServiceProvider),
      replayed: replayed,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(tutorialReplayRequestProvider, (previous, next) {
      if (next > 0 && next != previous) {
        _tutorialScheduled = false;
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _showTutorialIfNeeded());
      }
    });
    final analytics = ref.read(analyticsServiceProvider);
    analytics.screen('dashboard');
    final l = context.l10n;
    final expenses = ref.watch(recentTransactionsProvider);
    final summary = ref.watch(financialSummaryProvider).valueOrNull ??
        const FinancialSummary(totalIncomeMinor: 0, totalExpensesMinor: 0);
    final categories = ref.watch(categoriesProvider).valueOrNull ?? [];
    final methods = ref.watch(paymentMethodsProvider).valueOrNull ?? [];
    final safe = ref.watch(safeToSpendProvider).valueOrNull;
    final bnpl = ref.watch(bnplDetailsProvider).valueOrNull ?? [];
    final recurring = ref.watch(recurringDetailsProvider).valueOrNull ?? [];
    final goals = ref.watch(_dashboardGoalsProvider).valueOrNull ?? [];
    final records = ref.watch(expensesProvider).valueOrNull ?? [];
    final now = DateTime.now();
    final report = const AnalyticsCalculator().calculate(records,
        from: DateTime(now.year, now.month),
        to: DateTime(now.year, now.month + 1, 0));
    final breakdownReport = const AnalyticsCalculator().calculate(records,
        from: switch (_breakdownPeriod) {
          'weekly' => DateTime(now.year, now.month, now.day)
              .subtract(Duration(days: now.weekday - 1)),
          'yearly' => DateTime(now.year),
          _ => DateTime(now.year, now.month),
        },
        to: now);
    final breakdown = breakdownReport.categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final categoryById = {for (final c in categories) c.id: c};
    final methodById = {for (final m in methods) m.id: m};
    if (!_summaryLogged && ref.watch(financialSummaryProvider).hasValue) {
      _summaryLogged = true;
      analytics.dashboardSummaryViewed();
    }
    return Scaffold(
      appBar: DinarHeader(
          subtitle: l.homeLabel,
          settingsKey: _settingsKey,
          actions: [
            IconButton(
                tooltip: l.nextBill,
                onPressed: () => context.push('/planning/recurring'),
                icon: const Icon(Icons.notifications_none, size: 22)),
          ]),
      bottomNavigationBar:
          DinarBottomNav(selected: 0, analyticsKey: _analyticsKey),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(recentTransactionsProvider),
        child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(l.dashboardWelcome,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text(
                    DateFormat.yMMMMEEEEd(
                            Localizations.localeOf(context).toLanguageTag())
                        .format(now),
                    style: const TextStyle(
                        fontSize: 12, color: DinarColors.muted)),
                const SizedBox(height: 18),
                Container(
                  key: _summaryKey,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [DinarColors.green, DinarColors.forest]),
                    border: Border.all(color: DinarColors.gold.withAlpha(70)),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.circle,
                              color: DinarColors.gold, size: 7),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(l.availableToSpend,
                                  style: const TextStyle(
                                      color: DinarColors.mint,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)))
                        ]),
                        const SizedBox(height: 20),
                        FinancialAmount(summary.remainingBalanceMinor,
                            color: Colors.white, size: 32),
                        const SizedBox(height: 6),
                        Text(l.localRecordsLabel,
                            style: const TextStyle(
                                color: DinarColors.mint, fontSize: 11)),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white.withAlpha(18),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(children: [
                            Row(children: [
                              Expanded(
                                  child: Text(l.monthPace,
                                      style: const TextStyle(
                                          color: DinarColors.mint,
                                          fontSize: 11))),
                              Text(
                                  '${now.day} / ${DateTime(now.year, now.month + 1, 0).day}',
                                  style: const TextStyle(
                                      color: DinarColors.gold, fontSize: 11))
                            ]),
                            const SizedBox(height: 8),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                    value: now.day /
                                        DateTime(now.year, now.month + 1, 0)
                                            .day,
                                    color: DinarColors.gold,
                                    backgroundColor: Colors.white12,
                                    minHeight: 6)),
                          ]),
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(builder: (context, constraints) {
                          final metrics = [
                            _BannerMetric(
                                icon: Icons.south_west,
                                label: l.totalIncome,
                                amount: summary.totalIncomeMinor),
                            _BannerMetric(
                                icon: Icons.north_east,
                                label: l.totalExpenses,
                                amount: summary.totalExpensesMinor),
                            _BannerMetric(
                                icon: Icons.savings_outlined,
                                label: l.savedInGoals,
                                amount: goals.fold<int>(
                                    0, (sum, goal) => sum + goal.currentMinor),
                                gold: true),
                          ];
                          if (MediaQuery.textScalerOf(context).scale(1) > 1.4) {
                            return Column(
                                children: metrics
                                    .map((m) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: m))
                                    .toList());
                          }
                          return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var i = 0; i < metrics.length; i++) ...[
                                  if (i > 0) const SizedBox(width: 8),
                                  Expanded(child: metrics[i])
                                ]
                              ]);
                        }),
                      ]),
                ),
                const SizedBox(height: 14),
                if (safe != null)
                  DinarCard(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(children: [
                          Expanded(
                              child: Text(l.safeToSpendToday,
                                  style:
                                      Theme.of(context).textTheme.titleSmall)),
                          const Icon(Icons.shield_outlined,
                              color: DinarColors.green)
                        ]),
                        const SizedBox(height: 10),
                        Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            children: [
                              FinancialAmount(safe.dailyMinor, size: 26),
                              Text(l.perDay,
                                  style: const TextStyle(
                                      color: DinarColors.muted, fontSize: 12))
                            ]),
                        const SizedBox(height: 10),
                        Text(l.daysUntilPayday(safe.daysUntilPayday),
                            style: const TextStyle(
                                color: DinarColors.muted, fontSize: 12)),
                        TextButton(
                            onPressed: () => context.push('/planning/budgets'),
                            child: Text(l.safeToSpend)),
                      ])),
                const SizedBox(height: 20),
                Text(l.quickServices,
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 10),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                      child: _QuickAction(
                          key: _addExpenseKey,
                          icon: Icons.remove,
                          label: l.expense,
                          tint: const Color(0xFFFDE9E6),
                          onTap: () => context.push('/capture'))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: KeyedSubtree(
                          key: _addIncomeKey,
                          child: _QuickAction(
                              key: const ValueKey('dashboardAddIncome'),
                              icon: Icons.south,
                              label: l.addIncome,
                              tint: DinarColors.mint,
                              onTap: () => manageIncome(context, ref)))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: _QuickAction(
                          icon: Icons.document_scanner_outlined,
                          label: l.scanBill,
                          onTap: () => context.push('/capture'))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: _QuickAction(
                          icon: Icons.sync_alt,
                          label: l.transferLabel,
                          onTap: () => showTransferUnavailable(context))),
                ]),
                const SizedBox(height: 22),
                Row(children: [
                  Expanded(
                      child: Text(l.smartInsights,
                          style: Theme.of(context).textTheme.titleMedium)),
                  IconButton(
                      tooltip: l.aiFeature,
                      onPressed: () => showOfflineAiNotice(context, ref),
                      icon: const Icon(Icons.auto_awesome_outlined, size: 20))
                ]),
                DinarCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(l.thisMonthLabel,
                          style: const TextStyle(
                              color: DinarColors.muted, fontSize: 12)),
                      const SizedBox(height: 8),
                      Text(l.averageDailySpending,
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 5),
                      FinancialAmount(report.averageDailyExpenseMinor),
                      TextButton(
                          onPressed: () => context.push('/analytics'),
                          child: Text(l.analytics)),
                    ])),
                if (recurring.any((r) => r.nextOccurrence != null)) ...[
                  const SizedBox(height: 10),
                  DinarCard(
                      child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.bolt_outlined),
                          title: Text(l.nextBill),
                          subtitle: Text(recurring
                              .firstWhere((r) => r.nextOccurrence != null)
                              .name),
                          onTap: () => context.push('/planning/recurring'))),
                ],
                if (bnpl.any((r) => r.nextInstalment != null)) ...[
                  const SizedBox(height: 10),
                  DinarCard(
                      child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.calendar_month_outlined),
                          title: Text(l.nextBnplPayment),
                          subtitle: Text(bnpl
                              .firstWhere((r) => r.nextInstalment != null)
                              .merchant),
                          onTap: () => context.push('/planning/bnpl'))),
                ],
                const SizedBox(height: 18),
                DinarCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(l.spendingBreakdown,
                          style: Theme.of(context).textTheme.titleMedium),
                      Wrap(spacing: 6, children: [
                        for (final period in [
                          ('weekly', l.weekly),
                          ('monthly', l.monthly),
                          ('yearly', l.yearly)
                        ])
                          ChoiceChip(
                              label: Text(period.$2,
                                  style: const TextStyle(fontSize: 11)),
                              selected: _breakdownPeriod == period.$1,
                              onSelected: (_) =>
                                  setState(() => _breakdownPeriod = period.$1)),
                      ]),
                      const SizedBox(height: 4),
                      const SizedBox(height: 10),
                      FinancialAmount(breakdownReport.totalExpenseMinor),
                      const SizedBox(height: 14),
                      if (breakdown.isEmpty)
                        Text(l.noTransactions)
                      else ...[
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Row(children: [
                              for (var i = 0; i < breakdown.length; i++)
                                Expanded(
                                    flex: breakdown[i].value,
                                    child: Container(
                                        height: 10,
                                        color: _chartColors[
                                            i % _chartColors.length]))
                            ])),
                        const SizedBox(height: 10),
                        for (var i = 0; i < breakdown.length; i++)
                          InkWell(
                            onTap: () => context.push(
                                '/history?category=${Uri.encodeComponent(breakdown[i].key)}'),
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(children: [
                                  Icon(Icons.circle,
                                      size: 9,
                                      color: _chartColors[
                                          i % _chartColors.length]),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                          categoryById[breakdown[i].key] == null
                                              ? l.other
                                              : localizedCategoryName(
                                                  l,
                                                  categoryById[
                                                      breakdown[i].key]!),
                                          style:
                                              const TextStyle(fontSize: 12))),
                                  Text(
                                      '${(breakdown[i].value * 100 / breakdownReport.totalExpenseMinor).round()}%',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ])),
                          ),
                      ],
                    ])),
                const SizedBox(height: 18),
                Row(key: _transactionsKey, children: [
                  Expanded(
                      child: Text(l.recentActivity,
                          style: Theme.of(context).textTheme.titleMedium)),
                  TextButton(
                      onPressed: () => context.push('/history'),
                      child: Text(l.viewAll))
                ]),
                expenses.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => DinarCard(
                      child: Column(children: [
                    Text(l.unknownError),
                    TextButton(
                        onPressed: () =>
                            ref.invalidate(recentTransactionsProvider),
                        child: Text(l.tryAgain))
                  ])),
                  data: (items) => items.isEmpty
                      ? DinarCard(
                          child: Column(children: [
                          const Icon(Icons.receipt_long_outlined, size: 40),
                          const SizedBox(height: 12),
                          Text(l.noTransactions),
                          Text(l.noTransactionsDescription,
                              textAlign: TextAlign.center),
                        ]))
                      : Column(
                          children: items
                              .map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: DinarTransactionTile(
                                        item: item,
                                        category: categoryById[item.categoryId],
                                        method:
                                            methodById[item.paymentMethodId],
                                        onTap: () => item.type == 'income'
                                            ? manageIncome(context, ref,
                                                income: item)
                                            : context.push('/capture',
                                                extra: item)),
                                  ))
                              .toList()),
                ),
                const SizedBox(height: 18),
                Text(l.financialPlanning,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                const PlanningLinks(),
              ])
            ]),
      ),
    );
  }
}

const _chartColors = [
  DinarColors.green,
  DinarColors.gold,
  DinarColors.muted,
  Color(0xFF98D2BE),
  Color(0xFFBFC9C3)
];
final _dashboardGoalsProvider =
    StreamProvider.autoDispose<List<GoalDetails>>((ref) async* {
  final state = await ref.watch(onboardingControllerProvider.future);
  yield* ref
      .watch(advancedPlanningRepositoryProvider)
      .watchGoals(state.localProfileId);
});

class _BannerMetric extends StatelessWidget {
  const _BannerMetric(
      {required this.icon,
      required this.label,
      required this.amount,
      this.gold = false});
  final IconData icon;
  final String label;
  final int amount;
  final bool gold;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
            color: Colors.white.withAlpha(12),
            borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon,
              size: 15, color: gold ? DinarColors.gold : DinarColors.mint),
          const SizedBox(height: 5),
          Text(label,
              style: const TextStyle(color: DinarColors.mint, fontSize: 10)),
          const SizedBox(height: 6),
          FinancialAmount(amount,
              showCurrency: false,
              size: 13,
              color: gold ? DinarColors.gold : Colors.white),
        ]),
      );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.tint = DinarColors.inset,
      super.key});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color tint;
  @override
  Widget build(BuildContext context) => Card(
          child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            child: Column(children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: tint, borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, size: 22, color: DinarColors.green)),
              const SizedBox(height: 8),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600)),
            ])),
      ));
}
