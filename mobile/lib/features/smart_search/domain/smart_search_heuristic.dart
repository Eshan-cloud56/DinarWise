/// Deterministic heuristic to distinguish natural-language search queries
/// from simple local keyword searches (e.g. "Al Baik", "Starbucks", "Fuel").
bool isNaturalLanguageQuery(String query) {
  final clean = query.trim().toLowerCase();
  if (clean.isEmpty) return false;

  final words = clean.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

  // Explicit natural language question / action prefixes (English & Arabic)
  const nlPrefixes = [
    'how much',
    'what did i',
    'what did we',
    'what i spent',
    'show my',
    'show me',
    'show what',
    'show all',
    'list all',
    'list my',
    'how many',
    'where did i',
    'where did we',
    'spending on',
    'expenses on',
    'spent on',
    'spent at',
    // Arabic
    'كم صرفت',
    'كم أنفقت',
    'كم انفق',
    'ماذا صرفت',
    'ما أنفقت',
    'ما انفق',
    'أرني',
    'ارني',
    'أظهر',
    'اظهر',
    'اعرض',
    'عرض مصاريف',
    'كل المصاريف',
    'جميع المصاريف',
    'مصاريف',
    'مصروفات',
  ];

  for (final prefix in nlPrefixes) {
    if (clean.startsWith(prefix)) {
      return true;
    }
  }

  // Temporal qualifiers that signal an intent query when accompanied by category/merchant/spending terms
  const temporalPhrases = [
    'this month',
    'last month',
    'this week',
    'last week',
    'this year',
    'last year',
    'today',
    'yesterday',
    // Arabic
    'هذا الشهر',
    'الشهر الماضي',
    'الشهر السابق',
    'هذا الأسبوع',
    'هذا الاسبوع',
    'الأسبوع الماضي',
    'الاسبوع الماضي',
    'هذه السنة',
    'السنة الماضية',
    'اليوم',
    'أمس',
    'امس',
  ];

  final hasTemporal = temporalPhrases.any((phrase) => clean.contains(phrase));
  if (hasTemporal && words.length >= 2) {
    // Check if paired with a financial or category or merchant subject
    // e.g., "restaurants this month", "groceries last month", "transport this week", "subscriptions this year"
    return true;
  }

  // Sentences with 4 or more words containing spending/financial action keywords
  if (words.length >= 4) {
    const financialTokens = [
      'spent',
      'spend',
      'spending',
      'expenses',
      'expense',
      'cost',
      'paid',
      'bought',
      'صرف',
      'انفاق',
      'أنفق',
      'دفع',
      'شراء',
    ];
    final hasFinancialToken = words.any((w) => financialTokens.contains(w));
    if (hasFinancialToken) {
      return true;
    }
  }

  return false;
}

/// Checks if a natural-language query is complete enough to warrant an AI call,
/// avoiding firing searches on incomplete intermediate typing states.
bool isCompleteNaturalLanguageQuery(String query) {
  final clean = query.trim().toLowerCase();
  if (!isNaturalLanguageQuery(clean)) return false;

  final words = clean.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return false;

  // Hanging prepositions, conjunctions, articles, or unfinished connector words at the end
  const hangingEndings = {
    'on',
    'at',
    'in',
    'for',
    'to',
    'from',
    'the',
    'my',
    'our',
    'a',
    'an',
    'did',
    'of',
    'with',
    'is',
    'was',
    'what',
    'how',
    'show',
    'and',
    // Arabic
    'في',
    'على',
    'من',
    'إلى',
    'عن',
    'ل',
    'مع',
    'هذا',
    'هذه',
    'ال',
    'ما',
    'ماذا',
    'كم',
  };

  final lastWord = words.last;
  if (hangingEndings.contains(lastWord)) {
    return false;
  }

  // If query consists only of a standalone question prefix without any target, it is incomplete
  const standalonePrefixes = {
    'how much',
    'how much did i',
    'how much did i spend',
    'how much did we',
    'how much did we spend',
    'what did i',
    'what did i spend',
    'what did we',
    'what did we spend',
    'what i spent',
    'show my',
    'show me',
    'show what',
    'show what i',
    'show what i spent',
    'show all',
    'list all',
    'list my',
    'how many',
    'where did i',
    'where did we',
    'spending on',
    'expenses on',
    'spent on',
    'spent at',
    'كم صرفت',
    'كم أنفقت',
    'كم انفق',
    'ماذا صرفت',
    'ما أنفقت',
    'ما انفق',
    'أرني',
    'ارني',
    'أظهر',
    'اظهر',
  };

  if (standalonePrefixes.contains(clean)) {
    return false;
  }

  // Need at least 2 words (e.g. "groceries today")
  if (words.length < 2) return false;

  return true;
}

