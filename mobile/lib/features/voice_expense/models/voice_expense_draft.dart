import 'package:dinarwise/features/capture/capture_screen.dart';

class VoiceExpenseDraft {
  const VoiceExpenseDraft({
    required this.rawTranscript,
    this.amountMinor,
    this.currency,
    this.merchant,
    this.description,
    this.categoryId,
    this.categoryName,
    this.categorySystemCode,
    this.paymentMethodId,
    this.paymentMethodName,
    this.paymentMethodSystemCode,
    this.date,
    this.isYesterday = false,
    this.isCurrencyMismatch = false,
    this.isCurrencyAmbiguous = false,
    this.rawSpokenCurrency,
    this.detectedCurrency,
  });

  final String rawTranscript;
  final int? amountMinor;
  final String? currency;
  final String? merchant;
  final String? description;
  final String? categoryId;
  final String? categoryName;
  final String? categorySystemCode;
  final String? paymentMethodId;
  final String? paymentMethodName;
  final String? paymentMethodSystemCode;
  final DateTime? date;
  final bool isYesterday;
  final bool isCurrencyMismatch;
  final bool isCurrencyAmbiguous;
  final String? rawSpokenCurrency;
  final String? detectedCurrency;

  bool get hasAmount => amountMinor != null && amountMinor! > 0;

  CaptureLaunchArgs toCaptureLaunchArgs() {
    return CaptureLaunchArgs(
      prefilledMerchant: merchant,
      prefilledAmountMinor: amountMinor,
      prefilledDate: date,
      prefilledCategoryId: categoryId,
      prefilledPaymentMethodId: paymentMethodId,
      prefilledDescription: description,
      prefilledCurrency: currency,
      autoFocusMerchant: merchant == null || merchant!.isEmpty,
      isCurrencyMismatch: isCurrencyMismatch,
      detectedCurrency: detectedCurrency ?? currency,
    );
  }

  @override
  String toString() =>
      'VoiceExpenseDraft(amountMinor: $amountMinor, currency: $currency, isMismatch: $isCurrencyMismatch, merchant: $merchant, categoryId: $categoryId, paymentMethodId: $paymentMethodId, date: $date)';
}
