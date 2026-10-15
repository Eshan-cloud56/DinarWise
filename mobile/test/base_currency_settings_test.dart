import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/features/settings/settings_screen.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Base Currency Settings & Ledger Integrity Tests', () {
    late AppDatabase database;
    late SharedPreferences sharedPreferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'privacy_policy_accepted': true,
        'privacy_policy_version': '1.3',
        'intro_slides_completed': true,
        'onboarding_completed': true,
        'selected_language': 'en',
        'selected_currency': 'PKR',
        'local_profile_id': 'test_profile',
      });
      sharedPreferences = await SharedPreferences.getInstance();
      database = AppDatabase(NativeDatabase.memory());

      // Ensure initial preferences exist
      await database.into(database.financialPreferences).insert(
            FinancialPreferencesCompanion.insert(
              profileId: 'test_profile',
              currency: const Value('PKR'),
            ),
          );
    });

    tearDown(() async {
      await database.close();
    });

    Widget createSettingsApp() {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          databaseProvider.overrideWithValue(database),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsScreen(),
        ),
      );
    }

    testWidgets('Allows changing base currency when NO financial transactions exist',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createSettingsApp());
      await tester.pumpAndSettle();

      // Verify currency tile displays PKR
      expect(find.byKey(const ValueKey('settingsCurrencyTile')), findsOneWidget);
      expect(find.textContaining('PKR'), findsWidgets);

      // Tap currency tile -> opens bottom sheet
      await tester.tap(find.byKey(const ValueKey('settingsCurrencyTile')));
      await tester.pumpAndSettle();

      // Search for USD in the searchable bottom sheet
      expect(find.byKey(const ValueKey('settingsCurrencySearchField')), findsOneWidget);
      await tester.enterText(find.byKey(const ValueKey('settingsCurrencySearchField')), 'USD');
      await tester.pumpAndSettle();

      // Tap USD currency item
      final usdTile = find.byKey(const ValueKey('currency_item_USD'));
      expect(usdTile, findsOneWidget);
      await tester.tap(usdTile);
      await tester.pumpAndSettle();

      // Verify currency was changed to USD in database and preferences
      final pref = await (database.select(database.financialPreferences)
            ..where((tbl) => tbl.profileId.equals('test_profile')))
          .getSingle();
      expect(pref.currency, 'USD');
      expect(sharedPreferences.getString('selected_currency'), 'USD');
    });

    testWidgets(
        'PREVENTS silent base-currency switching when financial transactions exist (e.g. 50,000 PKR)',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Insert existing financial transaction: 50,000 PKR (5,000,000 minor units)
      await database.into(database.financialTransactions).insert(
            FinancialTransactionsCompanion.insert(
              id: 'tx_pkr_1',
              profileId: 'test_profile',
              categoryId: 'groceries',
              currency: const Value('PKR'),
              amountMinor: 5000000, // 50,000.00 PKR
              transactedAt: DateTime.now(),
            ),
          );

      await tester.pumpWidget(createSettingsApp());
      await tester.pumpAndSettle();

      // Tap currency tile to attempt change
      await tester.tap(find.byKey(const ValueKey('settingsCurrencyTile')));
      await tester.pumpAndSettle();

      // Bottom sheet must NOT open; explanatory blocking dialog MUST open
      expect(find.byKey(const ValueKey('settingsCurrencySearchField')), findsNothing);
      expect(find.text('Cannot Change Base Currency'), findsOneWidget);
      expect(
        find.textContaining('Existing transactions and financial records use your current base currency (PKR)'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Changing the base currency while records exist would silently relabel and corrupt historical amounts'),
        findsOneWidget,
      );

      // Actions must be Keep PKR and Reset Data & Start Fresh
      expect(find.text('Keep PKR'), findsOneWidget);
      expect(find.text('Reset Data & Start Fresh'), findsOneWidget);

      // Tap "Keep PKR"
      await tester.tap(find.text('Keep PKR'));
      await tester.pumpAndSettle();

      // Dialog is dismissed
      expect(find.text('Cannot Change Base Currency'), findsNothing);

      // Verify the transaction was NEVER relabeled or modified
      final tx = await (database.select(database.financialTransactions)
            ..where((tbl) => tbl.id.equals('tx_pkr_1')))
          .getSingle();
      expect(tx.currency, 'PKR');
      expect(tx.amountMinor, 5000000);

      // Database preference is still PKR
      final pref = await (database.select(database.financialPreferences)
            ..where((tbl) => tbl.profileId.equals('test_profile')))
          .getSingle();
      expect(pref.currency, 'PKR');
    });
  });
}
