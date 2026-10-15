import 'package:dinarwise/core/currency/app_currency.dart';

class VoiceCurrencyResolution {
  const VoiceCurrencyResolution({
    required this.currencyCode,
    this.isMismatch = false,
    this.isAmbiguous = false,
    this.rawSpokenCurrency,
  });

  /// The resolved ISO currency code, or null if ambiguous / invalid.
  final String? currencyCode;

  /// True if a foreign currency was explicitly detected that differs from base currency.
  final bool isMismatch;

  /// True if an ambiguous word (like "dollars" or "rupees") was spoken that is incompatible with base currency.
  final bool isAmbiguous;

  /// The raw currency text identified in the transcript.
  final String? rawSpokenCurrency;
}

class CurrencyVoiceResolver {
  const CurrencyVoiceResolver();

  static const Map<String, List<String>> _genericBuckets = {
    'dollar': ['USD', 'CAD', 'AUD', 'NZD', 'SGD', 'HKD'],
    'rupee': ['PKR', 'INR', 'LKR', 'NPR'],
    'dinar': ['KWD', 'BHD', 'JOD', 'IQD', 'TND', 'LYD'],
    'riyal': ['SAR', 'QAR', 'OMR', 'YER'],
    'dirham': ['AED', 'MAD'],
    'pound': ['GBP', 'EGP', 'LBP', 'SDG', 'SYP'],
    'franc': ['CHF', 'RWF', 'BIF', 'DJF', 'KMF', 'XOF', 'XAF', 'XPF', 'CDF'],
    'peso': ['MXN', 'COP', 'CLP', 'ARS', 'PHP', 'DOP', 'UYU'],
    'krone': ['NOK', 'SEK', 'DKK', 'ISK'],
  };

  /// Resolves the spoken currency in a transcript relative to the user's base currency.
  VoiceCurrencyResolution resolve({
    required String transcriptLower,
    required String baseCurrencyCode,
  }) {
    final baseUpper = baseCurrencyCode.toUpperCase();

    // 1. Check for unambiguous explicit expressions (e.g. 'canadian dollar', 'us dollar', 'saudi riyal', 'euro', etc.)
    final explicitMatch = _findExplicitMatch(transcriptLower);
    if (explicitMatch != null) {
      final code = explicitMatch.$1;
      final raw = explicitMatch.$2;
      return VoiceCurrencyResolution(
        currencyCode: code,
        isMismatch: code != baseUpper,
        rawSpokenCurrency: raw,
      );
    }

    // 2. Check for ambiguous generic currency words ('dollars', 'rupees', 'dinars', 'riyals', etc.)
    final genericMatch = _findGenericMatch(transcriptLower);
    if (genericMatch != null) {
      final bucketKey = genericMatch.$1;
      final raw = genericMatch.$2;
      final compatibleCodes = _genericBuckets[bucketKey] ?? [];

      if (compatibleCodes.contains(baseUpper)) {
        // Logically compatible with base currency: adopt base currency without mismatch
        return VoiceCurrencyResolution(
          currencyCode: baseUpper,
          isMismatch: false,
          rawSpokenCurrency: raw,
        );
      } else {
        // Incompatible with base currency: mark as ambiguous / review rather than guessing
        return VoiceCurrencyResolution(
          currencyCode: null,
          isMismatch: true,
          isAmbiguous: true,
          rawSpokenCurrency: raw,
        );
      }
    }

    // 3. No currency word detected -> default to user's configured base currency
    return VoiceCurrencyResolution(
      currencyCode: baseUpper,
      isMismatch: false,
      rawSpokenCurrency: null,
    );
  }

