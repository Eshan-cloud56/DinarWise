import 'dart:io';

import 'package:dinarwise/core/android_file_share.dart';
import 'package:dinarwise/core/android_file_picker.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/data_tools/data_tools_providers.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/expenses/data/history_filter.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataToolsScreen extends ConsumerStatefulWidget {
  const DataToolsScreen({super.key});

  @override
  ConsumerState<DataToolsScreen> createState() => _DataToolsScreenState();
}

class _DataToolsScreenState extends ConsumerState<DataToolsScreen> {
  bool _busy = false;

  Future<T?> _working<T>(Future<T> Function() action) async {
    setState(() => _busy = true);
    try {
      return await action();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.l10n.operationFailed}: $error')),
        );
      }
      return null;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<String?> _password({required bool confirmation}) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.backupPassword),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration:
              InputDecoration(hintText: context.l10n.minimumSixCharacters),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(confirmation
                ? context.l10n.restore
                : context.l10n.continueLabel),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  Future<void> _share(File file, String title) => AndroidFileShare.share(
        file.path,
        file.path.endsWith('.pdf')
            ? 'application/pdf'
            : file.path.endsWith('.csv')
                ? 'text/csv'
                : 'application/octet-stream',
      );

  Future<void> _exportCsv() async {
    final profile =
        (await ref.read(onboardingControllerProvider.future)).localProfileId;
    final file = await _working(
      () => ref.read(dataExportServiceProvider).exportCsv(profile),
    );
    if (file != null) await _share(file, 'DinarWise CSV');
  }

  Future<void> _exportPdf() async {
    final state = await ref.read(onboardingControllerProvider.future);
    final file = await _working(
      () => ref.read(dataExportServiceProvider).monthlyPdf(
            profileId: state.localProfileId,
            month: DateTime.now(),
            locale: state.locale?.languageCode ?? 'en',
          ),
    );
    if (file != null) await _share(file, 'DinarWise PDF');
  }

  Future<void> _importCsv() async {
    final filePath = await AndroidFilePicker.pick('text/*');
    if (filePath == null) return;
    final state = await ref.read(onboardingControllerProvider.future);
    final current = await ref.read(expenseRepositoryProvider).search(
          profileId: state.localProfileId,
          filter: const TransactionHistoryFilter(),
          limit: 1000000,
        );
    final preview = await _working(
      () => ref.read(dataExportServiceProvider).previewCsv(
            File(filePath).readAsStringSync(),
            current.map((item) => item.id).toSet(),
          ),
    );
    if (preview == null || !mounted) return;
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.importPreview),
        content: Text(
          context.l10n.importPreviewCounts(
            preview.validRows.length,
            preview.invalidRows.length,
            preview.duplicateRows,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: preview.validRows.isEmpty
                ? null
                : () => Navigator.pop(context, true),
            child: Text(context.l10n.importLabel),
          ),
        ],
      ),
    );
    if (approved == true) {
      await _working(
        () => ref
            .read(dataExportServiceProvider)
            .importCsv(state.localProfileId, preview),
      );
    }
  }

  Future<void> _backup() async {
    final password = await _password(confirmation: false);
    if (password == null) return;
    final file = await _working(
      () => ref.read(dataExportServiceProvider).encryptedBackup(password),
    );
    if (file != null) await _share(file, 'DinarWise Backup');
  }

  Future<void> _restore() async {
    final filePath = await AndroidFilePicker.pick('application/octet-stream');
    if (filePath == null || !mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.restoreBackup),
        content: Text(context.l10n.restoreReplacesData),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.continueLabel),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final password = await _password(confirmation: true);
    if (password == null) return;
    await _working(() async {
      final service = ref.read(dataExportServiceProvider);
      final decrypted = await service.decryptBackup(filePath, password);
      await service.restoreDecrypted(decrypted);
      ref.invalidate(expensesProvider);
      ref.invalidate(financialSummaryProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.backupAndExport)),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _item(Icons.table_view_outlined, context.l10n.exportCsv,
                  _exportCsv),
              _item(Icons.upload_file_outlined, context.l10n.importCsv,
                  _importCsv),
              _item(Icons.picture_as_pdf_outlined, context.l10n.monthlyPdf,
                  _exportPdf),
              const Divider(),
              _item(Icons.lock_outline, context.l10n.encryptedBackup, _backup),
              _item(
                  Icons.restore_outlined, context.l10n.restoreBackup, _restore),
            ],
          ),
          if (_busy) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title, VoidCallback onTap) => Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: _busy ? null : onTap,
        ),
      );
}
