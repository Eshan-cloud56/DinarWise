import 'package:dinarwise/core/widgets/dinar_form.dart';
import 'package:dinarwise/core/widgets/dinar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Planning sheet top stays fixed when keyboard opens',
      (tester) async {
    Future<void> show(double inset) => tester.pumpWidget(MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
                size: const Size(400, 800),
                viewInsets: EdgeInsets.only(bottom: inset)),
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                  child: DinarFormSheet(children: [
                Text('Header'),
                TextField(),
                TextField(),
                Text('Date'),
              ])),
            ),
          ),
        ));
    await show(0);
    final top = tester.getTopLeft(find.text('Header'));
    await show(280);
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('Header')), top);
    expect(tester.takeException(), isNull);
  });

  for (final direction in TextDirection.values) {
    testWidgets('Long financial values fit in $direction', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Directionality(
        textDirection: direction,
        child: const Center(
            child: SizedBox(
                width: 100,
                child: ResponsiveFinancialText('KWD 999,999,999,999.999',
                    style: TextStyle(fontSize: 32)))),
      )));
      expect(
          tester.getSize(find.byType(FittedBox)).width, lessThanOrEqualTo(100));
      expect(tester.takeException(), isNull);
    });
  }
}
