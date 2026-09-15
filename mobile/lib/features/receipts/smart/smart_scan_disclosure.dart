import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

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
