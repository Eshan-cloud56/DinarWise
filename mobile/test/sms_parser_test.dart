import 'package:flutter_test/flutter_test.dart';
import 'package:dinarwise/features/sms_detection/sms_parser.dart';
import 'package:dinarwise/features/sms_detection/sms_transaction.dart';

void main() {
  const parser = SmsParser(defaultCurrency: 'SAR');

  group('SmsParser - Outgoing Expenses', () {
    test('parses Al Rajhi Arabic mada card purchase', () {
      const sms =
          'شراء بواسطة بطاقة مدى *1234 بمبلغ 120.50 ر.س لدى بندة في 2026/09/15';
      final result = parser.parse(sender: 'AlRajhiBank', body: sms);

      expect(result, isNotNull);
      expect(result!.type, equals(SmsTransactionType.expense));
      expect(result.amountMinor, equals(12050));
      expect(result.currency, equals('SAR'));
      expect(result.merchantOrSender, contains('بندة'));
      expect(result.bankOrAccount, equals('Al Rajhi Bank'));
      expect(result.isHighConfidence, isTrue);
    });

    test('parses Al Rajhi English purchase', () {
      const sms =
          'Purchase with mada card *4321 for SAR 85.00 at Starbucks on 15/09/2026';
      final result = parser.parse(sender: 'AlRajhiBank', body: sms);

      expect(result, isNotNull);
      expect(result!.type, equals(SmsTransactionType.expense));
      expect(result.amountMinor, equals(8500));
      expect(result.currency, equals('SAR'));
      expect(result.merchantOrSender, contains('Starbucks'));
      expect(result.bankOrAccount, equals('Al Rajhi Bank'));
      expect(result.isHighConfidence, isTrue);
    });

    test('parses SNB credit card purchase', () {
      const sms =
          'تمت عملية شراء بواسطة بطاقة الأهلي الائتمانية بمبلغ 340.00 ر.س لدى JARIR BOOKSTORE';
      final result = parser.parse(sender: 'SNB', body: sms);

      expect(result, isNotNull);
      expect(result!.type, equals(SmsTransactionType.expense));
      expect(result.amountMinor, equals(34000));
      expect(result.currency, equals('SAR'));
      expect(result.merchantOrSender, contains('JARIR BOOKSTORE'));
      expect(result.bankOrAccount, equals('SNB'));
      expect(result.isHighConfidence, isTrue);
    });

    test('parses STC Pay payment', () {
      const sms = 'تم دفع 45.00 ر.س لدى هنقرستيشن بواسطة STC Pay';
      final result = parser.parse(sender: 'STCPay', body: sms);

      expect(result, isNotNull);
      expect(result!.type, equals(SmsTransactionType.expense));
      expect(result.amountMinor, equals(4500));
      expect(result.merchantOrSender, contains('هنقرستيشن'));
      expect(result.bankOrAccount, equals('STC Pay'));
      expect(result.isHighConfidence, isTrue);
    });

    test('parses Arabic-Indic numerals correctly', () {
      const sms = 'شراء بمبلغ ١٢٠٫٥٠ ر.س لدى العثيم';
      final result = parser.parse(sender: 'Bank', body: sms);

      expect(result, isNotNull);
      expect(result!.amountMinor, equals(12050));
      expect(result.merchantOrSender, contains('العثيم'));
    });
  });

  group('SmsParser - Incoming Income', () {
    test('parses incoming salary deposit', () {
      const sms =
          'إيداع راتب بمبلغ 12500.00 ر.س في حسابك لدى مصرف الراجحي';
      final result = parser.parse(sender: 'AlRajhiBank', body: sms);

      expect(result, isNotNull);
      expect(result!.type, equals(SmsTransactionType.income));
      expect(result.amountMinor, equals(1250000));
      expect(result.currency, equals('SAR'));
      expect(result.bankOrAccount, equals('Al Rajhi Bank'));
      expect(result.isHighConfidence, isTrue);
    });

    test('parses English credited message', () {
      const sms =
          'SAR 2,500.00 was credited to your Alinma Bank account from Fahad';
      final result = parser.parse(sender: 'Alinma', body: sms);

      expect(result, isNotNull);
      expect(result!.type, equals(SmsTransactionType.income));
      expect(result.amountMinor, equals(250000));
      expect(result.currency, equals('SAR'));
      expect(result.bankOrAccount, equals('Alinma Bank'));
      expect(result.merchantOrSender, contains('Fahad'));
      expect(result.isHighConfidence, isTrue);
    });

    test('parses incoming transfer deposit', () {
      const sms =
          'حوالة واردة من شركة النور بمبلغ 5000.00 ر.س إلى حسابكم لدى البنك الأهلي';
      final result = parser.parse(sender: 'SNB', body: sms);

      expect(result, isNotNull);
      expect(result!.type, equals(SmsTransactionType.income));
      expect(result.amountMinor, equals(500000));
      expect(result.bankOrAccount, equals('SNB'));
      expect(result.merchantOrSender, contains('شركة النور'));
      expect(result.isHighConfidence, isTrue);
    });
  });

  group('SmsParser - Filters & Security', () {
    test('strictly rejects OTP verification code', () {
      const sms =
          'رمز التحقق لمرة واحدة هو 582910 لإتمام عملية الشراء. لا تشارك هذا الرمز مع أحد.';
      final result = parser.parse(sender: 'AlRajhiBank', body: sms);
      expect(result, isNull);
    });

    test('strictly rejects English OTP message', () {
      const sms =
          'OTP: 192837 is your verification code for online banking. Do not share.';
      final result = parser.parse(sender: 'SNB', body: sms);
      expect(result, isNull);
    });

    test('rejects non-financial message', () {
      const sms = 'عزيزي العميل، نود تذكيرك بتحديث بيانات الهوية الوطنية عبر التطبيق.';
      final result = parser.parse(sender: 'AlRajhiBank', body: sms);
      expect(result, isNull);
    });

    test('rejects empty or zero amount', () {
      const sms = 'تمت عملية بنجاح بقيمة 0.00 ر.س';
      final result = parser.parse(sender: 'Bank', body: sms);
      expect(result, isNull);
    });
  });
}
