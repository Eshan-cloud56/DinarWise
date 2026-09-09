import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/categories/category_localization.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/payment_methods/payment_method_repository.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show NumberFormat, DateFormat;

class DinarCard extends StatelessWidget {
  const DinarCard(
      {required this.child,
      this.padding = const EdgeInsets.all(18),
      super.key});
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) =>
      Card(child: Padding(padding: padding, child: child));
}

class FinancialAmount extends ConsumerWidget {
  const FinancialAmount(this.minor,
      {this.color,
      this.size = 22,
      this.signed = false,
      this.income = false,
      this.showCurrency = true,
      super.key});
  final int minor;
  final Color? color;
  final double size;
  final bool signed, income;
  final bool showCurrency;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(selectedCurrencyProvider);
    final value = showCurrency
        ? currency
            .formatter(Localizations.localeOf(context).toLanguageTag())
            .format(currency.toMajor(minor))
        : NumberFormat.decimalPatternDigits(
                locale: Localizations.localeOf(context).toLanguageTag(),
                decimalDigits: currency.decimalDigits)
            .format(currency.toMajor(minor));
    return Text('${signed ? (income ? '+' : '−') : ''}$value',
        textDirection: TextDirection.ltr,
        style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontFamilyFallback: const ['NotoSansArabic'],
            fontSize: size,
            fontWeight: FontWeight.w700,
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()]));
  }
}

class DinarHeader extends ConsumerWidget implements PreferredSizeWidget {
  const DinarHeader(
      {required this.subtitle,
      this.settingsKey,
      this.actions = const [],
      super.key});
  final String subtitle;
  final Key? settingsKey;
  final List<Widget> actions;
  @override
  Size get preferredSize => const Size.fromHeight(76);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final currency = ref.watch(selectedCurrencyProvider);
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 76,
      titleSpacing: 16,
      title: Row(children: [
        Image.asset('assets/branding/stitch-logo.png',
            width: 34, height: 34, semanticLabel: l.appName),
        const SizedBox(width: 8),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.brandTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          Text(subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontFamily: 'Inter', fontSize: 11, color: DinarColors.muted)),
        ])),
      ]),
      actions: [
        PopupMenuButton<String>(
          tooltip: l.chooseCurrency,
          onSelected: (code) => ref
              .read(onboardingControllerProvider.notifier)
              .selectCurrency(code),
          itemBuilder: (_) => GulfCurrency.supported
              .map((c) => PopupMenuItem(
                  value: c.code,
                  child: Text(
                      '${c.code} · ${c.name(Localizations.localeOf(context).languageCode)}')))
              .toList(),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Chip(
                  label:
                      Text(currency.code, style: const TextStyle(fontSize: 12)),
                  avatar: const Icon(Icons.expand_more, size: 16))),
        ),
        ...actions,
        IconButton(
            key: settingsKey,
            tooltip: l.settings,
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined, size: 23)),
        const SizedBox(width: 6),
      ],
    );
  }
}

class DinarBottomNav extends StatelessWidget {
  const DinarBottomNav({required this.selected, this.analyticsKey, super.key});
  final int selected;
  final Key? analyticsKey;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final labels = [
      l.homeLabel,
      l.transactionsLabel,
      l.add,
      l.planningLabel,
      l.insightsLabel
    ];
    const icons = [
      Icons.home_outlined,
      Icons.receipt_long_outlined,
      Icons.add,
      Icons.track_changes,
      Icons.auto_graph
    ];
    const routes = ['/', '/history', '/capture', '/planning', '/analytics'];
    return Material(
        color: Colors.white,
        child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (i) {
                    if (i == 1) return const SizedBox.shrink();
                    return Expanded(
                        child: Semantics(
                            selected: selected == i,
                            button: true,
                            child: InkWell(
                              key: i == 4 ? analyticsKey : ValueKey('nav-$i'),
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                if (selected == i) return;
                                if (i == 0) {
                                  context.go('/');
                                } else if (i == 2 || selected == 0) {
                                  context.push(routes[i]);
                                } else {
                                  context.replace(routes[i]);
                                }
                              },
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 4),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                            padding:
                                                EdgeInsets.all(i == 2 ? 10 : 8),
                                            decoration: BoxDecoration(
                                                color: i == 2
                                                    ? DinarColors.green
                                                    : (selected == i
                                                        ? DinarColors.inset
                                                        : Colors.transparent),
                                                shape: BoxShape.circle),
                                            child: Icon(icons[i],
                                                size: i == 2 ? 26 : 22,
                                                color: i == 2
                                                    ? DinarColors.gold
                                                    : (selected == i
                                                        ? DinarColors.green
                                                        : DinarColors.muted))),
                                        const SizedBox(height: 3),
                                        Text(labels[i],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: selected == i
                                                    ? FontWeight.w700
                                                    : FontWeight.w500,
                                                color: DinarColors.green)),
                                      ])),
                            )));
                  })),
            )));
  }
}

