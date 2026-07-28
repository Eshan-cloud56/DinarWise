class CaptureDraft {
  const CaptureDraft({
    required this.merchant,
    required this.amount,
    required this.currency,
    required this.category,
    required this.confidence,
  });

  final String? merchant;
  final double amount;
  final String currency;
  final String category;
  final double confidence;

  factory CaptureDraft.fromJson(Map<String, dynamic> json) {
    final extraction = json['extraction'] as Map<String, dynamic>;
    return CaptureDraft(
      merchant: extraction['merchant_name'] as String?,
      amount: double.parse(extraction['amount'].toString()),
      currency: extraction['currency'] as String,
      category: extraction['category'] as String,
      confidence: double.parse(extraction['confidence'].toString()),
    );
  }
}
