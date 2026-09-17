import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/expenses/data/history_filter.dart';
import 'package:dinarwise/features/smart_search/data/smart_search_client.dart';
import 'package:dinarwise/features/smart_search/domain/smart_search_category_mapper.dart';
import 'package:dinarwise/features/smart_search/domain/smart_search_date_resolver.dart';
import 'package:dinarwise/features/smart_search/models/smart_search_intent.dart';
import 'package:intl/intl.dart';

class SmartSearchResult {
  const SmartSearchResult({
    required this.title,
    required this.totalAmountMinor,
    required this.count,
    required this.items,
    required this.intent,
  });

  final String title;
  final int totalAmountMinor;
  final int count;
  final List<ExpenseRecord> items;
  final SmartSearchIntent intent;

  String formattedTotal({
    required GulfCurrency currencySpec,
    required String locale,
  }) {
    final major = currencySpec.toMajor(totalAmountMinor);
    final formatted = NumberFormat('#,##0.##', locale).format(major);
    return '${currencySpec.code} $formatted';
  }
}

final smartSearchClientProvider = Provider<SmartSearchClient>((ref) {
  return SmartSearchClient();
});

final smartSearchServiceProvider = Provider<SmartSearchService>((ref) {
  return SmartSearchService(
    client: ref.watch(smartSearchClientProvider),
    categoryMapper: const SmartSearchCategoryMapper(),
    dateResolver: const SmartSearchDateResolver(),
    expenseRepository: ref.watch(expenseRepositoryProvider),
  );
});

class SmartSearchService {
  SmartSearchService({
    required SmartSearchClient client,
    required SmartSearchCategoryMapper categoryMapper,
    required SmartSearchDateResolver dateResolver,
    required ExpenseRepository expenseRepository,
  })  : _client = client,
        _categoryMapper = categoryMapper,
        _dateResolver = dateResolver,
        _expenseRepository = expenseRepository;

  final SmartSearchClient _client;
  final SmartSearchCategoryMapper _categoryMapper;
  final SmartSearchDateResolver _dateResolver;
  final ExpenseRepository _expenseRepository;

  Future<SmartSearchResult> executeSmartSearch({
    required String query,
    required String locale,
    required String profileId,
    List<CategoryRecord> existingCategories = const [],
    DateTime? referenceTime,
    CancelToken? cancelToken,
  }) async {
    // 1. Call Cloudflare Smart Search endpoint with strictly query and locale
    final intent = await _client.parseQuery(
      query: query,
      locale: locale,
      cancelToken: cancelToken,
    );

    // 2. Resolve date range on-device
    final dateRange = _dateResolver.resolve(
      dateRange: intent.dateRange,
      month: intent.month,
      year: intent.year,
      startDate: intent.startDate,
      endDate: intent.endDate,
      referenceTime: referenceTime,
    );

    // 3. Resolve category IDs on-device
    Set<String>? categoryIds;
    if (intent.intent == SmartSearchIntentType.categoryExpenses) {
      categoryIds = _categoryMapper.mapCategoryGroupsToIds(
        categoryGroups: intent.categoryGroups,
        profileId: profileId,
        existingCategories: existingCategories,
      );
    }

    // 4. Resolve sorting
    final sort = switch (intent.sort.toLowerCase()) {
      'oldest' => TransactionHistorySort.oldest,
      'highest_amount' => TransactionHistorySort.highestAmount,
      'lowest_amount' => TransactionHistorySort.lowestAmount,
      _ => TransactionHistorySort.newest,
    };

    // 5. Query local SQLite/Drift database
    final items = await _expenseRepository.searchByIntent(
      profileId: profileId,
      categoryIds: categoryIds,
      merchant: intent.intent == SmartSearchIntentType.merchantExpenses
          ? intent.merchant
          : null,
      from: dateRange?.from,
      to: dateRange?.to,
      sort: sort,
    );

    // 6. Calculate total and count locally
    final totalMinor = items.fold<int>(0, (sum, item) => sum + item.amountMinor);

    // 7. Generate localized summary title
    final title = _buildSummaryTitle(
      intent: intent,
      locale: locale,
    );

    return SmartSearchResult(
      title: title,
      totalAmountMinor: totalMinor,
      count: items.length,
      items: items,
      intent: intent,
    );
  }

  String _buildSummaryTitle({
    required SmartSearchIntent intent,
    required String locale,
  }) {
    final isArabic = locale.startsWith('ar');

    final subject = switch (intent.intent) {
      SmartSearchIntentType.merchantExpenses => intent.merchant ?? (isArabic ? 'التاجر' : 'Merchant'),
      SmartSearchIntentType.allExpenses => isArabic ? 'جميع المصاريف' : 'All Expenses',
      SmartSearchIntentType.categoryExpenses => _formatCategoryGroups(intent.categoryGroups, isArabic),
      SmartSearchIntentType.unknown => isArabic ? 'المصاريف' : 'Expenses',
    };

    final dateLabel = _formatDateRangeLabel(intent.dateRange, isArabic);

    if (dateLabel != null && dateLabel.isNotEmpty) {
      return '$subject — $dateLabel';
    }
    return subject;
  }

  String _formatCategoryGroups(List<String> groups, bool isArabic) {
    if (groups.isEmpty) return isArabic ? 'المصاريف' : 'Expenses';

    const enNames = {
      'restaurants_cafes': 'Restaurants & Cafés',
      'groceries': 'Groceries',
      'transport': 'Transport',
      'shopping': 'Shopping',
      'entertainment': 'Entertainment',
      'health': 'Health',
      'education': 'Education',
      'bills': 'Bills',
      'subscriptions': 'Subscriptions',
      'travel': 'Travel',
      'utilities': 'Utilities',
      'other': 'Other',
    };

    const arNames = {
      'restaurants_cafes': 'المطاعم والمقاهي',
      'groceries': 'البقالة',
      'transport': 'النقل والمواصلات',
      'shopping': 'التسوق',
      'entertainment': 'الترفيه',
      'health': 'الصحة',
      'education': 'التعليم',
      'bills': 'الفواتير',
      'subscriptions': 'الاشتراكات',
      'travel': 'السفر',
      'utilities': 'الخدمات',
      'other': 'أخرى',
    };

    final names = groups.map((g) {
      final key = g.toLowerCase().trim();
      return isArabic ? (arNames[key] ?? key) : (enNames[key] ?? key);
    }).toList();

    return names.join(isArabic ? ' و ' : ' & ');
  }

  String? _formatDateRangeLabel(String? dateRange, bool isArabic) {
    if (dateRange == null) return null;

    return switch (dateRange.toLowerCase().trim()) {
      'today' => isArabic ? 'اليوم' : 'Today',
      'yesterday' => isArabic ? 'أمس' : 'Yesterday',
      'this_week' => isArabic ? 'هذا الأسبوع' : 'This Week',
      'last_week' => isArabic ? 'الأسبوع الماضي' : 'Last Week',
      'this_month' => isArabic ? 'هذا الشهر' : 'This Month',
      'last_month' => isArabic ? 'الشهر الماضي' : 'Last Month',
      'this_year' => isArabic ? 'هذه السنة' : 'This Year',
      'last_year' => isArabic ? 'السنة الماضية' : 'Last Year',
      _ => null,
    };
  }
}
