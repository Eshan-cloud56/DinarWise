import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/core/router.dart';
import 'package:dinarwise/features/expenses/history_screen.dart';
import 'package:dinarwise/features/receipts/smart/receipt_launcher.dart';
import 'package:dinarwise/features/voice_expense/presentation/voice_expense_modal.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Supported home-screen widget action identifiers.
abstract final class QuickWidgetActions {
  static const camera = 'com.sl.dinarwise.ACTION_WIDGET_CAMERA';
  static const cameraAlias = 'dinarwise_widget_camera';

  static const media = 'com.sl.dinarwise.ACTION_WIDGET_MEDIA';
  static const mediaAlias = 'dinarwise_widget_media';

  static const voice = 'com.sl.dinarwise.ACTION_WIDGET_VOICE';
  static const voiceAlias = 'dinarwise_widget_voice';

  static const search = 'com.sl.dinarwise.ACTION_WIDGET_SEARCH';
  static const searchAlias = 'dinarwise_widget_search';

  static bool isCamera(String? a) => a == camera || a == cameraAlias;
  static bool isMedia(String? a) => a == media || a == mediaAlias;
  static bool isVoice(String? a) => a == voice || a == voiceAlias;
  static bool isSearch(String? a) => a == search || a == searchAlias;
}

/// Manages Android Quick Widget action routing.
///
/// Ensures actions are retained through cold/warm starts, delayed until
/// initialization/onboarding is complete, and consumed exactly once.
class QuickWidgetLifecycle extends ConsumerStatefulWidget {
  const QuickWidgetLifecycle({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<QuickWidgetLifecycle> createState() =>
      _QuickWidgetLifecycleState();
}

class _QuickWidgetLifecycleState extends ConsumerState<QuickWidgetLifecycle> {
  static const _channel = MethodChannel('dinarwise/quick_widget');

  String? _queuedAction;
  bool _isExecuting = false;

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onWidgetAction') {
        final action = call.arguments as String?;
        if (action != null) {
          _enqueueAction(action);
        }
      }
    });
    _consumeInitialAction();
  }

  Future<void> _consumeInitialAction() async {
    try {
      final initial =
          await _channel.invokeMethod<String>('consumeInitialAction');
      if (initial != null && initial.isNotEmpty) {
        _enqueueAction(initial);
      }
    } catch (_) {}
  }

  void _enqueueAction(String action) {
    _queuedAction = action;
    _processQueuedAction();
  }

  void _processQueuedAction() {
    if (_queuedAction == null || _isExecuting) return;

    final onboarding = ref.read(onboardingControllerProvider).valueOrNull;
    if (onboarding?.destination != StartupDestination.dashboard) {
      // Retain queued action until onboarding is completed
      return;
    }

    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null || !ctx.mounted) {
      // Wait for router/navigation tree to be mounted
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _processQueuedAction();
      });
      return;
    }

    final action = _queuedAction!;
    _queuedAction = null;
    _isExecuting = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!ctx.mounted) {
        _isExecuting = false;
        return;
      }

      try {
        if (QuickWidgetActions.isCamera(action)) {
          await launchSmartBillScan(ctx, ref, source: ImageSource.camera);
        } else if (QuickWidgetActions.isMedia(action)) {
          await launchSmartBillScan(ctx, ref, source: ImageSource.gallery);
        } else if (QuickWidgetActions.isVoice(action)) {
          await showVoiceExpenseModal(ctx, autoStart: true);
        } else if (QuickWidgetActions.isSearch(action)) {
          ctx.go('/history', extra: const HistoryLaunchArgs(autoFocusSearch: true));
        }
      } finally {
        _isExecuting = false;
        if (_queuedAction != null && mounted) {
          _processQueuedAction();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(onboardingControllerProvider, (_, __) => _processQueuedAction());
    return widget.child;
  }
}
