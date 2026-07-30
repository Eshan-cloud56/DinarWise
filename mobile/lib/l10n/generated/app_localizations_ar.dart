// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'دينار وايز';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get languageSelectionTitle => 'اختر لغتك';

  @override
  String get languageSelectionSubtitle =>
      'يمكنك تغيير اللغة لاحقًا من الإعدادات.';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get welcomeTitle => 'أهلاً بك في دينار وايز';

  @override
  String get welcomeSubtitle => 'إرشادات مالية يومية مصممة لحياتك.';

  @override
  String get privacyConsentPrefix => 'لقد قرأت ';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get privacyConsentSuffix => ' وأوافق عليها.';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get privacyOpenError =>
      'تعذر فتح سياسة الخصوصية. يرجى المحاولة مرة أخرى.';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get recordedExpenses => 'المصروفات المسجلة';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpenses => 'إجمالي المصروفات';

  @override
  String get remainingBalance => 'الرصيد المتبقي';

  @override
  String get yourRemainingBalanceIs => 'رصيدك المتبقي هو';

  @override
  String get addIncome => 'إضافة دخل';

  @override
  String get editIncome => 'تعديل الدخل';

  @override
  String get incomeAmount => 'مبلغ الدخل';

  @override
  String get incomeSaved => 'تم حفظ الدخل بنجاح';

  @override
  String get incomeDeleted => 'تم حذف الدخل';

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملة',
      many: '$count معاملة',
      few: '$count معاملات',
      two: 'معاملتان',
      one: 'معاملة واحدة',
      zero: 'لا توجد معاملات',
    );
    return '$_temp0';
  }

  @override
  String get recentTransactions => 'المعاملات الأخيرة';

  @override
  String get addExpense => 'إضافة مصروف';

  @override
  String get addTransaction => 'إضافة معاملة';

  @override
  String get expense => 'مصروف';

  @override
  String get income => 'دخل';

  @override
  String get noExpenses => 'لا توجد مصروفات بعد';

  @override
  String get noExpensesDescription => 'اضغط «إضافة مصروف» لتسجيل أول مصروف.';

  @override
  String get noTransactions => 'لا توجد معاملات بعد';

  @override
  String get noTransactionsDescription =>
      'أضف الدخل أولاً، ثم سجّل مصروفات المنزل.';

  @override
  String get merchant => 'المتجر';

  @override
  String get amount => 'المبلغ';

  @override
  String get category => 'الفئة';

  @override
  String get notesOptional => 'ملاحظات (اختياري)';

  @override
  String get date => 'التاريخ';

  @override
  String get saveExpense => 'حفظ المصروف';

  @override
  String get saving => 'جارٍ الحفظ…';

  @override
  String get expenseSaved => 'تم حفظ المصروف بنجاح';

  @override
  String get transactionSaved => 'تم حفظ المعاملة بنجاح';

  @override
  String get enterExpenseDetails => 'أدخل تفاصيل المصروف';

  @override
  String get enterTransactionDetails => 'أدخل تفاصيل المعاملة';

  @override
  String get manualExpenseHint => 'يعمل التتبع اليدوي دون اتصال بالإنترنت.';

  @override
  String get enterMerchant => 'أدخل اسم المتجر';

  @override
  String get enterValidAmount => 'أدخل مبلغًا صحيحًا';

  @override
  String get insufficientBalance =>
      'يتجاوز هذا المصروف رصيدك المتبقي. أضف دخلاً أو أدخل مبلغًا أقل.';

  @override
  String get incomeReductionBlocked =>
      'لا يمكن تقليل هذا الدخل أو حذفه لأن ذلك سيجعل الرصيد المتبقي سالبًا.';

  @override
  String get transactionNotFound => 'لم تعد هذه المعاملة موجودة.';

  @override
  String get restaurants => 'المطاعم والمقاهي';

  @override
  String get groceries => 'البقالة';

  @override
  String get fuel => 'الوقود';

  @override
  String get transportation => 'المواصلات';

  @override
  String get shopping => 'التسوق';

  @override
  String get healthcare => 'الرعاية الصحية';

  @override
  String get utilities => 'الخدمات';

  @override
  String get subscriptions => 'الاشتراكات';

  @override
  String get bnplPayment => 'دفعة اشترِ الآن وادفع لاحقًا';

  @override
  String get other => 'أخرى';

  @override
  String get customCategory => 'فئة مخصصة';

  @override
  String get customCategoryName => 'اسم الفئة';

  @override
  String get createCustomCategory => 'إنشاء فئة مخصصة';

  @override
  String get customCategoryEmpty => 'أدخل اسم الفئة';

  @override
  String get customCategoryTooLong => 'يجب ألا يتجاوز اسم الفئة 50 حرفًا';

  @override
  String get customCategoryDuplicate => 'توجد فئة بهذا الاسم بالفعل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get create => 'إنشاء';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get deleteExpenseTitle => 'حذف المصروف؟';

  @override
  String get deleteExpenseMessage => 'سيتم حذف هذا المصروف نهائيًا.';

  @override
  String get deleteTransactionTitle => 'حذف المعاملة؟';

  @override
  String get deleteTransactionMessage => 'سيتم حذف هذه المعاملة نهائيًا.';

  @override
  String get editTransaction => 'تعديل المعاملة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get confirm => 'تأكيد';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get customCategories => 'الفئات المخصصة';

  @override
  String get noCustomCategories => 'لا توجد فئات مخصصة بعد';

  @override
  String get categoryInUse =>
      'تُستخدم هذه الفئة في سجلات حالية. انقل تلك السجلات إلى فئة أخرى قبل حذفها.';

  @override
  String get deleteCategoryTitle => 'حذف الفئة؟';

  @override
  String get deleteCategoryMessage => 'سيتم حذف هذه الفئة المخصصة نهائيًا.';

  @override
  String get resetApplicationData => 'إعادة تعيين بيانات التطبيق';

  @override
  String get resetDataTitle => 'إعادة تعيين دينار وايز نهائيًا؟';

  @override
  String get resetDataMessage =>
      'سيؤدي ذلك إلى حذف المصروفات والدخل والميزانيات والأهداف والفئات المخصصة وخطط الدفع الآجل والفواتير والاشتراكات وإعدادات التطبيق نهائيًا. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get resetDataConfirmation => 'حذف جميع البيانات';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get financialPlanning => 'التخطيط المالي';

  @override
  String get budgets => 'الميزانيات';

  @override
  String get savingsGoals => 'أهداف الادخار';

  @override
  String get bnplPlans => 'خطط اشترِ الآن وادفع لاحقًا';

  @override
  String get billsAndSubscriptions => 'الفواتير والاشتراكات';

  @override
  String get comingSoon => 'لا توجد سجلات بعد';

  @override
  String get add => 'إضافة';

  @override
  String get name => 'الاسم';

  @override
  String get targetAmount => 'المبلغ المستهدف';

  @override
  String get purchaseAmount => 'مبلغ الشراء';

  @override
  String get budgetLimit => 'حد الميزانية';

  @override
  String get dueDate => 'تاريخ الاستحقاق';

  @override
  String get save => 'حفظ';

  @override
  String get recordCreated => 'تم الحفظ بنجاح';

  @override
  String get safeToSpend => 'المبلغ الآمن للإنفاق';

  @override
  String get availableUntilPayday => 'المتاح حتى موعد الراتب';

  @override
  String get dailySafeToSpend => 'المتاح للإنفاق اليوم';

  @override
  String get salaryCycle => 'دورة الراتب';

  @override
  String get reports => 'التقارير';

  @override
  String get weeklySummary => 'الملخص الأسبوعي';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get offlineReady => 'سجلاتك المالية متاحة دون اتصال بالإنترنت.';

  @override
  String get offlineAiMessage =>
      'تتطلب ميزة الذكاء الاصطناعي هذه اتصالاً بالإنترنت. لا يزال بإمكانك إضافة المصروف يدويًا.';

  @override
  String get addManually => 'إضافة يدويًا';

  @override
  String get aiFeature => 'ميزة الذكاء الاصطناعي';

  @override
  String get search => 'بحث';

  @override
  String get filter => 'تصفية';

  @override
  String get allCategories => 'جميع الفئات';

  @override
  String get noResults => 'لم يتم العثور على نتائج';

  @override
  String get back => 'رجوع';

  @override
  String get close => 'إغلاق';

  @override
  String get currencySar => 'ر.س.';

  @override
  String get unknownError => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get databaseError => 'تعذر حفظ التغييرات. يرجى المحاولة مرة أخرى.';

  @override
  String privacyVersion(String version) {
    return 'إصدار سياسة الخصوصية $version';
  }

  @override
  String get history => 'سجل المعاملات';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get searchTransactions =>
      'ابحث بالمتجر أو الملاحظات أو الفئة أو المبلغ';

  @override
  String get allTransactions => 'الكل';

  @override
  String get dateRange => 'نطاق التاريخ';

  @override
  String get clearFilters => 'مسح عوامل التصفية';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get highestAmountFirst => 'الأعلى مبلغًا أولاً';

  @override
  String get lowestAmountFirst => 'الأقل مبلغًا أولاً';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String get dailyIncome => 'الدخل';

  @override
  String get dailyExpense => 'المصروفات';

  @override
  String get dailyNet => 'الصافي';

  @override
  String get duplicate => 'تكرار';

  @override
  String get transactionDuplicated => 'تم تكرار المعاملة';

  @override
  String get noMatchingTransactions => 'لا توجد معاملات تطابق عوامل التصفية';

  @override
  String get selectDateRange => 'اختر نطاق التاريخ';

  @override
  String get filters => 'عوامل التصفية';

  @override
  String get analytics => 'التحليلات والتقارير';

  @override
  String get customDateRange => 'نطاق تاريخ مخصص';

  @override
  String get averageDailySpending => 'متوسط الإنفاق اليومي';

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get weekComparison => 'هذا الأسبوع مقارنة بالأسبوع الماضي';

  @override
  String get monthComparison => 'هذا الشهر مقارنة بالشهر الماضي';

  @override
  String get currentPeriod => 'الفترة الحالية';

  @override
  String get previousPeriod => 'الفترة السابقة';

  @override
  String get monthlySpendingTrend => 'اتجاه الإنفاق الشهري';

  @override
  String get categoryBreakdown => 'الإنفاق حسب الفئة';

  @override
  String get localInsights => 'ملاحظة مالية دون اتصال';

  @override
  String get highestSpendingMerchant => 'المتجر الأعلى إنفاقًا';

  @override
  String get highestSpendingCategory => 'الفئة الأعلى إنفاقًا';

  @override
  String get notEnoughComparisonData =>
      'أضف المزيد من المعاملات لعرض مقارنة بين الفترات.';

  @override
  String spendingIncreased(int percent) {
    return 'زاد إنفاقك بنسبة $percent% مقارنة بالشهر السابق.';
  }

  @override
  String spendingDecreased(int percent) {
    return 'انخفض إنفاقك بنسبة $percent% مقارنة بالشهر السابق.';
  }

  @override
  String get spendingCalendar => 'تقويم الإنفاق';

  @override
  String get calendarView => 'عرض التقويم';

  @override
  String get listView => 'عرض القائمة';

  @override
  String get mondayFirst => 'يبدأ الأسبوع يوم الاثنين';

  @override
  String get sundayFirst => 'يبدأ الأسبوع يوم الأحد';

  @override
  String get showHijriDates => 'عرض التاريخ الهجري';
}
