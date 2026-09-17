import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/features/sms_detection/sms_transaction.dart';

class SmsParser {
  const SmsParser({this.defaultCurrency = 'SAR'});

  final String defaultCurrency;

  // Regex to detect OTP / verification codes
  static final RegExp _otpPattern = RegExp(
    r'(?:otp|verification\s*code|one[\s-]*time\s*password|رمز\s*التحقق|كود\s*التفعيل|كلمة\s*(?:المرور|السر)\s*المؤقتة|لا\s*تشارك)',
    caseSensitive: false,
  );

  // Regex to detect failed / declined transactions
  static final RegExp _failedPattern = RegExp(
    r'(?:declined|failed|unsuccessful|cancelled|canceled|reversed|مرفوض|فشل|ملغاة|ملغي|لم\s*تتم)',
    caseSensitive: false,
  );

  // Regex to detect promotions / marketing offers
  static final RegExp _promoPattern = RegExp(
    r'(?:cashback\s*up\s*to|discount|promo|voucher|deal|win\s*cash|spin\s*(?:&|and)\s*win|apply\s*now|upgrade\s*now|عرض\s*خاص|خصم\s*خاص|وفر|اشترك\s*الآن)',
    caseSensitive: false,
  );

  // Regex to detect balance-only reports without movement
  static final RegExp _balanceOnlyPattern = RegExp(
    r'^(?:your\s+)?(?:current\s+|available\s+)?balance\s*(?:is|:)?\s*(?:rs\.?|pkr|sar|aed)?\s*[0-9]+(?:\.[0-9]+)?\s*(?:\.?)$',
    caseSensitive: false,
  );

  // Currencies mapping
  static final Map<String, String> _currencyMap = {
    'sar': 'SAR',
    'sr': 'SAR',
    'ر.س': 'SAR',
    'رس': 'SAR',
    'ريال': 'SAR',
    'ريال سعودي': 'SAR',
    'aed': 'AED',
    'د.إ': 'AED',
    'درهم': 'AED',
    'kwd': 'KWD',
    'د.ك': 'KWD',
    'دينار': 'KWD',
    'bhd': 'BHD',
    'د.ب': 'BHD',
    'qar': 'QAR',
    'ر.ق': 'QAR',
    'omr': 'OMR',
    'ر.ع': 'OMR',
    'pkr': 'PKR',
    'pkr.': 'PKR',
    'rs': 'PKR',
    'rs.': 'PKR',
    'rupees': 'PKR',
  };

  // Known bank and wallet names
  static final List<({String key, String en, String ar})> _knownBanks = [
    (key: 'easypaisa', en: 'Easypaisa', ar: 'إيزي بيسا'),
    (key: 'jazzcash', en: 'JazzCash', ar: 'جاز كاش'),
    (key: 'sadapay', en: 'SadaPay', ar: 'سادا باي'),
    (key: 'nayapay', en: 'NayaPay', ar: 'نايا باي'),
    (key: 'raast', en: 'Raast', ar: 'راست'),
    (key: 'rajhi', en: 'Al Rajhi Bank', ar: 'مصرف الراجحي'),
    (key: 'snb', en: 'SNB', ar: 'البنك الأهلي'),
    (key: 'ahli', en: 'SNB', ar: 'البنك الأهلي'),
    (key: 'alinma', en: 'Alinma Bank', ar: 'مصرف الإنماء'),
    (key: 'inma', en: 'Alinma Bank', ar: 'مصرف الإنماء'),
    (key: 'riyad', en: 'Riyad Bank', ar: 'بنك الرياض'),
    (key: 'sab', en: 'SAB', ar: 'بنك ساب'),
    (key: 'sabb', en: 'SAB', ar: 'بنك ساب'),
    (key: 'fransi', en: 'Banque Saudi Fransi', ar: 'البنك السعودي الفرنسي'),
    (key: 'jazira', en: 'Bank AlJazira', ar: 'بنك الجزيرة'),
    (key: 'stcpay', en: 'STC Pay', ar: 'إس تي سي باي'),
    (key: 'stc pay', en: 'STC Pay', ar: 'إس تي سي باي'),
    (key: 'urpay', en: 'Urpay', ar: 'يورباي'),
    (key: 'tiqmo', en: 'Tiqmo', ar: 'تيقمو'),
    (key: 'anb', en: 'Arab National Bank', ar: 'البنك العربي الوطني'),
    (key: 'albilad', en: 'Bank Albilad', ar: 'بنك البلاد'),
    (key: 'bilad', en: 'Bank Albilad', ar: 'بنك البلاد'),
    (key: 'd360', en: 'D360 Bank', ar: 'بنك دال 360'),
  ];

