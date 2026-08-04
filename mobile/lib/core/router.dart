import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/analytics/analytics_observer.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/analytics/analytics_screen.dart';
import 'package:dinarwise/features/capture/capture_screen.dart';
import 'package:dinarwise/features/calculators/calculators_screen.dart';
import 'package:dinarwise/features/dashboard/dashboard_screen.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/expenses/history_screen.dart';
import 'package:dinarwise/features/expenses/spending_calendar_screen.dart';
import 'package:dinarwise/features/onboarding/language_selection_screen.dart';
import 'package:dinarwise/features/onboarding/currency_selection_screen.dart';
import 'package:dinarwise/features/onboarding/privacy_consent_screen.dart';
import 'package:dinarwise/features/planning/planning_screen.dart';
import 'package:dinarwise/features/planning/budgets_screen.dart';
import 'package:dinarwise/features/planning/bnpl_screen.dart';
import 'package:dinarwise/features/planning/recurring_screen.dart';
import 'package:dinarwise/features/planning/savings_goals_screen.dart';
import 'package:dinarwise/features/settings/custom_categories_screen.dart';
import 'package:dinarwise/features/settings/data_tools_screen.dart';
import 'package:dinarwise/features/settings/payment_methods_screen.dart';
import 'package:dinarwise/features/settings/receipt_storage_screen.dart';
import 'package:dinarwise/features/settings/security_settings_screen.dart';
import 'package:dinarwise/features/settings/settings_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final destination = ref.watch(
    onboardingControllerProvider.select(
      (value) => value.requireValue.destination,
    ),
  );
  final initialLocation = switch (destination) {
    StartupDestination.language => '/language',
    StartupDestination.privacy => '/privacy',
    StartupDestination.currency => '/currency',
    StartupDestination.dashboard => '/',
  };
  return GoRouter(
    initialLocation: initialLocation,
    observers: [
      AnalyticsNavigationObserver(ref.watch(analyticsServiceProvider)),
    ],
    redirect: (_, route) {
      final location = route.matchedLocation;
      if (destination == StartupDestination.language) {
        return location == '/language' ? null : '/language';
      }
      if (destination == StartupDestination.privacy) {
        return location == '/privacy' ? null : '/privacy';
      }
      if (destination == StartupDestination.currency) {
        return location == '/currency' ? null : '/currency';
      }
      if (location == '/language' ||
          location == '/privacy' ||
          location == '/currency') {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/language',
        name: 'onboarding',
        builder: (_, __) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy_consent',
        builder: (_, __) => const PrivacyConsentScreen(),
      ),
      GoRoute(
        path: '/currency',
        name: 'currency_settings',
        builder: (_, __) => const CurrencySelectionScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (_, state) => DashboardScreen(
          openIncome: state.uri.queryParameters['action'] == 'income',
        ),
      ),
      GoRoute(
        path: '/history',
        name: 'transactions',
        builder: (_, state) => HistoryScreen(
          initialCategoryId: state.uri.queryParameters['category'],
        ),
      ),
      GoRoute(
        path: '/history/calendar',
        name: 'transaction_details',
        builder: (_, __) => const SpendingCalendarScreen(),
      ),
      GoRoute(
        path: '/analytics',
        name: 'analytics',
        builder: (_, __) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/calculators',
        builder: (_, __) => const CalculatorsScreen(),
      ),
      GoRoute(
        path: '/capture',
        name: 'add_expense',
        builder: (_, state) {
          final extra = state.extra;
          if (extra is CaptureLaunchArgs) {
            return CaptureScreen(
              expense: extra.expense,
              sharedReceiptPath: extra.sharedReceiptPath,
            );
          }
          return CaptureScreen(expense: extra as ExpenseRecord?);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/categories',
        name: 'categories',
        builder: (_, __) => const CustomCategoriesScreen(),
      ),
      GoRoute(
        path: '/settings/payment-methods',
        builder: (_, __) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/settings/receipts',
        builder: (_, __) => const ReceiptStorageScreen(),
      ),
      GoRoute(
        path: '/settings/data-tools',
        builder: (_, __) => const DataToolsScreen(),
      ),
      GoRoute(
        path: '/settings/security',
        builder: (_, __) => const SecuritySettingsScreen(),
      ),
      GoRoute(
        path: '/planning/:section',
        builder: (_, state) {
          final section = state.pathParameters['section']!;
          return switch (section) {
            'budgets' => const BudgetsScreen(),
            'goals' => const SavingsGoalsScreen(),
            'bnpl' => const BnplScreen(),
            'recurring' => const RecurringScreen(),
            _ => PlanningScreen(section: section),
          };
        },
      ),
    ],
  );
});
