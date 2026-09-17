import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/payment_methods/payment_method_repository.dart';
import 'package:dinarwise/features/voice_expense/models/voice_expense_draft.dart';

class VoiceExpenseParser {
  static const Map<String, List<String>> _categoryKeywords = {
    'restaurants': [
      'albaik',
      'al baik',
      'starbucks',
      'coffee',
      'cafe',
      'cafes',
      'restaurant',
      'restaurants',
      'dining',
      'fast food',
      'burger',
      'pizza',
      'dinner',
      'lunch',
      'breakfast',
      'food',
      'مطعم',
      'مطاعم',
      'مقهى',
      'مقاهي',
      'كافيه',
      'قهوة',
      'عشاء',
      'غداء',
      'وجبة',
      'اكل',
    ],
    'groceries': [
      'carrefour',
      'panda',
      'danube',
      'lulu',
      'supermarket',
      'groceries',
      'grocery',
      'market',
      'بقالة',
      'تموينات',
      'سوبرماركت',
      'اغذية',
    ],
    'fuel': [
      'fuel',
      'petrol',
      'gas',
      'gasoline',
      'station',
      'aramco',
      'sasco',
      'adnoc',
      'enoc',
      'بنزين',
      'وقود',
      'محطة',
    ],
    'transportation': [
      'uber',
      'careem',
      'taxi',
      'transport',
      'transportation',
      'transit',
      'metro',
      'bus',
      'ride',
      'مواصلات',
      'نقل',
      'تاكسي',
      'توصيل',
      'مشوار',
    ],
    'shopping': [
      'shoes',
      'sneakers',
      'clothing',
      'clothes',
      'shirt',
      'pants',
      'dress',
      'shopping',
      'store',
      'mall',
      'jarir',
      'amazon',
      'noon',
      'تسوق',
      'ملابس',
      'احذية',
      'حذاء',
      'متجر',
    ],
    'utilities': [
      'electricity',
      'water',
      'internet',
      'stc',
      'mobily',
      'zain',
      'utilities',
      'كهرباء',
      'مياه',
      'فاتورة',
      'انترنت',
    ],
    'subscriptions': [
      'netflix',
      'spotify',
      'subscription',
      'subscriptions',
      'gym',
      'اشتراك',
      'اشتراكات',
      'نادي',
    ],
  };

  static const Map<String, String> _knownMerchants = {
    'albaik': 'AlBaik',
    'al baik': 'AlBaik',
    'carrefour': 'Carrefour',
    'panda': 'Panda',
    'starbucks': 'Starbucks',
    'uber': 'Uber',
    'careem': 'Careem',
    'jarir': 'Jarir',
    'amazon': 'Amazon',
    'noon': 'Noon',
    'lulu': 'Lulu',
    'danube': 'Danube',
    'sasco': 'Sasco',
    'aramco': 'Aramco',
    'mcdonald': "McDonald's",
    'mcdonalds': "McDonald's",
    'kfc': 'KFC',
    'cravy': 'Cravy',
  };

  static VoiceExpenseDraft parse({
    required String transcript,
    required List<CategoryRecord> categories,
    List<PaymentMethodDetails> paymentMethods = const [],
    String defaultCurrencyCode = 'SAR',
    String? defaultPaymentMethodId,
    DateTime? now,
  }) {
    final cleanTranscript = transcript.trim();
    final lower = cleanTranscript.toLowerCase();
    final referenceDate = now ?? DateTime.now();

    // 1. Date Recognition
    final date = _parseDate(lower, referenceDate);

    // 2. Currency Recognition
    final currency = _parseCurrency(lower, defaultCurrencyCode);

    // 3. Amount Recognition
    final amountDouble = _parseAmount(lower);
    final amountMinor = amountDouble != null
        ? GulfCurrency.fromCode(currency).toMinor(amountDouble)
        : null;

    // 4. Merchant & Item Recognition
    final merchant = _parseMerchant(cleanTranscript, lower);
    final itemDescription = _parseItemDescription(lower);

    // 5. Category Detection
    final categoryId = _parseCategory(lower, merchant, categories);

    // 6. Payment Method Recognition
    final paymentMethodId = _parsePaymentMethod(
      lower,
      paymentMethods,
      defaultPaymentMethodId,
    );

    return VoiceExpenseDraft(
      rawTranscript: cleanTranscript,
      amountMinor: amountMinor,
      currency: currency,
      merchant: merchant,
      description: itemDescription,
      categoryId: categoryId,
      paymentMethodId: paymentMethodId,
      date: date,
    );
  }

