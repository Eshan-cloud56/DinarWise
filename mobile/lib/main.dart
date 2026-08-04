import 'package:dinarwise/app.dart';
import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/diagnostics/crash_reporting_service.dart';
import 'package:dinarwise/core/firebase/firebase_bootstrap.dart';
import 'package:dinarwise/core/performance/performance_service.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/features/onboarding/brand_launch_screen.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final preferences = AppPreferences(sharedPreferences);
  final firebase = await FirebaseBootstrap.initialize(preferences);
  await firebase.performance.trace(PerformanceTraces.appInitialization,
      () async {
    if (preferences.analyticsAllowed) {
      final analytics = firebase.analytics;
      analytics.setAppLanguage(preferences.selectedLanguage ?? 'en');
      if (preferences.selectedCurrency case final currency?) {
        analytics.setSelectedCurrency(currency);
      }
      analytics.setOnboardingStatus(preferences.onboardingCompleted);
      analytics.setAppTheme('light');
    }
  });
  runApp(
    _DinarWiseBootstrap(
      preferences: sharedPreferences,
      firebase: firebase,
    ),
  );
}

class _DinarWiseBootstrap extends StatefulWidget {
  const _DinarWiseBootstrap({
    required this.preferences,
    required this.firebase,
  });

  final SharedPreferences preferences;
  final FirebaseServices firebase;

  @override
  State<_DinarWiseBootstrap> createState() => _DinarWiseBootstrapState();
}

class _DinarWiseBootstrapState extends State<_DinarWiseBootstrap> {
  bool _animationFinished = false;

  @override
  Widget build(BuildContext context) {
    if (_animationFinished) {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(widget.preferences),
          analyticsServiceProvider.overrideWithValue(widget.firebase.analytics),
          crashReportingServiceProvider
              .overrideWithValue(widget.firebase.crashReporting),
          performanceServiceProvider
              .overrideWithValue(widget.firebase.performance),
        ],
        child: const DinarWiseApp(),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildDinarWiseTheme(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: BrandLaunchScreen(
        onFinished: () {
          if (mounted) setState(() => _animationFinished = true);
        },
      ),
    );
  }
}
