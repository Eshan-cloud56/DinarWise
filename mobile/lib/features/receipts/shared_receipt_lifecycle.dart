import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/core/router.dart';
import 'package:dinarwise/features/capture/capture_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

class SharedReceiptLifecycle extends ConsumerStatefulWidget {
  const SharedReceiptLifecycle({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SharedReceiptLifecycle> createState() =>
      _SharedReceiptLifecycleState();
}

class _SharedReceiptLifecycleState
    extends ConsumerState<SharedReceiptLifecycle> {
  static const _channel = MethodChannel('dinarwise/shared_receipt');
  String? _pendingPath;

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'sharedReceipt') {
        _receive(call.arguments as String?);
      }
    });
    _channel.invokeMethod<String>('getInitial').then(_receive);
  }

  void _receive(String? path) {
    if (path == null || path.isEmpty) return;
    _pendingPath = path;
    _openWhenReady();
  }

  void _openWhenReady() {
    final path = _pendingPath;
    final onboarding = ref.read(onboardingControllerProvider).valueOrNull;
    if (path == null ||
        onboarding?.destination != StartupDestination.dashboard) {
      return;
    }
    _pendingPath = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(routerProvider).push(
            '/capture',
            extra: CaptureLaunchArgs(sharedReceiptPath: path),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(onboardingControllerProvider, (_, __) => _openWhenReady());
    return widget.child;
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null);
    super.dispose();
  }
}
