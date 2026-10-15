import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/receipts/smart/receipt_review_dialog.dart';
import 'package:dinarwise/features/receipts/smart/receipt_validator.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Smart Receipt Currency Validation & Mismatch Protection', () {
    final validator = ReceiptValidator();

    test('ReceiptValidator validates global ISO currencies and rejects unknown codes', () {
      // Valid global currencies
      final eurReceipt = validator.validate({
        'merchantName': 'Paris Cafe',
        'total': '25.00',
        'currency': 'EUR',
      });
      expect(eurReceipt.fields['currency'], 'EUR');
      expect(eurReceipt.issues.contains(ReceiptIssue.invalidField), isFalse);

      final usdReceipt = validator.validate({
        'merchantName': 'New York Store',
        'total': '15.50',
        'currency': 'USD',
      });
      expect(usdReceipt.fields['currency'], 'USD');

      final kwdReceipt = validator.validate({
        'merchantName': 'Kuwait Mall',
        'total': '5.250',
        'currency': 'KWD',
      });
      expect(kwdReceipt.fields['currency'], 'KWD');

      // Invalid / unknown code should be stripped and flagged as invalidField
      final invalidReceipt = validator.validate({
        'merchantName': 'Test Shop',
        'total': '10.00',
        'currency': 'XYZ_UNKNOWN',
      });
      expect(invalidReceipt.fields['currency'], isNull);
      expect(invalidReceipt.issues.contains(ReceiptIssue.invalidField), isTrue);
    });

    testWidgets('Foreign currency receipt blocks Apply until resolved to base currency',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      ValidatedReceipt? result;

      await tester.pumpWidget(MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                key: const ValueKey('openReview'),
                onPressed: () async {
                  final labels = AppLocalizations.of(context);
                  result = await showDialog<ValidatedReceipt>(
                    context: context,
                    builder: (_) => ReceiptReviewDialog(
                      receipt: validator.validate({
                        'merchantName': 'Bistro de Paris',
                        'total': '30.00',
                        'currency': 'EUR',
                        'category': 'restaurants',
                      }),
                      locale: 'en',
                      ledgerCurrency: GulfCurrency.fromCode('SAR'),
                      categoryLabels: {'restaurants': labels.restaurants},
                    ),
                  );
                },
                child: const Text('Open Review'),
              ),
            ),
          ),
        ),
      ));

      await tester.tap(find.byKey(const ValueKey('openReview')));
      await tester.pumpAndSettle();

      // 1. Mismatch banner must be displayed
      expect(find.byKey(const ValueKey('receiptCurrencyMismatchBanner')), findsOneWidget);
      expect(find.textContaining('Detected on receipt: EUR'), findsOneWidget);
      expect(find.textContaining('Configured ledger currency: SAR'), findsOneWidget);
      expect(find.textContaining('Save is blocked until resolved'), findsOneWidget);

      // 2. Apply button must be disabled
      final applyButton = tester.widget<FilledButton>(find.byKey(const ValueKey('receiptReview_apply')));
      expect(applyButton.onPressed, isNull);

      // 3. Resolve button must be present
      expect(find.byKey(const ValueKey('receiptResolveMismatchButton')), findsOneWidget);

      // 4. Tap "Resolve to SAR" button
      await tester.tap(find.byKey(const ValueKey('receiptResolveMismatchButton')));
      await tester.pumpAndSettle();

      // Mismatch banner is now gone
      expect(find.byKey(const ValueKey('receiptCurrencyMismatchBanner')), findsNothing);

      // Total field was cleared for user to enter equivalent SAR amount
      final totalField = find.byKey(const ValueKey('receiptReview_total'));
      expect(tester.widget<TextField>(totalField).controller!.text, '');

      // Apply button is still disabled because total is empty
      final applyStillDisabled = tester.widget<FilledButton>(find.byKey(const ValueKey('receiptReview_apply')));
      expect(applyStillDisabled.onPressed, isNull);

      // 5. Enter equivalent amount in base currency (SAR 120.00)
      await tester.enterText(totalField, '120.00');
      await tester.pumpAndSettle();

      // Apply button should now be enabled
      final applyEnabled = tester.widget<FilledButton>(find.byKey(const ValueKey('receiptReview_apply')));
      expect(applyEnabled.onPressed, isNotNull);

      // Tap apply and verify result
      await tester.tap(find.byKey(const ValueKey('receiptReview_apply')));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.fields['merchantName'], 'Bistro de Paris');
      expect(result!.fields['total'], '120.000');
    });

    testWidgets('Matching currency receipt allows immediate Apply without mismatch banner',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      ValidatedReceipt? result;

      await tester.pumpWidget(MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                key: const ValueKey('openReview'),
                onPressed: () async {
                  final labels = AppLocalizations.of(context);
                  result = await showDialog<ValidatedReceipt>(
                    context: context,
                    builder: (_) => ReceiptReviewDialog(
                      receipt: validator.validate({
                        'merchantName': 'Riyadh Hypermarket',
                        'total': '45.00',
                        'currency': 'SAR',
                        'category': 'groceries',
                      }),
                      locale: 'en',
                      ledgerCurrency: GulfCurrency.fromCode('SAR'),
                      categoryLabels: {'groceries': labels.groceries},
                    ),
                  );
                },
                child: const Text('Open Review'),
              ),
            ),
          ),
        ),
      ));

      await tester.tap(find.byKey(const ValueKey('openReview')));
      await tester.pumpAndSettle();

      // No mismatch banner
      expect(find.byKey(const ValueKey('receiptCurrencyMismatchBanner')), findsNothing);

      // Apply button should be enabled immediately
      final applyButton = tester.widget<FilledButton>(find.byKey(const ValueKey('receiptReview_apply')));
      expect(applyButton.onPressed, isNotNull);

      await tester.tap(find.byKey(const ValueKey('receiptReview_apply')));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.fields['merchantName'], 'Riyadh Hypermarket');
    });
  });
}
