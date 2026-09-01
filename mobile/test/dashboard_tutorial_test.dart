import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/features/tutorial/dashboard_tutorial.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('missing tutorial targets are skipped safely', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = AppPreferences(await SharedPreferences.getInstance());
    final analytics = AnalyticsService(
      const NoopAnalyticsBackend(),
      enabled: true,
    );
    final anchors = DashboardTutorialAnchors(
      dashboardSummary: GlobalKey(),
      addIncome: GlobalKey(),
      addExpense: GlobalKey(),
      transactions: GlobalKey(),
      analytics: GlobalKey(),
      settings: GlobalKey(),
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () => showDashboardTutorial(
                context: context,
                anchors: anchors,
                preferences: preferences,
                analytics: analytics,
                replayed: false,
              ),
              child: const Text('Start'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(preferences.dashboardTutorialCompletedV1, isTrue);
  });
}
