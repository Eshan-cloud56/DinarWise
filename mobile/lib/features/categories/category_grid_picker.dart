import 'dart:math' as math;
import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/core/widgets/dinar_widgets.dart';
import 'package:dinarwise/features/categories/category_localization.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

/// Presentation only: IDs and callbacks belong to the existing expense form.
class CategoryGridPicker extends StatelessWidget {
  const CategoryGridPicker(
      {super.key,
      required this.categories,
      required this.selectedId,
      required this.onSelected,
      required this.onCustom});
  final List<CategoryRecord> categories;
  final String? selectedId;
  final ValueChanged<String> onSelected;
  final VoidCallback onCustom;

  @override
  Widget build(BuildContext context) {
    final labels = [
      for (final category in categories)
        localizedCategoryName(context.l10n, category),
      context.l10n.customCategory,
    ];
    final scaler = MediaQuery.textScalerOf(context);
    final labelStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(fontSize: 12, fontWeight: FontWeight.w700, height: 1.3);
    return LayoutBuilder(builder: (context, constraints) {
      const gap = 8.0;
      final minWidth = math.max(64.0, scaler.scale(44));
      final columns =
          ((constraints.maxWidth + gap) / (minWidth + gap)).floor().clamp(1, 4);
      final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
      // Measure all labels at the stronger selected weight. Selection cannot
      // change row geometry; custom names and Arabic are never truncated.
      var labelHeight = 0.0;
      for (final label in labels) {
        final painter = TextPainter(
            text: TextSpan(text: label, style: labelStyle),
            textDirection: Directionality.of(context),
            textScaler: scaler)
          ..layout(maxWidth: math.max(1, width - 4));
        labelHeight = math.max(labelHeight, painter.height);
        painter.dispose();
      }
      final extent = 56 + 10 + labelHeight + 12;
      // The expense form owns vertical scrolling. A nested scroll viewport can
      // trap swipes before Merchant/Save, so the grid participates in that page.
      return GridView.builder(
        key: const PageStorageKey('expenseCategoryGrid'),
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 2),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: gap,
            mainAxisSpacing: gap,
            mainAxisExtent: extent),
        itemCount: labels.length,
        itemBuilder: (context, index) {
          final customAction = index == categories.length;
          final category = customAction ? null : categories[index];
          final selected = !customAction && category!.id == selectedId;
          final onTap =
              customAction ? onCustom : () => onSelected(category!.id);
          return Semantics(
            button: true,
            selected: selected,
            label: labels[index],
            excludeSemantics: true,
            onTap: onTap,
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: ValueKey(customAction
                      ? 'categoryGrid_custom'
                      : 'categoryGrid_${category!.id}'),
                  borderRadius: BorderRadius.circular(14),
                  onTap: onTap,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 4),
                      child: Column(children: [
                        Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                                color: selected
                                    ? DinarColors.mint
                                    : DinarColors.inset,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: selected
                                        ? DinarColors.green
                                        : DinarColors.border,
                                    width: 2)),
                            child: Icon(
                                customAction
                                    ? Icons.add
                                    : categoryIcon(category!.systemCode),
                                color: selected
                                    ? DinarColors.green
                                    : DinarColors.muted,
                                size: 26)),
                        const SizedBox(height: 10),
                        Text(labels[index],
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: labelStyle.copyWith(
                                color: selected
                                    ? DinarColors.green
                                    : DinarColors.muted,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500)),
                      ])),
                )),
          );
        },
      );
    });
  }
}
