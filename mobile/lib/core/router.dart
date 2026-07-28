import 'package:dinarwise/features/auth/onboarding_screen.dart';
import 'package:dinarwise/features/auth/login_screen.dart';
import 'package:dinarwise/features/capture/capture_screen.dart';
import 'package:dinarwise/features/dashboard/dashboard_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final onboardingCompleteProvider = StateProvider<bool>((_) => false);

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
      GoRoute(path: '/capture', builder: (_, __) => const CaptureScreen()),
    ],
  );
});
