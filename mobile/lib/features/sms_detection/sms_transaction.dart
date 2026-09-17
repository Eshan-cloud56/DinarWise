enum SmsTransactionType {
  expense,
  income,
}

class SmsTransaction {
  const SmsTransaction({
    required this.type,
    required this.amountMinor,
    required this.currency,
    this.merchantOrSender,
    this.bankOrAccount,
    required this.dateTime,
    required this.rawMessage,
    required this.sender,
    required this.messageHash,
    required this.confidence,
  });

  final SmsTransactionType type;
  final int amountMinor;
  final String currency;
  final String? merchantOrSender;
  final String? bankOrAccount;
  final DateTime dateTime;
  final String rawMessage;
  final String sender;
  final String messageHash;
  final double confidence;

  bool get isHighConfidence => confidence >= 0.7 && amountMinor > 0;
}