  static DateTime _parseDate(String lower, DateTime referenceDate) {
    if (lower.contains('yesterday') ||
        lower.contains('أمس') ||
        lower.contains('امس') ||
        lower.contains('البارحة')) {
      return referenceDate.subtract(const Duration(days: 1));
    }
    // "today", "this morning", "tonight", or default
    return referenceDate;
  }

  static String _parseCurrency(String lower, String defaultCode) {
    if (RegExp(r'\b(aed|dirham|dirhams|درهم|دراهم)\b', caseSensitive: false)
        .hasMatch(lower)) {
      return 'AED';
    }
    if (RegExp(r'\b(bhd|د\.ب|دينار بحريني)\b', caseSensitive: false)
        .hasMatch(lower)) {
      return 'BHD';
    }
    if (RegExp(r'\b(kwd|د\.ك|دينار كويتي)\b', caseSensitive: false)
        .hasMatch(lower)) {
      return 'KWD';
    }
    if (RegExp(r'\b(omr|ر\.ع|ريال عماني)\b', caseSensitive: false)
        .hasMatch(lower)) {
      return 'OMR';
    }
    if (RegExp(r'\b(qar|ر\.ق|ريال قطري)\b', caseSensitive: false)
        .hasMatch(lower)) {
      return 'QAR';
    }
    if (RegExp(r'\b(sar|riyal|riyals|ريال|ريالات|رس)\b', caseSensitive: false)
        .hasMatch(lower)) {
      return 'SAR';
    }
    return defaultCode;
  }

  static double? _parseAmount(String lower) {
    // Look for explicit number pattern e.g. "100", "120.50", "80"
    // Handles formats like:
    // "spent 100 sar", "for 250 riyals", "paid 120 aed", "100 SAR"
    final regex = RegExp(r'\b(\d+(?:[.,]\d{1,2})?)\b');
    final matches = regex.allMatches(lower).toList();

    if (matches.isEmpty) return null;

    // Prefer numbers that are directly before or after currency/words
    for (final match in matches) {
      final valStr = match.group(1)!.replaceAll(',', '.');
      final val = double.tryParse(valStr);
      if (val != null && val > 0) {
        return val;
      }
    }
    return null;
  }

  static String? _parseMerchant(String raw, String lower) {
    // Check known merchants first
    for (final entry in _knownMerchants.entries) {
      if (RegExp(r'\b' + RegExp.escape(entry.key) + r'\b', caseSensitive: false)
          .hasMatch(lower)) {
        return entry.value;
      }
    }

    // Preposition matching: "at <Merchant>", "from <Merchant>", "in <Merchant>", "عند <Merchant>", "في <Merchant>", "من <Merchant>"
    final prepRegex = RegExp(
      r'\b(?:at|from|in|to|لدى|في|من|عند)\s+([A-Za-z0-9\u0600-\u06FF\s&]+?)(?=\s+(?:using|with|for|yesterday|today|on|بواسطة|عبر|أمس|اليوم|نقدا|كاش|\d|$))',
      caseSensitive: false,
    );
    final match = prepRegex.firstMatch(raw);
    if (match != null) {
      final candidate = match.group(1)!.trim();
      // Filter out non-merchant terms
      final lowerCandidate = candidate.toLowerCase();
      if (!_isNonMerchantTerm(lowerCandidate)) {
        return _formatMerchantName(candidate);
      }
    }
    return null;
  }

  static bool _isNonMerchantTerm(String term) {
    const nonMerchants = [
      'fuel',
      'petrol',
      'gas',
      'coffee',
      'shoes',
      'clothes',
      'dinner',
      'lunch',
      'breakfast',
      'cash',
      'visa',
      'card',
      'home',
      'work',
      'بنزين',
      'قهوة',
      'كاش',
    ];
    return nonMerchants.contains(term);
  }

