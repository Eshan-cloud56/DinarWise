import 'package:dinarwise/features/capture/capture_screen.dart';
import 'package:dinarwise/features/voice_expense/domain/currency_voice_resolver.dart';
import 'package:dinarwise/features/voice_expense/domain/voice_expense_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Voice Expense Currency Mismatch & Single-Currency Ledger Integrity', () {
    const resolver = CurrencyVoiceResolver();

    test('detects foreign EUR when base currency is SAR and flags mismatch', () {
      final result = resolver.resolve(
        transcriptLower: 'spent 30 euros on lunch',
        baseCurrencyCode: 'SAR',
      );

      expect(result.currencyCode, 'EUR');
      expect(result.isMismatch, isTrue);
      expect(result.isAmbiguous, isFalse);

      final draft = VoiceExpenseParser.parse(
        transcript: 'spent 30 euros on lunch',
        categories: const [],
        defaultCurrencyCode: 'SAR',
      );
      expect(draft.currency, isNull);
      expect(draft.isCurrencyMismatch, isTrue);
      expect(draft.detectedCurrency, 'EUR');
      expect(draft.amountMinor, 3000);
    });

    test('compatible dollar detection: Base CAD + "dollars" resolves to CAD without mismatch', () {
      final result = resolver.resolve(
        transcriptLower: 'spent 20 dollars on coffee',
        baseCurrencyCode: 'CAD',
      );

      expect(result.currencyCode, 'CAD');
      expect(result.isMismatch, isFalse);
      expect(result.isAmbiguous, isFalse);

      final draft = VoiceExpenseParser.parse(
        transcript: 'spent 20 dollars on coffee',
        categories: const [],
        defaultCurrencyCode: 'CAD',
      );
      expect(draft.isCurrencyMismatch, isFalse);
      expect(draft.currency, 'CAD');
      expect(draft.detectedCurrency, 'CAD');
    });

    test('ambiguous dollar detection: Base PKR + "dollars" flags mismatch against base currency', () {
      final result = resolver.resolve(
        transcriptLower: 'spent 50 dollars on groceries',
        baseCurrencyCode: 'PKR',
      );

      expect(result.isMismatch, isTrue);
      expect(result.isAmbiguous, isTrue);
      expect(result.currencyCode, isNull);
      expect(result.rawSpokenCurrency, 'dollars');

      final draft = VoiceExpenseParser.parse(
        transcript: 'spent 50 dollars on groceries',
        categories: const [],
        defaultCurrencyCode: 'PKR',
      );
      expect(draft.isCurrencyMismatch, isTrue);
      expect(draft.isCurrencyAmbiguous, isTrue);
      expect(draft.rawSpokenCurrency, 'dollars');
    });

    test('unspecified currency defaults safely to base currency without mismatch', () {
      final result = resolver.resolve(
        transcriptLower: 'bought coffee for 15',
        baseCurrencyCode: 'SAR',
      );

      expect(result.currencyCode, 'SAR');
      expect(result.isMismatch, isFalse);

      final draft = VoiceExpenseParser.parse(
        transcript: 'bought coffee for 15',
        categories: const [],
        defaultCurrencyCode: 'SAR',
      );
      expect(draft.isCurrencyMismatch, isFalse);
      expect(draft.currency, 'SAR');
    });

    test('CaptureLaunchArgs correctly conveys mismatch flags to review screen', () {
      const args = CaptureLaunchArgs(
        prefilledAmountMinor: 3000,
        prefilledCurrency: 'EUR',
        isCurrencyMismatch: true,
        detectedCurrency: 'EUR',
      );

      expect(args.isCurrencyMismatch, isTrue);
      expect(args.detectedCurrency, 'EUR');
      expect(args.prefilledCurrency, 'EUR');
      expect(args.prefilledAmountMinor, 3000);
    });
  });
}
