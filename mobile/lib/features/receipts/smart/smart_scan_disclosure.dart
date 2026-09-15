import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

Future<bool> acknowledgeSmartScan(
    BuildContext context, AppPreferences preferences) async {
  if (preferences.smartScanAcknowledged) return true;
  final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(context.l10n.smartScan),
            content: Text(context.l10n.smartReceiptCloudNotice),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(context.l10n.manualEntry)),
              FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(context.l10n.smartScan)),
            ],
          ));
  if (approved != true) return false;
  await preferences.acknowledgeSmartScan();
  return true;
}

Future<void> showSmartScanInformation(BuildContext context) => showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.smartScan),
        content: Text(context.l10n.smartReceiptCloudNotice),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel))
        ],
      ),
    );
