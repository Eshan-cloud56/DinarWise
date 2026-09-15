import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/receipts/smart/receipt_review_dialog.dart';
import 'package:dinarwise/features/receipts/smart/receipt_validator.dart';
import 'package:dinarwise/features/receipts/smart/smart_scan_disclosure.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

Widget app(Widget home, String language) => MaterialApp(
    locale: Locale(language),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home);

void main() {
  for (final language in ['en', 'ar']) {
    testWidgets(
        'Six editable review fields require valid merchant total category in $language',
        (tester) async {
      await tester.pumpWidget(app(
          Scaffold(
              body: ReceiptReviewDialog(
            receipt: const ValidatedReceipt(
                {'currency': 'AED', 'date': 'bad', 'time': '25:99'}, [], {}, 0),
            categoryLabels: const {'groceries': 'Groceries'},
            locale: language,
            ledgerCurrency: GulfCurrency.fromCode('KWD'),
          )),
          language));
      await tester.pumpAndSettle();
      Finder field(String key) => find.byKey(ValueKey('receiptReview_$key'));
      TextField input(String key) => tester.widget<TextField>(field(key));
      bool enabled() =>
          tester
              .widget<FilledButton>(
                  find.byKey(const ValueKey('receiptReview_apply')))
              .onPressed !=
          null;
      expect(find.byType(TextField), findsNWidgets(6));
      expect(enabled(), isFalse);
      expect(input('total').decoration!.prefixText, 'KWD ');
      expect(input('date').controller!.text,
          DateFormat('yyyy-MM-dd').format(DateTime.now()));
      expect(input('time').controller!.text, matches(r'^\d{2}:\d{2}$'));
      expect(input('paymentMethod').controller!.text,
          language == 'ar' ? 'تم التحويل' : 'Transferred');
      for (final key in ['merchantName', 'total', 'category']) {
        expect(input(key).decoration!.labelText, endsWith(' *'));
      }
      Future<void> edit(String key, String value) async {
        await tester.ensureVisible(field(key));
        await tester.enterText(field(key), value);
        await tester.pump();
      }

      await edit('merchantName', 'متجر');
      await edit('total', '12.50');
      expect(enabled(), isFalse);
      await edit('category', 'not-a-category');
      expect(enabled(), isFalse);
      await edit('category', 'groceries');
      expect(enabled(), isTrue);
      await edit('total', '0');
      expect(enabled(), isFalse);
      await edit('total', '-5');
      expect(enabled(), isFalse);
      await edit('total', '1.001');
      expect(enabled(), isFalse);
      await edit('total', '١٢٫٥٠');
      expect(enabled(), isTrue);
      await edit('merchantName', '   ');
      expect(enabled(), isFalse);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
      'Settings information remains available without a scan confirmation',
      (tester) async {
    await tester.pumpWidget(app(
        Builder(
            builder: (context) => Scaffold(
                  body: TextButton(
                      key: const ValueKey('info'),
                      onPressed: () => showSmartScanInformation(context),
                      child: const Text('Info')),
                )),
        'en'));
    await tester.tap(find.byKey(const ValueKey('info')));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });
}
