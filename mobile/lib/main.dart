import 'package:dinarwise/app.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/features/onboarding/brand_launch_screen.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _DinarWiseBootstrap());
}

class _DinarWiseBootstrap extends StatefulWidget {
  const _DinarWiseBootstrap();

  @override
  State<_DinarWiseBootstrap> createState() => _DinarWiseBootstrapState();
}

class _DinarWiseBootstrapState extends State<_DinarWiseBootstrap> {
  SharedPreferences? _preferences;
  bool _animationFinished = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((preferences) {
      if (mounted) setState(() => _preferences = preferences);
    });
  }

  @override
  Widget build(BuildContext context) {
    final preferences = _preferences;
    if (preferences != null && _animationFinished) {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
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
