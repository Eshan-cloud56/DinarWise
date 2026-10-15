import 'package:dinarwise/features/tutorial/dinar_tutorial_card.dart';
import 'package:flutter/material.dart';

/// A coach-mark overlay that highlights a target widget with a spotlight
/// cutout and shows a [DinarTutorialCard] with contextual information.
///
/// Supports multi-step guides and single-step contextual tips.
/// Absorbs pointer events outside the card to prevent accidental clicks.
class DinarCoachMark extends StatelessWidget {
  const DinarCoachMark({
    required this.steps,
    required this.currentIndex,
    required this.targetRect,
    this.onSkip,
    this.onBack,
    this.onNext,
    this.onComplete,
    super.key,
  });

  final List<CoachMarkStep> steps;
  final int currentIndex;
  final Rect? targetRect;
  final VoidCallback? onSkip;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final step = steps[currentIndex];
    final isLast = currentIndex == steps.length - 1;
    final isSingle = steps.length == 1;
    final target = targetRect;
    final placeCardAtTop =
        target != null && target.center.dy > size.height / 2;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Spotlight overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _SpotlightPainter(target),
            ),
          ),
          // Card
          SafeArea(
            minimum: const EdgeInsets.all(16),
            child: Align(
              alignment:
                  placeCardAtTop ? Alignment.topCenter : Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 520,
                  maxHeight: size.height * 0.48,
                ),
                child: DinarTutorialCard(
                  title: step.title,
                  description: step.description,
                  stepIndex: isSingle ? null : currentIndex,
                  totalSteps: isSingle ? null : steps.length,
                  onSkip: onSkip,
                  onBack: currentIndex > 0 ? onBack : null,
                  onGotIt: isSingle ? onComplete : null,
                  onNext: isSingle ? null : (isLast ? onComplete : onNext),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single step in a multi-step coach-mark guide.
class CoachMarkStep {
  const CoachMarkStep({
    required this.title,
    required this.description,
    this.targetKey,
  });

  final String title;
  final String description;
  final GlobalKey? targetKey;
}

class _SpotlightPainter extends CustomPainter {
  const _SpotlightPainter(this.target);

  final Rect? target;

  @override
  void paint(Canvas canvas, Size size) {
    final overlay = Path()..addRect(Offset.zero & size);
    if (target case final target?) {
      overlay.addRRect(
        RRect.fromRectAndRadius(
          target.inflate(8),
          const Radius.circular(16),
        ),
      );
      overlay.fillType = PathFillType.evenOdd;
    }
    canvas.drawPath(overlay, Paint()..color = Colors.black.withAlpha(190));
  }

  @override
  bool shouldRepaint(_SpotlightPainter oldDelegate) =>
      oldDelegate.target != target;
}
