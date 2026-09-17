import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/core/router.dart';

class VoiceExpenseLifecycle extends ConsumerStatefulWidget {
  const VoiceExpenseLifecycle({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<VoiceExpenseLifecycle> createState() => _VoiceExpenseLifecycleState();
}

class _VoiceExpenseLifecycleState extends ConsumerState<VoiceExpenseLifecycle> {
  static const _channel = MethodChannel('dinarwise/voice_expense');
  bool _pendingLaunch = false;

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onWidgetLaunch') {
        _trigger();
      }
    });
    _checkInitial();
  }

  Future<void> _checkInitial() async {
    try {
      final pending = await _channel.invokeMethod<bool>('consumeWidgetLaunch');
      if (pending == true) {
        _trigger();
      }
    } catch (_) {}
  }

  void _trigger() {
    _pendingLaunch = true;
    _openWhenReady();
  }

  void _openWhenReady() {
    if (!_pendingLaunch) return;
    final onboarding = ref.read(onboardingControllerProvider).valueOrNull;
    if (onboarding?.destination != StartupDestination.dashboard) {
      return;
    }
    _pendingLaunch = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(routerProvider).go('/?action=voice_expense');
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(onboardingControllerProvider, (_, __) => _openWhenReady());
    return widget.child;
  }
}
