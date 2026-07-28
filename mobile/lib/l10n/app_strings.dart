import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppStrings {
  AppStrings(this.locale);

  final Locale locale;
  bool get _ar => locale.languageCode == 'ar';

  static const supportedLocales = [Locale('en'), Locale('ar')];
  static const delegate = _AppStringsDelegate();
  static AppStrings of(BuildContext context) =>
      Localizations.of<AppStrings>(context, AppStrings)!;

  String get appName => 'DinarWise';
  String get welcome => _ar ? 'أهلاً بك في دينار وايز' : 'Welcome to DinarWise';
  String get onboardingSubtitle => _ar
      ? 'ميزانيتك اليومية، مصممة لحياتك'
      : 'Everyday money guidance, built for your life';
  String get continueLabel => _ar ? 'متابعة' : 'Continue';
  String get language => _ar ? 'اللغة' : 'Language';
  String get dashboard => _ar ? 'الرئيسية' : 'Home';
  String get availableUntilPayday =>
      _ar ? 'المتاح حتى الراتب' : 'Available until payday';
  String get dailySafe => _ar ? 'المتاح يومياً' : 'Safe to spend today';
  String get recentTransactions =>
      _ar ? 'المعاملات الأخيرة' : 'Recent transactions';
  String get addExpense => _ar ? 'إضافة مصروف' : 'Add expense';
  String get describeExpense =>
      _ar ? 'اكتب مصروفك بالعربية أو الإنجليزية' : 'Describe your expense';
  String get example =>
      _ar ? 'مثال: دفعت ١٢٠ ريال في كارفور' : 'Example: I spent 45 SAR at Al Baik';
  String get extract => _ar ? 'استخراج التفاصيل' : 'Extract details';
  String get confirm => _ar ? 'تأكيد وحفظ' : 'Confirm and save';
  String get reviewFirst =>
      _ar ? 'راجع التفاصيل قبل الحفظ' : 'Review before saving';
  String get merchant => _ar ? 'المتجر' : 'Merchant';
  String get amount => _ar ? 'المبلغ' : 'Amount';
  String get category => _ar ? 'الفئة' : 'Category';
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) =>
      SynchronousFuture(AppStrings(locale));

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}
