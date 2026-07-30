import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/core/router.dart';
import 'package:dinarwise/features/notifications/notification_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationLifecycle extends ConsumerStatefulWidget {
  const NotificationLifecycle({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<NotificationLifecycle> createState() =>
      _NotificationLifecycleState();
}

class _NotificationLifecycleState extends ConsumerState<NotificationLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  Future<void> _sync() async {
    try {
      final service = ref.read(localNotificationServiceProvider);
      await service.initialize(
        onOpen: (payload) => ref.read(routerProvider).go(payload),
      );
      final state = await ref.read(onboardingControllerProvider.future);
      if (state.destination != StartupDestination.dashboard) return;
      await service.reschedule(
        profileId: state.localProfileId,
        locale: state.locale?.languageCode ?? 'en',
      );
    } catch (_) {
      // Plugins are unavailable in widget tests and on unsupported platforms.
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _sync();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
