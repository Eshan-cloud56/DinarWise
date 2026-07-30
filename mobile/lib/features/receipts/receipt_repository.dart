import 'dart:io';

import 'package:dinarwise/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:image/image.dart' as image_lib;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ReceiptRecord {
  const ReceiptRecord({
    required this.id,
    required this.transactionId,
    required this.filePath,
    required this.thumbnailPath,
    required this.sizeBytes,
    required this.createdAt,
  });

  final String id;
  final String transactionId;
  final String filePath;
  final String? thumbnailPath;
  final int sizeBytes;
  final DateTime createdAt;
}

class ReceiptRepository {
  ReceiptRepository(this._database);

  final AppDatabase _database;

  ReceiptRecord _map(ReceiptAttachment row) => ReceiptRecord(
        id: row.id,
        transactionId: row.transactionId,
        filePath: row.filePath,
        thumbnailPath: row.thumbnailPath,
        sizeBytes: row.sizeBytes,
        createdAt: row.createdAt,
      );

  Future<Directory> _directory() async {
    final root = await getApplicationDocumentsDirectory();
    final directory = Directory(path.join(root.path, 'receipts'));
    if (!await directory.exists()) await directory.create(recursive: true);
    return directory;
  }

  Future<ReceiptRecord?> forTransaction(String transactionId) async {
    final row = await (_database.select(_database.receiptAttachments)
          ..where((item) => item.transactionId.equals(transactionId)))
        .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  Stream<ReceiptRecord?> watchForTransaction(String transactionId) {
    final query = _database.select(_database.receiptAttachments)
      ..where((item) => item.transactionId.equals(transactionId));
    return query
        .watchSingleOrNull()
        .map((row) => row == null ? null : _map(row));
  }

  Future<ReceiptRecord> attach({
    required String profileId,
    required String transactionId,
    required String sourcePath,
  }) async {
    final sourceBytes = await File(sourcePath).readAsBytes();
    final decoded = image_lib.decodeImage(sourceBytes);
    if (decoded == null) throw const FormatException('Invalid receipt image');
    final full = decoded.width > 1800
        ? image_lib.copyResize(decoded, width: 1800)
        : decoded;
    final thumbnail = image_lib.copyResize(
      decoded,
      width: decoded.width > 320 ? 320 : decoded.width,
    );
    final fullBytes = image_lib.encodeJpg(full, quality: 82);
    final thumbBytes = image_lib.encodeJpg(thumbnail, quality: 72);
    final directory = await _directory();
    final id = const Uuid().v4();
    final file = File(path.join(directory.path, '$id.jpg'));
    final thumb = File(path.join(directory.path, '${id}_thumb.jpg'));
    await file.writeAsBytes(fullBytes, flush: true);
    await thumb.writeAsBytes(thumbBytes, flush: true);

    try {
      await _database.transaction(() async {
        final existing = await (_database.select(_database.receiptAttachments)
              ..where((row) => row.transactionId.equals(transactionId)))
            .getSingleOrNull();
        if (existing != null) {
          await (_database.delete(_database.receiptAttachments)
                ..where((row) => row.id.equals(existing.id)))
              .go();
        }
        await _database.into(_database.receiptAttachments).insert(
              ReceiptAttachmentsCompanion.insert(
                id: id,
                profileId: profileId,
                transactionId: transactionId,
                filePath: file.path,
                thumbnailPath: Value(thumb.path),
                mimeType: 'image/jpeg',
                sizeBytes: fullBytes.length,
                width: Value(full.width),
                height: Value(full.height),
              ),
            );
        await (_database.update(_database.financialTransactions)
              ..where((row) => row.id.equals(transactionId)))
            .write(
          FinancialTransactionsCompanion(
            receiptAttachmentId: Value(id),
            updatedAt: Value(DateTime.now()),
          ),
        );
        if (existing != null) {
          await _deleteFiles(existing.filePath, existing.thumbnailPath);
        }
      });
    } catch (_) {
      await _deleteFiles(file.path, thumb.path);
      rethrow;
    }
    return (await forTransaction(transactionId))!;
  }

  Future<void> removeForTransaction(String transactionId) async {
    final existing = await (_database.select(_database.receiptAttachments)
          ..where((row) => row.transactionId.equals(transactionId)))
        .getSingleOrNull();
    if (existing == null) return;
    await _database.transaction(() async {
      await (_database.update(_database.financialTransactions)
            ..where((row) => row.id.equals(transactionId)))
          .write(const FinancialTransactionsCompanion(
        receiptAttachmentId: Value(null),
      ));
      await (_database.delete(_database.receiptAttachments)
            ..where((row) => row.id.equals(existing.id)))
          .go();
    });
    await _deleteFiles(existing.filePath, existing.thumbnailPath);
  }

  Future<int> storageUsed(String profileId) async {
    final rows = await (_database.select(_database.receiptAttachments)
          ..where((row) => row.profileId.equals(profileId)))
        .get();
    var total = 0;
    for (final row in rows) {
      total += row.sizeBytes;
    }
    return total;
  }

  Future<List<ReceiptRecord>> all(String profileId) async {
    final rows = await (_database.select(_database.receiptAttachments)
          ..where((row) => row.profileId.equals(profileId))
          ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
        .get();
    return rows.map(_map).toList();
  }

  Future<void> clearAll(String profileId) async {
    final rows = await (_database.select(_database.receiptAttachments)
          ..where((row) => row.profileId.equals(profileId)))
        .get();
    await _database.transaction(() async {
      await (_database.update(_database.financialTransactions)
            ..where((row) => row.profileId.equals(profileId)))
          .write(const FinancialTransactionsCompanion(
        receiptAttachmentId: Value(null),
      ));
      await (_database.delete(_database.receiptAttachments)
            ..where((row) => row.profileId.equals(profileId)))
          .go();
    });
    for (final row in rows) {
      await _deleteFiles(row.filePath, row.thumbnailPath);
    }
  }

  Future<void> _deleteFiles(String filePath, String? thumbnailPath) async {
    for (final item in [filePath, thumbnailPath]) {
      if (item == null) continue;
      final file = File(item);
      if (await file.exists()) await file.delete();
    }
  }
}
