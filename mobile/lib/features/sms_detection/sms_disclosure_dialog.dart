import 'package:flutter/material.dart';
import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';

/// Shows a prominent disclosure dialog explaining SMS transaction detection
/// before requesting the Android RECEIVE_SMS permission, adhering strictly to
/// Google Play Store restricted permissions policy.
///
/// Returns `true` if the user gave explicit affirmative consent ("Agree & Enable"),
/// or `false` if the user dismissed or tapped "Not Now".
Future<bool> showSmsDetectionDisclosure(
  BuildContext context, {
  bool isInformationalOnly = false,
}) async {
  final l10n = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(ctx).colorScheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      actionsPadding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: DinarColors.mint.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: DinarColors.green,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.smsDisclosureTitle,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Theme.of(ctx).colorScheme.onSurface,
                  ),
                ),
                Text(
                  l10n.smsDisclosureSubtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              l10n.smsDisclosureDescription,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(ctx).colorScheme.onSurface,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            _DisclosureBullet(
              icon: Icons.receipt_long_outlined,
              text: l10n.smsDisclosurePoint1,
            ),
            const SizedBox(height: 12),
            _DisclosureBullet(
              icon: Icons.touch_app_outlined,
              text: l10n.smsDisclosurePoint2,
            ),
            const SizedBox(height: 12),
            _DisclosureBullet(
              icon: Icons.lock_outline,
              text: l10n.smsDisclosurePoint3,
              highlight: true,
            ),
            const SizedBox(height: 12),
            _DisclosureBullet(
              icon: Icons.verified_user_outlined,
              text: l10n.smsDisclosurePoint4,
            ),
            const SizedBox(height: 12),
            _DisclosureBullet(
              icon: Icons.sms_outlined,
              text: l10n.smsDisclosurePoint5,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      actions: [
        if (isInformationalOnly) ...[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.cancel,
              style: const TextStyle(
                color: DinarColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ] else ...[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.smsDisclosureDecline,
              style: const TextStyle(
                color: DinarColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: DinarColors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.smsDisclosureAgree,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ],
    ),
  );

  return result ?? false;
}

class _DisclosureBullet extends StatelessWidget {
  const _DisclosureBullet({
    required this.icon,
    required this.text,
    this.highlight = false,
  });

  final IconData icon;
  final String text;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: highlight ? const EdgeInsets.all(8) : EdgeInsets.zero,
      decoration: highlight
          ? BoxDecoration(
              color: DinarColors.mint.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: DinarColors.mint),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: highlight ? DinarColors.green : DinarColors.muted,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: highlight
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
