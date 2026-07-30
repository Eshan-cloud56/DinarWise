enum TransactionHistorySort {
  newest,
  oldest,
  highestAmount,
  lowestAmount,
}

class TransactionHistoryFilter {
  const TransactionHistoryFilter({
    this.search = '',
    this.type = 'all',
    this.categoryId,
    this.paymentMethodId,
    this.from,
    this.to,
    this.sort = TransactionHistorySort.newest,
  });

  final String search;
  final String type;
  final String? categoryId;
  final String? paymentMethodId;
  final DateTime? from;
  final DateTime? to;
  final TransactionHistorySort sort;

  TransactionHistoryFilter copyWith({
    String? search,
    String? type,
    String? categoryId,
    bool clearCategory = false,
    String? paymentMethodId,
    bool clearPaymentMethod = false,
    DateTime? from,
    DateTime? to,
    bool clearDates = false,
    TransactionHistorySort? sort,
  }) {
    return TransactionHistoryFilter(
      search: search ?? this.search,
      type: type ?? this.type,
      categoryId: clearCategory ? null : categoryId ?? this.categoryId,
      paymentMethodId:
          clearPaymentMethod ? null : paymentMethodId ?? this.paymentMethodId,
      from: clearDates ? null : from ?? this.from,
      to: clearDates ? null : to ?? this.to,
      sort: sort ?? this.sort,
    );
  }
}
