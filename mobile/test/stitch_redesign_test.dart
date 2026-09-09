import 'dart:io';
import 'dart:ui' as ui;
import 'package:dinarwise/app.dart';
import 'package:dinarwise/core/constants.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _previewKey = ValueKey('preview');
Future<AppDatabase> _start(WidgetTester tester, String language,
    {double scale = 1, double width = 390, double height = 844}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
  SharedPreferences.setMockInitialValues({
    'selected_language': language,
    'privacy_policy_accepted': true,
    'privacy_policy_version': currentPrivacyPolicyVersion,
    'privacy_policy_accepted_at': '2026-09-04T00:00:00Z',
    'onboarding_completed': true,
    'selected_currency': 'SAR',
    'local_profile_id': 'redesign-test',
    'dashboard_tutorial_completed_v1': true,
  });
  final db = AppDatabase(NativeDatabase.memory());
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(RepaintBoundary(
      key: _previewKey,
      child: ProviderScope(overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(db),
      ], child: const DinarWiseApp())));
  await tester.pumpAndSettle();
  return db;
}

Future<void> _preview(WidgetTester tester, String name) async {
  if (!const bool.fromEnvironment('UI_PREVIEWS')) return;
  final context = tester.element(find.byType(Scaffold).last);
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  await tester.runAsync(() => precacheImage(
      const AssetImage('assets/branding/stitch-logo.png'), context));
  await tester.pumpAndSettle();
  await tester.runAsync(() async {
    final boundary =
        tester.renderObject<RenderRepaintBoundary>(find.byKey(_previewKey));
    final image = await boundary.toImage(pixelRatio: 1);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    await Directory('build/ui-previews').create(recursive: true);
    await File('build/ui-previews/$name.png')
        .writeAsBytes(data!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final channel in [
      'dinarwise/shared_receipt',
      'plugins.flutter.io/quick_actions'
    ]) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(MethodChannel(channel), (_) async => null);
    }
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    for (final family in ['Inter', 'PlusJakartaSans', 'NotoSansArabic']) {
      final loader = FontLoader(family)
        ..addFont(rootBundle.load('assets/fonts/$family.ttf'));
      await loader.load();
    }
  });
  for (final language in ['en', 'ar']) {
    testWidgets(
        'Expense keypad is immediately visible on small $language phone',
        (tester) async {
      final db = await _start(tester, language, width: 360, height: 640);
      await tester.tap(find.byKey(const ValueKey('nav-2')));
      await tester.pumpAndSettle();
      final amount = find.byKey(const ValueKey('expenseAmountField'));
      expect(amount.hitTestable(), findsOneWidget);
      for (final digit in [
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '0',
        '.',
        'back'
      ]) {
        final key = find.byKey(ValueKey('keypad-$digit'));
        expect(key.hitTestable(), findsOneWidget,
            reason: '$digit requires scrolling');
        expect(tester.getRect(key).bottom, lessThanOrEqualTo(640));
        await tester.tap(key);
        await tester.pump();
      }
      expect(
          tester.widget<TextFormField>(amount).controller!.text, '1234567890');
      for (var i = 0; i < 10; i++) {
        await tester.tap(find.byKey(const ValueKey('keypad-back')));
      }
      for (final digit in ['.', '.', '5', 'back', '0']) {
        await tester.tap(find.byKey(ValueKey('keypad-$digit')));
        await tester.pump();
      }
      expect(tester.widget<TextFormField>(amount).controller!.text, '0.0');
      expect(
          tester
              .widget<TextField>(
                  find.descendant(of: amount, matching: find.byType(TextField)))
              .keyboardType,
          TextInputType.none);
      await tester.tap(
          find.widgetWithText(ActionChip, language == 'en' ? 'Income' : 'دخل'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('incomeAmountField')), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(
          ActionChip, language == 'en' ? 'Transfer' : 'تحويل'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.runAsync(db.close);
    });
    testWidgets(
        'Stitch $language saves income and expense with unchanged balance rules',
        (tester) async {
      final db = await _start(tester, language);
      final container =
          ProviderScope.containerOf(tester.element(find.byType(DinarWiseApp)));
      await tester
          .ensureVisible(find.byKey(const ValueKey('dashboardAddIncome')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('dashboardAddIncome')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const ValueKey('incomeAmountField')), '1000');
      await tester.tap(find.byKey(const ValueKey('saveIncomeButton')));
      await tester.pumpAndSettle();
      expect(
          (await container.read(financialSummaryProvider.future))
              .remainingBalanceMinor,
          100000);
      await tester.drag(find.byType(ListView).first, const Offset(0, 1500));
      await tester.pumpAndSettle();
      await _preview(tester, 'home-$language');
      await tester.tap(find.byKey(const ValueKey('nav-2')));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
          find.byKey(const ValueKey('expenseMerchantField')), 150,
          scrollable: find
              .descendant(
                  of: find.byType(ListView).first,
                  matching: find.byType(Scrollable))
              .first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('expenseMerchantField')),
          language == 'en' ? 'Local Supermarket' : 'السوق المحلي');
      await tester.scrollUntilVisible(
          find.byKey(const ValueKey('keypad-2')), -150,
          scrollable: find
              .descendant(
                  of: find.byType(ListView).first,
                  matching: find.byType(Scrollable))
              .first);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('keypad-2')));
      await tester.tap(find.byKey(const ValueKey('keypad-5')));
      await tester.ensureVisible(find.byKey(const ValueKey('keypad-0')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('keypad-0')));
      await tester.drag(find.byType(ListView).first, const Offset(0, 1800));
      await tester.pumpAndSettle();
      await _preview(tester, 'add-$language');
      await tester.scrollUntilVisible(
          find.byKey(const ValueKey('saveExpenseButton')), 300,
          scrollable: find
              .descendant(
                  of: find.byType(ListView).first,
                  matching: find.byType(Scrollable))
              .first);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('saveExpenseButton')));
      await tester.pumpAndSettle();
      expect(
          (await container.read(financialSummaryProvider.future))
              .remainingBalanceMinor,
          75000);
      await tester.tap(find.byKey(const ValueKey('nav-1')));
      await tester.pumpAndSettle();
      expect(find.text(language == 'en' ? 'Local Supermarket' : 'السوق المحلي'),
          findsOneWidget);
      await _preview(tester, 'history-$language');
      // Search remains wired to the existing repository and debounced filter.
      await tester.enterText(find.byType(TextField).first, 'no-match-merchant');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text(language == 'en' ? 'Local Supermarket' : 'السوق المحلي'),
          findsNothing);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('nav-0')), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.runAsync(db.close);
    });
    testWidgets('Stitch $language small screen large text stays usable',
        (tester) async {
      final db = await _start(tester, language, scale: 2, width: 320);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(const ValueKey('nav-2')));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView).first, const Offset(0, -1800));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('nav-1')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.runAsync(db.close);
    });
  }
}
