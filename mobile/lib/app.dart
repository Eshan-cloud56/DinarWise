import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/core/router.dart';
import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/features/onboarding/splash_screen.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DinarWiseApp extends ConsumerWidget {
  const DinarWiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingControllerProvider);
    final locale = onboarding.valueOrNull?.locale ?? const Locale('en');
    final common = (
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildDinarWiseTheme(),
    );

    if (!onboarding.hasValue) {
      return MaterialApp(
        debugShowCheckedModeBanner: common.debugShowCheckedModeBanner,
        locale: common.locale,
        supportedLocales: common.supportedLocales,
        localizationsDelegates: common.localizationsDelegates,
        theme: common.theme,
        home: const SplashScreen(),
      );
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: common.debugShowCheckedModeBanner,
      locale: common.locale,
      supportedLocales: common.supportedLocales,
      localizationsDelegates: common.localizationsDelegates,
      theme: common.theme,
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
