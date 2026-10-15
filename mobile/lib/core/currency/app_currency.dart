import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';

final selectedCurrencyProvider = Provider<AppCurrency>(
  (ref) {
    final onboarding = ref.watch(onboardingControllerProvider).valueOrNull;
    final code = onboarding?.currencyCode;
    return AppCurrency.tryFromCode(code) ?? AppCurrency.sar;
  },
);

/// Official ISO 4217 Currency Definition.
/// Source: ISO 4217 Maintenance Agency (SIX Financial Information AG).
/// Currencies represent circulating ordinary currencies appropriate for personal finance.
class AppCurrency {
  const AppCurrency({
    required this.code,
    required this.englishName,
    required this.arabicName,
    required this.symbol,
    required this.decimalDigits,
    this.isGcc = false,
  });

  final String code;
  final String englishName;
  final String arabicName;
  final String symbol;
  final int decimalDigits;
  final bool isGcc;

  /// Derived minor-unit scale factor (10^decimalDigits).
  /// For 0 decimals: 1 (e.g. JPY, KRW)
  /// For 2 decimals: 100 (e.g. USD, EUR, SAR, PKR)
  /// For 3 decimals: 1000 (e.g. KWD, BHD, OMR)
  int get minorFactor => math.pow(10, decimalDigits).toInt();

  /// Deterministic conversion from major unit string to integer minor units without binary floating-point drift.
  /// Example: '1.25' with 2 decimals -> 125.
  /// Example: '500' with 0 decimals -> 500.
  /// Example: '1.250' with 3 decimals -> 1250.
  int parseToMinor(String input) {
    final normalized = input
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9')
        .replaceAll('٫', '.')
        .replaceAll('٬', '')
        .replaceAll(',', '')
        .trim();
    if (normalized.isEmpty) return 0;
    final isNegative = normalized.startsWith('-');
    final absCleaned = isNegative ? normalized.substring(1).trim() : normalized;

    final parts = absCleaned.split('.');
    final wholePart = int.tryParse(parts[0].isEmpty ? '0' : parts[0]) ?? 0;
    var fractionPart = 0;

    if (decimalDigits > 0 && parts.length > 1) {
      final rawFraction = parts[1];
      final truncated = rawFraction.length > decimalDigits
          ? rawFraction.substring(0, decimalDigits)
          : rawFraction.padRight(decimalDigits, '0');
      fractionPart = int.tryParse(truncated) ?? 0;
    }

    final total = wholePart * minorFactor + fractionPart;
    return isNegative ? -total : total;
  }

  /// Convenience conversion from double if needed (prefer parseToMinor when string is available).
  int toMinor(num major) => (major * minorFactor).round();

  /// Conversion from integer minor units to major double for display.
  double toMajor(int minor) => minor / minorFactor;

  /// Localized currency formatter.
  NumberFormat formatter(String locale) => NumberFormat.currency(
        name: code,
        symbol: '$code ',
        decimalDigits: decimalDigits,
        locale: locale,
      );

  /// Localized string for an integer minor amount.
  String formatMinor(int minor, {String? locale}) {
    final fmt = formatter(locale ?? 'en');
    return fmt.format(toMajor(minor));
  }

  /// Localized string for major units (convenience helper).
  String format(num major, {String? locale}) {
    final fmt = formatter(locale ?? 'en');
    return fmt.format(major);
  }

  /// Formats an integer minor amount for text input without currency symbol.
  String formatAmountForInput(int minor) {
    return toMajor(minor).toStringAsFixed(decimalDigits);
  }

  /// Localized name according to language code ('ar' or 'en').
  String name(String languageCode) =>
      languageCode == 'ar' ? arabicName : englishName;

  /// Backward-compatibility alias for GCC supported currencies list.
  static const supported = gccCurrencies;

  /// Complete list of supported ISO 4217 currencies.
  static const all = allCurrencies;

  /// Authoritative ISO 4217 source version / maintenance agency.
  static const String isoSourceVersion =
      'ISO 4217 Maintenance Agency (SIX Financial Information AG) - 2026 Snapshot';

