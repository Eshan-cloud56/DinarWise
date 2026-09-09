// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get saveIncomeLabel => 'حفظ الدخل';

  @override
  String get brandTitle => 'دينار وايز';

  @override
  String get transactionsLabel => 'المصروفات';

  @override
  String get planningLabel => 'التخطيط';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get homeLabel => 'الرئيسية';

  @override
  String get dashboardWelcome => 'ميزانية منزلك بين يديك.';

  @override
  String get localRecordsLabel => 'السجلات المالية محفوظة على هذا الجهاز';

  @override
  String get availableToSpend => 'المتاح للإنفاق';

  @override
  String get safeToSpendToday => 'المتاح للإنفاق اليوم';

  @override
  String get quickServices => 'خدمات سريعة';

  @override
  String get scanBill => 'إرفاق فاتورة';

  @override
  String get transferLabel => 'تحويل';

  @override
  String get transferUnavailable =>
      'التحويل بين الحسابات غير متاح. يتتبع دينار وايز دخل المنزل ومصروفاته دون تحويلات بنكية.';

  @override
  String get smartInsights => 'رؤى مالية';

  @override
  String get spendingBreakdown => 'توزيع الإنفاق';

  @override
  String get recentActivity => 'المصروفات الأخيرة';

  @override
  String get insightsLabel => 'الرؤى';

  @override
  String get cashFlow => 'التدفق النقدي الشهري';

  @override
  String get netSavings => 'صافي التوفير';

  @override
  String get savedInGoals => 'مدخرات الأهداف';

  @override
  String get perDay => '/ يوم';

  @override
  String get manualReceiptHint =>
      'أرفق إيصالًا واستخدم المسح الذكي الخاص على الجهاز، أو تابع الإدخال يدويًا.';

  @override
  String get monthPace => 'تقدم الشهر';

  @override
  String get saveExpenseLabel => 'حفظ المصروف';

  @override
  String get splitBnplLabel => 'التقسيط / خطط الدفع الآجل';

  @override
  String get manageBnplHint =>
      'أدر الأقساط ضمن تخطيط الشراء الآن والدفع لاحقًا. لا يؤدي ذلك إلى تقسيم المصروف الحالي.';

  @override
  String get thisMonthLabel => 'هذا الشهر';

  @override
  String get paymentMethodUnknown => 'وسيلة الدفع غير محددة';

  @override
  String get backspaceLabel => 'حذف الرقم الأخير';

  @override
  String get appName => 'دينار وايز: مدير المصروفات بالذكاء الاصطناعي';

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
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get privacyAcknowledgementPrefix =>
      'بالنقر على \"ابدأ\"، فإنك تقر بأنك قرأت ';

  @override
  String get privacyAcknowledgementSuffix => ' ووافقت عليها.';

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
  String get recentTransactions => 'المصروفات الأخيرة';

  @override
  String get addExpense => 'إضافة مصروف';

  @override
  String get addTransaction => 'إضافة مصروف';

  @override
  String get expense => 'مصروف';

  @override
  String get income => 'دخل';

  @override
  String get noExpenses => 'لا توجد مصروفات بعد';

  @override
  String get noExpensesDescription => 'اضغط «إضافة مصروف» لتسجيل أول مصروف.';

  @override
  String get noTransactions => 'لا توجد مصروفات بعد';

  @override
  String get noTransactionsDescription => 'ستظهر مصروفاتك المحفوظة هنا.';

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
  String get transactionSaved => 'تم حفظ المصروف بنجاح';

  @override
  String get enterExpenseDetails => 'أدخل تفاصيل المصروف';

  @override
  String get enterTransactionDetails => 'أدخل تفاصيل المصروف';

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
  String get transactionNotFound => 'هذا المصروف لم يعد موجودًا.';

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
  String get deleteTransactionTitle => 'حذف المصروف؟';

  @override
  String get deleteTransactionMessage => 'سيتم حذف هذا المصروف نهائيًا.';

  @override
  String get editTransaction => 'تعديل المصروف';

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
  String get history => 'سجل المصروفات';

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
  String get transactionDuplicated => 'تم تكرار المصروف';

  @override
  String get noMatchingTransactions => 'لا توجد مصروفات تطابق عوامل التصفية';

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

  @override
  String get addBudget => 'إضافة ميزانية';

  @override
  String get editBudget => 'تعديل الميزانية';

  @override
  String get overallBudget => 'الميزانية الشهرية الإجمالية';

  @override
  String get rollover => 'ترحيل الميزانية الشهري';

  @override
  String get noRollover => 'دون ترحيل';

  @override
  String get carryUnused => 'ترحيل المبلغ غير المستخدم';

  @override
  String get carryUnusedAndOverspending => 'ترحيل المبلغ غير المستخدم والتجاوز';

  @override
  String get budgetCycle => 'دورة الميزانية';

  @override
  String get monthly => 'شهريًا';

  @override
  String get payday => 'يوم الراتب';

  @override
  String get fixedCommitments => 'الالتزامات الثابتة';

  @override
  String get emergencyBuffer => 'احتياطي الطوارئ';

  @override
  String get budgetHistory => 'سجل الميزانية';

  @override
  String get noHistory => 'لا يوجد سجل بعد';

  @override
  String get amountSpent => 'المبلغ المنفق';

  @override
  String get amountRemaining => 'المبلغ المتبقي';

  @override
  String get used => 'مستخدم';

  @override
  String get budgetOverspent => 'تم تجاوز هذه الميزانية.';

  @override
  String budgetWarning(int percent) {
    return 'لقد استخدمت $percent% من هذه الميزانية.';
  }

  @override
  String daysUntilPayday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أيام حتى الراتب',
      two: 'يومان حتى الراتب',
      one: 'يوم واحد حتى الراتب',
      zero: 'موعد الراتب اليوم',
    );
    return '$_temp0';
  }

  @override
  String get upcomingBills => 'الفواتير القادمة';

  @override
  String get upcomingBnpl => 'دفعات الشراء الآجل القادمة';

  @override
  String get plannedSavings => 'الادخار المخطط';

  @override
  String get remaining => 'المتبقي';

  @override
  String get goalCompleted => 'اكتمل الهدف';

  @override
  String get requiredWeekly => 'المطلوب أسبوعيًا';

  @override
  String get requiredMonthly => 'المطلوب شهريًا';

  @override
  String get addContribution => 'إضافة مساهمة';

  @override
  String get noContributions => 'لا توجد مساهمات بعد';

  @override
  String get addGoal => 'إضافة هدف ادخار';

  @override
  String get editGoal => 'تعديل هدف الادخار';

  @override
  String get goalTemplate => 'قالب الهدف';

  @override
  String get targetDate => 'التاريخ المستهدف';

  @override
  String get optional => 'اختياري';

  @override
  String get emergencyFund => 'صندوق الطوارئ';

  @override
  String get travel => 'السفر';

  @override
  String get wedding => 'الزفاف';

  @override
  String get car => 'السيارة';

  @override
  String get education => 'التعليم';

  @override
  String get hajj => 'الحج';

  @override
  String get umrah => 'العمرة';

  @override
  String get eid => 'العيد';

  @override
  String get customGoal => 'هدف مخصص';

  @override
  String get addBnplPlan => 'إضافة خطة شراء آجل';

  @override
  String get editBnplPlan => 'تعديل خطة الشراء الآجل';

  @override
  String get provider => 'مزود الخدمة';

  @override
  String get customProvider => 'مزود مخصص';

  @override
  String get providerName => 'اسم المزود';

  @override
  String get purchaseDate => 'تاريخ الشراء';

  @override
  String get paidAmount => 'المبلغ المدفوع';

  @override
  String get totalOutstandingBnpl => 'إجمالي دفعات الشراء الآجل المستحقة';

  @override
  String get completed => 'مكتمل';

  @override
  String get latePayment => 'الدفعة متأخرة';

  @override
  String get paymentHistory => 'سجل الدفعات';

  @override
  String get markedPaid => 'تم تحديدها كمدفوعة';

  @override
  String get paymentUndone => 'تم التراجع عن حالة الدفع';

  @override
  String instalmentNumber(int number) {
    return 'القسط $number';
  }

  @override
  String get instalmentTotalError =>
      'يجب أن يساوي مجموع الأقساط مبلغ الشراء تمامًا.';

  @override
  String get addRecurring => 'إضافة فاتورة أو اشتراك';

  @override
  String get editRecurring => 'تعديل فاتورة أو اشتراك';

  @override
  String get recurrence => 'التكرار';

  @override
  String get daily => 'يوميًا';

  @override
  String get weekly => 'أسبوعيًا';

  @override
  String get yearly => 'سنويًا';

  @override
  String get every => 'التكرار كل';

  @override
  String get isSubscription => 'هذا اشتراك';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get maxOccurrences => 'عدد مرات التكرار (اختياري)';

  @override
  String get lifetimePaid => 'إجمالي المدفوع طوال المدة';

  @override
  String get monthlyEquivalent => 'المعادل الشهري';

  @override
  String get paid => 'مدفوع';

  @override
  String get upcoming => 'قادم';

  @override
  String get markAsPaid => 'تحديد كمدفوع';

  @override
  String get editOneOccurrence => 'تعديل هذه الدفعة فقط';

  @override
  String get stopRecurring => 'إيقاف التكرار';

  @override
  String get ended => 'منتهي';

  @override
  String get nextBill => 'الفاتورة أو الاشتراك القادم';

  @override
  String get nextBnplPayment => 'دفعة الشراء الآجل القادمة';

  @override
  String get incomeVsExpense => 'الدخل مقابل المصروفات';

  @override
  String get spendingCharts => 'مخططات الإنفاق';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get paymentMethods => 'طرق الدفع';

  @override
  String get allPaymentMethods => 'جميع طرق الدفع';

  @override
  String get cash => 'نقدًا';

  @override
  String get debitCard => 'بطاقة خصم';

  @override
  String get creditCard => 'بطاقة ائتمان';

  @override
  String get bankTransfer => 'تحويل بنكي';

  @override
  String get paymentMethodDuplicate => 'توجد طريقة دفع بهذا الاسم بالفعل.';

  @override
  String get reassignPaymentMethod => 'انقل المعاملات قبل الحذف';

  @override
  String get reassignAndDelete => 'نقل وحذف';

  @override
  String usageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'استُخدمت $count مرات',
      two: 'استُخدمت مرتين',
      one: 'استُخدمت مرة واحدة',
      zero: 'غير مستخدمة',
    );
    return '$_temp0';
  }

  @override
  String get categoryAppearance => 'الأيقونة واللون';

  @override
  String get sortCategories => 'ترتيب الفئات';

  @override
  String get mostUsed => 'الأكثر استخدامًا';

  @override
  String get recentlyUsed => 'المستخدمة مؤخرًا';

  @override
  String get alphabetical => 'أبجديًا';

  @override
  String get reassignCategory => 'انقل السجلات المرتبطة قبل الحذف';

  @override
  String get defaultPaymentMethod => 'طريقة الدفع الافتراضية';

  @override
  String get attachReceipt => 'إرفاق الإيصال أو مسحه بذكاء';

  @override
  String get takeReceiptPhoto => 'التقاط صورة للإيصال';

  @override
  String get chooseReceiptPhoto => 'اختيار من المعرض';

  @override
  String get receiptAttached => 'تم إرفاق الإيصال';

  @override
  String get tapToView => 'اضغط للعرض';

  @override
  String get removeReceipt => 'إزالة الإيصال';

  @override
  String get receiptPickError => 'تعذر فتح صورة الإيصال. جرّب صورة أخرى.';

  @override
  String get receiptStorage => 'مساحة تخزين الإيصالات';

  @override
  String get storageUsed => 'المساحة المستخدمة';

  @override
  String get clearAllReceipts => 'مسح جميع صور الإيصالات';

  @override
  String get clearAllReceiptsMessage =>
      'سيؤدي هذا إلى حذف جميع صور الإيصالات المحفوظة نهائيًا مع الاحتفاظ بالمعاملات.';

  @override
  String get noReceipts => 'لا توجد صور إيصالات محفوظة';

  @override
  String get enableNotifications => 'تفعيل التذكيرات المحلية';

  @override
  String get notificationPermissionHint =>
      'الفواتير والاشتراكات والشراء الآجل والميزانيات والأهداف';

  @override
  String get notificationsEnabled => 'تم تفعيل التذكيرات المحلية.';

  @override
  String get notificationsDenied => 'لم يتم منح إذن الإشعارات.';

  @override
  String get backupAndExport => 'النسخ الاحتياطي والاستيراد والتصدير';

  @override
  String get exportCsv => 'تصدير المعاملات بصيغة CSV';

  @override
  String get importCsv => 'استيراد المعاملات من CSV';

  @override
  String get monthlyPdf => 'مشاركة التقرير الشهري PDF';

  @override
  String get encryptedBackup => 'إنشاء نسخة احتياطية مشفرة';

  @override
  String get restoreBackup => 'استعادة نسخة احتياطية مشفرة';

  @override
  String get backupPassword => 'كلمة مرور النسخة الاحتياطية';

  @override
  String get minimumSixCharacters => 'ستة أحرف على الأقل';

  @override
  String get restore => 'استعادة';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get operationFailed => 'تعذر إكمال العملية';

  @override
  String get importPreview => 'معاينة الاستيراد';

  @override
  String get importLabel => 'استيراد';

  @override
  String importPreviewCounts(int valid, int invalid, int duplicates) {
    return '$valid صالح، $invalid غير صالح، $duplicates مكرر';
  }

  @override
  String get restoreReplacesData =>
      'ستستبدل الاستعادة جميع البيانات المالية المحلية الحالية. إذا فشل التحقق فستبقى بياناتك الحالية دون تغيير.';

  @override
  String get applicationSecurity => 'أمان التطبيق';

  @override
  String get applicationPin => 'رمز PIN للتطبيق';

  @override
  String get pinStoredSecurely =>
      'يتم تمليح رمز PIN وتجزئته بأمان ولا يُحفظ كنص صريح.';

  @override
  String get createPin => 'إنشاء رمز PIN';

  @override
  String get verifyCurrentPin => 'التحقق من رمز PIN الحالي';

  @override
  String get pinRequirements => 'استخدم رمز PIN رقميًا من 4 إلى 8 أرقام.';

  @override
  String get changePin => 'تغيير رمز PIN';

  @override
  String get useBiometrics => 'استخدام البصمة أو الوجه';

  @override
  String get fingerprintOrFace =>
      'استخدام المصادقة الحيوية في أندرويد عند دعمها';

  @override
  String get biometricsUnavailable =>
      'المصادقة الحيوية غير متاحة على هذا الجهاز.';

  @override
  String get lockInBackground => 'قفل التطبيق عند بقائه في الخلفية';

  @override
  String get autoLockTimeout => 'مهلة القفل التلقائي';

  @override
  String get immediately => 'فورًا';

  @override
  String get seconds30 => '30 ثانية';

  @override
  String get minute1 => 'دقيقة واحدة';

  @override
  String get minutes5 => '5 دقائق';

  @override
  String get appLocked => 'DinarWise مقفل';

  @override
  String get incorrectPin => 'رمز PIN غير صحيح';

  @override
  String get unlockDinarWise => 'فتح DinarWise';

  @override
  String get unlock => 'فتح';

  @override
  String get offlineCalculators => 'حاسبات مالية دون اتصال';

  @override
  String get calculator => 'الحاسبة';

  @override
  String get budgetCalculator => 'حاسبة ميزانية 50/30/20';

  @override
  String get emergencyCalculator => 'حاسبة صندوق الطوارئ';

  @override
  String get travelCalculator => 'حاسبة ميزانية السفر';

  @override
  String get debtCalculator => 'حاسبة سداد الدين';

  @override
  String get goalCalculator => 'حاسبة هدف الادخار';

  @override
  String get compoundCalculator => 'حاسبة الفائدة المركبة';

  @override
  String get needs => 'الاحتياجات (50٪)';

  @override
  String get wants => 'الرغبات (30٪)';

  @override
  String get savings => 'الادخار (20٪)';

  @override
  String get monthlyEssentials => 'التكاليف الأساسية الشهرية';

  @override
  String get monthlyIncome => 'الدخل الشهري';

  @override
  String get currentSaved => 'المبلغ المدخر حاليًا';

  @override
  String get months => 'الأشهر';

  @override
  String get transport => 'النقل';

  @override
  String get lodging => 'السكن';

  @override
  String get dailyCost => 'التكلفة اليومية';

  @override
  String get days => 'الأيام';

  @override
  String get bufferPercent => 'الهامش (٪)';

  @override
  String get debtBalance => 'رصيد الدين';

  @override
  String get annualRate => 'نسبة الفائدة السنوية (٪)';

  @override
  String get monthlyPayment => 'الدفعة الشهرية';

  @override
  String get paymentTooLow => 'الدفعة منخفضة جدًا لسداد هذا الدين.';

  @override
  String monthCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أشهر',
      two: 'شهران',
      one: 'شهر واحد',
    );
    return '$_temp0';
  }

  @override
  String get startingAmount => 'المبلغ الابتدائي';

  @override
  String get years => 'السنوات';

  @override
  String get monthlyContribution => 'المساهمة الشهرية';

  @override
  String get calculate => 'احسب';

  @override
  String get result => 'النتيجة';

  @override
  String get calculatorDoesNotSave => 'نتائج الحاسبة لا تغير سجلاتك المالية.';

  @override
  String get chooseCurrency => 'اختر عملتك';

  @override
  String get chooseCurrencyDescription =>
      'سيستخدم DinarWise هذه العملة للدخل والمصروفات والميزانيات والتقارير.';

  @override
  String decimalPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منازل عشرية',
      two: 'منزلتان عشريتان',
      one: 'منزلة عشرية واحدة',
    );
    return '$_temp0';
  }

  @override
  String get privacyAtGlance => 'خصوصيتك في لمحة';

  @override
  String get privacyLocalRecords => 'تبقى السجلات المالية على هذا الجهاز.';

  @override
  String get privacySafeTelemetry =>
      'تساعد معلومات الاستخدام والتشخيص الآمنة في تحسين دينار وايز.';

  @override
  String get privacyNeverSent =>
      'لا تُرسل المبالغ الدقيقة أو أسماء المتاجر أو الملاحظات أو الإيصالات إلى Firebase.';

  @override
  String get readFullPrivacyPolicy => 'قراءة سياسة الخصوصية كاملة';

  @override
  String get firebasePrivacyExplanation =>
      'يستخدم دينار وايز Firebase Analytics تلقائيًا لفهم فتح التطبيق والجلسات والشاشات والتفاعل الآمن مع الميزات. ويجمع Firebase Crashlytics ومراقبة الأداء تلقائيًا معلومات آمنة عن الأعطال والأخطاء والأداء. قد تُرسل بيانات القياس إلى Firebase/Google عند توفر الإنترنت. تبقى السجلات المالية والمبالغ الدقيقة والأرصدة وأسماء المتاجر والملاحظات والإيصالات محلية ولا تُرسل. لا يستخدم دينار وايز مصادقة Firebase أو المزامنة السحابية. تم تعطيل معرّفات الإعلانات وتخصيصها.';

  @override
  String get replayAppTutorial => 'إعادة عرض دليل التطبيق';

  @override
  String get tutorialDashboardTitle => 'ملخص لوحة التحكم';

  @override
  String get tutorialDashboardDescription =>
      'اطّلع بسرعة على الرصيد المتبقي وإجمالي الدخل وإجمالي المصروفات.';

  @override
  String get tutorialIncomeTitle => 'إضافة دخل';

  @override
  String get tutorialIncomeDescription =>
      'أضف دخل الأسرة قبل تسجيل المصروفات ليتمكن دينار وايز من حماية رصيدك المتبقي.';

  @override
  String get tutorialExpenseTitle => 'إضافة مصروف';

  @override
  String get tutorialExpenseDescription =>
      'سجّل المتجر والفئة والتاريخ والملاحظات الاختيارية لكل مصروف.';

  @override
  String get tutorialTransactionsTitle => 'المصروفات الأخيرة';

  @override
  String get tutorialTransactionsDescription =>
      'استخدم عرض الكل لمراجعة مصروفاتك وتعديلها وحذفها والبحث فيها وتصفيتها.';

  @override
  String get tutorialAnalyticsTitle => 'التحليلات';

  @override
  String get tutorialAnalyticsDescription =>
      'استكشف رؤى الإنفاق والاتجاهات وملخصات الفئات المحسوبة من سجلاتك المحلية.';

  @override
  String get tutorialCategoriesTitle => 'الفئات';

  @override
  String get tutorialCategoriesDescription =>
      'افتح الإعدادات لإدارة الفئات المضمنة وإنشاء فئاتك المخصصة.';

  @override
  String get tutorialSettingsTitle => 'الإعدادات';

  @override
  String get tutorialSettingsDescription =>
      'أدر اللغة والعملة وتفضيلات التطبيق الأخرى، بما في ذلك خيارات المظهر عند دعمها.';

  @override
  String get tutorialNext => 'التالي';

  @override
  String get tutorialBack => 'السابق';

  @override
  String get tutorialSkip => 'تخطي';

  @override
  String get tutorialFinish => 'إنهاء';

  @override
  String get smartReceiptModel => 'نموذج مسح الإيصال الذكي';

  @override
  String get smartReceiptModelNotConfigured =>
      'لم يتم بعد إعداد توزيع النموذج العام لمسح الإيصال الذكي. يمكنك متابعة إدخال المصروف يدويًا.';

  @override
  String get smartReceiptUnsupported =>
      'لا يمكن لهذا الجهاز تشغيل نموذج الإيصالات المحلي. يظل الإدخال اليدوي متاحًا.';

  @override
  String get smartReceiptModelRequired =>
      'اختر ملف Gemma 3n E2B المرخّص. سيتم التحقق منه وتخزينه بشكل خاص على هذا الجهاز.';

  @override
  String get smartReceiptModelError => 'تعذّر التحقق من النموذج أو استيراده.';

  @override
  String get importModel => 'استيراد النموذج المتحقق منه';

  @override
  String get manualEntry => 'إدخال يدوي';

  @override
  String get smartScanFailed =>
      'تعذّرت قراءة الإيصال. أعد المحاولة أو أدخل المصروف يدويًا.';

  @override
  String get reviewReceiptDetails => 'مراجعة التفاصيل المكتشفة';

  @override
  String get lowConfidenceReview =>
      'بعض التفاصيل غير مؤكدة. راجع كل حقل قبل استخدامها.';

  @override
  String get useDetectedDetails => 'استخدام هذه التفاصيل';

  @override
  String get detectedCurrencyMismatch =>
      'تختلف عملة الإيصال عن عملتك المحددة، لذلك لم تتم تعبئة المبلغ.';

  @override
  String get receiptTotalsInconsistent =>
      'إجماليات الإيصال المكتشفة غير متسقة، لذلك لم تتم تعبئة المبلغ.';

  @override
  String get processingReceipt => 'تجري قراءة الإيصال بشكل خاص على جهازك…';

  @override
  String get smartScan => 'مسح ذكي';

  @override
  String get arabicMixedReceipt => 'إيصال عربي / مختلط';

  @override
  String get receiptTotal => 'الإجمالي';

  @override
  String get receiptSubtotal => 'المجموع الفرعي';

  @override
  String get receiptTax => 'ضريبة القيمة المضافة / الضريبة';

  @override
  String get receiptCurrency => 'العملة';

  @override
  String get receiptTime => 'الوقت';

  @override
  String get cardLastFour => 'آخر 4 أرقام من البطاقة';

  @override
  String get invoiceNumber => 'رقم الفاتورة / الإيصال';

  @override
  String get receiptLineItems => 'بنود الإيصال الموثوقة';
}
