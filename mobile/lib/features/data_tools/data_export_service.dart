import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:csv/csv.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/expenses/data/history_filter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CsvImportPreview {
  const CsvImportPreview({
    required this.validRows,
    required this.invalidRows,
    required this.duplicateRows,
  });

  final List<Map<String, String>> validRows;
  final List<String> invalidRows;
  final int duplicateRows;
}

class DataExportService {
  DataExportService(this.database, this.expenses);

  final AppDatabase database;
  final ExpenseRepository expenses;

  Future<Directory> _temp() => getTemporaryDirectory();

  Future<File> exportCsv(String profileId) async {
    final rows = await expenses.search(
      profileId: profileId,
      filter: const TransactionHistoryFilter(),
      limit: 1000000,
    );
    final data = <List<dynamic>>[
      [
        'id',
        'type',
        'amount_minor',
        'currency',
        'merchant',
        'notes',
        'category_id',
        'date',
        'payment_method_id',
      ],
      for (final row in rows)
        [
          row.id,
          row.type,
          row.amountMinor,
          row.currency,
          row.merchant ?? '',
          row.description ?? '',
          row.categoryId,
          row.transactedAt.toIso8601String(),
          row.paymentMethodId ?? '',
        ],
    ];
    final directory = await _temp();
    final file = File(path.join(directory.path, 'dinarwise-transactions.csv'));
    await file.writeAsString(csv.encode(data), flush: true);
    return file;
  }

  Future<CsvImportPreview> previewCsv(
    String contents,
    Set<String> existingIds,
  ) async {
    final rows = csv.decode(contents).toList();
    if (rows.isEmpty) {
      return const CsvImportPreview(
        validRows: [],
        invalidRows: ['The CSV file is empty.'],
        duplicateRows: 0,
      );
    }
    final headers = rows.first.map((value) => '$value'.trim()).toList();
    const required = {'id', 'type', 'amount_minor', 'category_id', 'date'};
    if (!required.every(headers.contains)) {
      return const CsvImportPreview(
        validRows: [],
        invalidRows: ['Required columns are missing.'],
        duplicateRows: 0,
      );
    }
    final valid = <Map<String, String>>[];
    final invalid = <String>[];
    var duplicates = 0;
    for (var index = 1; index < rows.length; index++) {
      final values = rows[index];
      final item = <String, String>{
        for (var i = 0; i < headers.length; i++)
          headers[i]: i < values.length ? '${values[i]}' : '',
      };
      if (existingIds.contains(item['id'])) {
        duplicates++;
        continue;
      }
      final amount = int.tryParse(item['amount_minor'] ?? '');
      final date = DateTime.tryParse(item['date'] ?? '');
      if (amount == null ||
          amount <= 0 ||
          date == null ||
          !{'income', 'expense'}.contains(item['type']) ||
          (item['category_id']?.isEmpty ?? true)) {
        invalid.add('Row ${index + 1}');
      } else {
        valid.add(item);
      }
    }
    return CsvImportPreview(
      validRows: valid,
      invalidRows: invalid,
      duplicateRows: duplicates,
    );
  }

  Future<void> importCsv(
    String profileId,
    CsvImportPreview preview,
  ) async {
    final ordered = [...preview.validRows]
      ..sort((a, b) => a['type'] == b['type']
          ? 0
          : a['type'] == 'income'
              ? -1
              : 1);
    await database.transaction(() async {
      for (final item in ordered) {
        await expenses.create(
          profileId: profileId,
          amountMinor: int.parse(item['amount_minor']!),
          merchant: item['merchant'] ?? '',
          description: item['notes'] ?? '',
          categoryId: item['category_id']!,
          transactedAt: DateTime.parse(item['date']!),
          type: item['type']!,
          currency:
              item['currency']?.isNotEmpty == true ? item['currency']! : 'SAR',
          paymentMethodId: item['payment_method_id']?.isEmpty == true
              ? null
              : item['payment_method_id'],
        );
      }
    });
  }

