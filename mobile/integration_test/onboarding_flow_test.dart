import 'package:drift/native.dart';
import 'package:dinarwise/app.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('fresh install completes consent and reaches dashboard',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          databaseProvider.overrideWithValue(database),
        ],
        child: const DinarWiseApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Choose your language'), findsOneWidget);
    expect(find.text('Sign in'), findsNothing);
    await tester.tap(find.text('English').first);
    await tester.pumpAndSettle();

    expect(find.text('Welcome to DinarWise'), findsOneWidget);
    final getStarted = find.widgetWithText(FilledButton, 'Get Started');
    expect(tester.widget<FilledButton>(getStarted).onPressed, isNull);
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(tester.widget<FilledButton>(getStarted).onPressed, isNotNull);
    await tester.tap(getStarted);
    await tester.pumpAndSettle();

    expect(find.text('Recent transactions'), findsOneWidget);
    expect(preferences.getBool('privacy_policy_accepted'), isTrue);
    expect(preferences.getBool('onboarding_completed'), isTrue);
  });
}
