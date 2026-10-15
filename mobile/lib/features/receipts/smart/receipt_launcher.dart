import 'package:dinarwise/features/capture/capture_screen.dart';
import 'package:dinarwise/features/receipts/smart/receipt_scan_service.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Centralized Smart Bill Scan entry method.
///
/// Reused by both DashboardScreen and QuickWidgetLifecycle to ensure
/// identical image picking, permission handling, and receipt review routing.
Future<void> launchSmartBillScan(
  BuildContext context,
  WidgetRef ref, {
  required ImageSource source,
}) async {
  try {
    final picked =
        await ref.read(receiptScanServiceProvider).images.pick(source);
    if (picked != null && context.mounted) {
      await context.push(
        '/capture',
        extra: CaptureLaunchArgs(sharedReceiptPath: picked),
      );
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).receiptPickError)),
      );
    }
  }
}