  static final RegExp _outgoingKeywords = RegExp(
    r'(?:شراء|خصم|سحب|دفع|سداد|مدين|صادر|نقاط\s*بيع|purchase|debited|debit|payment\s*of|paid\s*to|paid|pos|withdrawn|spent|transferred\s*to|transferred|successfully\s*sent|payment\s*successful|purchase\s*successful|amount\s*sent|sent\s*to)',
    caseSensitive: false,
  );

  static final RegExp _incomingKeywords = RegExp(
    r'(?:إيداع|ايداع|أودع|حوالة\s*واردة|تحويل\s*وارد|تم\s*قيد|تم\s*إضافة|تم\s*اضافة|دائن|استرداد|وارد|راتب|credited|credit|deposit|received\s*from|received|refund|added\s*to|transferred\s*from|money\s*received|amount\s*received|received\s*successfully|transfer\s*received|sent\s*you)',
    caseSensitive: false,
  );

  SmsTransaction? parse({
    required String sender,
    required String body,
    DateTime? timestamp,
    String? messageHash,
  }) {
    final text = body.trim();
    if (text.isEmpty) return null;

    // 1. Strictly ignore OTP/2FA, failed, promo, and balance-only messages
    if (_otpPattern.hasMatch(text) ||
        _failedPattern.hasMatch(text) ||
        _promoPattern.hasMatch(text) ||
        _balanceOnlyPattern.hasMatch(text)) {
      return null;
    }

    // 2. Classify incoming vs outgoing
    final isOutgoing = _outgoingKeywords.hasMatch(text);
    final isIncoming = _incomingKeywords.hasMatch(text);

    if (!isOutgoing && !isIncoming) {
      // Unrecognized financial intent
      return null;
    }

    final type = isIncoming && !isOutgoing
        ? SmsTransactionType.income
        : SmsTransactionType.expense;

    // 3. Extract amount and currency
    final amountResult = _extractAmountAndCurrency(text);
    if (amountResult == null || amountResult.amountMinor <= 0) {
      return null;
    }

    // 4. Extract merchant or sender
    final merchant = _extractMerchant(text, type);

    // 5. Extract bank or account
    final bank = _extractBank(sender, text);

    // 6. Calculate confidence score
    double confidence = 0.5; // Base confidence since valid transaction keywords matched
    if (amountResult.amountMinor > 0) confidence += 0.2;
    if (amountResult.explicitCurrency) confidence += 0.1;
    if (bank != null) confidence += 0.1;
    if (merchant != null && merchant.isNotEmpty) confidence += 0.1;

    return SmsTransaction(
      type: type,
      amountMinor: amountResult.amountMinor,
      currency: amountResult.currency,
      merchantOrSender: merchant,
      bankOrAccount: bank,
      dateTime: timestamp ?? DateTime.now(),
      rawMessage: body,
      sender: sender,
      messageHash: messageHash ?? '',
      confidence: confidence.clamp(0.0, 1.0),
    );
  }

  /// Converts Arabic-Indic digits (٠١٢٣٤٥٦٧٨٩) to Latin (0-9)
  static String _normalizeDigits(String input) {
    const arabicIndic = '٠١٢٣٤٥٦٧٨٩';
    const englishDigits = '0123456789';
    var out = input;
    for (var i = 0; i < arabicIndic.length; i++) {
      out = out.replaceAll(arabicIndic[i], englishDigits[i]);
    }
    // Normalize Arabic decimal separator
    return out.replaceAll('٫', '.').replaceAll('،', ',');
  }

