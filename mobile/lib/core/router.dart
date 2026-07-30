import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/analytics/analytics_screen.dart';
import 'package:dinarwise/features/capture/capture_screen.dart';
import 'package:dinarwise/features/dashboard/dashboard_screen.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/expenses/history_screen.dart';
import 'package:dinarwise/features/expenses/spending_calendar_screen.dart';
import 'package:dinarwise/features/onboarding/language_selection_screen.dart';
import 'package:dinarwise/features/onboarding/privacy_consent_screen.dart';
import 'package:dinarwise/features/planning/planning_screen.dart';
import 'package:dinarwise/features/settings/custom_categories_screen.dart';
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
    StartupDestination.dashboard => '/',
  };
  return GoRouter(
    initialLocation: initialLocation,
    redirect: (_, route) {
      final location = route.matchedLocation;
      if (destination == StartupDestination.language) {
        return location == '/language' ? null : '/language';
      }
      if (destination == StartupDestination.privacy) {
        return location == '/privacy' ? null : '/privacy';
      }
      if (location == '/language' || location == '/privacy') return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/language',
        builder: (_, __) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (_, __) => const PrivacyConsentScreen(),
      ),
      GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
      GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
      GoRoute(
        path: '/history/calendar',
        builder: (_, __) => const SpendingCalendarScreen(),
      ),
      GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsScreen()),
      GoRoute(
        path: '/capture',
        builder: (_, state) =>
            CaptureScreen(expense: state.extra as ExpenseRecord?),
      ),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(
        path: '/settings/categories',
        builder: (_, __) => const CustomCategoriesScreen(),
      ),
      GoRoute(
        path: '/planning/:section',
        builder: (_, state) => PlanningScreen(
          section: state.pathParameters['section']!,
        ),
      ),
    ],
  );
});
