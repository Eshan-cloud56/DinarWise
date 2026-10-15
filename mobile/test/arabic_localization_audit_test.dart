import 'dart:async';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/payment_methods/payment_method_repository.dart';
import 'package:dinarwise/features/payment_methods/payment_method_providers.dart';
import 'package:dinarwise/features/settings/help_tutorials_screen.dart';
import 'package:dinarwise/features/settings/settings_screen.dart';
import 'package:dinarwise/features/tutorial/dinar_tutorial_card.dart';
import 'package:dinarwise/features/tutorial/tutorial_service.dart';
import 'package:dinarwise/features/voice_expense/application/voice_expense_coordinator.dart';
import 'package:dinarwise/features/voice_expense/models/voice_expense_draft.dart';
import 'package:dinarwise/features/voice_expense/presentation/voice_expense_modal.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _buildLocalizedHarness({
  required Widget child,
  required Locale locale,
  ProviderContainer? container,
}) {
  final app = MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  if (container != null) {
    return UncontrolledProviderScope(container: container, child: app);
  }
  return ProviderScope(child: app);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  group('Tutorial Card Localizations & RTL Layout', () {
    testWidgets('DinarTutorialCard displays Arabic controls and step counter in ar locale', (tester) async {
      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('ar'),
          child: DinarTutorialCard(
            title: 'إضافة مصروف',
            description: 'سجّل المتجر والفئة والتاريخ والملاحظات الاختيارية لكل مصروف.',
            stepIndex: 0,
            totalSteps: 3,
            onSkip: () {},
            onBack: () {},
            onNext: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('إضافة مصروف'), findsOneWidget);
      expect(find.text('تخطي'), findsOneWidget);
      expect(find.text('السابق'), findsOneWidget);
      expect(find.text('التالي'), findsOneWidget);
      expect(find.text('الخطوة 1 من 3'), findsOneWidget);
    });

    testWidgets('DinarTutorialCard displays English controls and step counter in en locale', (tester) async {
      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('en'),
          child: DinarTutorialCard(
            title: 'Add expense',
            description: 'Record the merchant, category, date and optional notes for each expense.',
            stepIndex: 0,
            totalSteps: 3,
            onSkip: () {},
            onBack: () {},
            onNext: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add expense'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Step 1 of 3'), findsOneWidget);
    });

    testWidgets('DinarTutorialCard displays Got It for single step in ar and en', (tester) async {
      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('ar'),
          child: DinarTutorialCard(
            title: 'المسح الذكي',
            description: 'امسح الإيصال بالكاميرا.',
            onGotIt: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('فهمت'), findsOneWidget);

      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('en'),
          child: DinarTutorialCard(
            title: 'Smart Scan',
            description: 'Scan receipt with camera.',
            onGotIt: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Got it'), findsOneWidget);
    });

    testWidgets('DinarTutorialCard renders without overflow in RTL on narrow viewport', (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('ar'),
          child: DinarTutorialCard(
            title: 'إضافة مصروف طويل جداً للتحقق من التوافق مع شاشات الهواتف الصغيرة',
            description: 'سجّل المتجر والفئة والتاريخ والملاحظات الاختيارية لكل مصروف بدون أي أخطاء أو قص.',
            stepIndex: 2,
            totalSteps: 3,
            onSkip: () {},
            onBack: () {},
            onNext: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('إنهاء'), findsOneWidget);
      expect(find.text('الخطوة 3 من 3'), findsOneWidget);
    });
  });

  group('Help & Tutorials Screen Localization', () {
    testWidgets('HelpTutorialsScreen renders fully in Arabic without hardcoded English', (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          tutorialServiceProvider.overrideWithValue(TutorialService(prefs)),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('ar'),
          container: container,
          child: const HelpTutorialsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('المساعدة والدروس التعليمية'), findsOneWidget);
      expect(find.text('الدروس التعليمية للميزات'), findsOneWidget);
      expect(find.text('إعادة عرض جميع الدروس'), findsOneWidget);

      // Verify feature tutorial titles in Arabic
      expect(find.text('ملخص لوحة التحكم'), findsOneWidget);
      expect(find.text('المصروفات الأخيرة'), findsOneWidget);
      expect(find.text('البحث الذكي'), findsOneWidget);
      expect(find.text('المسح الذكي للفواتير'), findsOneWidget);
      expect(find.text('المصروف الصوتي'), findsOneWidget);
      expect(find.text('الكشف التلقائي عن المعاملات'), findsOneWidget);
      expect(find.text('تنبيهات الإنفاق'), findsOneWidget);
      expect(find.text('إضافة مصروف'), findsOneWidget);
      expect(find.text('التخطيط المالي'), findsOneWidget);
      expect(find.text('التنقل في التطبيق'), findsOneWidget);
      expect(find.text('أداة الشاشة الرئيسية'), findsOneWidget);
    });

    testWidgets('HelpTutorialsScreen renders in English without regression', (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          tutorialServiceProvider.overrideWithValue(TutorialService(prefs)),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('en'),
          container: container,
          child: const HelpTutorialsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Help & Tutorials'), findsOneWidget);
      expect(find.text('Feature Tutorials'), findsOneWidget);
      expect(find.text('Replay All Feature Tutorials'), findsOneWidget);
      expect(find.text('Dashboard summary'), findsOneWidget);
      expect(find.text('Recent expenses'), findsOneWidget);
      expect(find.text('Smart Search'), findsOneWidget);
      expect(find.text('Smart Bill Scan'), findsOneWidget);
      expect(find.text('Voice Expense'), findsOneWidget);
      expect(find.text('Home Screen Widget'), findsOneWidget);
    });
  });

  group('Voice Expense Modal Localization & RTL', () {
    testWidgets('VoiceExpenseModal shows localized ready state in Arabic', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('ar'),
          container: container,
          child: const VoiceExpenseModal(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('المصروف الصوتي'), findsOneWidget);
      expect(find.text('جرّب أن تقول:'), findsOneWidget);
      expect(find.text('• “صرفت 100 ريال في البيك كاش”'), findsOneWidget);
      expect(find.text('• “أمس صرفت 80 ريال بنزين بالبطاقة”'), findsOneWidget);
      expect(find.text('اضغط للتسجيل'), findsOneWidget);
    });

    testWidgets('VoiceExpenseModal shows localized result labels and RTL banner in Arabic', (tester) async {
      final container = ProviderContainer(
        overrides: [
          categoriesProvider.overrideWith((ref) => Stream.value([
                const CategoryRecord(
                  id: 'cat-restaurants',
                  name: 'Restaurants & cafés',
                  isSystem: true,
                  systemCode: 'restaurants',
                ),
              ])),
          paymentMethodsProvider.overrideWith((ref) => Stream.value([
                const PaymentMethodDetails(
                  id: 'pm-cash',
                  systemCode: 'cash',
                  name: 'Cash',
                  iconName: 'cash',
                  isSystem: true,
                  isDefault: false,
                  usageCount: 0,
                  lastUsedAt: null,
                ),
              ])),
        ],
      );
      addTearDown(container.dispose);

      final coordinator = container.read(voiceExpenseCoordinatorProvider.notifier);
      coordinator.state = VoiceExpenseState(
        status: VoiceExpenseStatus.result,
        draft: VoiceExpenseDraft(
          rawTranscript: 'صرفت 100 ريال في البيك كاش',
          amountMinor: 10000,
          currency: 'SAR',
          merchant: 'Al Baik',
          categoryId: 'cat-restaurants',
          paymentMethodId: 'pm-cash',
          date: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('ar'),
          container: container,
          child: const VoiceExpenseModal(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('المصروف المكتشف'), findsOneWidget);
      expect(find.text('المبلغ'), findsOneWidget);
      expect(find.text('المتجر'), findsOneWidget);
      expect(find.text('الفئة'), findsOneWidget);
      expect(find.text('طريقة الدفع'), findsOneWidget);
      expect(find.text('التاريخ'), findsOneWidget);
      expect(find.text('اليوم'), findsOneWidget);
      expect(find.text('إلغاء'), findsOneWidget);
      expect(find.text('مراجعة في إضافة مصروف'), findsOneWidget);
    });

    testWidgets('VoiceExpenseModal shows Merchant Required in Arabic when merchant missing', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final coordinator = container.read(voiceExpenseCoordinatorProvider.notifier);
      coordinator.state = VoiceExpenseState(
        status: VoiceExpenseStatus.result,
        draft: VoiceExpenseDraft(
          rawTranscript: 'صرفت 100 ريال كاش',
          amountMinor: 10000,
          currency: 'SAR',
          merchant: null, // missing merchant
          paymentMethodId: null,
          date: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('ar'),
          container: container,
          child: const VoiceExpenseModal(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('مطلوب'), findsOneWidget);
      expect(
        find.textContaining('المتجر مطلوب: تم استخراج تفاصيل المصروف'),
        findsOneWidget,
      );
    });

    testWidgets('VoiceExpenseModal shows localized result in English without regression', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final coordinator = container.read(voiceExpenseCoordinatorProvider.notifier);
      coordinator.state = VoiceExpenseState(
        status: VoiceExpenseStatus.result,
        draft: VoiceExpenseDraft(
          rawTranscript: 'I spent 100 SAR at Al Baik using cash.',
          amountMinor: 10000,
          currency: 'SAR',
          merchant: 'Al Baik',
          date: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('en'),
          container: container,
          child: const VoiceExpenseModal(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Recognized Expense'), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('Merchant'), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Review in Add Expense'), findsOneWidget);
    });
  });

  group('Settings Screen Help & Tutorials Localization', () {
    testWidgets('SettingsScreen displays Help & Tutorials in Arabic and English', (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final controller = _MockOnboardingController(
        const OnboardingState(
          locale: Locale('en'),
          privacyAccepted: true,
          privacyVersion: '1.0',
          onboardingCompleted: true,
          localProfileId: 'test-profile',
          currencyCode: 'SAR',
        ),
      );

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          databaseProvider.overrideWithValue(db),
          onboardingControllerProvider.overrideWith(() => controller),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('ar'),
          container: container,
          child: const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('المساعدة والدروس التعليمية'), findsOneWidget);

      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('en'),
          container: container,
          child: const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Help & Tutorials'), findsOneWidget);
    });
  });

  group('Quick Services Voice Label Localization', () {
    testWidgets('Voice label resolves to Arabic صوت in ar and Voice in en', (tester) async {
      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('ar'),
          child: Builder(
            builder: (context) => Text(context.l10n.voice),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('صوت'), findsOneWidget);

      await tester.pumpWidget(
        _buildLocalizedHarness(
          locale: const Locale('en'),
          child: Builder(
            builder: (context) => Text(context.l10n.voice),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Voice'), findsOneWidget);
    });
  });
}

class _MockOnboardingController extends OnboardingController {
  _MockOnboardingController(this._initialState);
  final OnboardingState _initialState;

  @override
  FutureOr<OnboardingState> build() => _initialState;
}

