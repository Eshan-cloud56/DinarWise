import 'package:dinarwise/app.dart';
import 'package:dinarwise/core/router.dart';
import 'package:dinarwise/l10n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final locale = ref.watch(localeProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.account_balance_wallet_rounded,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                strings.welcome,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                strings.onboardingSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'en', label: Text('English')),
                  ButtonSegment(value: 'ar', label: Text('العربية')),
                ],
                selected: {locale.languageCode},
                onSelectionChanged: (value) =>
                    ref.read(localeProvider.notifier).state =
                        Locale(value.first),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  ref.read(onboardingCompleteProvider.notifier).state = true;
                  context.go('/');
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(strings.continueLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
