import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/planning/data/planning_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommitmentsLifecycle extends ConsumerStatefulWidget {
  const CommitmentsLifecycle({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<CommitmentsLifecycle> createState() =>
      _CommitmentsLifecycleState();
}

class _CommitmentsLifecycleState extends ConsumerState<CommitmentsLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _reconcile();
  }

  Future<void> _reconcile() async {
    final onboarding = await ref.read(onboardingControllerProvider.future);
    await ref
        .read(commitmentsRepositoryProvider)
        .reconcileRecurring(onboarding.localProfileId);
    ref.invalidate(recurringDetailsProvider);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
