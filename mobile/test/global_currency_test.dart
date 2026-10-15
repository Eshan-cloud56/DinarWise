import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Global Currency Catalog & Precision', () {
    test('catalog contains 150+ currencies from authoritative ISO 4217 source', () {
      expect(AppCurrency.all.length, greaterThanOrEqualTo(150));
      expect(AppCurrency.isoSourceVersion, isNotEmpty);
      expect(AppCurrency.isoSourceVersion.contains('SIX'), isTrue);

      // Verify major world currencies are present
      final requiredCodes = [
        'USD', 'EUR', 'GBP', 'JPY', 'CNY', 'INR', 'PKR', 'CAD', 'AUD',
        'NZD', 'CHF', 'SGD', 'HKD', 'MYR', 'IDR', 'PHP', 'THB', 'VND',
        'TRY', 'EGP', 'ZAR', 'BRL', 'MXN', 'NGN', 'BDT',
        // GCC
        'SAR', 'AED', 'KWD', 'BHD', 'QAR', 'OMR',
      ];

      for (final code in requiredCodes) {
        final currency = AppCurrency.tryFromCode(code);
        expect(currency, isNotNull, reason: 'Expected $code to exist in catalog');
        expect(currency!.code, code);
      }
    });

    test('currencies have correct decimal precision and minor factors', () {
      // 0 decimals (factor 1)
      final zeroDecimals = ['JPY', 'KRW', 'VND', 'CLP', 'UGX', 'RWF', 'PYG'];
      for (final code in zeroDecimals) {
        final c = AppCurrency.fromCode(code);
        expect(c.decimalDigits, 0, reason: '$code should have 0 decimals');
        expect(c.minorFactor, 1, reason: '$code should have factor 1');
      }

      // 3 decimals (factor 1000)
      final threeDecimals = ['KWD', 'BHD', 'OMR', 'JOD', 'IQD', 'TND', 'LYD'];
      for (final code in threeDecimals) {
        final c = AppCurrency.fromCode(code);
        expect(c.decimalDigits, 3, reason: '$code should have 3 decimals');
        expect(c.minorFactor, 1000, reason: '$code should have factor 1000');
      }

      // 2 decimals (factor 100)
      final twoDecimals = ['USD', 'EUR', 'GBP', 'SAR', 'AED', 'PKR', 'INR', 'CAD'];
      for (final code in twoDecimals) {
        final c = AppCurrency.fromCode(code);
        expect(c.decimalDigits, 2, reason: '$code should have 2 decimals');
        expect(c.minorFactor, 100, reason: '$code should have factor 100');
      }
    });

    test('NO universal SAR parsing fallback in tryFromCode', () {
      expect(AppCurrency.tryFromCode(null), isNull);
      expect(AppCurrency.tryFromCode(''), isNull);
      expect(AppCurrency.tryFromCode('INVALID'), isNull);
      expect(AppCurrency.tryFromCode('XYZ'), isNull);
      expect(AppCurrency.tryFromCode('FAKE_CODE'), isNull);

      // Only valid ISO codes resolve
      expect(AppCurrency.tryFromCode('USD')?.code, 'USD');
      expect(AppCurrency.tryFromCode('sar')?.code, 'SAR');
      expect(AppCurrency.tryFromCode('KWD')?.code, 'KWD');
    });

    test('parseToMinor correctly parses amounts for different decimal precision', () {
      final usd = AppCurrency.fromCode('USD');
      final jpy = AppCurrency.fromCode('JPY');
      final kwd = AppCurrency.fromCode('KWD');

      // 2 decimals
      expect(usd.parseToMinor('12.50'), 1250);
      expect(usd.parseToMinor('12.5'), 1250);
      expect(usd.parseToMinor('12'), 1200);
      expect(usd.parseToMinor('0.05'), 5);

      // 0 decimals
      expect(jpy.parseToMinor('500'), 500);
      expect(jpy.parseToMinor('500.99'), 500);

      // 3 decimals
      expect(kwd.parseToMinor('1.250'), 1250);
      expect(kwd.parseToMinor('1.25'), 1250);
      expect(kwd.parseToMinor('1.2'), 1200);
      expect(kwd.parseToMinor('1'), 1000);
      expect(kwd.parseToMinor('0.005'), 5);

      // Localized Arabic numerals
      expect(usd.parseToMinor('١٢.٥٠'), 1250);
      expect(kwd.parseToMinor('١.٢٥٠'), 1250);
    });

    test('toMajor and formatAmountForInput work accurately', () {
      final usd = AppCurrency.fromCode('USD');
      final jpy = AppCurrency.fromCode('JPY');
      final kwd = AppCurrency.fromCode('KWD');

      expect(usd.toMajor(1250), 12.50);
      expect(jpy.toMajor(500), 500.0);
      expect(kwd.toMajor(1250), 1.250);

      expect(usd.formatAmountForInput(1250), '12.50');
      expect(jpy.formatAmountForInput(500), '500');
      expect(kwd.formatAmountForInput(1250), '1.250');
    });

    test('GulfCurrency backward compatibility layer maintains GCC behavior', () {
      expect(GulfCurrency.gccCurrencies.length, 6);
      final gccCodes = GulfCurrency.gccCurrencies.map((c) => c.code).toSet();
      expect(gccCodes, containsAll(['SAR', 'AED', 'KWD', 'BHD', 'QAR', 'OMR']));
      expect(GulfCurrency.all.length, greaterThanOrEqualTo(150));

      expect(GulfCurrency.byCode('SAR').code, 'SAR');
      expect(GulfCurrency.byCode('KWD').decimalDigits, 3);
      expect(GulfCurrency.fromCode('OMR').minorFactor, 1000);
      expect(GulfCurrency.tryFromCode('INVALID'), isNull);
    });
  });
}
