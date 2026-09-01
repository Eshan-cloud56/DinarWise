import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/constants.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tutorialReplayRequestProvider = StateProvider<int>((_) => 0);

abstract final class TutorialStepIds {
  static const dashboardSummary = 'dashboard_summary';
  static const addIncome = 'add_income';
  static const addExpense = 'add_expense';
  static const transactions = 'transactions';
  static const analytics = 'analytics';
  static const categories = 'categories';
  static const settings = 'settings';
}

class DashboardTutorialAnchors {
  DashboardTutorialAnchors({
    required this.dashboardSummary,
    required this.addIncome,
    required this.addExpense,
    required this.transactions,
    required this.analytics,
    required this.settings,
  });

  final GlobalKey dashboardSummary;
  final GlobalKey addIncome;
  final GlobalKey addExpense;
  final GlobalKey transactions;
  final GlobalKey analytics;
  final GlobalKey settings;
}

enum _TutorialResult { skipped, completed }

class _TutorialStep {
  const _TutorialStep({
    required this.id,
    required this.title,
    required this.description,
    required this.target,
  });

  final String id;
  final String title;
  final String description;
  final GlobalKey target;
}

Future<void> showDashboardTutorial({
  required BuildContext context,
  required DashboardTutorialAnchors anchors,
  required AppPreferences preferences,
  required AnalyticsService analytics,
  required bool replayed,
}) async {
  final l10n = context.l10n;
  final steps = [
    _TutorialStep(
      id: TutorialStepIds.dashboardSummary,
      title: l10n.tutorialDashboardTitle,
      description: l10n.tutorialDashboardDescription,
      target: anchors.dashboardSummary,
    ),
    _TutorialStep(
      id: TutorialStepIds.addIncome,
      title: l10n.tutorialIncomeTitle,
      description: l10n.tutorialIncomeDescription,
      target: anchors.addIncome,
    ),
    _TutorialStep(
      id: TutorialStepIds.addExpense,
      title: l10n.tutorialExpenseTitle,
      description: l10n.tutorialExpenseDescription,
      target: anchors.addExpense,
    ),
    _TutorialStep(
      id: TutorialStepIds.transactions,
      title: l10n.tutorialTransactionsTitle,
      description: l10n.tutorialTransactionsDescription,
      target: anchors.transactions,
    ),
    _TutorialStep(
      id: TutorialStepIds.analytics,
      title: l10n.tutorialAnalyticsTitle,
      description: l10n.tutorialAnalyticsDescription,
      target: anchors.analytics,
    ),
    _TutorialStep(
      id: TutorialStepIds.categories,
      title: l10n.tutorialCategoriesTitle,
      description: l10n.tutorialCategoriesDescription,
      target: anchors.settings,
    ),
    _TutorialStep(
      id: TutorialStepIds.settings,
      title: l10n.tutorialSettingsTitle,
      description: l10n.tutorialSettingsDescription,
      target: anchors.settings,
    ),
  ];

  analytics.tutorialStarted(
    dashboardTutorialVersion,
    replayed: replayed,
  );
  if (!context.mounted) return;
  final result = await showDialog<_TutorialResult>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    useSafeArea: false,
    builder: (_) => _DashboardTutorialOverlay(
      steps: steps,
      analytics: analytics,
    ),
  );
  if (result != null) {
    await preferences.setDashboardTutorialCompletedV1(true);
  }
}

class _DashboardTutorialOverlay extends StatefulWidget {
  const _DashboardTutorialOverlay({
    required this.steps,
    required this.analytics,
  });

  final List<_TutorialStep> steps;
  final AnalyticsService analytics;

  @override
  State<_DashboardTutorialOverlay> createState() =>
      _DashboardTutorialOverlayState();
}

class _DashboardTutorialOverlayState extends State<_DashboardTutorialOverlay> {
  int _index = 0;
  Rect? _targetRect;
  bool _moving = true;

  _TutorialStep get _step => widget.steps[_index];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _moveTo(0, 1));
  }

  Future<void> _moveTo(int requestedIndex, int direction) async {
    if (!mounted) return;
    setState(() => _moving = true);
    var candidate = requestedIndex;
    while (candidate >= 0 && candidate < widget.steps.length) {
      final targetContext = widget.steps[candidate].target.currentContext;
      if (targetContext != null && targetContext.mounted) {
        await Scrollable.ensureVisible(
          targetContext,
          alignment: 0.45,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        );
        await WidgetsBinding.instance.endOfFrame;
        if (!mounted) return;
        final renderObject =
            widget.steps[candidate].target.currentContext?.findRenderObject();
        if (renderObject is RenderBox && renderObject.attached) {
          final origin = renderObject.localToGlobal(Offset.zero);
          setState(() {
            _index = candidate;
            _targetRect = origin & renderObject.size;
            _moving = false;
          });
          widget.analytics.tutorialStepViewed(
            dashboardTutorialVersion,
            widget.steps[candidate].id,
          );
          return;
        }
      }
      candidate += direction;
    }

    if (!mounted) return;
    if (direction < 0) {
      await _moveTo(0, 1);
    } else {
      _complete();
    }
  }

  void _skip() {
    widget.analytics.tutorialSkipped(
      dashboardTutorialVersion,
      _step.id,
    );
    Navigator.of(context).pop(_TutorialResult.skipped);
  }

  void _complete() {
    widget.analytics.tutorialCompleted(dashboardTutorialVersion);
    Navigator.of(context).pop(_TutorialResult.completed);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final size = MediaQuery.sizeOf(context);
    final target = _targetRect;
    final placeCardAtTop = target != null && target.center.dy > size.height / 2;
    return PopScope(
      canPop: true,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _SpotlightPainter(target),
              ),
            ),
            SafeArea(
              minimum: const EdgeInsets.all(16),
              child: Align(
                alignment: placeCardAtTop
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 520,
                    maxHeight: size.height * 0.48,
                  ),
                  child: Semantics(
                    namesRoute: true,
                    label: _step.title,
                    child: Card(
                      elevation: 12,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _step.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 8),
                            Text(_step.description),
                            const SizedBox(height: 16),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                TextButton(
                                  onPressed: _moving ? null : _skip,
                                  child: Text(l10n.tutorialSkip),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (_index > 0)
                                      TextButton(
                                        onPressed: _moving
                                            ? null
                                            : () => _moveTo(_index - 1, -1),
                                        child: Text(l10n.tutorialBack),
                                      ),
                                    const SizedBox(width: 6),
                                    FilledButton(
                                      onPressed: _moving
                                          ? null
                                          : _index == widget.steps.length - 1
                                              ? _complete
                                              : () => _moveTo(_index + 1, 1),
                                      child: Text(
                                        _index == widget.steps.length - 1
                                            ? l10n.tutorialFinish
                                            : l10n.tutorialNext,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
