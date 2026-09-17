import 'package:dinarwise/app.dart';
import 'package:dinarwise/core/constants.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/core/router.dart';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
      'SMS navigation to Add Expense prefills merchant and amount without auto-saving',
      (tester) async {
    tester.view.physicalSize = const Size(412, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({
      'selected_language': 'en',
      'selected_currency': 'SAR',
      'privacy_policy_accepted': true,
      'privacy_policy_version': currentPrivacyPolicyVersion,
      'onboarding_completed': true,
      'local_profile_id': 'sms-nav-test',
      'dashboard_tutorial_completed_v1': true,
    });
    final preferences = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        databaseProvider.overrideWithValue(db),
      ],
      child: const DinarWiseApp(),
    ));
    await tester.pumpAndSettle();

    final container =
        ProviderScope.containerOf(tester.element(find.byType(DinarWiseApp)));

    container.read(routerProvider).push(
        '/capture?source=sms&amountMinor=12050&merchant=Panda');
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('expenseMerchantField')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const ValueKey('expenseMerchantField')));
    expect(find.text('Panda'), findsOneWidget);
    expect(find.text('120.50'), findsOneWidget);

    expect(find.text('Add expense'), findsWidgets);
    expect(find.text('Delete transaction'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(db.close);
  });

  testWidgets(
      'SMS navigation to Add Income opens dialog with prefilled amount',
      (tester) async {
    tester.view.physicalSize = const Size(412, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({
      'selected_language': 'en',
      'selected_currency': 'SAR',
      'privacy_policy_accepted': true,
      'privacy_policy_version': currentPrivacyPolicyVersion,
      'onboarding_completed': true,
      'local_profile_id': 'sms-nav-income-test',
      'dashboard_tutorial_completed_v1': true,
    });
    final preferences = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        databaseProvider.overrideWithValue(db),
      ],
      child: const DinarWiseApp(),
    ));
    await tester.pumpAndSettle();

    final container =
        ProviderScope.containerOf(tester.element(find.byType(DinarWiseApp)));

    container.read(routerProvider).go(
        '/?action=income&source=sms&amountMinor=250000');
    await tester.pumpAndSettle();

    expect(find.text('Add income'), findsWidgets);
    expect(find.text('2500.00'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(db.close);
  });
}
