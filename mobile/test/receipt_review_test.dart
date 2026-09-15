import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/receipts/smart/receipt_review_dialog.dart';
import 'package:dinarwise/features/receipts/smart/receipt_validator.dart';
import 'package:dinarwise/features/receipts/smart/receipt_form_mapper.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  for (final language in ['en', 'ar']) {
    testWidgets(
        'Review edits, keyboard rebuilds, scrolling and close/reopen in $language',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      ValidatedReceipt? accepted;
      var applied = 0;
      await tester.pumpWidget(MaterialApp(
        locale: Locale(language),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
            builder: (context) => Scaffold(
                body: Center(
                    child: TextButton(
                        key: const ValueKey('open'),
                        onPressed: () async {
                          final labels = AppLocalizations.of(context);
                          accepted = await showDialog<ValidatedReceipt>(
                              context: context,
                              builder: (_) => ReceiptReviewDialog(
                                    receipt: ReceiptValidator().validate({
                                      'merchantName': 'Original shop',
                                      'total': 5179,
                                      'currency': 'SAR',
                                      'category': 'restaurants',
                                    }),
                                    locale: language,
                                    ledgerCurrency:
                                        GulfCurrency.fromCode('SAR'),
                                    categoryLabels: {
                                      'restaurants': labels.restaurants
                                    },
                                  ));
                          if (accepted != null) applied++;
                        },
                        child: const Text('Open'))))),
      ));
      Future<void> open() async {
        await tester.tap(find.byKey(const ValueKey('open')));
        await tester.pumpAndSettle();
      }

      Finder field(String key) => find.byKey(ValueKey('receiptReview_$key'));
      await open();
      final original = {
        for (final key in receiptReviewFields)
          key: tester.widget<TextField>(field(key)),
      };
      expect(
          original['total']!.controller!.text,
          NumberFormat.decimalPatternDigits(locale: language, decimalDigits: 2)
              .format(5179));
      for (final key in [
        'subtotal',
        'tax',
        'currency',
        'cardLastFour',
        'invoiceNumber',
        'lines'
      ]) {
        expect(field(key), findsNothing);
      }
      expect(original['date']!.controller!.text, isNotEmpty);
      expect(original['time']!.controller!.text, isNotEmpty);
      expect(original['paymentMethod']!.controller!.text,
          language == 'ar' ? 'تم التحويل' : 'Transferred');
      expect(original['category']!.controller!.text, isNot('restaurants'));
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      await tester.pumpAndSettle();
      final edits = {
        'merchantName': 'Edited shop',
        'total': '5179.40',
        'date': '2026-09-01',
        'time': '14:30',
        'paymentMethod': 'VISA',
        'category': 'restaurants'
      };
      for (final entry in edits.entries) {
        await tester.ensureVisible(field(entry.key));
        await tester.pumpAndSettle();
        await tester.tap(field(entry.key));
        await tester.enterText(field(entry.key), entry.value);
        await tester.pump();
        final current = tester.widget<TextField>(field(entry.key));
        expect(current.controller, same(original[entry.key]!.controller));
        expect(current.focusNode, same(original[entry.key]!.focusNode));
        expect(tester.takeException(), isNull);
      }
      await tester.tap(find.byKey(const ValueKey('receiptReview_apply')));
      // Exercise the pop future and reverse animation separately: the old
      // implementation disposed controllers before this animation finished.
      await tester.pump();
      tester.view.viewInsets = const FakeViewPadding();
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();
      expect(applied, 1);
      final patch = ReceiptFormMapper().map(accepted!,
          ledgerCurrency: 'SAR',
          systemCategories: {'restaurants': 'existing-category'});
      expect(patch.amount, '5179.40');
      expect(patch.merchant, 'Edited shop');
      expect(patch.categoryId, 'existing-category');
      expect(accepted!.fields.keys, unorderedEquals(receiptReviewFields));
      expect(accepted!.fields.containsKey('subtotal'), isFalse);
      tester.view.resetViewInsets();
      await open();
      await tester.ensureVisible(field('merchantName'));
      await tester.tap(field('merchantName'));
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(applied, 1);
      expect(tester.takeException(), isNull);
    });
  }
}
