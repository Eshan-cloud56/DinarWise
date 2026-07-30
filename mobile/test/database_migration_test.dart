import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

class _VersionOneExecutorUser implements QueryExecutorUser {
  @override
  int get schemaVersion => 1;

  @override
  Future<void> beforeOpen(
    QueryExecutor executor,
    OpeningDetails details,
  ) async {}
}

Future<void> _createVersionOneSchema(File file) async {
  final executor = NativeDatabase(file);
  await executor.ensureOpen(_VersionOneExecutorUser());
  const statements = [
    '''
      CREATE TABLE financial_transactions (
        id TEXT NOT NULL PRIMARY KEY,
        profile_id TEXT NOT NULL,
        type TEXT NOT NULL DEFAULT 'expense',
        amount_minor INTEGER NOT NULL,
        currency TEXT NOT NULL DEFAULT 'SAR',
        merchant TEXT,
        description TEXT,
        category_id TEXT NOT NULL,
        transacted_at INTEGER NOT NULL,
        payment_method TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''',
    '''
      CREATE TABLE expense_categories (
        id TEXT NOT NULL PRIMARY KEY,
        profile_id TEXT NOT NULL,
        system_code TEXT,
        name TEXT NOT NULL,
        is_system INTEGER NOT NULL DEFAULT 0,
        icon_code_point INTEGER NOT NULL DEFAULT 59596,
        color_value INTEGER NOT NULL DEFAULT 4284513675,
        created_at INTEGER NOT NULL
      )
    ''',
    '''
      CREATE TABLE budgets (
        id TEXT NOT NULL PRIMARY KEY,
        profile_id TEXT NOT NULL,
        name TEXT NOT NULL,
        limit_minor INTEGER NOT NULL,
        category_id TEXT,
        starts_on INTEGER NOT NULL,
        ends_on INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''',
    '''
      CREATE TABLE savings_goals (
        id TEXT NOT NULL PRIMARY KEY,
        profile_id TEXT NOT NULL,
        name TEXT NOT NULL,
        target_minor INTEGER NOT NULL,
        current_minor INTEGER NOT NULL DEFAULT 0,
        target_date INTEGER,
        created_at INTEGER NOT NULL
      )
    ''',
    '''
      CREATE TABLE goal_contributions (
        id TEXT NOT NULL PRIMARY KEY,
        profile_id TEXT NOT NULL,
        goal_id TEXT NOT NULL,
        amount_minor INTEGER NOT NULL,
        contributed_at INTEGER NOT NULL
      )
    ''',
    '''
      CREATE TABLE bnpl_plans (
        id TEXT NOT NULL PRIMARY KEY,
        profile_id TEXT NOT NULL,
        provider TEXT NOT NULL,
        merchant TEXT NOT NULL,
        purchase_amount_minor INTEGER NOT NULL,
        currency TEXT NOT NULL DEFAULT 'SAR',
        instalment_count INTEGER NOT NULL,
        purchase_date INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''',
    '''
      CREATE TABLE bnpl_instalments (
        id TEXT NOT NULL PRIMARY KEY,
        profile_id TEXT NOT NULL,
        plan_id TEXT NOT NULL,
        amount_minor INTEGER NOT NULL,
        due_date INTEGER NOT NULL,
        is_paid INTEGER NOT NULL DEFAULT 0,
        paid_at INTEGER
      )
    ''',
    '''
      CREATE TABLE recurring_payments (
        id TEXT NOT NULL PRIMARY KEY,
        profile_id TEXT NOT NULL,
        name TEXT NOT NULL,
        amount_minor INTEGER NOT NULL,
        currency TEXT NOT NULL DEFAULT 'SAR',
        recurrence TEXT NOT NULL,
        category_id TEXT,
        next_payment_date INTEGER NOT NULL,
        is_subscription INTEGER NOT NULL DEFAULT 0,
        is_active INTEGER NOT NULL DEFAULT 1
      )
    ''',
    '''
      CREATE TABLE financial_preferences (
        profile_id TEXT NOT NULL PRIMARY KEY,
        monthly_income_minor INTEGER NOT NULL DEFAULT 0,
        payday INTEGER NOT NULL DEFAULT 1,
        currency TEXT NOT NULL DEFAULT 'SAR',
        notifications_enabled INTEGER NOT NULL DEFAULT 1
      )
    ''',
  ];
  for (final statement in statements) {
    await executor.runCustom(statement);
  }
  await executor.runCustom(
    '''
      INSERT INTO financial_transactions (
        id, profile_id, type, amount_minor, currency, merchant, description,
        category_id, transacted_at, created_at, updated_at
      ) VALUES (
        'legacy-transaction', 'legacy-profile', 'expense', 12345, 'SAR',
        'Legacy Merchant', 'Preserve me', 'legacy-category', 1, 1, 1
      )
    ''',
  );
  await executor.runCustom('PRAGMA user_version = 1');
  await executor.close();
}

void main() {
  test('schema v1 migrates to v2 without deleting existing records', () async {
    final directory = await Directory.systemTemp.createTemp('dinarwise_v1_');
    final file = File('${directory.path}/migration.sqlite');
    addTearDown(() => directory.delete(recursive: true));
    await _createVersionOneSchema(file);

    final database = AppDatabase(NativeDatabase(file));
    addTearDown(database.close);

    final legacy = await (database.select(database.financialTransactions)
          ..where((row) => row.id.equals('legacy-transaction')))
        .getSingle();
    expect(legacy.merchant, 'Legacy Merchant');
    expect(legacy.amountMinor, 12345);
    expect(legacy.paymentMethodId, isNull);
    expect(legacy.receiptAttachmentId, isNull);

    final version = await database
        .customSelect('PRAGMA user_version')
        .map((row) => row.read<int>('user_version'))
        .getSingle();
    expect(version, 2);

    final newTables = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' "
          "AND name IN ('payment_methods', 'receipt_attachments', "
          "'recurring_occurrences', 'notification_schedules', "
          "'exchange_rates', 'security_preferences')",
        )
        .get();
    expect(newTables, hasLength(6));

    final indexes = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'index' "
          "AND name = 'idx_transactions_profile_date'",
        )
        .get();
    expect(indexes, hasLength(1));
  });
}