IconData categoryIcon(String? code) => switch (code) {
      'groceries' => Icons.shopping_cart_outlined,
      'restaurants' => Icons.restaurant_outlined,
      'transport' ||
      'transportation' ||
      'fuel' =>
        Icons.directions_car_outlined,
      'utilities' => Icons.bolt_outlined,
      'rent' => Icons.home_work_outlined,
      'shopping' => Icons.shopping_bag_outlined,
      'health' || 'healthcare' => Icons.favorite_outline,
      'education' => Icons.school_outlined,
      'entertainment' => Icons.play_circle_outline,
      _ => Icons.category_outlined,
    };
String paymentLabel(BuildContext context, PaymentMethodDetails method) =>
    switch (method.systemCode) {
      'cash' => context.l10n.cash,
      'debit_card' => context.l10n.debitCard,
      'credit_card' => context.l10n.creditCard,
      'bank_transfer' => context.l10n.bankTransfer,
      'mada' => 'Mada',
      'stc_pay' => 'STC Pay',
      'google_pay' => 'Google Pay',
      'tabby' => 'Tabby',
      'tamara' => 'Tamara',
      'other' => context.l10n.other,
      _ => method.name,
    };

class DinarTransactionTile extends StatelessWidget {
  const DinarTransactionTile(
      {required this.item,
      required this.onTap,
      this.category,
      this.method,
      this.menu,
      super.key});
  final ExpenseRecord item;
  final CategoryRecord? category;
  final PaymentMethodDetails? method;
  final VoidCallback onTap;
  final Widget? menu;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final income = item.type == 'income';
    final categoryName =
        category == null ? l.other : localizedCategoryName(l, category!);
    final largeText = MediaQuery.textScalerOf(context).scale(1) > 1.4;
    final title = Text(
        item.merchant?.trim().isNotEmpty == true
            ? item.merchant!
            : (income ? l.income : l.expense),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleSmall);
    final amount = FinancialAmount(item.amountMinor,
        signed: true,
        income: income,
        size: 15,
        color: income ? DinarColors.green : DinarColors.ink);
    return Card(
        child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                      color: income ? DinarColors.mint : DinarColors.inset,
                      borderRadius: BorderRadius.circular(14)),
                  child: Icon(
                      income
                          ? Icons.account_balance_outlined
                          : categoryIcon(category?.systemCode),
                      color: DinarColors.green,
                      size: 22)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    title,
                    const SizedBox(height: 5),
                    Text(categoryName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, color: DinarColors.muted)),
                    if (largeText) amount,
                  ])),
              if (!largeText) ...[
                const SizedBox(width: 8),
                Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                      amount,
                      if (method != null)
                        Text(paymentLabel(context, method!),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontSize: 10, color: DinarColors.muted)),
                    ])),
              ],
              if (menu != null)
                SizedBox(width: 40, child: menu!)
              else
                const Icon(Icons.chevron_right, size: 16),
            ]),
            const SizedBox(height: 6),
            Wrap(spacing: 8, runSpacing: 4, children: [
              Text(
                  DateFormat.jm(Localizations.localeOf(context).toLanguageTag())
                      .format(item.transactedAt),
                  style:
                      const TextStyle(fontSize: 10, color: DinarColors.muted)),
              if (item.description?.isNotEmpty == true)
                Text(item.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 10, color: DinarColors.muted)),
              if (item.receiptAttachmentId != null)
                Text('📎 ${l.receiptAttached}',
                    style: const TextStyle(fontSize: 10)),
              if (largeText && method != null)
                Text(paymentLabel(context, method!),
                    style: const TextStyle(fontSize: 11)),
            ]),
          ])),
    ));
  }
}

Future<void> showTransferUnavailable(BuildContext context) => showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.transferLabel),
        content: Text(context.l10n.transferUnavailable),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.close))
        ],
      ),
    );
