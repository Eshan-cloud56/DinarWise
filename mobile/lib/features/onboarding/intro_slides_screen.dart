import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class IntroSlidesScreen extends ConsumerStatefulWidget {
  const IntroSlidesScreen({
    super.key,
    this.replay = false,
  });

  final bool replay;

  @override
  ConsumerState<IntroSlidesScreen> createState() => _IntroSlidesScreenState();
}

class _IntroSlidesScreenState extends ConsumerState<IntroSlidesScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _completing = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> _getSlideAssets(bool isArabic) {
    if (isArabic) {
      return const [
        'assets/intro/intro1_ar.png',
        'assets/intro/intro2_ar.png',
        'assets/intro/intro3_ar.png',
      ];
    }
    return const [
      'assets/intro/intro1_en.png',
      'assets/intro/intro2_en.png',
      'assets/intro/intro3_en.png',
    ];
  }

  void _safePop() {
    if (!mounted) return;
    final nav = Navigator.maybeOf(context);
    if (nav != null && nav.canPop()) {
      nav.pop();
      return;
    }
    try {
      context.go('/');
    } catch (_) {
      // In isolated widget tests without GoRouter inherited widget
    }
  }

  Future<void> _onNextPressed() async {
    if (_currentIndex < 2) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      if (widget.replay) {
        _safePop();
        return;
      }
      if (_completing) return;
      setState(() => _completing = true);
      await ref.read(onboardingControllerProvider.notifier).completeIntro();
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = ref.watch(onboardingControllerProvider);
    final locale = onboarding.valueOrNull?.locale ?? Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final slideAssets = _getSlideAssets(isArabic);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFF07221C),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF07221C),
              Color(0xFF0C1412),
              Color(0xFF051713),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar: Replay close button & Slide Counter indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.replay)
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: _safePop,
                      )
                    else
                      const SizedBox(width: 48),
                    // Slide indicator capsule: 1 / 3, 2 / 3, 3 / 3
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFC5A059).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        l10n.introSlideCount('${_currentIndex + 1}', '3'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // PageView displaying the prominent marketing creatives
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: slideAssets.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            slideAssets[index],
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Area: Page Dots & White Next Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dot indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final isSelected = index == _currentIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isSelected ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFC5A059)
                                : Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 18),

                    // Prominent White Next Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        key: const ValueKey('introNextButton'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0E4D3E),
                          elevation: 4,
                          shadowColor: Colors.black45,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _completing ? null : _onNextPressed,
                        child: _completing
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF0E4D3E),
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    l10n.introNext,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    isArabic
                                        ? Icons.arrow_back_rounded
                                        : Icons.arrow_forward_rounded,
                                    size: 18,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
