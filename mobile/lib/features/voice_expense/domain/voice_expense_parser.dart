import 'package:dinarwise/core/currency/app_currency.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/payment_methods/payment_method_repository.dart';
import 'package:dinarwise/features/voice_expense/domain/currency_voice_resolver.dart';
import 'package:dinarwise/features/voice_expense/models/voice_expense_draft.dart';
import 'package:flutter/foundation.dart';

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
      'movers',
      'mover',
      'moving',
      'faisal movers',
      'مواصلات',
      'نقل',
      'تاكسي',
      'توصيل',
      'مشوار',
      'نقل عفش',
      'نقل اثاث',
    ],
    'shopping': [
      'apple store',
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
    'albaik': 'Al Baik',
    'al baik': 'Al Baik',
    'al-baik': 'Al Baik',
    'apple store': 'Apple Store',
    'carrefour': 'Carrefour',
    'faisal movers': 'Faisal Movers',
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
    'البيك': 'البيك',
    'جرير': 'جرير',
    'كارفور': 'كارفور',
    'ستاربكس': 'ستاربكس',
    'اوبر': 'أوبر',
    'أوبر': 'أوبر',
    'كريم': 'كريم',
    'ماكدونالدز': 'ماكدونالدز',
    'كنتاكي': 'كنتاكي',
    'لولو': 'لولو',
    'الدانوب': 'الدانوب',
    'ساسكو': 'ساسكو',
    'أرامكو': 'أرامكو',
    'ارامكو': 'أرامكو',
    'نون': 'نون',
    'أمازون': 'أمازون',
    'امازون': 'أمازون',
    'باندا': 'بنده',
    'بنده': 'بنده',
  };

  static const Map<String, int> _spokenUnits = {
    'zero': 0, 'one': 1, 'two': 2, 'three': 3, 'four': 4,
    'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9,
    'ten': 10, 'eleven': 11, 'twelve': 12, 'thirteen': 13, 'fourteen': 14,
    'fifteen': 15, 'sixteen': 16, 'seventeen': 17, 'eighteen': 18, 'nineteen': 19,
    'twenty': 20, 'thirty': 30, 'forty': 40, 'fifty': 50,
    'sixty': 60, 'seventy': 70, 'eighty': 80, 'ninety': 90,
  };

  static const Map<String, int> _arabicSpokenUnits = {
    'مئة': 100, 'مائة': 100, 'مية': 100, 'ميه': 100,
    'مئتان': 200, 'مائتان': 200, 'ميتين': 200,
    'ثلاثمئة': 300, 'أربعمئة': 400, 'خمسمئة': 500,
    'عشرة': 10, 'عشرين': 20, 'عشرون': 20,
    'ثلاثين': 30, 'ثلاثون': 30, 'أربعين': 40, 'أربعون': 40,
    'خمسين': 50, 'خمسون': 50, 'ستين': 60, 'ستون': 60,
    'سبعين': 70, 'سبعون': 70, 'ثمانين': 80, 'ثمانون': 80,
    'تسعين': 90, 'تسعون': 90,
    'ألف': 1000, 'الف': 1000, 'ألفين': 2000, 'الفين': 2000,
  };

  static VoiceExpenseDraft parse({
    required String transcript,
    required List<CategoryRecord> categories,
    List<PaymentMethodDetails> paymentMethods = const [],
    String defaultCurrencyCode = 'SAR',
    String? defaultPaymentMethodId,
    DateTime? now,
  }) {
    final cleanTranscript = transcript
        .replaceAll('[BLANK_AUDIO]', '')
        .replaceAll(RegExp(r'\[.*?\]'), '')
        .trim();

    // 0. Explicit Note Extraction: only populate Notes when an explicit note intent exists
    String? explicitNote;
    String workingTranscript = cleanTranscript;
    final noteMatch = RegExp(
      r'[,.]?\s*\b(?:note|notes|note:|with note|ملاحظة|ملاحظه)\s*:?\s*(.+)$',
      caseSensitive: false,
    ).firstMatch(cleanTranscript);

    if (noteMatch != null) {
      final rawNote = noteMatch.group(1)?.trim();
      if (rawNote != null && rawNote.isNotEmpty) {
        explicitNote = rawNote[0].toUpperCase() + rawNote.substring(1);
        workingTranscript = cleanTranscript.substring(0, noteMatch.start).trim();
      }
    }

    final lower = workingTranscript.toLowerCase();
    final referenceDate = now ?? DateTime.now();

    // 1. Date Recognition (calendar-safe, explicit relative date takes precedence)
    final (date, isYesterday) = _parseDate(lower, referenceDate);

    // 2. Currency Recognition
    final resolution = const CurrencyVoiceResolver().resolve(
      transcriptLower: lower,
      baseCurrencyCode: defaultCurrencyCode,
    );
    final detectedCurrency = resolution.currencyCode;
    final isCurrencyMismatch = resolution.isMismatch;
    final isCurrencyAmbiguous = resolution.isAmbiguous;
    final rawSpokenCurrency = resolution.rawSpokenCurrency;
    final currency = isCurrencyMismatch &&
            !AppCurrency.gccCurrencies
                .any((c) => c.code == detectedCurrency)
        ? null
        : detectedCurrency;

    // 3. Amount Recognition
    final amountDouble = _parseAmount(lower);
    final effectiveCurrency = AppCurrency.tryFromCode(currency) ??
        AppCurrency.fromCode(defaultCurrencyCode);
    final amountMinor = amountDouble != null
        ? effectiveCurrency.toMinor(amountDouble)
        : null;

    // 4. Merchant Recognition
    final merchant = _parseMerchant(workingTranscript, lower);

    // 5. Category Detection (never create merchant from category)
    final matchedCategory = _parseCategory(lower, merchant, categories);

    // 6. Payment Method Recognition
    final matchedPaymentMethod = _parsePaymentMethod(
      lower,
      paymentMethods,
      defaultPaymentMethodId,
    );

    if (kDebugMode) {
      debugPrint('[VoiceExpenseParser] raw: "$transcript"');
      debugPrint('[VoiceExpenseParser] working: "$workingTranscript"');
      debugPrint('[VoiceExpenseParser] amount: $amountDouble, currency: $currency, minor: $amountMinor, mismatch: $isCurrencyMismatch');
      debugPrint('[VoiceExpenseParser] merchant: $merchant, category: ${matchedCategory?.name}, payment: ${matchedPaymentMethod?.name}, date: $date (isYesterday: $isYesterday)');
    }

    return VoiceExpenseDraft(
      rawTranscript: cleanTranscript,
      amountMinor: amountMinor,
      currency: currency,
      merchant: merchant,
      description: explicitNote,
      categoryId: matchedCategory?.id,
      categoryName: matchedCategory?.name,
      categorySystemCode: matchedCategory?.systemCode,
      paymentMethodId: matchedPaymentMethod?.id,
      paymentMethodName: matchedPaymentMethod?.name,
      paymentMethodSystemCode: matchedPaymentMethod?.systemCode,
      date: date,
      isYesterday: isYesterday,
      isCurrencyMismatch: isCurrencyMismatch,
      isCurrencyAmbiguous: isCurrencyAmbiguous,
      rawSpokenCurrency: rawSpokenCurrency,
      detectedCurrency: detectedCurrency,
    );
  }

  static (DateTime, bool) _parseDate(String lower, DateTime referenceDate) {
    final yesterdayRegex = RegExp(
      r'\b(yesterday(?:\s+(?:morning|afternoon|evening))?|last\s*night|أمس|امس|البارحة|البارحه)\b',
      caseSensitive: false,
    );
    if (yesterdayRegex.hasMatch(lower)) {
      // Calendar-safe day subtraction using DateTime constructor (handles month/year/leap rollbacks cleanly)
      final resolvedDate = DateTime(
        referenceDate.year,
        referenceDate.month,
        referenceDate.day - 1,
        referenceDate.hour,
        referenceDate.minute,
        referenceDate.second,
      );
      return (resolvedDate, true);
    }
    // "today", "this morning", "tonight", or default
    return (referenceDate, false);
  }


  static String _normalizeNumerals(String text) {
    const easternToWestern = {
      '٠': '0', '١': '1', '٢': '2', '٣': '3', '٤': '4',
      '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9',
      '۰': '0', '۱': '1', '۲': '2', '۳': '3', '۴': '4',
      '۵': '5', '۶': '6', '۷': '7', '۸': '8', '۹': '9',
    };
    var result = text;
    easternToWestern.forEach((k, v) {
      result = result.replaceAll(k, v);
    });
    return result;
  }

  static String _normalizeAmountText(String text) {
    var normalized = _normalizeNumerals(text);
    // Separate digits and attached letters e.g. "100sar" -> "100 sar", "100.50sar" -> "100.50 sar"
    normalized = normalized.replaceAllMapped(
      RegExp(r'(\d+)([a-zA-Z\u0600-\u06FF]+)'),
      (m) => '${m.group(1)} ${m.group(2)}',
    );
    normalized = normalized.replaceAllMapped(
      RegExp(r'([a-zA-Z\u0600-\u06FF]+)(\d+)'),
      (m) => '${m.group(1)} ${m.group(2)}',
    );
    return normalized;
  }

  static double? _parseAmount(String lower) {
    final text = _normalizeAmountText(lower);

    // 1. Look for explicit digit pattern e.g. "100", "100.50", "1,000", "1.250"
    final regex = RegExp(r'\b(\d{1,3}(?:,\d{3})*(?:\.\d{1,3})?|\d+(?:[.,]\d{1,3})?)\b');
    final matches = regex.allMatches(text).toList();

    for (final match in matches) {
      var valStr = match.group(1)!;
      if (valStr.contains(',') && valStr.contains('.')) {
        valStr = valStr.replaceAll(',', '');
      } else if (valStr.contains(',')) {
        if (RegExp(r'^\d{1,3},\d{3}$').hasMatch(valStr)) {
          valStr = valStr.replaceAll(',', '');
        } else {
          valStr = valStr.replaceAll(',', '.');
        }
      }
      final val = double.tryParse(valStr);
      if (val != null && val > 0) {
        return val;
      }
    }

    // 2. Deterministic fallback for spoken numbers
    return _parseSpokenNumber(text);
  }

  static double? _parseSpokenNumber(String lower) {
    for (final entry in _arabicSpokenUnits.entries) {
      if (lower.contains(entry.key)) {
        return entry.value.toDouble();
      }
    }

    final words = lower
        .replaceAll(RegExp(r'[^\w\s-]'), ' ')
        .split(RegExp(r'\s+'));

    double? bestParsedNumber;
    int current = 0;
    int total = 0;
    bool inNumber = false;

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      if (word.isEmpty) continue;

      if (word.contains('-')) {
        final parts = word.split('-');
        int hyphenVal = 0;
        bool validHyphen = true;
        for (final p in parts) {
          if (_spokenUnits.containsKey(p)) {
            hyphenVal += _spokenUnits[p]!;
          } else {
            validHyphen = false;
            break;
          }
        }
        if (validHyphen && hyphenVal > 0) {
          current += hyphenVal;
          inNumber = true;
          continue;
        }
      }

      if (_spokenUnits.containsKey(word)) {
        current += _spokenUnits[word]!;
        inNumber = true;
      } else if (word == 'hundred') {
        if (current == 0) current = 1;
        current *= 100;
        inNumber = true;
      } else if (word == 'thousand') {
        if (current == 0) current = 1;
        total += current * 1000;
        current = 0;
        inNumber = true;
      } else if (word == 'and' && inNumber) {
        continue;
      } else if (word == 'a' &&
          !inNumber &&
          i + 1 < words.length &&
          (words[i + 1] == 'hundred' || words[i + 1] == 'thousand')) {
        current = 1;
        inNumber = true;
      } else {
        if (inNumber) {
          final candidate = (total + current).toDouble();
          if (candidate > 0) {
            bestParsedNumber = candidate;
          }
          current = 0;
          total = 0;
          inNumber = false;
        }
      }
    }

    if (inNumber) {
      final candidate = (total + current).toDouble();
      if (candidate > 0) {
        bestParsedNumber = candidate;
      }
    }

    return bestParsedNumber;
  }

  static String? _parseMerchant(String raw, String lower) {
    // 1. Check known merchants first (exact match)
    for (final entry in _knownMerchants.entries) {
      if (RegExp(r'\b' + RegExp.escape(entry.key) + r'\b', caseSensitive: false)
          .hasMatch(lower)) {
        return entry.value;
      }
    }

    const delimiterPattern =
        r'(?=\s+(?:using|with|via|paid by|for|on|yesterday|today|tonight|this morning|last night|بواسطة|عبر|أمس|امس|اليوم|البارحة|بقيمة|بسعر|بـ|\d)|[,.]|$)';

    // 2. Compound verbs: "bought from <M>", "ordered from <M>", "purchased from <M>", "paid to <M>", "spent at <M>"
    final compoundRegex = RegExp(
      r'\b(?:bought from|ordered from|purchased from|paid to|spent at)\s+([A-Za-z0-9\u0600-\u06FF\s&.-]+?)' +
          delimiterPattern,
      caseSensitive: false,
    );
    final compoundMatch = compoundRegex.firstMatch(raw);
    if (compoundMatch != null) {
      final merchant = _cleanMerchantCandidate(compoundMatch.group(1)!);
      if (merchant != null) return merchant;
    }

    // 3. Preposition matching: "at <M>", "from <M>", "to <M>", "in <M>", "لدى <M>", "في <M>", "من <M>", "عند <M>"
    final prepRegex = RegExp(
      r'\b(?:at|from|to|in|لدى|في|من|عند)\s+([A-Za-z0-9\u0600-\u06FF\s&.-]+?)' +
          delimiterPattern,
      caseSensitive: false,
    );
    final prepMatch = prepRegex.firstMatch(raw);
    if (prepMatch != null) {
      final merchant = _cleanMerchantCandidate(prepMatch.group(1)!);
      if (merchant != null) return merchant;
    }

    // 4. "using <provider>": Only if NOT a payment method and NOT a generic category/concept
    final usingRegex = RegExp(
      r'\b(?:using|بواسطة|عبر)\s+([A-Za-z0-9\u0600-\u06FF\s&.-]+?)' +
          delimiterPattern,
      caseSensitive: false,
    );
    final usingMatch = usingRegex.firstMatch(raw);
    if (usingMatch != null) {
      final candidate = usingMatch.group(1)!.trim();
      if (!_isPaymentPhrase(candidate) &&
          !_isNonMerchantTerm(candidate) &&
          _isValidProviderCandidate(candidate)) {
        final merchant = _cleanMerchantCandidate(candidate);
        if (merchant != null) return merchant;
      }
    }

    return null;
  }

  static String? _cleanMerchantCandidate(String rawCandidate) {
    var candidate = rawCandidate.trim();
    if (candidate.toLowerCase().startsWith('the ') && candidate.length > 4) {
      final stripped = candidate.substring(4).trim();
      if (!_isNonMerchantTerm(stripped) && !_isPaymentPhrase(stripped)) {
        candidate = stripped;
      }
    }
    if (_isNonMerchantTerm(candidate) || _isPaymentPhrase(candidate)) {
      return null;
    }
    return _formatMerchantName(candidate);
  }

  static bool _isValidProviderCandidate(String candidate) {
    final lower = candidate.toLowerCase().trim();
    if (_knownMerchants.containsKey(lower)) return true;
    if (_isNonMerchantTerm(lower) || _isPaymentPhrase(lower)) return false;
    
    // Multi-word candidates or capitalized words (e.g. "Faisal Movers", "Fast Couriers")
    final words = candidate.trim().split(RegExp(r'\s+'));
    if (words.length >= 2) return true;
    // Single word with capital letter that isn't a common generic noun
    if (words.length == 1 &&
        candidate[0].toUpperCase() == candidate[0] &&
        !_isNonMerchantTerm(lower)) {
      return true;
    }
    return false;
  }

  static bool _isPaymentPhrase(String term) {
    final lower = term.toLowerCase().trim();
    return RegExp(
      r'\b(cash|bank\s*transfer|visa|mastercard|mada|apple\s*pay|stc\s*pay|card|credit\s*card|debit\s*card|my\s*bank\s*transfer|my\s*card)\b',
      caseSensitive: false,
    ).hasMatch(lower) ||
        lower.contains('كاش') ||
        lower.contains('نقدا') ||
        lower.contains('نقد') ||
        lower.contains('تحويل') ||
        lower.contains('حوالة') ||
        lower.contains('فيزا') ||
        lower.contains('ماستركارد') ||
        lower.contains('مدى') ||
        lower.contains('ابل') ||
        lower.contains('اس تي سي') ||
        lower.contains('بطاقة');
  }

  static bool _isNonMerchantTerm(String term) {
    final cleaned = term.trim().toLowerCase();
    if (cleaned.isEmpty) return true;

    // Exact standalone generic concepts that must NEVER become a merchant
    const genericTerms = {
      'taxi', 'transport', 'transportation', 'transit', 'metro', 'bus', 'ride',
      'subscription', 'subscriptions', 'membership', 'gym',
      'fuel', 'petrol', 'gas', 'gasoline',
      'coffee', 'tea', 'cafe', 'cafes',
      'groceries', 'grocery', 'supermarket', 'market', 'store', 'shop',
      'food', 'dinner', 'lunch', 'breakfast', 'meal',
      'shoes', 'clothes', 'clothing', 'sneakers', 'shirt', 'pants', 'dress',
      'utilities', 'electricity', 'water', 'internet', 'bill', 'bills',
      'cash', 'visa', 'mastercard', 'mada', 'card', 'bank transfer', 'apple pay', 'stc pay',
      'home', 'work', 'office', 'service', 'services',
      'airport', 'station', 'hotel', 'hospital', 'clinic', 'school', 'university',
      // Arabic terms
      'تاكسي', 'مواصلات', 'نقل', 'باص', 'مترو', 'مشوار', 'توصيل',
      'اشتراك', 'اشتراكات', 'نادي',
      'بنزين', 'وقود', 'محطة',
      'قهوة', 'شاي', 'مقهى',
      'بقالة', 'تموينات', 'سوبرماركت', 'اغذية',
      'اكل', 'طعام', 'عشاء', 'غداء', 'فطور', 'وجبة',
      'ملابس', 'احذية', 'حذاء',
      'كهرباء', 'مياه', 'انترنت', 'فاتورة',
      'كاش', 'نقدا', 'نقد', 'فيزا', 'ماستركارد', 'مدى', 'بطاقة', 'تحويل', 'حوالة',
      'مطار', 'فندق', 'مستشفى', 'عيادة', 'مدرسة', 'جامعة',
    };

    if (genericTerms.contains(cleaned)) {
      return true;
    }

    const stopWords = {'my', 'a', 'an', 'the', 'some', 'any', 'this', 'that', 'it', 'me'};
    if (stopWords.contains(cleaned)) {
      return true;
    }

    return false;
  }

  static String _formatMerchantName(String name) {
    if (name.isEmpty) return name;
    final lower = name.toLowerCase().trim();
    if (_knownMerchants.containsKey(lower)) {
      return _knownMerchants[lower]!;
    }
    return name
        .split(RegExp(r'\s+'))
        .map((w) => w.isEmpty
            ? ''
            : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  static CategoryRecord? _parseCategory(
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
        return cat;
      }
    }
    return null;
  }

  static PaymentMethodDetails? _parsePaymentMethod(
    String lower,
    List<PaymentMethodDetails> paymentMethods,
    String? defaultPaymentMethodId,
  ) {
    // Check spoken keywords explicitly
    bool wantsBankTransfer = RegExp(
          r'\b(bank\s*transfer|using\s+bank\s*transfer|via\s+bank\s*transfer|paid\s+by\s+bank\s*transfer|through\s+bank\s*transfer)\b',
          caseSensitive: false,
        ).hasMatch(lower) ||
        lower.contains('تحويل') ||
        lower.contains('حوالة');

    bool wantsCash = RegExp(r'\b(cash)\b', caseSensitive: false).hasMatch(lower) ||
        lower.contains('كاش') ||
        lower.contains('نقدا') ||
        lower.contains('نقد');

    bool wantsVisa =
        RegExp(r'\b(visa)\b', caseSensitive: false).hasMatch(lower) ||
            lower.contains('فيزا');

    bool wantsMastercard =
        RegExp(r'\b(mastercard)\b', caseSensitive: false).hasMatch(lower) ||
            lower.contains('ماستركارد');

    bool wantsMada =
        RegExp(r'\b(mada)\b', caseSensitive: false).hasMatch(lower) ||
            lower.contains('مدى');

    bool wantsApplePay =
        RegExp(r'\b(apple\s*pay)\b', caseSensitive: false).hasMatch(lower) ||
            lower.contains('ابل باي');

    bool wantsStcPay = RegExp(
          r'\b(stc\s*pay|stcpay)\b',
          caseSensitive: false,
        ).hasMatch(lower) ||
        lower.contains('اس تي سي باي') ||
        lower.contains('stc باي');

    bool wantsCard = !wantsVisa &&
        !wantsMastercard &&
        !wantsMada &&
        !wantsBankTransfer &&
        !wantsApplePay &&
        !wantsStcPay &&
        (RegExp(r'\b(card|credit card|debit card)\b', caseSensitive: false).hasMatch(lower) ||
            lower.contains('بطاقة'));

    if (wantsBankTransfer) {
      final match = paymentMethods.where((pm) =>
          pm.systemCode?.toLowerCase() == 'bank_transfer' ||
          pm.name.toLowerCase().contains('bank transfer') ||
          pm.name.toLowerCase().contains('transfer') ||
          pm.name.contains('تحويل') ||
          pm.name.contains('حوالة'));
      if (match.isNotEmpty) return match.first;
    }
    if (wantsCash) {
      final match = paymentMethods.where((pm) =>
          pm.systemCode?.toLowerCase() == 'cash' ||
          pm.name.toLowerCase().contains('cash') ||
          pm.name.contains('نقد'));
      if (match.isNotEmpty) return match.first;
    }
    if (wantsVisa) {
      final match = paymentMethods.where((pm) =>
          pm.systemCode?.toLowerCase() == 'visa' ||
          pm.name.toLowerCase().contains('visa') ||
          pm.name.contains('فيزا'));
      if (match.isNotEmpty) return match.first;
      final cardMatch = paymentMethods.where((pm) =>
          pm.systemCode?.toLowerCase() == 'credit_card' ||
          pm.systemCode?.toLowerCase() == 'card' ||
          pm.systemCode?.toLowerCase() == 'debit_card');
      if (cardMatch.isNotEmpty) return cardMatch.first;
    }
    if (wantsMastercard) {
      final match = paymentMethods.where((pm) =>
          pm.systemCode?.toLowerCase() == 'mastercard' ||
          pm.name.toLowerCase().contains('mastercard') ||
          pm.name.contains('ماستركارد'));
      if (match.isNotEmpty) return match.first;
      final cardMatch = paymentMethods.where((pm) =>
          pm.systemCode?.toLowerCase() == 'credit_card' ||
          pm.systemCode?.toLowerCase() == 'card' ||
          pm.systemCode?.toLowerCase() == 'debit_card');
      if (cardMatch.isNotEmpty) return cardMatch.first;
    }
    if (wantsMada) {
      final match = paymentMethods.where((pm) =>
          pm.systemCode?.toLowerCase() == 'mada' ||
          pm.name.toLowerCase().contains('mada') ||
          pm.name.contains('مدى'));
      if (match.isNotEmpty) return match.first;
    }
    if (wantsApplePay) {
      final match = paymentMethods.where((pm) =>
          pm.systemCode?.toLowerCase() == 'apple_pay' ||
          pm.systemCode?.toLowerCase() == 'google_pay' ||
          pm.name.toLowerCase().contains('apple') ||
          pm.name.contains('ابل'));
      if (match.isNotEmpty) return match.first;
    }
    if (wantsStcPay) {
      final match = paymentMethods.where((pm) =>
          pm.systemCode?.toLowerCase() == 'stc_pay' ||
          pm.name.toLowerCase().contains('stc') ||
          pm.name.contains('اس تي سي'));
      if (match.isNotEmpty) return match.first;
    }
    if (wantsCard) {
      final match = paymentMethods.where((pm) =>
          pm.systemCode?.toLowerCase() == 'card' ||
          pm.systemCode?.toLowerCase() == 'credit_card' ||
          pm.systemCode?.toLowerCase() == 'debit_card' ||
          pm.name.toLowerCase().contains('card') ||
          pm.name.contains('بطاقة'));
      if (match.isNotEmpty) return match.first;
    }

    // If nothing explicitly spoken, do not invent or claim voice recognition.
    // Return null so Add Expense uses its genuine existing default-payment architecture.
    return null;
  }
}