  /// Lookup by code with fallback to SAR (alias).
  static AppCurrency byCode(String code) => fromCode(code);

  // Static standard GCC currencies for priority access
  static const sar = AppCurrency(
    code: 'SAR',
    englishName: 'Saudi Riyal',
    arabicName: 'الريال السعودي',
    symbol: 'ر.س',
    decimalDigits: 2,
    isGcc: true,
  );

  static const aed = AppCurrency(
    code: 'AED',
    englishName: 'UAE Dirham',
    arabicName: 'الدرهم الإماراتي',
    symbol: 'د.إ',
    decimalDigits: 2,
    isGcc: true,
  );

  static const kwd = AppCurrency(
    code: 'KWD',
    englishName: 'Kuwaiti Dinar',
    arabicName: 'الدينار الكويتي',
    symbol: 'د.ك',
    decimalDigits: 3,
    isGcc: true,
  );

  static const bhd = AppCurrency(
    code: 'BHD',
    englishName: 'Bahraini Dinar',
    arabicName: 'الدينار البحريني',
    symbol: 'د.ب',
    decimalDigits: 3,
    isGcc: true,
  );

  static const qar = AppCurrency(
    code: 'QAR',
    englishName: 'Qatari Riyal',
    arabicName: 'الريال القطري',
    symbol: 'ر.ق',
    decimalDigits: 2,
    isGcc: true,
  );

  static const omr = AppCurrency(
    code: 'OMR',
    englishName: 'Omani Rial',
    arabicName: 'الريال العُماني',
    symbol: 'ر.ع',
    decimalDigits: 3,
    isGcc: true,
  );

  /// GCC currencies listed in conventional regional order.
  static const gccCurrencies = [sar, aed, kwd, bhd, qar, omr];