  (String, String)? _findExplicitMatch(String lower) {
    // Check explicit compound phrases first
    final explicitPhrases = <(String pattern, String code, String label)>[
      // USD
      (r'\b(us\s*dollars?|united\s*states\s*dollars?|دولار\s*أمريكي|دولار\s*امريكي)\b', 'USD', 'US Dollar'),
      // CAD
      (r'\b(canadian\s*dollars?|دولار\s*كندي)\b', 'CAD', 'Canadian Dollar'),
      // AUD
      (r'\b(australian\s*dollars?|دولار\s*أسترالي|دولار\s*استرالي)\b', 'AUD', 'Australian Dollar'),
      // NZD
      (r'\b(new\s*zealand\s*dollars?|دولار\s*نيوزيلندي)\b', 'NZD', 'New Zealand Dollar'),
      // SGD
      (r'\b(singapore\s*dollars?|دولار\s*سنغافوري)\b', 'SGD', 'Singapore Dollar'),
      // HKD
      (r'\b(hong\s*kong\s*dollars?|دولار\s*هونغ\s*كونغ)\b', 'HKD', 'Hong Kong Dollar'),
      // EUR
      (r'\b(euros?|eur|يورو)\b', 'EUR', 'Euro'),
      // GBP
      (r'\b(british\s*pounds?|pounds?\s*sterling|gbp|جنيه\s*إسترليني|جنيه\s*استرليني)\b', 'GBP', 'British Pound'),
      // JPY
      (r'\b(japanese\s*yen|yens?|jpy|ين\s*ياباني|ين)\b', 'JPY', 'Japanese Yen'),
      // CNY
      (r'\b(chinese\s*yuan|yuans?|cny|يوان\s*صيني|يوان)\b', 'CNY', 'Chinese Yuan'),
      // PKR
      (r'\b(pakistani\s*rupees?|pkr|روبية\s*باكستانية|روبيه\s*باكستانيه)\b', 'PKR', 'Pakistani Rupee'),
      // INR
      (r'\b(indian\s*rupees?|inr|روبية\s*هندية|روبيه\s*هنديه)\b', 'INR', 'Indian Rupee'),
      // SAR
      (r'\b(saudi\s*riyals?|sar|ريال\s*سعودي|ريالات\s*سعودية)\b', 'SAR', 'Saudi Riyal'),
      // AED
      (r'\b(uae\s*dirhams?|emirati\s*dirhams?|aed|درهم\s*إماراتي|درهم\s*اماراتي|dirhams?|درهم|دراهم)\b', 'AED', 'UAE Dirham'),
      // KWD
      (r'\b(kuwaiti\s*dinars?|kwd|د\.ك|دينار\s*كويتي)\b', 'KWD', 'Kuwaiti Dinar'),
      // BHD
      (r'\b(bahraini\s*dinars?|bhd|د\.ب|دينار\s*بحريني)\b', 'BHD', 'Bahraini Dinar'),
      // QAR
      (r'\b(qatari\s*riyals?|qar|ر\.ق|ريال\s*قطري)\b', 'QAR', 'Qatari Riyal'),
      // OMR
      (r'\b(omani\s*ri[ya]ls?|omr|ر\.ع|ريال\s*عماني)\b', 'OMR', 'Omani Rial'),
      // EGP
      (r'\b(egyptian\s*pounds?|egp|جنيه\s*مصري)\b', 'EGP', 'Egyptian Pound'),
      // JOD
      (r'\b(jordanian\s*dinars?|jod|د\.أ|دينار\s*أردني)\b', 'JOD', 'Jordanian Dinar'),
      // TRY
      (r'\b(turkish\s*liras?|try|ليرة\s*تركية)\b', 'TRY', 'Turkish Lira'),
      // KRW
      (r'\b(korean\s*wons?|krw|وون\s*كوري)\b', 'KRW', 'South Korean Won'),
      // CHF
      (r'\b(swiss\s*francs?|chf|فرنك\s*سويسري)\b', 'CHF', 'Swiss Franc'),
    ];

    for (final item in explicitPhrases) {
      final reg = RegExp(item.$1, caseSensitive: false);
      final m = reg.firstMatch(lower);
      if (m != null) {
        return (item.$2, m.group(0)!);
      }
    }

    // Check standalone 3-letter ISO codes (e.g. 'usd', 'pkr', 'cad', 'sar', '100usd')
    final isoPattern = RegExp(r'\b([a-z]{3})\b', caseSensitive: false);
    for (final m in isoPattern.allMatches(lower)) {
      final candidate = m.group(1)!.toUpperCase();
      final appCur = AppCurrency.tryFromCode(candidate);
      if (appCur != null) {
        return (appCur.code, candidate);
      }
    }

    // Check attached codes like '100usd', '500pkr'
    final attachedPattern = RegExp(r'\d+([a-z]{3})\b', caseSensitive: false);
    final attachedMatch = attachedPattern.firstMatch(lower);
    if (attachedMatch != null) {
      final candidate = attachedMatch.group(1)!.toUpperCase();
      final appCur = AppCurrency.tryFromCode(candidate);
      if (appCur != null) {
        return (appCur.code, candidate);
      }
    }

    return null;
  }

  (String, String)? _findGenericMatch(String lower) {
    final genericPatterns = <(String pattern, String bucketKey)>[
      (r'\b(dollars?|bucks?|دولار|دولارات)\b', 'dollar'),
      (r'\b(rupees?|روبية|روبيات|روبيه)\b', 'rupee'),
      (r'\b(dinars?|دينار|دنانير)\b', 'dinar'),
      (r'\b(riyals?|ريال|ريالات|رس|ر\.س)\b', 'riyal'),
      (r'\b(dirhams?|درهم|دراهم)\b', 'dirham'),
      (r'\b(pounds?|جنيه|جنيهات)\b', 'pound'),
      (r'\b(francs?|فرنك|فرنكات)\b', 'franc'),
      (r'\b(pesos?|بيزو)\b', 'peso'),
      (r'\b(krones?|kronas?|كرونة|كرونات)\b', 'krone'),
    ];

    for (final item in genericPatterns) {
      final reg = RegExp(item.$1, caseSensitive: false);
      final m = reg.firstMatch(lower);
      if (m != null) {
        return (item.$2, m.group(0)!);
      }
    }

    return null;
  }
}
