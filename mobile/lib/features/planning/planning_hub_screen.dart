import 'package:dinarwise/core/widgets/dinar_widgets.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlanningHubScreen extends StatelessWidget {
  const PlanningHubScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: DinarHeader(subtitle: context.l10n.financialPlanning),
        bottomNavigationBar: const DinarBottomNav(selected: 3),
        body: const SafeArea(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(20), child: PlanningLinks())),
      );
}

class PlanningLinks extends StatelessWidget {
  const PlanningLinks({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final links = [
      (Icons.pie_chart_outline, l.budgets, '/planning/budgets'),
      (Icons.savings_outlined, l.savingsGoals, '/planning/goals'),
      (Icons.calendar_month_outlined, l.bnplPlans, '/planning/bnpl'),
      (
        Icons.receipt_long_outlined,
        l.billsAndSubscriptions,
        '/planning/recurring'
      ),
      (Icons.calculate_outlined, l.offlineCalculators, '/calculators'),
    ];
    return Card(
        child: Column(children: [
      for (var i = 0; i < links.length; i++) ...[
        if (i > 0) const Divider(height: 1),
        ListTile(
            leading: Icon(links[i].$1),
            title: Text(links[i].$2),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(links[i].$3)),
      ],
    ]));
  }
}
