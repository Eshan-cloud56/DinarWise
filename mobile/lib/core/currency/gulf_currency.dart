import 'package:intl/intl.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCurrencyProvider = Provider<GulfCurrency>(
  (ref) => GulfCurrency.fromCode(
    ref.watch(onboardingControllerProvider).requireValue.currencyCode,
  ),
);

class GulfCurrency {
  const GulfCurrency({
    required this.code,
    required this.englishName,
    required this.arabicName,
    required this.symbol,
    required this.decimalDigits,
  });

  final String code;
  final String englishName;
  final String arabicName;
  final String symbol;
  final int decimalDigits;

  // DinarWise keeps a stable hundredth-based ledger so changing the display
  // currency never changes, rescales, or corrupts existing household records.
  int get minorFactor => 100;

  int toMinor(num major) => (major * minorFactor).round();
  double toMajor(int minor) => minor / minorFactor;

  NumberFormat formatter(String locale) => NumberFormat.currency(
        name: code,
        symbol: '$code ',
        decimalDigits: decimalDigits,
        locale: locale,
      );

  String name(String languageCode) =>
      languageCode == 'ar' ? arabicName : englishName;

  static const supported = [
    GulfCurrency(
      code: 'SAR',
      englishName: 'Saudi Riyal',
      arabicName: 'الريال السعودي',
      symbol: 'ر.س',
      decimalDigits: 2,
    ),
    GulfCurrency(
      code: 'AED',
      englishName: 'UAE Dirham',
      arabicName: 'الدرهم الإماراتي',
      symbol: 'د.إ',
      decimalDigits: 2,
    ),
    GulfCurrency(
      code: 'KWD',
      englishName: 'Kuwaiti Dinar',
      arabicName: 'الدينار الكويتي',
      symbol: 'د.ك',
      decimalDigits: 3,
    ),
    GulfCurrency(
      code: 'BHD',
      englishName: 'Bahraini Dinar',
      arabicName: 'الدينار البحريني',
      symbol: 'د.ب',
      decimalDigits: 3,
    ),
    GulfCurrency(
      code: 'QAR',
      englishName: 'Qatari Riyal',
      arabicName: 'الريال القطري',
      symbol: 'ر.ق',
      decimalDigits: 2,
    ),
    GulfCurrency(
      code: 'OMR',
      englishName: 'Omani Rial',
      arabicName: 'الريال العُماني',
      symbol: 'ر.ع',
      decimalDigits: 3,
    ),
  ];

  static GulfCurrency fromCode(String? code) => supported.firstWhere(
        (item) => item.code == code,
        orElse: () => supported.first,
      );
}
