import 'package:dinarwise/features/capture/capture_screen.dart';

class VoiceExpenseDraft {
  const VoiceExpenseDraft({
    required this.rawTranscript,
    this.amountMinor,
    this.currency,
    this.merchant,
    this.description,
    this.categoryId,
    this.paymentMethodId,
    this.date,
  });

  final String rawTranscript;
  final int? amountMinor;
  final String? currency;
  final String? merchant;
  final String? description;
  final String? categoryId;
  final String? paymentMethodId;
  final DateTime? date;

  bool get hasAmount => amountMinor != null && amountMinor! > 0;

  CaptureLaunchArgs toCaptureLaunchArgs() {
    return CaptureLaunchArgs(
      prefilledMerchant: merchant,
      prefilledAmountMinor: amountMinor,
      prefilledDate: date,
      prefilledCategoryId: categoryId,
      prefilledPaymentMethodId: paymentMethodId,
      prefilledDescription: description ?? (merchant != null ? '' : rawTranscript),
      prefilledCurrency: currency,
    );
  }

  @override
  String toString() =>
      'VoiceExpenseDraft(amountMinor: $amountMinor, currency: $currency, merchant: $merchant, categoryId: $categoryId, paymentMethodId: $paymentMethodId, date: $date)';
}
