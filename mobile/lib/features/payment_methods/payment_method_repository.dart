import 'package:drift/drift.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:uuid/uuid.dart';

const defaultPaymentMethodCodes = [
  'cash',
  'debit_card',
  'credit_card',
  'bank_transfer',
  'mada',
  'stc_pay',
  'google_pay',
  'tabby',
  'tamara',
  'other',
];

class PaymentMethodDetails {
  const PaymentMethodDetails({
    required this.id,
    required this.systemCode,
    required this.name,
    required this.iconName,
    required this.isSystem,
    required this.isDefault,
    required this.usageCount,
    required this.lastUsedAt,
  });

  final String id;
  final String? systemCode;
  final String name;
  final String iconName;
  final bool isSystem;
  final bool isDefault;
  final int usageCount;
  final DateTime? lastUsedAt;
}

class PaymentMethodRepository {
  PaymentMethodRepository(this._database);

  final AppDatabase _database;

  Future<void> ensureDefaults(String profileId) async {
    final existing = await (_database.select(_database.paymentMethods)
          ..where((row) => row.profileId.equals(profileId)))
        .get();
    if (existing.length >= defaultPaymentMethodCodes.length) return;
    await _database.batch((batch) {
      for (final code in defaultPaymentMethodCodes) {
        batch.insert(
          _database.paymentMethods,
          PaymentMethodsCompanion.insert(
            id: '$profileId:payment:$code',
            profileId: profileId,
            systemCode: Value(code),
            name: code,
            iconName: Value(code),
            isSystem: const Value(true),
            isDefault: Value(code == 'cash' && existing.isEmpty),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  Stream<List<PaymentMethodDetails>> watchAll(String profileId) => _database
      .customSelect(
        '''
          SELECT p.*,
            COUNT(t.id) AS usage_count,
            MAX(t.transacted_at) AS transaction_last_used
          FROM payment_methods p
          LEFT JOIN financial_transactions t ON t.payment_method_id = p.id
          WHERE p.profile_id = ?
          GROUP BY p.id
          ORDER BY p.is_default DESC, usage_count DESC,
            COALESCE(transaction_last_used, p.last_used_at) DESC, p.name
        ''',
        variables: [Variable(profileId)],
        readsFrom: {
          _database.paymentMethods,
          _database.financialTransactions,
        },
      )
      .watch()
      .map(
        (rows) => rows
            .map(
              (row) => PaymentMethodDetails(
                id: row.read<String>('id'),
                systemCode: row.readNullable<String>('system_code'),
                name: row.read<String>('name'),
                iconName: row.read<String>('icon_name'),
                isSystem: row.read<bool>('is_system'),
                isDefault: row.read<bool>('is_default'),
                usageCount: row.read<int>('usage_count'),
                lastUsedAt:
                    row.readNullable<DateTime>('transaction_last_used') ??
                        row.readNullable<DateTime>('last_used_at'),
              ),
            )
            .toList(),
      );

  Future<void> create(String profileId, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > 50) {
      throw const FormatException('invalid_payment_method');
    }
    final rows = await (_database.select(_database.paymentMethods)
          ..where((row) => row.profileId.equals(profileId)))
        .get();
    if (rows.any((row) => row.name.toLowerCase() == trimmed.toLowerCase())) {
      throw const FormatException('duplicate_payment_method');
    }
    await _database.into(_database.paymentMethods).insert(
          PaymentMethodsCompanion.insert(
            id: const Uuid().v4(),
            profileId: profileId,
            name: trimmed,
          ),
        );
  }

  Future<void> rename(String id, String name) async {
    final current = await (_database.select(_database.paymentMethods)
          ..where((row) => row.id.equals(id)))
        .getSingle();
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > 50) {
      throw const FormatException('invalid_payment_method');
    }
    final duplicate = await (_database.select(_database.paymentMethods)
          ..where((row) =>
              row.profileId.equals(current.profileId) &
              row.name.lower().equals(trimmed.toLowerCase()) &
              row.id.equals(id).not()))
        .getSingleOrNull();
    if (duplicate != null) {
      throw const FormatException('duplicate_payment_method');
    }
    await (_database.update(_database.paymentMethods)
          ..where((row) => row.id.equals(id)))
        .write(PaymentMethodsCompanion(name: Value(trimmed)));
  }

  Future<void> setDefault(String profileId, String id) async {
    await _database.transaction(() async {
      await (_database.update(_database.paymentMethods)
            ..where((row) => row.profileId.equals(profileId)))
          .write(const PaymentMethodsCompanion(isDefault: Value(false)));
      await (_database.update(_database.paymentMethods)
            ..where((row) => row.id.equals(id)))
          .write(const PaymentMethodsCompanion(isDefault: Value(true)));
      await _database.into(_database.financialPreferences).insert(
            FinancialPreferencesCompanion.insert(
              profileId: profileId,
              defaultPaymentMethodId: Value(id),
            ),
            mode: InsertMode.insertOrIgnore,
          );
      await (_database.update(_database.financialPreferences)
            ..where((row) => row.profileId.equals(profileId)))
          .write(
              FinancialPreferencesCompanion(defaultPaymentMethodId: Value(id)));
    });
  }

  Future<bool> delete(String id, {String? reassignTo}) async {
    return _database.transaction(() async {
      final usage = await (_database.select(_database.financialTransactions)
            ..where((row) => row.paymentMethodId.equals(id)))
          .get();
      if (usage.isNotEmpty && reassignTo == null) return false;
      if (reassignTo != null) {
        await (_database.update(_database.financialTransactions)
              ..where((row) => row.paymentMethodId.equals(id)))
            .write(
          FinancialTransactionsCompanion(
            paymentMethodId: Value(reassignTo),
          ),
        );
      }
      await (_database.delete(_database.paymentMethods)
            ..where((row) => row.id.equals(id)))
          .go();
      return true;
    });
  }
}
