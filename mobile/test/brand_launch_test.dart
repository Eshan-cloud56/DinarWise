import 'package:dinarwise/features/onboarding/brand_launch_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final direction in TextDirection.values) {
    testWidgets(
        'Opening animation completes once, square and safe in $direction',
        (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var completions = 0;
      await tester.pumpWidget(MaterialApp(
          home: Directionality(
              textDirection: direction,
              child: MediaQuery(
                  data: const MediaQueryData(textScaler: TextScaler.linear(2)),
                  child: BrandLaunchScreen(onFinished: () => completions++)))));
      final emblem = find.byKey(const ValueKey('stitchOpeningEmblem'));
      expect(tester.getSize(emblem).width, tester.getSize(emblem).height);
      await tester.pump(const Duration(milliseconds: 1300));
      expect(completions, 0);
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(milliseconds: 1400));
      expect(completions, 1);
      await tester.pump(const Duration(seconds: 5));
      expect(completions, 1);
      expect(tester.takeException(), isNull);
    });
  }
}
