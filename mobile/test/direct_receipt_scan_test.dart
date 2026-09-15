import 'package:dinarwise/app.dart';
import 'package:dinarwise/core/constants.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/core/router.dart';
import 'package:dinarwise/features/capture/capture_screen.dart';
import 'package:dinarwise/features/receipts/smart/receipt_scan_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_ocr_service.dart';
import 'package:dinarwise/features/receipts/smart/receipt_validator.dart';
import 'package:dinarwise/features/receipts/smart/receipt_review_dialog.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Scan extends ReceiptScanService {
  var calls = 0;
  @override
  Future<ValidatedReceipt> scan(
      String path, ReceiptScript script, Iterable<String> categories,
      {required String locale, required String currencyHint}) async {
    calls++;
    return const ValidatedReceipt(
        {'merchantName': 'Shop', 'total': '10.000', 'category': 'groceries'},
        [],
        {},
        1);
  }
}

void main() {
  for (final previousAcknowledgement in [null, false, true]) {
    testWidgets(
        'Scan reaches review directly with legacy acknowledgement $previousAcknowledgement',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'selected_language': 'en',
        'selected_currency': 'SAR',
        'privacy_policy_accepted': true,
        'privacy_policy_version': currentPrivacyPolicyVersion,
        'onboarding_completed': true,
        'local_profile_id': 'direct-scan-test',
        'dashboard_tutorial_completed_v1': true,
        if (previousAcknowledgement != null)
          'smart_scan_acknowledged_v1': previousAcknowledgement,
      });
      final preferences = await SharedPreferences.getInstance();
      final db = AppDatabase(NativeDatabase.memory());
      final scan = _Scan();
      await tester.pumpWidget(ProviderScope(overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        databaseProvider.overrideWithValue(db),
        receiptScanServiceProvider.overrideWithValue(scan),
      ], child: const DinarWiseApp()));
      await tester.pumpAndSettle();
      final container =
          ProviderScope.containerOf(tester.element(find.byType(DinarWiseApp)));
      container.read(routerProvider).push('/capture',
          extra: const CaptureLaunchArgs(
              sharedReceiptPath: 'assets/branding/stitch-logo.png'));
      await tester.pumpAndSettle();
      expect(scan.calls, 1);
      expect(find.byType(ReceiptReviewDialog), findsOneWidget);
      expect(find.textContaining('HTTPS'), findsNothing);
      expect(find.text('About Smart Scan'), findsNothing);
      expect(await db.select(db.financialTransactions).get(), isEmpty);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.runAsync(db.close);
    });
  }
}
