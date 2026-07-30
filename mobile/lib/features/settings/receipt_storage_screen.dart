import 'dart:io';

import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/receipts/receipt_providers.dart';
import 'package:dinarwise/features/receipts/receipt_repository.dart';
import 'package:dinarwise/features/receipts/receipt_viewer.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReceiptStorageScreen extends ConsumerStatefulWidget {
  const ReceiptStorageScreen({super.key});

  @override
  ConsumerState<ReceiptStorageScreen> createState() =>
      _ReceiptStorageScreenState();
}

class _ReceiptStorageScreenState extends ConsumerState<ReceiptStorageScreen> {
  Future<List<ReceiptRecord>>? _receipts;

  Future<List<ReceiptRecord>> _load() async {
    final profile =
        (await ref.read(onboardingControllerProvider.future)).localProfileId;
    return ref.read(receiptRepositoryProvider).all(profile);
  }

  void _refresh() {
    setState(() => _receipts = _load());
    ref.invalidate(receiptStorageProvider);
  }

  @override
  void initState() {
    super.initState();
    _receipts = _load();
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.clearAllReceipts),
        content: Text(context.l10n.clearAllReceiptsMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final profile =
        (await ref.read(onboardingControllerProvider.future)).localProfileId;
    await ref.read(receiptRepositoryProvider).clearAll(profile);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final storage = ref.watch(receiptStorageProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.receiptStorage),
        actions: [
          IconButton(
            onPressed: _clearAll,
            tooltip: context.l10n.clearAllReceipts,
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.storage_outlined),
            title: Text(context.l10n.storageUsed),
            subtitle: Text(
              storage.valueOrNull == null
                  ? context.l10n.loading
                  : _formatBytes(storage.valueOrNull!),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<ReceiptRecord>>(
              future: _receipts,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data!;
                if (items.isEmpty) {
                  return Center(child: Text(context.l10n.noReceipts));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              ReceiptViewer(filePath: item.filePath),
                        ),
                      ),
                      child: Image.file(
                        File(item.thumbnailPath ?? item.filePath),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
