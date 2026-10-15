import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

/// A styled card used inside tutorial overlays.
///
/// Uses DinarWise ivory palette with forest green headers and gold accents.
/// Supports RTL layout automatically through Flutter's directionality.
class DinarTutorialCard extends StatelessWidget {
  const DinarTutorialCard({
    required this.title,
    required this.description,
    this.stepIndex,
    this.totalSteps,
    this.onSkip,
    this.onBack,
    this.onNext,
    this.onGotIt,
    super.key,
  });

  final String title;
  final String description;
  final int? stepIndex;
  final int? totalSteps;
  final VoidCallback? onSkip;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final VoidCallback? onGotIt;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLastStep =
        stepIndex != null && totalSteps != null && stepIndex == totalSteps! - 1;

    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFFFFBF0), // Ivory
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: DinarColors.forest.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline,
                    color: DinarColors.forest,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: DinarColors.forest,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),

            // Step indicator
            if (stepIndex != null && totalSteps != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.stepXofY(stepIndex! + 1, totalSteps!),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      totalSteps!,
                      (i) => Container(
                        width: i == stepIndex ? 20 : 8,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: i == stepIndex
                              ? const Color(0xFFD4A017) // Gold accent
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),

            // Controls
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                if (onSkip != null)
                  TextButton(
                    onPressed: onSkip,
                    child: Text(l10n.tutorialSkip),
                  )
                else
                  const SizedBox.shrink(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onBack != null)
                      TextButton(
                        onPressed: onBack,
                        child: Text(l10n.tutorialBack),
                      ),
                    const SizedBox(width: 6),
                    if (onGotIt != null)
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: DinarColors.forest,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: onGotIt,
                        child: Text(l10n.gotIt),
                      )
                    else if (onNext != null)
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: DinarColors.forest,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: onNext,
                        child: Text(
                          isLastStep ? l10n.tutorialFinish : l10n.tutorialNext,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
