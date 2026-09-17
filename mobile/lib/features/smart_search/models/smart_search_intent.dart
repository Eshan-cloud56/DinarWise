enum SmartSearchIntentType {
  categoryExpenses,
  merchantExpenses,
  allExpenses,
  unknown;

  static SmartSearchIntentType fromString(String? value) {
    return switch (value) {
      'category_expenses' => SmartSearchIntentType.categoryExpenses,
      'merchant_expenses' => SmartSearchIntentType.merchantExpenses,
      'all_expenses' => SmartSearchIntentType.allExpenses,
      _ => SmartSearchIntentType.unknown,
    };
  }
}

class SmartSearchIntent {
  const SmartSearchIntent({
    required this.intent,
    this.categoryGroups = const [],
    this.merchant,
    this.dateRange,
    this.month,
    this.year,
    this.startDate,
    this.endDate,
    this.sort = 'newest',
  });

  factory SmartSearchIntent.fromJson(Map<String, dynamic> json) {
    final rawGroups = json['category_groups'];
    final groups = <String>[];
    if (rawGroups is List) {
      for (final item in rawGroups) {
        if (item is String && item.trim().isNotEmpty) {
          groups.add(item.trim());
        }
      }
    }

    final merchantRaw = json['merchant'] as String?;
    final merchant = (merchantRaw != null && merchantRaw.trim().isNotEmpty)
        ? merchantRaw.trim()
        : null;

    final dateRangeRaw = json['date_range'] as String?;
    final dateRange = (dateRangeRaw != null && dateRangeRaw.trim().isNotEmpty)
        ? dateRangeRaw.trim()
        : null;

    int? parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return SmartSearchIntent(
      intent: SmartSearchIntentType.fromString(json['intent'] as String?),
      categoryGroups: groups,
      merchant: merchant,
      dateRange: dateRange,
      month: parseInt(json['month']),
      year: parseInt(json['year']),
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      sort: json['sort'] as String? ?? 'newest',
    );
  }

  final SmartSearchIntentType intent;
  final List<String> categoryGroups;
  final String? merchant;
  final String? dateRange;
  final int? month;
  final int? year;
  final String? startDate;
  final String? endDate;
  final String sort;

  /// Strict validation against supported intent criteria.
  bool get isValid {
    return switch (intent) {
      SmartSearchIntentType.categoryExpenses => categoryGroups.isNotEmpty,
      SmartSearchIntentType.merchantExpenses =>
        merchant != null && merchant!.isNotEmpty,
      SmartSearchIntentType.allExpenses => true,
      SmartSearchIntentType.unknown => false,
    };
  }
}
