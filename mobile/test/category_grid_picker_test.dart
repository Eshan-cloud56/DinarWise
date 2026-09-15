import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/features/categories/category_grid_picker.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final language in ['en', 'ar']) {
    for (final width in [320.0, 360.0, 412.0]) {
      for (final scale in [1.0, 2.0]) {
        testWidgets(
            'Category grid $language width=$width scale=$scale preserves selection and scroll',
            (tester) async {
          tester.view.physicalSize = Size(width, 900);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          var selected = 'c0';
          var created = false;
          final categories = [
            const CategoryRecord(
                id: 'c0',
                name: 'Groceries',
                systemCode: 'groceries',
                isSystem: true),
            const CategoryRecord(
                id: 'c1',
                name: 'Restaurant',
                systemCode: 'restaurants',
                isSystem: true),
            for (var i = 2; i < 40; i++)
              CategoryRecord(
                  id: 'c$i',
                  name: i == 2 ? 'مستلزمات المنزل والعائلة' : 'Custom $i',
                  systemCode: null,
                  isSystem: false),
          ];
          await tester.pumpWidget(MaterialApp(
            theme: buildDinarWiseTheme(),
            locale: Locale(language),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: child!),
            home: StatefulBuilder(
                builder: (context, setState) => Scaffold(
                        body: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        CategoryGridPicker(
                          categories: categories,
                          selectedId: selected,
                          onSelected: (id) => setState(() => selected = id),
                          onCustom: () => created = true,
                        )
                      ],
                    ))),
          ));
          await tester.pumpAndSettle();
          final grid = find.byType(GridView);
          final delegate = tester.widget<GridView>(grid).gridDelegate
              as SliverGridDelegateWithFixedCrossAxisCount;
          expect(
              delegate.crossAxisCount, scale == 1 ? 4 : lessThanOrEqualTo(4));
          final before = tester.getSize(grid);
          await tester.tap(find.byKey(const ValueKey('categoryGrid_c1')));
          await tester.pumpAndSettle();
          expect(selected, 'c1');
          expect(tester.getSize(grid), before);
          final boxes = tester.widgetList<Container>(find.descendant(
              of: find.byKey(const ValueKey('categoryGrid_c1')),
              matching: find.byType(Container)));
          expect(
              boxes.any((box) =>
                  box.decoration is BoxDecoration &&
                  (box.decoration! as BoxDecoration).color == DinarColors.mint),
              isTrue);
          await tester.scrollUntilVisible(
              find.byKey(const ValueKey('categoryGrid_custom')), 160,
              scrollable: find
                  .descendant(
                      of: find.byType(ListView),
                      matching: find.byType(Scrollable))
                  .first);
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const ValueKey('categoryGrid_custom')));
          await tester.pumpAndSettle();
          expect(created, isTrue);
          expect(selected, 'c1');
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
