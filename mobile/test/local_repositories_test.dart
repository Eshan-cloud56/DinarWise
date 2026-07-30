import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/categories/data/drift_category_repository.dart';
import 'package:dinarwise/features/expenses/data/drift_expense_repository.dart';
import 'package:dinarwise/features/expenses/data/expense_repository.dart';
import 'package:dinarwise/features/planning/data/drift_planning_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase database;
  late DriftCategoryRepository categories;
  late DriftExpenseRepository expenses;
  late DriftPlanningRepository planning;
  const profileId = 'stable-local-profile';

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    categories = DriftCategoryRepository(database);
    expenses = DriftExpenseRepository(database);
    planning = DriftPlanningRepository(database);
  });

  tearDown(() => database.close());

  test('stable local categories and expenses work completely offline',
      () async {
    await categories.ensureSystemCategories(profileId);
    final categoryList = await categories.watchAll(profileId).first;
    final shopping = categoryList.singleWhere(
      (category) => category.systemCode == 'shopping',
    );
    await expenses.create(
      profileId: profileId,
      amountMinor: 20000,
      merchant: 'Salary',
      description: '',
      categoryId: shopping.id,
      transactedAt: DateTime(2026, 7, 28),
      type: 'income',
    );
    await expenses.create(
      profileId: profileId,
      amountMinor: 12500,
      merchant: 'متجر محلي',
      description: 'ملاحظة عربية',
      categoryId: shopping.id,
      transactedAt: DateTime(2026, 7, 29),
    );
    var records = await expenses.watchAll(profileId).first;
    expect(records, hasLength(2));
    final updated = records.singleWhere((record) => record.type == 'expense');
    expect(updated.merchant, 'متجر محلي');
    await expenses.update(
      ExpenseRecord(
        id: updated.id,
        profileId: profileId,
        type: updated.type,
        amountMinor: 15000,
        currency: updated.currency,
        merchant: updated.merchant,
        description: updated.description,
        categoryId: updated.categoryId,
        transactedAt: updated.transactedAt,
      ),
    );
    records = await expenses.watchAll(profileId).first;
    expect(
      records.singleWhere((record) => record.type == 'expense').amountMinor,
      15000,
    );
    await expenses.delete(
      records.singleWhere((record) => record.type == 'expense').id,
    );
    records = await expenses.watchAll(profileId).first;
    expect(records, hasLength(1));
    await expenses.delete(records.single.id);
    expect(await expenses.watchAll(profileId).first, isEmpty);
  });

  test('custom category trims, deduplicates, renames, and protects use',
      () async {
    final custom = await categories.createCustom(
      profileId,
      '  Wedding gifts  ',
    );
    expect(custom.name, 'Wedding gifts');
    await expectLater(
      categories.createCustom(profileId, 'wedding GIFTS'),
      throwsA(isA<FormatException>()),
    );
    await categories.renameCustom(custom.id, 'هدايا الزواج');
    var list = await categories.watchAll(profileId).first;
    expect(list.single.name, 'هدايا الزواج');
    await expenses.create(
      profileId: profileId,
      amountMinor: 1000,
      merchant: 'Income',
      description: '',
      categoryId: custom.id,
      transactedAt: DateTime.now(),
      type: 'income',
    );
    await expenses.create(
      profileId: profileId,
      amountMinor: 1000,
      merchant: 'Test',
      description: '',
      categoryId: custom.id,
      transactedAt: DateTime.now(),
    );
    expect(
      await categories.deleteCustom(custom.id),
      DeleteCategoryResult.inUse,
    );
    final records = await expenses.watchAll(profileId).first;
    await expenses.delete(
      records.singleWhere((record) => record.type == 'expense').id,
    );
    await expenses.delete(
      records.singleWhere((record) => record.type == 'income').id,
    );
    expect(
      await categories.deleteCustom(custom.id),
      DeleteCategoryResult.deleted,
    );
    list = await categories.watchAll(profileId).first;
    expect(list, isEmpty);
  });

  test('budgets, goals, BNPL, and recurring payments work offline', () async {
    for (final section in ['budgets', 'goals', 'bnpl', 'recurring']) {
      await planning.create(
        profileId: profileId,
        section: section,
        name: 'Local $section',
        amountMinor: 50000,
        date: DateTime(2026, 8, 1),
      );
      final records = await planning.watchSection(profileId, section).first;
      expect(records, hasLength(1));
      expect(records.single.amountMinor, 50000);
      await planning.delete(section, records.single.id);
      expect(await planning.watchSection(profileId, section).first, isEmpty);
    }
  });

  test('BNPL creation persists four offline instalments', () async {
    await planning.create(
      profileId: profileId,
      section: 'bnpl',
      name: 'Local purchase',
      amountMinor: 10001,
      date: DateTime(2026, 7, 29),
    );
    final plan = (await database.select(database.bnplPlans).get()).single;
    final instalments = await (database.select(database.bnplInstalments)
          ..where((row) => row.planId.equals(plan.id)))
        .get();
    expect(instalments, hasLength(4));
    expect(
      instalments.fold<int>(0, (total, item) => total + item.amountMinor),
      10001,
    );
  });

  test('income, expenses, deletion, and edits recalculate balance', () async {
    await categories.ensureSystemCategories(profileId);
    final category = (await categories.watchAll(profileId).first).first;
    await expenses.create(
      profileId: profileId,
      amountMinor: 100000,
      merchant: 'Salary',
      description: 'Monthly income',
      categoryId: category.id,
      transactedAt: DateTime(2026, 7, 1),
      type: 'income',
    );
    await expenses.create(
      profileId: profileId,
      amountMinor: 40000,
      merchant: 'Local Supermarket',
      description: 'Chicken and household groceries',
      categoryId: category.id,
      transactedAt: DateTime(2026, 7, 2),
    );
    var summary = await expenses.watchSummary(profileId).first;
    expect(summary.totalIncomeMinor, 100000);
    expect(summary.totalExpensesMinor, 40000);
    expect(summary.remainingBalanceMinor, 60000);

    var records = await expenses.watchAll(profileId).first;
    final expense = records.singleWhere((record) => record.type == 'expense');
    await expenses.update(
      ExpenseRecord(
        id: expense.id,
        profileId: expense.profileId,
        type: expense.type,
        amountMinor: 50000,
        currency: expense.currency,
        merchant: expense.merchant,
        description: expense.description,
        categoryId: expense.categoryId,
        transactedAt: expense.transactedAt,
      ),
    );
    summary = await expenses.watchSummary(profileId).first;
    expect(summary.remainingBalanceMinor, 50000);

    records = await expenses.watchAll(profileId).first;
    await expenses.delete(
      records.singleWhere((record) => record.type == 'expense').id,
    );
    summary = await expenses.watchSummary(profileId).first;
    expect(summary.remainingBalanceMinor, 100000);
  });

  test('overspending and non-positive transactions are rejected atomically',
      () async {
    await categories.ensureSystemCategories(profileId);
    final category = (await categories.watchAll(profileId).first).first;
    await expenses.create(
      profileId: profileId,
      amountMinor: 10000,
      merchant: 'Income',
      description: '',
      categoryId: category.id,
      transactedAt: DateTime.now(),
      type: 'income',
    );
    await expectLater(
      expenses.create(
        profileId: profileId,
        amountMinor: 10001,
        merchant: 'Too expensive',
        description: '',
        categoryId: category.id,
        transactedAt: DateTime.now(),
      ),
      throwsA(
        isA<TransactionValidationException>().having(
          (error) => error.failure,
          'failure',
          TransactionValidationFailure.insufficientBalance,
        ),
      ),
    );
    await expectLater(
      expenses.create(
        profileId: profileId,
        amountMinor: 0,
        merchant: 'Invalid',
        description: '',
        categoryId: category.id,
        transactedAt: DateTime.now(),
        type: 'income',
      ),
      throwsA(
        isA<TransactionValidationException>().having(
          (error) => error.failure,
          'failure',
          TransactionValidationFailure.amountMustBePositive,
        ),
      ),
    );
    final summary = await expenses.watchSummary(profileId).first;
    expect(summary.remainingBalanceMinor, 10000);
    expect(await expenses.watchAll(profileId).first, hasLength(1));
  });

  test('expense edits and income reduction cannot make balance negative',
      () async {
    await categories.ensureSystemCategories(profileId);
    final category = (await categories.watchAll(profileId).first).first;
    await expenses.create(
      profileId: profileId,
      amountMinor: 10000,
      merchant: 'Income',
      description: '',
      categoryId: category.id,
      transactedAt: DateTime.now(),
      type: 'income',
    );
    await expenses.create(
      profileId: profileId,
      amountMinor: 8000,
      merchant: 'Expense',
      description: '',
      categoryId: category.id,
      transactedAt: DateTime.now(),
    );
    final records = await expenses.watchAll(profileId).first;
    final expense = records.singleWhere((record) => record.type == 'expense');
    final income = records.singleWhere((record) => record.type == 'income');

    await expectLater(
      expenses.update(
        ExpenseRecord(
          id: expense.id,
          profileId: expense.profileId,
          type: expense.type,
          amountMinor: 10001,
          currency: expense.currency,
          merchant: expense.merchant,
          description: expense.description,
          categoryId: expense.categoryId,
          transactedAt: expense.transactedAt,
        ),
      ),
      throwsA(isA<TransactionValidationException>()),
    );
    await expectLater(
      expenses.update(
        ExpenseRecord(
          id: income.id,
          profileId: income.profileId,
          type: income.type,
          amountMinor: 7999,
          currency: income.currency,
          merchant: income.merchant,
          description: income.description,
          categoryId: income.categoryId,
          transactedAt: income.transactedAt,
        ),
      ),
      throwsA(
        isA<TransactionValidationException>().having(
          (error) => error.failure,
          'failure',
          TransactionValidationFailure.incomeReductionWouldOverdraw,
        ),
      ),
    );
    await expectLater(
      expenses.delete(income.id),
      throwsA(
        isA<TransactionValidationException>().having(
          (error) => error.failure,
          'failure',
          TransactionValidationFailure.incomeReductionWouldOverdraw,
        ),
      ),
    );
    final summary = await expenses.watchSummary(profileId).first;
    expect(summary.remainingBalanceMinor, 2000);
  });

  test('financial data survives closing and reopening SQLite', () async {
    final directory = await Directory.systemTemp.createTemp('dinarwise_test_');
    final file = File('${directory.path}/finance.sqlite');
    addTearDown(() => directory.delete(recursive: true));

    final firstDatabase = AppDatabase(NativeDatabase(file));
    final firstCategories = DriftCategoryRepository(firstDatabase);
    final firstExpenses = DriftExpenseRepository(firstDatabase);
    await firstCategories.ensureSystemCategories(profileId);
    final category = (await firstCategories.watchAll(profileId).first).first;
    await firstExpenses.create(
      profileId: profileId,
      amountMinor: 75000,
      merchant: 'Persistent salary',
      description: '',
      categoryId: category.id,
      transactedAt: DateTime(2026, 7, 29),
      type: 'income',
    );
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(NativeDatabase(file));
    final reopenedExpenses = DriftExpenseRepository(reopenedDatabase);
    final records = await reopenedExpenses.watchAll(profileId).first;
    expect(records.single.merchant, 'Persistent salary');
    expect(
      (await reopenedExpenses.watchSummary(profileId).first)
          .remainingBalanceMinor,
      75000,
    );
    await reopenedDatabase.close();
  });

  test('reset clears all structured financial records', () async {
    await categories.ensureSystemCategories(profileId);
    await planning.create(
      profileId: profileId,
      section: 'budgets',
      name: 'Monthly',
      amountMinor: 100000,
      date: DateTime.now(),
    );
    await database.clearAllFinancialData();
    expect(await categories.watchAll(profileId).first, isEmpty);
    expect(await planning.watchSection(profileId, 'budgets').first, isEmpty);
  });
}