  /// Authoritative, complete catalog of active ISO 4217 national/regional currencies.
  /// Maintained according to SIX ISO 4217 Maintenance Agency specifications.
  static const allCurrencies = [
    // GCC Priority Currencies
    sar,
    aed,
    kwd,
    bhd,
    qar,
    omr,

    // Major World Currencies
    AppCurrency(code: 'USD', englishName: 'US Dollar', arabicName: 'الدولار الأمريكي', symbol: '\$', decimalDigits: 2),
    AppCurrency(code: 'EUR', englishName: 'Euro', arabicName: 'اليورو', symbol: '€', decimalDigits: 2),
    AppCurrency(code: 'GBP', englishName: 'British Pound', arabicName: 'الجنيه الإسترليني', symbol: '£', decimalDigits: 2),
    AppCurrency(code: 'JPY', englishName: 'Japanese Yen', arabicName: 'الين الياباني', symbol: '¥', decimalDigits: 0),
    AppCurrency(code: 'CNY', englishName: 'Chinese Yuan', arabicName: 'اليوان الصيني', symbol: '¥', decimalDigits: 2),
    AppCurrency(code: 'INR', englishName: 'Indian Rupee', arabicName: 'الروبية الهندية', symbol: '₹', decimalDigits: 2),
    AppCurrency(code: 'PKR', englishName: 'Pakistani Rupee', arabicName: 'الروبية الباكستانية', symbol: 'Rs', decimalDigits: 2),
    AppCurrency(code: 'CAD', englishName: 'Canadian Dollar', arabicName: 'الدولار الكندي', symbol: '\$', decimalDigits: 2),
    AppCurrency(code: 'AUD', englishName: 'Australian Dollar', arabicName: 'الدولار الأسترالي', symbol: '\$', decimalDigits: 2),
    AppCurrency(code: 'NZD', englishName: 'New Zealand Dollar', arabicName: 'دولار نيوزيلندي', symbol: '\$', decimalDigits: 2),
    AppCurrency(code: 'CHF', englishName: 'Swiss Franc', arabicName: 'الفرنك السويسري', symbol: 'CHF', decimalDigits: 2),
    AppCurrency(code: 'SGD', englishName: 'Singapore Dollar', arabicName: 'دولار سنغافوري', symbol: '\$', decimalDigits: 2),
    AppCurrency(code: 'HKD', englishName: 'Hong Kong Dollar', arabicName: 'دولار هونغ كونغ', symbol: '\$', decimalDigits: 2),
    AppCurrency(code: 'KRW', englishName: 'South Korean Won', arabicName: 'الوون الكوري الجنوبي', symbol: '₩', decimalDigits: 0),
    AppCurrency(code: 'TRY', englishName: 'Turkish Lira', arabicName: 'الليرة التركية', symbol: '₺', decimalDigits: 2),
    AppCurrency(code: 'ZAR', englishName: 'South African Rand', arabicName: 'الراند الجنوب أفريقي', symbol: 'R', decimalDigits: 2),
    AppCurrency(code: 'BRL', englishName: 'Brazilian Real', arabicName: 'الريال البرازيلي', symbol: 'R\$', decimalDigits: 2),
    AppCurrency(code: 'MXN', englishName: 'Mexican Peso', arabicName: 'البيزو المكسيكي', symbol: '\$', decimalDigits: 2),
    AppCurrency(code: 'IDR', englishName: 'Indonesian Rupiah', arabicName: 'الروبية الإندونيسية', symbol: 'Rp', decimalDigits: 2),
    AppCurrency(code: 'MYR', englishName: 'Malaysian Ringgit', arabicName: 'الرينغيت الماليزي', symbol: 'RM', decimalDigits: 2),
    AppCurrency(code: 'PHP', englishName: 'Philippine Peso', arabicName: 'البيزو الفلبيني', symbol: '₱', decimalDigits: 2),
    AppCurrency(code: 'THB', englishName: 'Thai Baht', arabicName: 'البات التايلاندي', symbol: '฿', decimalDigits: 2),
    AppCurrency(code: 'VND', englishName: 'Vietnamese Dong', arabicName: 'الدونغ الفيتنامي', symbol: '₫', decimalDigits: 0),
    AppCurrency(code: 'EGP', englishName: 'Egyptian Pound', arabicName: 'الجنيه المصري', symbol: 'E£', decimalDigits: 2),
    AppCurrency(code: 'JOD', englishName: 'Jordanian Dinar', arabicName: 'الدينار الأردني', symbol: 'د.أ', decimalDigits: 3),
    AppCurrency(code: 'IQD', englishName: 'Iraqi Dinar', arabicName: 'الدينار العراقي', symbol: 'د.ع', decimalDigits: 3),
    AppCurrency(code: 'LBP', englishName: 'Lebanese Pound', arabicName: 'الليرة اللبنانية', symbol: 'ل.ل', decimalDigits: 2),
    AppCurrency(code: 'MAD', englishName: 'Moroccan Dirham', arabicName: 'الدرهم المغربي', symbol: 'د.م.', decimalDigits: 2),
    AppCurrency(code: 'TND', englishName: 'Tunisian Dinar', arabicName: 'الدينار التونسي', symbol: 'د.ت', decimalDigits: 3),
    AppCurrency(code: 'DZD', englishName: 'Algerian Dinar', arabicName: 'الدينار الجزائري', symbol: 'د.ج', decimalDigits: 2),
    AppCurrency(code: 'LYD', englishName: 'Libyan Dinar', arabicName: 'الدينار الليبي', symbol: 'د.ل', decimalDigits: 3),
    AppCurrency(code: 'SDG', englishName: 'Sudanese Pound', arabicName: 'الجنيه السوداني', symbol: 'ج.س', decimalDigits: 2),
    AppCurrency(code: 'YER', englishName: 'Yemeni Rial', arabicName: 'الريال اليمني', symbol: '﷼', decimalDigits: 2),
    AppCurrency(code: 'SEK', englishName: 'Swedish Krona', arabicName: 'الكرونة السويدية', symbol: 'kr', decimalDigits: 2),
    AppCurrency(code: 'NOK', englishName: 'Norwegian Krone', arabicName: 'الكرونة النرويجية', symbol: 'kr', decimalDigits: 2),
    AppCurrency(code: 'DKK', englishName: 'Danish Krone', arabicName: 'الكرونة الدنماركية', symbol: 'kr', decimalDigits: 2),
    AppCurrency(code: 'PLN', englishName: 'Polish Zloty', arabicName: 'الزلوتي البولندي', symbol: 'zł', decimalDigits: 2),
    AppCurrency(code: 'CZK', englishName: 'Czech Koruna', arabicName: 'الكورونا التشيكية', symbol: 'Kč', decimalDigits: 2),
    AppCurrency(code: 'HUF', englishName: 'Hungarian Forint', arabicName: 'الفورنت المجري', symbol: 'Ft', decimalDigits: 2),
    AppCurrency(code: 'RON', englishName: 'Romanian Leu', arabicName: 'اللي الروماني', symbol: 'lei', decimalDigits: 2),
    AppCurrency(code: 'BGN', englishName: 'Bulgarian Lev', arabicName: 'الليف البلغاري', symbol: 'лв', decimalDigits: 2),
    AppCurrency(code: 'RSD', englishName: 'Serbian Dinar', arabicName: 'الدينار الصربي', symbol: 'дин.', decimalDigits: 2),
    AppCurrency(code: 'BAM', englishName: 'Bosnia and Herzegovina Mark', arabicName: 'المارك البوسني', symbol: 'KM', decimalDigits: 2),
    AppCurrency(code: 'ALL', englishName: 'Albanian Lek', arabicName: 'الليك الألباني', symbol: 'L', decimalDigits: 2),
    AppCurrency(code: 'MKD', englishName: 'Macedonian Denar', arabicName: 'الدينار المقدوني', symbol: 'ден', decimalDigits: 2),
    AppCurrency(code: 'MDL', englishName: 'Moldovan Leu', arabicName: 'الليو المولدوفي', symbol: 'L', decimalDigits: 2),
    AppCurrency(code: 'UAH', englishName: 'Ukrainian Hryvnia', arabicName: 'الهريفنيا الأوكرانية', symbol: '₴', decimalDigits: 2),
    AppCurrency(code: 'GEL', englishName: 'Georgian Lari', arabicName: 'اللاري الجورجي', symbol: '₾', decimalDigits: 2),
    AppCurrency(code: 'AMD', englishName: 'Armenian Dram', arabicName: 'الدرام الأرميني', symbol: '֏', decimalDigits: 2),
    AppCurrency(code: 'AZN', englishName: 'Azerbaijani Manat', arabicName: 'المانات الأذربيجاني', symbol: '₼', decimalDigits: 2),
    AppCurrency(code: 'KZT', englishName: 'Kazakhstani Tenge', arabicName: 'التينغ الكازاخستاني', symbol: '₸', decimalDigits: 2),
    AppCurrency(code: 'UZS', englishName: 'Uzbekistani Som', arabicName: 'السوم الأوزبكي', symbol: 'so\'m', decimalDigits: 2),
    AppCurrency(code: 'BDT', englishName: 'Bangladeshi Taka', arabicName: 'التاكا البنغلاديشية', symbol: '৳', decimalDigits: 2),
    AppCurrency(code: 'LKR', englishName: 'Sri Lankan Rupee', arabicName: 'الروبية السريلانكية', symbol: 'Rs', decimalDigits: 2),
    AppCurrency(code: 'NPR', englishName: 'Nepalese Rupee', arabicName: 'الروبية النيبالية', symbol: 'रू', decimalDigits: 2),
    AppCurrency(code: 'MMK', englishName: 'Myanmar Kyat', arabicName: 'الكيات البورمي', symbol: 'K', decimalDigits: 2),
    AppCurrency(code: 'KHR', englishName: 'Cambodian Riel', arabicName: 'الريال الكمبودي', symbol: '៛', decimalDigits: 2),
    AppCurrency(code: 'LAK', englishName: 'Lao Kip', arabicName: 'الكيب اللاوسي', symbol: '₭', decimalDigits: 2),
    AppCurrency(code: 'BND', englishName: 'Brunei Dollar', arabicName: 'دولار بروني', symbol: '\$', decimalDigits: 2),
    AppCurrency(code: 'TWD', englishName: 'New Taiwan Dollar', arabicName: 'دولار تايواني جديد', symbol: 'NT\$', decimalDigits: 2),
    AppCurrency(code: 'NGN', englishName: 'Nigerian Naira', arabicName: 'النايرا النيجيرية', symbol: '₦', decimalDigits: 2),
    AppCurrency(code: 'KES', englishName: 'Kenyan Shilling', arabicName: 'الشلن الكيني', symbol: 'KSh', decimalDigits: 2),
    AppCurrency(code: 'GHS', englishName: 'Ghanaian Cedi', arabicName: 'السيدي الغاني', symbol: 'GH₵', decimalDigits: 2),
    AppCurrency(code: 'TZS', englishName: 'Tanzanian Shilling', arabicName: 'الشلن التنزاني', symbol: 'TSh', decimalDigits: 2),
    AppCurrency(code: 'UGX', englishName: 'Ugandan Shilling', arabicName: 'الشلن الأوغندي', symbol: 'USh', decimalDigits: 0),
    AppCurrency(code: 'ETB', englishName: 'Ethiopian Birr', arabicName: 'البر الإثيوبي', symbol: 'Br', decimalDigits: 2),
    AppCurrency(code: 'RWF', englishName: 'Rwandan Franc', arabicName: 'الفرنك الرواندي', symbol: 'FRw', decimalDigits: 0),
    AppCurrency(code: 'MUR', englishName: 'Mauritian Rupee', arabicName: 'الروبية الموريشية', symbol: 'Rs', decimalDigits: 2),
    AppCurrency(code: 'BWP', englishName: 'Botswana Pula', arabicName: 'البولا البوتسوانية', symbol: 'P', decimalDigits: 2),
    AppCurrency(code: 'NAD', englishName: 'Namibian Dollar', arabicName: 'الدولار الناميبي', symbol: 'N\$', decimalDigits: 2),
    AppCurrency(code: 'ZMW', englishName: 'Zambian Kwacha', arabicName: 'الكواشا الزامبية', symbol: 'ZK', decimalDigits: 2),
    AppCurrency(code: 'MZN', englishName: 'Mozambican Metical', arabicName: 'المتيكال الموزمبيقي', symbol: 'MT', decimalDigits: 2),
    AppCurrency(code: 'AOA', englishName: 'Angolan Kwanza', arabicName: 'الكوانزا الأنغولية', symbol: 'Kz', decimalDigits: 2),
    AppCurrency(code: 'COP', englishName: 'Colombian Peso', arabicName: 'البيزو الكولومبي', symbol: '\$', decimalDigits: 2),
    AppCurrency(code: 'CLP', englishName: 'Chilean Peso', arabicName: 'البيزو التشيلي', symbol: '\$', decimalDigits: 0),
    AppCurrency(code: 'ARS', englishName: 'Argentine Peso', arabicName: 'البيزو الأرجنتيني', symbol: '\$', decimalDigits: 2),
    AppCurrency(code: 'PEN', englishName: 'Peruvian Sol', arabicName: 'السول البيروفي', symbol: 'S/', decimalDigits: 2),
    AppCurrency(code: 'UYU', englishName: 'Uruguayan Peso', arabicName: 'البيزو الأوروغواياني', symbol: '\$U', decimalDigits: 2),
    AppCurrency(code: 'PYG', englishName: 'Paraguayan Guarani', arabicName: 'الغواراني الباراغواياني', symbol: '₲', decimalDigits: 0),
    AppCurrency(code: 'BOB', englishName: 'Bolivian Boliviano', arabicName: 'البوليفيانو البوليفي', symbol: 'Bs.', decimalDigits: 2),
    AppCurrency(code: 'CRC', englishName: 'Costa Rican Colon', arabicName: 'الكولون الكوستاريكي', symbol: '₡', decimalDigits: 2),
    AppCurrency(code: 'DOP', englishName: 'Dominican Peso', arabicName: 'البيزو الدومينيكاني', symbol: 'RD\$', decimalDigits: 2),
    AppCurrency(code: 'GTQ', englishName: 'Guatemalan Quetzal', arabicName: 'الكيتزال الغواتيمالي', symbol: 'Q', decimalDigits: 2),
    AppCurrency(code: 'HNL', englishName: 'Honduran Lempira', arabicName: 'الليمبيرا الهندوراسية', symbol: 'L', decimalDigits: 2),
    AppCurrency(code: 'NIO', englishName: 'Nicaraguan Cordoba', arabicName: 'الكوردوبا النيكاراغوية', symbol: 'C\$', decimalDigits: 2),
    AppCurrency(code: 'PAB', englishName: 'Panamanian Balboa', arabicName: 'البالبوا البنمي', symbol: 'B/.', decimalDigits: 2),
    AppCurrency(code: 'JMD', englishName: 'Jamaican Dollar', arabicName: 'الدولار الجامايكي', symbol: 'J\$', decimalDigits: 2),
    AppCurrency(code: 'TTD', englishName: 'Trinidad and Tobago Dollar', arabicName: 'دولار ترينيداد وتوباغو', symbol: 'TT\$', decimalDigits: 2),
    AppCurrency(code: 'BBD', englishName: 'Barbadian Dollar', arabicName: 'الدولار البربادوسي', symbol: 'Bds\$', decimalDigits: 2),
    AppCurrency(code: 'BSD', englishName: 'Bahamian Dollar', arabicName: 'الدولار البهامي', symbol: 'B\$', decimalDigits: 2),
    AppCurrency(code: 'BZD', englishName: 'Belize Dollar', arabicName: 'دولار بليز', symbol: 'BZ\$', decimalDigits: 2),
    AppCurrency(code: 'GYD', englishName: 'Guyanese Dollar', arabicName: 'الدولار الغياني', symbol: 'G\$', decimalDigits: 2),
    AppCurrency(code: 'SRD', englishName: 'Surinamese Dollar', arabicName: 'الدولار السورينامي', symbol: 'Sr\$', decimalDigits: 2),
    AppCurrency(code: 'XCD', englishName: 'East Caribbean Dollar', arabicName: 'دولار شرق الكاريبي', symbol: 'EC\$', decimalDigits: 2),
    AppCurrency(code: 'AWG', englishName: 'Aruban Florin', arabicName: 'فلورين أروبي', symbol: 'Afl.', decimalDigits: 2),
    AppCurrency(code: 'ANG', englishName: 'Netherlands Antillean Guilder', arabicName: 'غيلدر الأنتيل الهولندية', symbol: 'NAƒ', decimalDigits: 2),
    AppCurrency(code: 'ISK', englishName: 'Icelandic Krona', arabicName: 'الكرونة الآيسلندية', symbol: 'kr', decimalDigits: 0),
    AppCurrency(code: 'RUB', englishName: 'Russian Ruble', arabicName: 'الروبل الروسي', symbol: '₽', decimalDigits: 2),
    AppCurrency(code: 'BYN', englishName: 'Belarusian Ruble', arabicName: 'الروبل البيلاروسي', symbol: 'Br', decimalDigits: 2),
    AppCurrency(code: 'AFN', englishName: 'Afghan Afghani', arabicName: 'الأفغاني', symbol: '؋', decimalDigits: 2),
    AppCurrency(code: 'MNT', englishName: 'Mongolian Tugrik', arabicName: 'التوغروغ المنغولي', symbol: '₮', decimalDigits: 2),
    AppCurrency(code: 'MOP', englishName: 'Macanese Pataca', arabicName: 'باتاكا ماكاوية', symbol: 'MOP\$', decimalDigits: 2),
    AppCurrency(code: 'FJD', englishName: 'Fijian Dollar', arabicName: 'الدولار الفيجي', symbol: 'FJ\$', decimalDigits: 2),
    AppCurrency(code: 'PGK', englishName: 'Papua New Guinean Kina', arabicName: 'الكينا البابوية', symbol: 'K', decimalDigits: 2),
    AppCurrency(code: 'WST', englishName: 'Samoan Tala', arabicName: 'تالا ساموا', symbol: 'WS\$', decimalDigits: 2),
    AppCurrency(code: 'VUV', englishName: 'Vanuatu Vatu', arabicName: 'الفاتو الفانواتي', symbol: 'VT', decimalDigits: 0),
    AppCurrency(code: 'SBD', englishName: 'Solomon Islands Dollar', arabicName: 'دولار جزر سليمان', symbol: 'SI\$', decimalDigits: 2),
    AppCurrency(code: 'TOP', englishName: 'Tongan Paʻanga', arabicName: 'بانغا تونغا', symbol: 'T\$', decimalDigits: 2),
    AppCurrency(code: 'CVE', englishName: 'Cape Verdean Escudo', arabicName: 'الإسكودو الرأس أخضري', symbol: '\$', decimalDigits: 2),
    AppCurrency(code: 'GMD', englishName: 'Gambian Dalasi', arabicName: 'الدالاسي الغامبي', symbol: 'D', decimalDigits: 2),
    AppCurrency(code: 'GNF', englishName: 'Guinean Franc', arabicName: 'الفرنك الغيني', symbol: 'FG', decimalDigits: 0),
    AppCurrency(code: 'SLE', englishName: 'Sierra Leonean Leone', arabicName: 'ليون سيراليوني', symbol: 'Le', decimalDigits: 2),
    AppCurrency(code: 'LRD', englishName: 'Liberian Dollar', arabicName: 'الدولار الليبيري', symbol: 'L\$', decimalDigits: 2),
    AppCurrency(code: 'MRU', englishName: 'Mauritanian Ouguiya', arabicName: 'الأوقية الموريتانية', symbol: 'UM', decimalDigits: 2),
    AppCurrency(code: 'STN', englishName: 'Sao Tome and Principe Dobra', arabicName: 'الدوبرا الساو تومية', symbol: 'Db', decimalDigits: 2),
    AppCurrency(code: 'XOF', englishName: 'West African CFA Franc', arabicName: 'فرنك غرب أفريقي', symbol: 'CFA', decimalDigits: 0),
    AppCurrency(code: 'XAF', englishName: 'Central African CFA Franc', arabicName: 'فرنك وسط أفريقي', symbol: 'FCFA', decimalDigits: 0),
    AppCurrency(code: 'XPF', englishName: 'CFP Franc', arabicName: 'فرنك س ف ب', symbol: '₣', decimalDigits: 0),
    AppCurrency(code: 'CDF', englishName: 'Congolese Franc', arabicName: 'الفرنك الكونغولي', symbol: 'FC', decimalDigits: 2),
    AppCurrency(code: 'BIF', englishName: 'Burundian Franc', arabicName: 'الفرنك البوروندي', symbol: 'FBu', decimalDigits: 0),
    AppCurrency(code: 'DJF', englishName: 'Djiboutian Franc', arabicName: 'الفرنك الجيبوتي', symbol: 'Fdj', decimalDigits: 0),
    AppCurrency(code: 'KMF', englishName: 'Comorian Franc', arabicName: 'الفرنك القمري', symbol: 'CF', decimalDigits: 0),
    AppCurrency(code: 'SOS', englishName: 'Somali Shilling', arabicName: 'الشلن الصومالي', symbol: 'Sh.So.', decimalDigits: 2),
    AppCurrency(code: 'SZL', englishName: 'Eswatini Lilangeni', arabicName: 'الليلانغيني الإسواتيني', symbol: 'E', decimalDigits: 2),
    AppCurrency(code: 'LSL', englishName: 'Lesotho Loti', arabicName: 'اللوتي الليسوتي', symbol: 'L', decimalDigits: 2),
    AppCurrency(code: 'MGA', englishName: 'Malagasy Ariary', arabicName: 'الأرياري المدغشقري', symbol: 'Ar', decimalDigits: 2),
    AppCurrency(code: 'SCR', englishName: 'Seychellois Rupee', arabicName: 'الروبية السيشيلية', symbol: 'SR', decimalDigits: 2),
    AppCurrency(code: 'MWK', englishName: 'Malawian Kwacha', arabicName: 'الكواشا الملاوية', symbol: 'MK', decimalDigits: 2),
    AppCurrency(code: 'ZWG', englishName: 'Zimbabwean Gold', arabicName: 'الذهب الزيمبابوي', symbol: 'ZiG', decimalDigits: 2),
    AppCurrency(code: 'SSP', englishName: 'South Sudanese Pound', arabicName: 'الجنيه الجنوب سوداني', symbol: 'SS£', decimalDigits: 2),
    AppCurrency(code: 'ERN', englishName: 'Eritrean Nakfa', arabicName: 'الناكفا الإريترية', symbol: 'Nfk', decimalDigits: 2),
    AppCurrency(code: 'CUP', englishName: 'Cuban Peso', arabicName: 'البيزو الكوبي', symbol: '\$', decimalDigits: 2),
    AppCurrency(code: 'HTG', englishName: 'Haitian Gourde', arabicName: 'الغورد الهايتي', symbol: 'G', decimalDigits: 2),
    AppCurrency(code: 'KGS', englishName: 'Kyrgyzstani Som', arabicName: 'السوم القيرغيزستاني', symbol: 'сом', decimalDigits: 2),
    AppCurrency(code: 'TJS', englishName: 'Tajikistani Somoni', arabicName: 'الساماني الطاجيكي', symbol: 'ЅМ', decimalDigits: 2),
    AppCurrency(code: 'TMT', englishName: 'Turkmenistani Manat', arabicName: 'المانات التركماني', symbol: 'T', decimalDigits: 2),
    AppCurrency(code: 'MVR', englishName: 'Maldivian Rufiyaa', arabicName: 'الروفيا المالديفية', symbol: 'Rf', decimalDigits: 2),
    AppCurrency(code: 'BTN', englishName: 'Bhutanese Ngultrum', arabicName: 'النغولتروم البوتاني', symbol: 'Nu.', decimalDigits: 2),
    AppCurrency(code: 'KPW', englishName: 'North Korean Won', arabicName: 'الوون الكوري الشمالي', symbol: '₩', decimalDigits: 2),
    AppCurrency(code: 'SYP', englishName: 'Syrian Pound', arabicName: 'الليرة السورية', symbol: 'LS', decimalDigits: 2),
    AppCurrency(code: 'IRR', englishName: 'Iranian Rial', arabicName: 'الريال الإيراني', symbol: '﷼', decimalDigits: 2),
    AppCurrency(code: 'SHP', englishName: 'Saint Helena Pound', arabicName: 'جنيه سانت هيلانة', symbol: '£', decimalDigits: 2),
    AppCurrency(code: 'GIP', englishName: 'Gibraltar Pound', arabicName: 'جنيه جبل طارق', symbol: '£', decimalDigits: 2),
    AppCurrency(code: 'FKP', englishName: 'Falkland Islands Pound', arabicName: 'جنيه جزر فوكلاند', symbol: '£', decimalDigits: 2),
    AppCurrency(code: 'KYD', englishName: 'Cayman Islands Dollar', arabicName: 'دولار جزر كايمان', symbol: 'CI\$', decimalDigits: 2),
    AppCurrency(code: 'BMD', englishName: 'Bermudian Dollar', arabicName: 'الدولار البرمودي', symbol: 'BD\$', decimalDigits: 2),
  ];

  static final Map<String, AppCurrency> _byCode = {
    for (final c in allCurrencies) c.code.toUpperCase(): c,
  };

  /// Strict non-guessing lookup: returns null if the currency code is unrecognized.
  static AppCurrency? tryFromCode(String? code) {
    if (code == null || code.trim().isEmpty) return null;
    return _byCode[code.trim().toUpperCase()];
  }

  /// Explicit default lookup for places where product behavior genuinely mandates a default.
  static AppCurrency fromCode(String? code, {AppCurrency fallback = AppCurrency.sar}) {
    return tryFromCode(code) ?? fallback;
  }

  /// Fast offline search by code, English name, Arabic name, or symbol.
  static List<AppCurrency> search(String query) {
    final clean = query.trim().toLowerCase();
    if (clean.isEmpty) return allCurrencies;
    return allCurrencies.where((c) {
      return c.code.toLowerCase().contains(clean) ||
          c.englishName.toLowerCase().contains(clean) ||
          c.arabicName.toLowerCase().contains(clean) ||
          c.symbol.toLowerCase().contains(clean);
    }).toList();
  }
}