  Future<File> monthlyPdf({
    required String profileId,
    required DateTime month,
    required String locale,
  }) async {
    final from = DateTime(month.year, month.month);
    final to = DateTime(month.year, month.month + 1)
        .subtract(const Duration(microseconds: 1));
    final rows = await expenses.search(
      profileId: profileId,
      filter: TransactionHistoryFilter(from: from, to: to),
      limit: 1000000,
    );
    final income = rows
        .where((row) => row.type == 'income')
        .fold(0, (sum, row) => sum + row.amountMinor);
    final spent = rows
        .where((row) => row.type == 'expense')
        .fold(0, (sum, row) => sum + row.amountMinor);
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (_) => [
          pw.Header(
            level: 0,
            child: pw.Text('DinarWise Monthly Financial Report'),
          ),
          pw.Text('${month.year}-${month.month.toString().padLeft(2, '0')}'),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headers: const ['Total income', 'Total expenses', 'Balance'],
            data: [
              [
                (income / 100).toStringAsFixed(2),
                (spent / 100).toStringAsFixed(2),
                ((income - spent) / 100).toStringAsFixed(2),
              ],
            ],
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: const ['Date', 'Type', 'Merchant', 'Amount'],
            data: [
              for (final row in rows)
                [
                  row.transactedAt.toIso8601String().substring(0, 10),
                  row.type,
                  row.merchant ?? '',
                  '${row.currency} ${(row.amountMinor / 100).toStringAsFixed(2)}',
                ],
            ],
          ),
        ],
      ),
    );
    final directory = await _temp();
    final file =
        File(path.join(directory.path, 'dinarwise-monthly-report.pdf'));
    await file.writeAsBytes(await document.save(), flush: true);
    return file;
  }

  Future<File> encryptedBackup(String password) async {
    if (password.length < 6) {
      throw const FormatException(
          'Password must contain at least 6 characters.');
    }
    await database.customStatement('PRAGMA wal_checkpoint(FULL)');
    final documents = await getApplicationDocumentsDirectory();
    final source = File(path.join(documents.path, 'dinarwise.sqlite'));
    final plain = await source.readAsBytes();
    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    final nonce = List<int>.generate(12, (_) => random.nextInt(256));
    final key = await Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 150000,
      bits: 256,
    ).deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
    final box = await AesGcm.with256bits().encrypt(
      plain,
      secretKey: key,
      nonce: nonce,
    );
    final envelope = jsonEncode({
      'format': 'dinarwise-backup',
      'version': 1,
      'salt': base64Encode(salt),
      'nonce': base64Encode(box.nonce),
      'cipherText': base64Encode(box.cipherText),
      'mac': base64Encode(box.mac.bytes),
    });
    final directory = await _temp();
    final file = File(path.join(directory.path, 'dinarwise-backup.dwb'));
    await file.writeAsString(envelope, flush: true);
    return file;
  }

  Future<File> decryptBackup(String backupPath, String password) async {
    final envelope = jsonDecode(await File(backupPath).readAsString())
        as Map<String, dynamic>;
    if (envelope['format'] != 'dinarwise-backup') {
      throw const FormatException('Invalid DinarWise backup.');
    }
    final salt = base64Decode(envelope['salt'] as String);
    final key = await Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 150000,
      bits: 256,
    ).deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
    final plain = await AesGcm.with256bits().decrypt(
      SecretBox(
        base64Decode(envelope['cipherText'] as String),
        nonce: base64Decode(envelope['nonce'] as String),
        mac: Mac(base64Decode(envelope['mac'] as String)),
      ),
      secretKey: key,
    );
    final directory = await _temp();
    final file = File(path.join(directory.path, 'dinarwise-restore.sqlite'));
    await file.writeAsBytes(plain, flush: true);
    return file;
  }

  Future<void> restoreDecrypted(File backup) async {
    final escaped = backup.path.replaceAll("'", "''");
    await database.customStatement("ATTACH DATABASE '$escaped' AS restored");
    try {
      final check = await database
          .customSelect('PRAGMA restored.quick_check')
          .getSingle();
      if (check.data.values.first != 'ok') {
        throw const FormatException('Backup database is damaged.');
      }
      final tables = await database
          .customSelect(
            'SELECT name FROM restored.sqlite_master '
            "WHERE type='table' AND name NOT LIKE 'sqlite_%'",
          )
          .get();
      await database.transaction(() async {
        for (final row in tables) {
          final table = row.read<String>('name');
          final exists = await database.customSelect(
            'SELECT 1 FROM sqlite_master WHERE type = ? AND name = ?',
            variables: [
              const Variable<String>('table'),
              Variable<String>(table),
            ],
          ).getSingleOrNull();
          if (exists == null) continue;
          await database.customStatement('DELETE FROM "$table"');
          await database.customStatement(
            'INSERT INTO "$table" SELECT * FROM restored."$table"',
          );
        }
      });
    } finally {
      await database.customStatement('DETACH DATABASE restored');
    }
  }
}
