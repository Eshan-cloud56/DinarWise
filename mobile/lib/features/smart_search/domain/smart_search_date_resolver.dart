class SmartSearchDateRange {
  const SmartSearchDateRange({
    required this.from,
    required this.to,
  });

  final DateTime from;
  final DateTime to;
}

class SmartSearchDateResolver {
  const SmartSearchDateResolver();

  /// Resolves the temporal intent locally on-device.
  /// Never trusts remote AI to calculate timestamps.
  SmartSearchDateRange? resolve({
    String? dateRange,
    int? month,
    int? year,
    String? startDate,
    String? endDate,
    DateTime? referenceTime,
  }) {
    final now = referenceTime ?? DateTime.now();

    if (dateRange == null && month == null && startDate == null) {
      return null;
    }

    final rangeKey = dateRange?.toLowerCase().trim();

    switch (rangeKey) {
      case 'today':
        return SmartSearchDateRange(
          from: DateTime(now.year, now.month, now.day, 0, 0, 0),
          to: DateTime(now.year, now.month, now.day, 23, 59, 59, 999),
        );

      case 'yesterday':
        final yesterday = DateTime(now.year, now.month, now.day - 1);
        return SmartSearchDateRange(
          from: DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0),
          to: DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59, 999),
        );

      case 'this_week':
        // Monday as first day of week (ISO-8601)
        final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
        final sunday = DateTime(monday.year, monday.month, monday.day + 6);
        return SmartSearchDateRange(
          from: DateTime(monday.year, monday.month, monday.day, 0, 0, 0),
          to: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59, 999),
        );

      case 'last_week':
        final mondayThisWeek = DateTime(now.year, now.month, now.day - (now.weekday - 1));
        final mondayLastWeek = DateTime(mondayThisWeek.year, mondayThisWeek.month, mondayThisWeek.day - 7);
        final sundayLastWeek = DateTime(mondayLastWeek.year, mondayLastWeek.month, mondayLastWeek.day + 6);
        return SmartSearchDateRange(
          from: DateTime(mondayLastWeek.year, mondayLastWeek.month, mondayLastWeek.day, 0, 0, 0),
          to: DateTime(sundayLastWeek.year, sundayLastWeek.month, sundayLastWeek.day, 23, 59, 59, 999),
        );

      case 'this_month':
        return SmartSearchDateRange(
          from: DateTime(now.year, now.month, 1, 0, 0, 0),
          to: DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999),
        );

      case 'last_month':
        return SmartSearchDateRange(
          from: DateTime(now.year, now.month - 1, 1, 0, 0, 0),
          to: DateTime(now.year, now.month, 0, 23, 59, 59, 999),
        );

      case 'this_year':
        return SmartSearchDateRange(
          from: DateTime(now.year, 1, 1, 0, 0, 0),
          to: DateTime(now.year, 12, 31, 23, 59, 59, 999),
        );

      case 'last_year':
        return SmartSearchDateRange(
          from: DateTime(now.year - 1, 1, 1, 0, 0, 0),
          to: DateTime(now.year - 1, 12, 31, 23, 59, 59, 999),
        );

      case 'explicit_month':
        final targetYear = year ?? now.year;
        final targetMonth = (month != null && month >= 1 && month <= 12)
            ? month
            : now.month;
        return SmartSearchDateRange(
          from: DateTime(targetYear, targetMonth, 1, 0, 0, 0),
          to: DateTime(targetYear, targetMonth + 1, 0, 23, 59, 59, 999),
        );

      case 'custom_range':
        if (startDate != null && endDate != null) {
          final s = DateTime.tryParse(startDate);
          final e = DateTime.tryParse(endDate);
          if (s != null && e != null) {
            return SmartSearchDateRange(
              from: DateTime(s.year, s.month, s.day, 0, 0, 0),
              to: DateTime(e.year, e.month, e.day, 23, 59, 59, 999),
            );
          }
        }
        return null;

      default:
        // Handle fallback if month/year were provided without explicit_month string
        if (month != null && month >= 1 && month <= 12) {
          final targetYear = year ?? now.year;
          return SmartSearchDateRange(
            from: DateTime(targetYear, month, 1, 0, 0, 0),
            to: DateTime(targetYear, month + 1, 0, 23, 59, 59, 999),
          );
        }
        return null;
    }
  }
}