  ({int amountMinor, String currency, bool explicitCurrency})? _extractAmountAndCurrency(
    String text,
  ) {
    final normalized = _normalizeDigits(text);

    final amountRegex = RegExp(
      r'(?:مبلغ|بقيمة|بمبلغ|قيمة|amount(?:\s*of)?|payment(?:\s*of)?|for|purchase(?:\s*of)?|credited(?:\s*with)?|debited(?:\s*with)?|deposit(?:\s*of)?|sum(?:\s*of)?)?\s*:?\s*(?:(PKR|RS\.|RS|SAR|AED|KWD|BHD|QAR|OMR|[A-Za-z]{3}|ر\.س|رس|ريال|د\.ك|د\.إ|د\.ب|ر\.ق|ر\.ع)\s*)?([0-9]+(?:,[0-9]{3})*(?:\.[0-9]{1,3})?|[0-9]+(?:\.[0-9]{1,3})?)\s*(PKR|RS\.|RS|SAR|AED|KWD|BHD|QAR|OMR|[A-Za-z]{3}|ر\.س|رس|ريال|د\.ك|د\.إ|د\.ب|ر\.ق|ر\.ع)?',
      caseSensitive: false,
    );

    final candidates =
        <({int amountMinor, String currency, bool explicitCurrency, int priority})>[];

    for (final match in amountRegex.allMatches(normalized)) {
      final preCurrency = match.group(1);
      final numStr = match.group(2);
      final postCurrency = match.group(3);

      if (numStr == null) continue;

      final cleanNum = numStr.replaceAll(',', '');
      final amountDouble = double.tryParse(cleanNum);
      if (amountDouble == null || amountDouble <= 0) continue;

      final prefix = normalized.substring(0, match.start).trim();
      if (RegExp(r'(?:card|بطاقة|account|حساب|\*|#)\s*$', caseSensitive: false)
          .hasMatch(prefix)) {
        continue;
      }

      if (amountDouble >= 1000 && amountDouble <= 9999 && !cleanNum.contains('.')) {
        if (preCurrency == null && postCurrency == null) {
          continue;
        }
      }

      String detectedCurrency = defaultCurrency;
      bool explicit = false;
      final rawCur = (preCurrency ?? postCurrency)?.trim().toLowerCase();
      if (rawCur != null && _currencyMap.containsKey(rawCur)) {
        detectedCurrency = _currencyMap[rawCur]!;
        explicit = true;
      }

      final gulfCur = GulfCurrency.fromCode(detectedCurrency);
      final minor = gulfCur.toMinor(amountDouble);

      int priority = 0;
      if (explicit) priority += 10;
      if (cleanNum.contains('.')) priority += 5;

      candidates.add((
        amountMinor: minor,
        currency: detectedCurrency,
        explicitCurrency: explicit,
        priority: priority,
      ));
    }

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) => b.priority.compareTo(a.priority));
    final best = candidates.first;
    return (
      amountMinor: best.amountMinor,
      currency: best.currency,
      explicitCurrency: best.explicitCurrency,
    );
  }

  String? _extractMerchant(String text, SmsTransactionType type) {
    if (type == SmsTransactionType.income) {
      final sentYouMatch = RegExp(r'^([A-Za-z\s]+?)\s+sent\s+you', caseSensitive: false).firstMatch(text);
      if (sentYouMatch != null) {
        final raw = sentYouMatch.group(1)?.trim();
        if (raw != null && raw.length > 1 && raw.length < 50) {
          return _cleanEntityName(raw);
        }
      }

      final incomeSourceRegex = RegExp(
        r'(?:من\s+(?:حساب\s+)?|from\s+|by\s+|received\s+from\s+)([^\n\r،\.\(\)]+?)(?=\s+(?:إلى|الى|في|بتاريخ|الرصيد|بمبلغ|بقيمة|مبلغ|amount|for|account|to|on|via)|$)',
        caseSensitive: false,
      );
      final match = incomeSourceRegex.firstMatch(text);
      if (match != null) {
        final raw = match.group(1)?.trim();
        if (raw != null && raw.length > 1 && raw.length < 50) {
          return _cleanEntityName(raw);
        }
      }
      return null;
    }

    final merchantRegex = RegExp(
      r'(?:transferred(?:\s+[^\s]+)*?\s+to|sent(?:\s+[^\s]+)*?\s+to|paid(?:\s+[^\s]+)*?\s+to|to|لدى|عبر|عند|at|in)\s+([^\n\r،\.\(\)]+?)(?=\s+(?:[0-9]{5,12}|Fee|fee|FEE|Ref|ref|REF|tx|txn|TXN|Txn|ID|id|في|بتاريخ|بواسطة|عبر|بطاقة|الرصيد|on|via|using|card|balance|\+?92|03[0-9]{9})|[\.\,\;\:]\s*|\s*$)',
      caseSensitive: false,
    );

    final match = merchantRegex.firstMatch(text);
    if (match != null) {
      final raw = match.group(1)?.trim();
      if (raw != null && raw.length > 1 && raw.length < 50) {
        return _cleanEntityName(raw);
      }
    }
    return null;
  }

  String? _extractBank(String sender, String text) {
    final combined = '$sender $text'.toLowerCase();
    for (final bank in _knownBanks) {
      if (combined.contains(bank.key) || combined.contains(bank.en.toLowerCase()) || combined.contains(bank.ar)) {
        return bank.en;
      }
    }

    // Check account pattern like "حساب ينتهي بـ 1234" or "Account ending 1234"
    final accRegex = RegExp(
      r'(?:حساب(?:\s*ينتهي\s*بـ?)?|account(?:\s*ending(?:\s*in)?)?)\s*[*#]?\s*([0-9]{3,4})',
      caseSensitive: false,
    );
    final accMatch = accRegex.firstMatch(text);
    if (accMatch != null) {
      final digits = accMatch.group(1);
      return 'Account *$digits';
    }

    // If sender is a clean alphanumeric name, use it
    final cleanSender = sender.trim().replaceAll(RegExp(r'[^A-Za-z0-9\s]'), '');
    if (cleanSender.length >= 3 && cleanSender.length <= 20) {
      return cleanSender;
    }

    return null;
  }

  String _cleanEntityName(String name) {
    return name
        .replaceAll(RegExp(r'\b(?:\+?92|03)[0-9]{9}\b'), '')
        .replaceAll(RegExp(r'[*#_]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