  static String _formatMerchantName(String name) {
    if (name.isEmpty) return name;
    return name
        .split(' ')
        .map((w) => w.isEmpty
            ? ''
            : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }

  static String? _parseItemDescription(String lower) {
    if (lower.contains('shoes') ||
        lower.contains('حذاء') ||
        lower.contains('احذية')) {
      return 'Shoes';
    }
    if (lower.contains('coffee') || lower.contains('قهوة')) {
      return 'Coffee';
    }
    if (lower.contains('fuel') || lower.contains('بنزين')) {
      return 'Fuel';
    }
    return null;
  }

  static String? _parseCategory(
    String lower,
    String? merchant,
    List<CategoryRecord> categories,
  ) {
    String? matchedSystemCode;

    // Search keywords
    for (final entry in _categoryKeywords.entries) {
      for (final kw in entry.value) {
        if (RegExp(r'\b' + RegExp.escape(kw) + r'\b', caseSensitive: false)
            .hasMatch(lower)) {
          matchedSystemCode = entry.key;
          break;
        }
      }
      if (matchedSystemCode != null) break;
    }

    if (matchedSystemCode == null) return null;

    // Map matched systemCode to existing CategoryRecord
    for (final cat in categories) {
      if (cat.systemCode == matchedSystemCode) {
        return cat.id;
      }
    }
    return null;
  }

  static String? _parsePaymentMethod(
    String lower,
    List<PaymentMethodDetails> paymentMethods,
    String? defaultPaymentMethodId,
  ) {
    // Check spoken keywords explicitly
    bool wantsCash = RegExp(r'\b(cash|كاش|نقدا|نقد)\b', caseSensitive: false)
        .hasMatch(lower);
    bool wantsVisa =
        RegExp(r'\b(visa|فيزا)\b', caseSensitive: false).hasMatch(lower);
    bool wantsMastercard =
        RegExp(r'\b(mastercard|ماستركارد)\b', caseSensitive: false)
            .hasMatch(lower);
    bool wantsMada =
        RegExp(r'\b(mada|مدى)\b', caseSensitive: false).hasMatch(lower);
    bool wantsApplePay =
        RegExp(r'\b(apple pay|ابل باي)\b', caseSensitive: false)
            .hasMatch(lower);
    bool wantsCard = !wantsVisa &&
        !wantsMastercard &&
        !wantsMada &&
        RegExp(r'\b(card|بطاقة)\b', caseSensitive: false).hasMatch(lower);

    if (wantsCash) {
      final match = paymentMethods.where((pm) =>
          pm.systemCode?.toLowerCase() == 'cash' ||
          pm.name.toLowerCase().contains('cash') ||
          pm.name.contains('نقد'));
      if (match.isNotEmpty) return match.first.id;
    }
    if (wantsVisa) {
      final match = paymentMethods
          .where((pm) => pm.name.toLowerCase().contains('visa'));
      if (match.isNotEmpty) return match.first.id;
    }
    if (wantsMastercard) {
      final match = paymentMethods
          .where((pm) => pm.name.toLowerCase().contains('mastercard'));
      if (match.isNotEmpty) return match.first.id;
    }
    if (wantsMada) {
      final match = paymentMethods
          .where((pm) => pm.name.toLowerCase().contains('mada'));
      if (match.isNotEmpty) return match.first.id;
    }
    if (wantsApplePay) {
      final match = paymentMethods
          .where((pm) => pm.name.toLowerCase().contains('apple'));
      if (match.isNotEmpty) return match.first.id;
    }
    if (wantsCard) {
      final match = paymentMethods.where((pm) =>
          pm.name.toLowerCase().contains('card') || pm.name.contains('بطاقة'));
      if (match.isNotEmpty) return match.first.id;
    }

    // If nothing explicitly spoken, check default payment method
    if (defaultPaymentMethodId != null) {
      return defaultPaymentMethodId;
    }

    // Never invent payment method
    return null;
  }
}
