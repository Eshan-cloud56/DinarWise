import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/core/router.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_actions/quick_actions.dart';

class QuickActionsLifecycle extends ConsumerStatefulWidget {
  const QuickActionsLifecycle({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<QuickActionsLifecycle> createState() =>
      _QuickActionsLifecycleState();
}

class _QuickActionsLifecycleState extends ConsumerState<QuickActionsLifecycle> {
  static const _actions = QuickActions();
  String? _pending;

  @override
  void initState() {
    super.initState();
    _actions.initialize((type) {
      _pending = type;
      _openWhenReady();
    });
    _configure();
  }

  Future<void> _configure() => _actions.setShortcutItems(const [
        ShortcutItem(
          type: 'expense',
          localizedTitle: 'Quick Add Expense',
          icon: 'ic_launcher',
        ),
        ShortcutItem(
          type: 'income',
          localizedTitle: 'Quick Add Income',
          icon: 'ic_launcher',
        ),
        ShortcutItem(
          type: 'receipt',
          localizedTitle: 'Open Receipt Capture',
          icon: 'ic_launcher',
        ),
        ShortcutItem(
          type: 'dashboard',
          localizedTitle: 'Open Dashboard',
          icon: 'ic_launcher',
        ),
      ]);

  void _openWhenReady() {
    final action = _pending;
    final state = ref.read(onboardingControllerProvider).valueOrNull;
    if (action == null || state?.destination != StartupDestination.dashboard) {
      return;
    }
    _pending = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final router = ref.read(routerProvider);
      switch (action) {
        case 'expense':
        case 'receipt':
          router.go('/capture');
        case 'income':
          router.go('/?action=income');
        default:
          router.go('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(onboardingControllerProvider, (_, __) => _openWhenReady());
    return widget.child;
  }
}
