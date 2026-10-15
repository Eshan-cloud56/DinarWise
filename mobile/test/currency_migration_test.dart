import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:dinarwise/core/currency/app_currency.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

class _VersionTwoExecutorUser implements QueryExecutorUser {
  @override
  int get schemaVersion => 2;

  @override
  Future<void> beforeOpen(
    QueryExecutor executor,
    OpeningDetails details,
  ) async {}
}

Future<void> _createVersionTwoSchemaWithRecords(File file) async {
  final executor = NativeDatabase(file);
  await executor.ensureOpen(_VersionTwoExecutorUser());

  // Create v2 tables
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
        payment_method_id TEXT,
        receipt_attachment_id TEXT,
        original_currency TEXT,
        original_amount_minor INTEGER,
        exchange_rate_id TEXT,
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
        created_at INTEGER NOT NULL,
        is_overall INTEGER NOT NULL DEFAULT 0,
        rollover_mode TEXT NOT NULL DEFAULT 'none',
        cycle_type TEXT NOT NULL DEFAULT 'monthly',
        payday INTEGER,
        fixed_commitments_minor INTEGER NOT NULL DEFAULT 0,
        emergency_buffer_minor INTEGER NOT NULL DEFAULT 0
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
        contributed_at INTEGER NOT NULL,
        note TEXT
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
        created_at INTEGER NOT NULL,
        custom_provider TEXT,
        status TEXT NOT NULL DEFAULT 'active'
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
        is_active INTEGER NOT NULL DEFAULT 1,
        interval_count INTEGER NOT NULL DEFAULT 1,
        start_date INTEGER NOT NULL DEFAULT 0,
        end_date INTEGER,
        max_occurrences INTEGER,
        generated_occurrences INTEGER NOT NULL DEFAULT 0,
        status TEXT NOT NULL DEFAULT 'active',
        last_reconciled_at INTEGER
      )
    ''',
    '''
      CREATE TABLE recurring_occurrences (
        id TEXT NOT NULL PRIMARY KEY,
        profile_id TEXT NOT NULL,
        recurring_payment_id TEXT NOT NULL,
        scheduled_at INTEGER NOT NULL,
        amount_minor INTEGER NOT NULL,
        status TEXT NOT NULL DEFAULT 'scheduled',
        paid_at INTEGER,
        created_at INTEGER NOT NULL
      )
    ''',
    '''
      CREATE TABLE financial_preferences (
        profile_id TEXT NOT NULL PRIMARY KEY,
        monthly_income_minor INTEGER NOT NULL DEFAULT 0,
        payday INTEGER NOT NULL DEFAULT 1,
        currency TEXT NOT NULL DEFAULT 'SAR',
        notifications_enabled INTEGER NOT NULL DEFAULT 1,
        default_payment_method_id TEXT,
        widget_privacy_enabled INTEGER NOT NULL DEFAULT 0
      )
    ''',
    '''
      CREATE TABLE payment_methods (
        id TEXT NOT NULL PRIMARY KEY,
        profile_id TEXT NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        details TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL
      )
    ''',
    '''
      CREATE TABLE receipt_attachments (
        id TEXT NOT NULL PRIMARY KEY,
        profile_id TEXT NOT NULL,
        file_path TEXT NOT NULL,
        mime_type TEXT NOT NULL,
        file_size INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''',
    '''
      CREATE TABLE exchange_rates (
        id TEXT NOT NULL PRIMARY KEY,
        base_currency TEXT NOT NULL,
        target_currency TEXT NOT NULL,
        rate REAL NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''',
    '''
      CREATE TABLE notification_schedules (
        id TEXT NOT NULL PRIMARY KEY,
        profile_id TEXT NOT NULL,
        type TEXT NOT NULL,
        scheduled_for INTEGER NOT NULL,
        is_sent INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''',
    '''
      CREATE TABLE security_preferences (
        profile_id TEXT NOT NULL PRIMARY KEY,
        biometrics_enabled INTEGER NOT NULL DEFAULT 0,
        pin_hash TEXT,
        auto_lock_interval INTEGER NOT NULL DEFAULT 0
      )
    ''',
  ];

  for (final statement in statements) {
    await executor.runCustom(statement);
  }

  // Seed with required records:
  // SAR: 10000
  // KWD: 125
  // BHD: 350
  // OMR: 275
  await executor.runCustom('''
    INSERT INTO financial_transactions (
      id, profile_id, type, amount_minor, currency, merchant, description,
      category_id, transacted_at, created_at, updated_at
    ) VALUES
      ('tx-sar', 'p1', 'expense', 10000, 'SAR', 'SAR Merchant', 'SAR test', 'cat1', 1, 1, 1),
      ('tx-kwd', 'p1', 'expense', 125, 'KWD', 'KWD Merchant', 'KWD test', 'cat1', 1, 1, 1),
      ('tx-bhd', 'p1', 'expense', 350, 'BHD', 'BHD Merchant', 'BHD test', 'cat1', 1, 1, 1),
      ('tx-omr', 'p1', 'expense', 275, 'OMR', 'OMR Merchant', 'OMR test', 'cat1', 1, 1, 1);
  ''');

  // Also seed recurring payments and BNPL plans in KWD/BHD/OMR/SAR
  await executor.runCustom('''
    INSERT INTO recurring_payments (
      id, profile_id, name, amount_minor, currency, recurrence, next_payment_date, is_subscription, is_active
    ) VALUES
      ('rec-sar', 'p1', 'SAR Bill', 10000, 'SAR', 'monthly', 1, 0, 1),
      ('rec-kwd', 'p1', 'KWD Bill', 125, 'KWD', 'monthly', 1, 0, 1),
      ('rec-bhd', 'p1', 'BHD Bill', 350, 'BHD', 'monthly', 1, 0, 1),
      ('rec-omr', 'p1', 'OMR Bill', 275, 'OMR', 'monthly', 1, 0, 1);
  ''');

  await executor.runCustom('''
    INSERT INTO bnpl_plans (
      id, profile_id, provider, merchant, purchase_amount_minor, currency,
      instalment_count, purchase_date, created_at
    ) VALUES
      ('bnpl-kwd', 'p1', 'tabby', 'KWD Store', 125, 'KWD', 1, 1, 1),
      ('bnpl-sar', 'p1', 'tabby', 'SAR Store', 10000, 'SAR', 1, 1, 1);
  ''');

  await executor.runCustom('''
    INSERT INTO financial_preferences (
      profile_id, monthly_income_minor, payday, currency
    ) VALUES
      ('p-kwd', 125, 1, 'KWD'),
      ('p-sar', 10000, 1, 'SAR');
  ''');

  await executor.runCustom('PRAGMA user_version = 2');
  await executor.close();
}

void main() {
  group('Precision Drift Migration (v2 -> v3)', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('dinarwise_precision_mig_');
      dbFile = File('${tempDir.path}/app_test.sqlite');
      await _createVersionTwoSchemaWithRecords(dbFile);
    });

    tearDown(() async {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('migrates KWD/BHD/OMR by factor 10, leaves SAR untouched, preserves monetary meaning', () async {
      // 1. Verify pre-migration monetary meaning under old 100-factor:
      // 10000 SAR / 100 = 100.00 SAR
      // 125 KWD / 100 = 1.25 KWD
      // 350 BHD / 100 = 3.50 BHD
      // 275 OMR / 100 = 2.75 OMR
      const oldFactor = 100;
      expect(10000 / oldFactor, 100.00);
      expect(125 / oldFactor, 1.25);
      expect(350 / oldFactor, 3.50);
      expect(275 / oldFactor, 2.75);

      // 2. Open database with AppDatabase (executes Drift schema migration v2 -> v3)
      var db = AppDatabase(NativeDatabase(dbFile));

      final version = await db
          .customSelect('PRAGMA user_version')
          .map((row) => row.read<int>('user_version'))
          .getSingle();
      expect(version, 3, reason: 'Schema version must be upgraded to 3');

      // Check transactions
      final txSar = await (db.select(db.financialTransactions)..where((t) => t.id.equals('tx-sar'))).getSingle();
      final txKwd = await (db.select(db.financialTransactions)..where((t) => t.id.equals('tx-kwd'))).getSingle();
      final txBhd = await (db.select(db.financialTransactions)..where((t) => t.id.equals('tx-bhd'))).getSingle();
      final txOmr = await (db.select(db.financialTransactions)..where((t) => t.id.equals('tx-omr'))).getSingle();

      expect(txSar.amountMinor, 10000, reason: 'SAR must remain 10000');
      expect(txKwd.amountMinor, 1250, reason: 'KWD 125 must become 1250');
      expect(txBhd.amountMinor, 3500, reason: 'BHD 350 must become 3500');
      expect(txOmr.amountMinor, 2750, reason: 'OMR 275 must become 2750');

      // Verify post-migration monetary meaning under new 1000-factor:
      final kwdCurrency = AppCurrency.fromCode('KWD');
      final bhdCurrency = AppCurrency.fromCode('BHD');
      final omrCurrency = AppCurrency.fromCode('OMR');
      final sarCurrency = AppCurrency.fromCode('SAR');

      expect(sarCurrency.toMajor(txSar.amountMinor), 100.00);
      expect(kwdCurrency.toMajor(txKwd.amountMinor), 1.250);
      expect(bhdCurrency.toMajor(txBhd.amountMinor), 3.500);
      expect(omrCurrency.toMajor(txOmr.amountMinor), 2.750);

      // Check recurring payments
      final recSar = await (db.select(db.recurringPayments)..where((r) => r.id.equals('rec-sar'))).getSingle();
      final recKwd = await (db.select(db.recurringPayments)..where((r) => r.id.equals('rec-kwd'))).getSingle();
      final recBhd = await (db.select(db.recurringPayments)..where((r) => r.id.equals('rec-bhd'))).getSingle();
      final recOmr = await (db.select(db.recurringPayments)..where((r) => r.id.equals('rec-omr'))).getSingle();

      expect(recSar.amountMinor, 10000);
      expect(recKwd.amountMinor, 1250);
      expect(recBhd.amountMinor, 3500);
      expect(recOmr.amountMinor, 2750);

      // Check BNPL
      final bnplKwd = await (db.select(db.bnplPlans)..where((b) => b.id.equals('bnpl-kwd'))).getSingle();
      final bnplSar = await (db.select(db.bnplPlans)..where((b) => b.id.equals('bnpl-sar'))).getSingle();
      expect(bnplKwd.purchaseAmountMinor, 1250);
      expect(bnplSar.purchaseAmountMinor, 10000);

      // Check financial preferences
      final prefKwd = await (db.select(db.financialPreferences)..where((p) => p.profileId.equals('p-kwd'))).getSingle();
      final prefSar = await (db.select(db.financialPreferences)..where((p) => p.profileId.equals('p-sar'))).getSingle();
      expect(prefKwd.monthlyIncomeMinor, 1250);
      expect(prefSar.monthlyIncomeMinor, 10000);

      await db.close();

      // 3. Re-open the migrated database MULTIPLE times and verify values DO NOT get multiplied again
      for (var i = 1; i <= 3; i++) {
        db = AppDatabase(NativeDatabase(dbFile));
        final txKwdReopen = await (db.select(db.financialTransactions)..where((t) => t.id.equals('tx-kwd'))).getSingle();
        final txSarReopen = await (db.select(db.financialTransactions)..where((t) => t.id.equals('tx-sar'))).getSingle();
        final txBhdReopen = await (db.select(db.financialTransactions)..where((t) => t.id.equals('tx-bhd'))).getSingle();
        final txOmrReopen = await (db.select(db.financialTransactions)..where((t) => t.id.equals('tx-omr'))).getSingle();

        expect(txKwdReopen.amountMinor, 1250, reason: 'Reopening iteration $i must NOT multiply KWD again');
        expect(txSarReopen.amountMinor, 10000, reason: 'Reopening iteration $i must leave SAR at 10000');
        expect(txBhdReopen.amountMinor, 3500, reason: 'Reopening iteration $i must NOT multiply BHD again');
        expect(txOmrReopen.amountMinor, 2750, reason: 'Reopening iteration $i must NOT multiply OMR again');

        final dbVersion = await db
            .customSelect('PRAGMA user_version')
            .map((row) => row.read<int>('user_version'))
            .getSingle();
        expect(dbVersion, 3);
        await db.close();
      }
    });
  });
}
