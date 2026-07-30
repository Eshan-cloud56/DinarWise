// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FinancialTransactionsTable extends FinancialTransactions
    with TableInfo<$FinancialTransactionsTable, FinancialTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('expense'));
  static const VerificationMeta _amountMinorMeta =
      const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
      'amount_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('SAR'));
  static const VerificationMeta _merchantMeta =
      const VerificationMeta('merchant');
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
      'merchant', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transactedAtMeta =
      const VerificationMeta('transactedAt');
  @override
  late final GeneratedColumn<DateTime> transactedAt = GeneratedColumn<DateTime>(
      'transacted_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paymentMethodIdMeta =
      const VerificationMeta('paymentMethodId');
  @override
  late final GeneratedColumn<String> paymentMethodId = GeneratedColumn<String>(
      'payment_method_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _receiptAttachmentIdMeta =
      const VerificationMeta('receiptAttachmentId');
  @override
  late final GeneratedColumn<String> receiptAttachmentId =
      GeneratedColumn<String>('receipt_attachment_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _originalCurrencyMeta =
      const VerificationMeta('originalCurrency');
  @override
  late final GeneratedColumn<String> originalCurrency = GeneratedColumn<String>(
      'original_currency', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _originalAmountMinorMeta =
      const VerificationMeta('originalAmountMinor');
  @override
  late final GeneratedColumn<int> originalAmountMinor = GeneratedColumn<int>(
      'original_amount_minor', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _exchangeRateIdMeta =
      const VerificationMeta('exchangeRateId');
  @override
  late final GeneratedColumn<String> exchangeRateId = GeneratedColumn<String>(
      'exchange_rate_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        type,
        amountMinor,
        currency,
        merchant,
        description,
        categoryId,
        transactedAt,
        paymentMethod,
        paymentMethodId,
        receiptAttachmentId,
        originalCurrency,
        originalAmountMinor,
        exchangeRateId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_transactions';
  @override
  VerificationContext validateIntegrity(
      Insertable<FinancialTransaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
          _amountMinorMeta,
          amountMinor.isAcceptableOrUnknown(
              data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('merchant')) {
      context.handle(_merchantMeta,
          merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('transacted_at')) {
      context.handle(
          _transactedAtMeta,
          transactedAt.isAcceptableOrUnknown(
              data['transacted_at']!, _transactedAtMeta));
    } else if (isInserting) {
      context.missing(_transactedAtMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('payment_method_id')) {
      context.handle(
          _paymentMethodIdMeta,
          paymentMethodId.isAcceptableOrUnknown(
              data['payment_method_id']!, _paymentMethodIdMeta));
    }
    if (data.containsKey('receipt_attachment_id')) {
      context.handle(
          _receiptAttachmentIdMeta,
          receiptAttachmentId.isAcceptableOrUnknown(
              data['receipt_attachment_id']!, _receiptAttachmentIdMeta));
    }
    if (data.containsKey('original_currency')) {
      context.handle(
          _originalCurrencyMeta,
          originalCurrency.isAcceptableOrUnknown(
              data['original_currency']!, _originalCurrencyMeta));
    }
    if (data.containsKey('original_amount_minor')) {
      context.handle(
          _originalAmountMinorMeta,
          originalAmountMinor.isAcceptableOrUnknown(
              data['original_amount_minor']!, _originalAmountMinorMeta));
    }
    if (data.containsKey('exchange_rate_id')) {
      context.handle(
          _exchangeRateIdMeta,
          exchangeRateId.isAcceptableOrUnknown(
              data['exchange_rate_id']!, _exchangeRateIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinancialTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialTransaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      amountMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_minor'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      merchant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}merchant']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      transactedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transacted_at'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method']),
      paymentMethodId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}payment_method_id']),
      receiptAttachmentId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}receipt_attachment_id']),
      originalCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}original_currency']),
      originalAmountMinor: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}original_amount_minor']),
      exchangeRateId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}exchange_rate_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $FinancialTransactionsTable createAlias(String alias) {
    return $FinancialTransactionsTable(attachedDatabase, alias);
  }
}

class FinancialTransaction extends DataClass
    implements Insertable<FinancialTransaction> {
  final String id;
  final String profileId;
  final String type;
  final int amountMinor;
  final String currency;
  final String? merchant;
  final String? description;
  final String categoryId;
  final DateTime transactedAt;
  final String? paymentMethod;
  final String? paymentMethodId;
  final String? receiptAttachmentId;
  final String? originalCurrency;
  final int? originalAmountMinor;
  final String? exchangeRateId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FinancialTransaction(
      {required this.id,
      required this.profileId,
      required this.type,
      required this.amountMinor,
      required this.currency,
      this.merchant,
      this.description,
      required this.categoryId,
      required this.transactedAt,
      this.paymentMethod,
      this.paymentMethodId,
      this.receiptAttachmentId,
      this.originalCurrency,
      this.originalAmountMinor,
      this.exchangeRateId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['type'] = Variable<String>(type);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || merchant != null) {
      map['merchant'] = Variable<String>(merchant);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['category_id'] = Variable<String>(categoryId);
    map['transacted_at'] = Variable<DateTime>(transactedAt);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || paymentMethodId != null) {
      map['payment_method_id'] = Variable<String>(paymentMethodId);
    }
    if (!nullToAbsent || receiptAttachmentId != null) {
      map['receipt_attachment_id'] = Variable<String>(receiptAttachmentId);
    }
    if (!nullToAbsent || originalCurrency != null) {
      map['original_currency'] = Variable<String>(originalCurrency);
    }
    if (!nullToAbsent || originalAmountMinor != null) {
      map['original_amount_minor'] = Variable<int>(originalAmountMinor);
    }
    if (!nullToAbsent || exchangeRateId != null) {
      map['exchange_rate_id'] = Variable<String>(exchangeRateId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FinancialTransactionsCompanion toCompanion(bool nullToAbsent) {
    return FinancialTransactionsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      type: Value(type),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      merchant: merchant == null && nullToAbsent
          ? const Value.absent()
          : Value(merchant),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      categoryId: Value(categoryId),
      transactedAt: Value(transactedAt),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      paymentMethodId: paymentMethodId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethodId),
      receiptAttachmentId: receiptAttachmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptAttachmentId),
      originalCurrency: originalCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(originalCurrency),
      originalAmountMinor: originalAmountMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(originalAmountMinor),
      exchangeRateId: exchangeRateId == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeRateId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FinancialTransaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialTransaction(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      type: serializer.fromJson<String>(json['type']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      merchant: serializer.fromJson<String?>(json['merchant']),
      description: serializer.fromJson<String?>(json['description']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      transactedAt: serializer.fromJson<DateTime>(json['transactedAt']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      paymentMethodId: serializer.fromJson<String?>(json['paymentMethodId']),
      receiptAttachmentId:
          serializer.fromJson<String?>(json['receiptAttachmentId']),
      originalCurrency: serializer.fromJson<String?>(json['originalCurrency']),
      originalAmountMinor:
          serializer.fromJson<int?>(json['originalAmountMinor']),
      exchangeRateId: serializer.fromJson<String?>(json['exchangeRateId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'type': serializer.toJson<String>(type),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'merchant': serializer.toJson<String?>(merchant),
      'description': serializer.toJson<String?>(description),
      'categoryId': serializer.toJson<String>(categoryId),
      'transactedAt': serializer.toJson<DateTime>(transactedAt),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'paymentMethodId': serializer.toJson<String?>(paymentMethodId),
      'receiptAttachmentId': serializer.toJson<String?>(receiptAttachmentId),
      'originalCurrency': serializer.toJson<String?>(originalCurrency),
      'originalAmountMinor': serializer.toJson<int?>(originalAmountMinor),
      'exchangeRateId': serializer.toJson<String?>(exchangeRateId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FinancialTransaction copyWith(
          {String? id,
          String? profileId,
          String? type,
          int? amountMinor,
          String? currency,
          Value<String?> merchant = const Value.absent(),
          Value<String?> description = const Value.absent(),
          String? categoryId,
          DateTime? transactedAt,
          Value<String?> paymentMethod = const Value.absent(),
          Value<String?> paymentMethodId = const Value.absent(),
          Value<String?> receiptAttachmentId = const Value.absent(),
          Value<String?> originalCurrency = const Value.absent(),
          Value<int?> originalAmountMinor = const Value.absent(),
          Value<String?> exchangeRateId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      FinancialTransaction(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        type: type ?? this.type,
        amountMinor: amountMinor ?? this.amountMinor,
        currency: currency ?? this.currency,
        merchant: merchant.present ? merchant.value : this.merchant,
        description: description.present ? description.value : this.description,
        categoryId: categoryId ?? this.categoryId,
        transactedAt: transactedAt ?? this.transactedAt,
        paymentMethod:
            paymentMethod.present ? paymentMethod.value : this.paymentMethod,
        paymentMethodId: paymentMethodId.present
            ? paymentMethodId.value
            : this.paymentMethodId,
        receiptAttachmentId: receiptAttachmentId.present
            ? receiptAttachmentId.value
            : this.receiptAttachmentId,
        originalCurrency: originalCurrency.present
            ? originalCurrency.value
            : this.originalCurrency,
        originalAmountMinor: originalAmountMinor.present
            ? originalAmountMinor.value
            : this.originalAmountMinor,
        exchangeRateId:
            exchangeRateId.present ? exchangeRateId.value : this.exchangeRateId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  FinancialTransaction copyWithCompanion(FinancialTransactionsCompanion data) {
    return FinancialTransaction(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      type: data.type.present ? data.type.value : this.type,
      amountMinor:
          data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      description:
          data.description.present ? data.description.value : this.description,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      transactedAt: data.transactedAt.present
          ? data.transactedAt.value
          : this.transactedAt,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      paymentMethodId: data.paymentMethodId.present
          ? data.paymentMethodId.value
          : this.paymentMethodId,
      receiptAttachmentId: data.receiptAttachmentId.present
          ? data.receiptAttachmentId.value
          : this.receiptAttachmentId,
      originalCurrency: data.originalCurrency.present
          ? data.originalCurrency.value
          : this.originalCurrency,
      originalAmountMinor: data.originalAmountMinor.present
          ? data.originalAmountMinor.value
          : this.originalAmountMinor,
      exchangeRateId: data.exchangeRateId.present
          ? data.exchangeRateId.value
          : this.exchangeRateId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialTransaction(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('type: $type, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('merchant: $merchant, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('transactedAt: $transactedAt, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('receiptAttachmentId: $receiptAttachmentId, ')
          ..write('originalCurrency: $originalCurrency, ')
          ..write('originalAmountMinor: $originalAmountMinor, ')
          ..write('exchangeRateId: $exchangeRateId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      profileId,
      type,
      amountMinor,
      currency,
      merchant,
      description,
      categoryId,
      transactedAt,
      paymentMethod,
      paymentMethodId,
      receiptAttachmentId,
      originalCurrency,
      originalAmountMinor,
      exchangeRateId,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialTransaction &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.type == this.type &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.merchant == this.merchant &&
          other.description == this.description &&
          other.categoryId == this.categoryId &&
          other.transactedAt == this.transactedAt &&
          other.paymentMethod == this.paymentMethod &&
          other.paymentMethodId == this.paymentMethodId &&
          other.receiptAttachmentId == this.receiptAttachmentId &&
          other.originalCurrency == this.originalCurrency &&
          other.originalAmountMinor == this.originalAmountMinor &&
          other.exchangeRateId == this.exchangeRateId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FinancialTransactionsCompanion
    extends UpdateCompanion<FinancialTransaction> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> type;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<String?> merchant;
  final Value<String?> description;
  final Value<String> categoryId;
  final Value<DateTime> transactedAt;
  final Value<String?> paymentMethod;
  final Value<String?> paymentMethodId;
  final Value<String?> receiptAttachmentId;
  final Value<String?> originalCurrency;
  final Value<int?> originalAmountMinor;
  final Value<String?> exchangeRateId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FinancialTransactionsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.type = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.merchant = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.transactedAt = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.receiptAttachmentId = const Value.absent(),
    this.originalCurrency = const Value.absent(),
    this.originalAmountMinor = const Value.absent(),
    this.exchangeRateId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinancialTransactionsCompanion.insert({
    required String id,
    required String profileId,
    this.type = const Value.absent(),
    required int amountMinor,
    this.currency = const Value.absent(),
    this.merchant = const Value.absent(),
    this.description = const Value.absent(),
    required String categoryId,
    required DateTime transactedAt,
    this.paymentMethod = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.receiptAttachmentId = const Value.absent(),
    this.originalCurrency = const Value.absent(),
    this.originalAmountMinor = const Value.absent(),
    this.exchangeRateId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        amountMinor = Value(amountMinor),
        categoryId = Value(categoryId),
        transactedAt = Value(transactedAt);
  static Insertable<FinancialTransaction> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? type,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<String>? merchant,
    Expression<String>? description,
    Expression<String>? categoryId,
    Expression<DateTime>? transactedAt,
    Expression<String>? paymentMethod,
    Expression<String>? paymentMethodId,
    Expression<String>? receiptAttachmentId,
    Expression<String>? originalCurrency,
    Expression<int>? originalAmountMinor,
    Expression<String>? exchangeRateId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (type != null) 'type': type,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (merchant != null) 'merchant': merchant,
      if (description != null) 'description': description,
      if (categoryId != null) 'category_id': categoryId,
      if (transactedAt != null) 'transacted_at': transactedAt,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      if (receiptAttachmentId != null)
        'receipt_attachment_id': receiptAttachmentId,
      if (originalCurrency != null) 'original_currency': originalCurrency,
      if (originalAmountMinor != null)
        'original_amount_minor': originalAmountMinor,
      if (exchangeRateId != null) 'exchange_rate_id': exchangeRateId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinancialTransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? type,
      Value<int>? amountMinor,
      Value<String>? currency,
      Value<String?>? merchant,
      Value<String?>? description,
      Value<String>? categoryId,
      Value<DateTime>? transactedAt,
      Value<String?>? paymentMethod,
      Value<String?>? paymentMethodId,
      Value<String?>? receiptAttachmentId,
      Value<String?>? originalCurrency,
      Value<int?>? originalAmountMinor,
      Value<String?>? exchangeRateId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return FinancialTransactionsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      type: type ?? this.type,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      merchant: merchant ?? this.merchant,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      transactedAt: transactedAt ?? this.transactedAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      receiptAttachmentId: receiptAttachmentId ?? this.receiptAttachmentId,
      originalCurrency: originalCurrency ?? this.originalCurrency,
      originalAmountMinor: originalAmountMinor ?? this.originalAmountMinor,
      exchangeRateId: exchangeRateId ?? this.exchangeRateId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (transactedAt.present) {
      map['transacted_at'] = Variable<DateTime>(transactedAt.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (paymentMethodId.present) {
      map['payment_method_id'] = Variable<String>(paymentMethodId.value);
    }
    if (receiptAttachmentId.present) {
      map['receipt_attachment_id'] =
          Variable<String>(receiptAttachmentId.value);
    }
    if (originalCurrency.present) {
      map['original_currency'] = Variable<String>(originalCurrency.value);
    }
    if (originalAmountMinor.present) {
      map['original_amount_minor'] = Variable<int>(originalAmountMinor.value);
    }
    if (exchangeRateId.present) {
      map['exchange_rate_id'] = Variable<String>(exchangeRateId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('type: $type, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('merchant: $merchant, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('transactedAt: $transactedAt, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('receiptAttachmentId: $receiptAttachmentId, ')
          ..write('originalCurrency: $originalCurrency, ')
          ..write('originalAmountMinor: $originalAmountMinor, ')
          ..write('exchangeRateId: $exchangeRateId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseCategoriesTable extends ExpenseCategories
    with TableInfo<$ExpenseCategoriesTable, ExpenseCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _systemCodeMeta =
      const VerificationMeta('systemCode');
  @override
  late final GeneratedColumn<String> systemCode = GeneratedColumn<String>(
      'system_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isSystemMeta =
      const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
      'is_system', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_system" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _iconCodePointMeta =
      const VerificationMeta('iconCodePoint');
  @override
  late final GeneratedColumn<int> iconCodePoint = GeneratedColumn<int>(
      'icon_code_point', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xe8cc));
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xff607d8b));
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastUsedAtMeta =
      const VerificationMeta('lastUsedAt');
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
      'last_used_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        systemCode,
        name,
        isSystem,
        iconCodePoint,
        colorValue,
        emoji,
        lastUsedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_categories';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('system_code')) {
      context.handle(
          _systemCodeMeta,
          systemCode.isAcceptableOrUnknown(
              data['system_code']!, _systemCodeMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta,
          isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    if (data.containsKey('icon_code_point')) {
      context.handle(
          _iconCodePointMeta,
          iconCodePoint.isAcceptableOrUnknown(
              data['icon_code_point']!, _iconCodePointMeta));
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
          _lastUsedAtMeta,
          lastUsedAt.isAcceptableOrUnknown(
              data['last_used_at']!, _lastUsedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      systemCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}system_code']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
      iconCodePoint: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}icon_code_point'])!,
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji']),
      lastUsedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_used_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExpenseCategoriesTable createAlias(String alias) {
    return $ExpenseCategoriesTable(attachedDatabase, alias);
  }
}

class ExpenseCategory extends DataClass implements Insertable<ExpenseCategory> {
  final String id;
  final String profileId;
  final String? systemCode;
  final String name;
  final bool isSystem;
  final int iconCodePoint;
  final int colorValue;
  final String? emoji;
  final DateTime? lastUsedAt;
  final DateTime createdAt;
  const ExpenseCategory(
      {required this.id,
      required this.profileId,
      this.systemCode,
      required this.name,
      required this.isSystem,
      required this.iconCodePoint,
      required this.colorValue,
      this.emoji,
      this.lastUsedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    if (!nullToAbsent || systemCode != null) {
      map['system_code'] = Variable<String>(systemCode);
    }
    map['name'] = Variable<String>(name);
    map['is_system'] = Variable<bool>(isSystem);
    map['icon_code_point'] = Variable<int>(iconCodePoint);
    map['color_value'] = Variable<int>(colorValue);
    if (!nullToAbsent || emoji != null) {
      map['emoji'] = Variable<String>(emoji);
    }
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpenseCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCategoriesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      systemCode: systemCode == null && nullToAbsent
          ? const Value.absent()
          : Value(systemCode),
      name: Value(name),
      isSystem: Value(isSystem),
      iconCodePoint: Value(iconCodePoint),
      colorValue: Value(colorValue),
      emoji:
          emoji == null && nullToAbsent ? const Value.absent() : Value(emoji),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      createdAt: Value(createdAt),
    );
  }

  factory ExpenseCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseCategory(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      systemCode: serializer.fromJson<String?>(json['systemCode']),
      name: serializer.fromJson<String>(json['name']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      iconCodePoint: serializer.fromJson<int>(json['iconCodePoint']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      emoji: serializer.fromJson<String?>(json['emoji']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'systemCode': serializer.toJson<String?>(systemCode),
      'name': serializer.toJson<String>(name),
      'isSystem': serializer.toJson<bool>(isSystem),
      'iconCodePoint': serializer.toJson<int>(iconCodePoint),
      'colorValue': serializer.toJson<int>(colorValue),
      'emoji': serializer.toJson<String?>(emoji),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseCategory copyWith(
          {String? id,
          String? profileId,
          Value<String?> systemCode = const Value.absent(),
          String? name,
          bool? isSystem,
          int? iconCodePoint,
          int? colorValue,
          Value<String?> emoji = const Value.absent(),
          Value<DateTime?> lastUsedAt = const Value.absent(),
          DateTime? createdAt}) =>
      ExpenseCategory(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        systemCode: systemCode.present ? systemCode.value : this.systemCode,
        name: name ?? this.name,
        isSystem: isSystem ?? this.isSystem,
        iconCodePoint: iconCodePoint ?? this.iconCodePoint,
        colorValue: colorValue ?? this.colorValue,
        emoji: emoji.present ? emoji.value : this.emoji,
        lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  ExpenseCategory copyWithCompanion(ExpenseCategoriesCompanion data) {
    return ExpenseCategory(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      systemCode:
          data.systemCode.present ? data.systemCode.value : this.systemCode,
      name: data.name.present ? data.name.value : this.name,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      iconCodePoint: data.iconCodePoint.present
          ? data.iconCodePoint.value
          : this.iconCodePoint,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      lastUsedAt:
          data.lastUsedAt.present ? data.lastUsedAt.value : this.lastUsedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategory(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('systemCode: $systemCode, ')
          ..write('name: $name, ')
          ..write('isSystem: $isSystem, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('colorValue: $colorValue, ')
          ..write('emoji: $emoji, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, systemCode, name, isSystem,
      iconCodePoint, colorValue, emoji, lastUsedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseCategory &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.systemCode == this.systemCode &&
          other.name == this.name &&
          other.isSystem == this.isSystem &&
          other.iconCodePoint == this.iconCodePoint &&
          other.colorValue == this.colorValue &&
          other.emoji == this.emoji &&
          other.lastUsedAt == this.lastUsedAt &&
          other.createdAt == this.createdAt);
}

class ExpenseCategoriesCompanion extends UpdateCompanion<ExpenseCategory> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String?> systemCode;
  final Value<String> name;
  final Value<bool> isSystem;
  final Value<int> iconCodePoint;
  final Value<int> colorValue;
  final Value<String?> emoji;
  final Value<DateTime?> lastUsedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExpenseCategoriesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.systemCode = const Value.absent(),
    this.name = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.emoji = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseCategoriesCompanion.insert({
    required String id,
    required String profileId,
    this.systemCode = const Value.absent(),
    required String name,
    this.isSystem = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.emoji = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        name = Value(name);
  static Insertable<ExpenseCategory> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? systemCode,
    Expression<String>? name,
    Expression<bool>? isSystem,
    Expression<int>? iconCodePoint,
    Expression<int>? colorValue,
    Expression<String>? emoji,
    Expression<DateTime>? lastUsedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (systemCode != null) 'system_code': systemCode,
      if (name != null) 'name': name,
      if (isSystem != null) 'is_system': isSystem,
      if (iconCodePoint != null) 'icon_code_point': iconCodePoint,
      if (colorValue != null) 'color_value': colorValue,
      if (emoji != null) 'emoji': emoji,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String?>? systemCode,
      Value<String>? name,
      Value<bool>? isSystem,
      Value<int>? iconCodePoint,
      Value<int>? colorValue,
      Value<String?>? emoji,
      Value<DateTime?>? lastUsedAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ExpenseCategoriesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      systemCode: systemCode ?? this.systemCode,
      name: name ?? this.name,
      isSystem: isSystem ?? this.isSystem,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      emoji: emoji ?? this.emoji,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (systemCode.present) {
      map['system_code'] = Variable<String>(systemCode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (iconCodePoint.present) {
      map['icon_code_point'] = Variable<int>(iconCodePoint.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('systemCode: $systemCode, ')
          ..write('name: $name, ')
          ..write('isSystem: $isSystem, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('colorValue: $colorValue, ')
          ..write('emoji: $emoji, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _limitMinorMeta =
      const VerificationMeta('limitMinor');
  @override
  late final GeneratedColumn<int> limitMinor = GeneratedColumn<int>(
      'limit_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startsOnMeta =
      const VerificationMeta('startsOn');
  @override
  late final GeneratedColumn<DateTime> startsOn = GeneratedColumn<DateTime>(
      'starts_on', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endsOnMeta = const VerificationMeta('endsOn');
  @override
  late final GeneratedColumn<DateTime> endsOn = GeneratedColumn<DateTime>(
      'ends_on', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isOverallMeta =
      const VerificationMeta('isOverall');
  @override
  late final GeneratedColumn<bool> isOverall = GeneratedColumn<bool>(
      'is_overall', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_overall" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _rolloverModeMeta =
      const VerificationMeta('rolloverMode');
  @override
  late final GeneratedColumn<String> rolloverMode = GeneratedColumn<String>(
      'rollover_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('none'));
  static const VerificationMeta _cycleTypeMeta =
      const VerificationMeta('cycleType');
  @override
  late final GeneratedColumn<String> cycleType = GeneratedColumn<String>(
      'cycle_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('monthly'));
  static const VerificationMeta _paydayMeta = const VerificationMeta('payday');
  @override
  late final GeneratedColumn<int> payday = GeneratedColumn<int>(
      'payday', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _fixedCommitmentsMinorMeta =
      const VerificationMeta('fixedCommitmentsMinor');
  @override
  late final GeneratedColumn<int> fixedCommitmentsMinor = GeneratedColumn<int>(
      'fixed_commitments_minor', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _emergencyBufferMinorMeta =
      const VerificationMeta('emergencyBufferMinor');
  @override
  late final GeneratedColumn<int> emergencyBufferMinor = GeneratedColumn<int>(
      'emergency_buffer_minor', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _carriedAmountMinorMeta =
      const VerificationMeta('carriedAmountMinor');
  @override
  late final GeneratedColumn<int> carriedAmountMinor = GeneratedColumn<int>(
      'carried_amount_minor', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        name,
        limitMinor,
        categoryId,
        startsOn,
        endsOn,
        isOverall,
        rolloverMode,
        cycleType,
        payday,
        fixedCommitmentsMinor,
        emergencyBufferMinor,
        carriedAmountMinor,
        isActive,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(Insertable<Budget> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('limit_minor')) {
      context.handle(
          _limitMinorMeta,
          limitMinor.isAcceptableOrUnknown(
              data['limit_minor']!, _limitMinorMeta));
    } else if (isInserting) {
      context.missing(_limitMinorMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('starts_on')) {
      context.handle(_startsOnMeta,
          startsOn.isAcceptableOrUnknown(data['starts_on']!, _startsOnMeta));
    } else if (isInserting) {
      context.missing(_startsOnMeta);
    }
    if (data.containsKey('ends_on')) {
      context.handle(_endsOnMeta,
          endsOn.isAcceptableOrUnknown(data['ends_on']!, _endsOnMeta));
    } else if (isInserting) {
      context.missing(_endsOnMeta);
    }
    if (data.containsKey('is_overall')) {
      context.handle(_isOverallMeta,
          isOverall.isAcceptableOrUnknown(data['is_overall']!, _isOverallMeta));
    }
    if (data.containsKey('rollover_mode')) {
      context.handle(
          _rolloverModeMeta,
          rolloverMode.isAcceptableOrUnknown(
              data['rollover_mode']!, _rolloverModeMeta));
    }
    if (data.containsKey('cycle_type')) {
      context.handle(_cycleTypeMeta,
          cycleType.isAcceptableOrUnknown(data['cycle_type']!, _cycleTypeMeta));
    }
    if (data.containsKey('payday')) {
      context.handle(_paydayMeta,
          payday.isAcceptableOrUnknown(data['payday']!, _paydayMeta));
    }
    if (data.containsKey('fixed_commitments_minor')) {
      context.handle(
          _fixedCommitmentsMinorMeta,
          fixedCommitmentsMinor.isAcceptableOrUnknown(
              data['fixed_commitments_minor']!, _fixedCommitmentsMinorMeta));
    }
    if (data.containsKey('emergency_buffer_minor')) {
      context.handle(
          _emergencyBufferMinorMeta,
          emergencyBufferMinor.isAcceptableOrUnknown(
              data['emergency_buffer_minor']!, _emergencyBufferMinorMeta));
    }
    if (data.containsKey('carried_amount_minor')) {
      context.handle(
          _carriedAmountMinorMeta,
          carriedAmountMinor.isAcceptableOrUnknown(
              data['carried_amount_minor']!, _carriedAmountMinorMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      limitMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}limit_minor'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      startsOn: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}starts_on'])!,
      endsOn: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ends_on'])!,
      isOverall: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_overall'])!,
      rolloverMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rollover_mode'])!,
      cycleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cycle_type'])!,
      payday: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}payday']),
      fixedCommitmentsMinor: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}fixed_commitments_minor'])!,
      emergencyBufferMinor: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}emergency_buffer_minor'])!,
      carriedAmountMinor: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}carried_amount_minor'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final String id;
  final String profileId;
  final String name;
  final int limitMinor;
  final String? categoryId;
  final DateTime startsOn;
  final DateTime endsOn;
  final bool isOverall;
  final String rolloverMode;
  final String cycleType;
  final int? payday;
  final int fixedCommitmentsMinor;
  final int emergencyBufferMinor;
  final int carriedAmountMinor;
  final bool isActive;
  final DateTime createdAt;
  const Budget(
      {required this.id,
      required this.profileId,
      required this.name,
      required this.limitMinor,
      this.categoryId,
      required this.startsOn,
      required this.endsOn,
      required this.isOverall,
      required this.rolloverMode,
      required this.cycleType,
      this.payday,
      required this.fixedCommitmentsMinor,
      required this.emergencyBufferMinor,
      required this.carriedAmountMinor,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['name'] = Variable<String>(name);
    map['limit_minor'] = Variable<int>(limitMinor);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['starts_on'] = Variable<DateTime>(startsOn);
    map['ends_on'] = Variable<DateTime>(endsOn);
    map['is_overall'] = Variable<bool>(isOverall);
    map['rollover_mode'] = Variable<String>(rolloverMode);
    map['cycle_type'] = Variable<String>(cycleType);
    if (!nullToAbsent || payday != null) {
      map['payday'] = Variable<int>(payday);
    }
    map['fixed_commitments_minor'] = Variable<int>(fixedCommitmentsMinor);
    map['emergency_buffer_minor'] = Variable<int>(emergencyBufferMinor);
    map['carried_amount_minor'] = Variable<int>(carriedAmountMinor);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      limitMinor: Value(limitMinor),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      startsOn: Value(startsOn),
      endsOn: Value(endsOn),
      isOverall: Value(isOverall),
      rolloverMode: Value(rolloverMode),
      cycleType: Value(cycleType),
      payday:
          payday == null && nullToAbsent ? const Value.absent() : Value(payday),
      fixedCommitmentsMinor: Value(fixedCommitmentsMinor),
      emergencyBufferMinor: Value(emergencyBufferMinor),
      carriedAmountMinor: Value(carriedAmountMinor),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Budget.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      limitMinor: serializer.fromJson<int>(json['limitMinor']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      startsOn: serializer.fromJson<DateTime>(json['startsOn']),
      endsOn: serializer.fromJson<DateTime>(json['endsOn']),
      isOverall: serializer.fromJson<bool>(json['isOverall']),
      rolloverMode: serializer.fromJson<String>(json['rolloverMode']),
      cycleType: serializer.fromJson<String>(json['cycleType']),
      payday: serializer.fromJson<int?>(json['payday']),
      fixedCommitmentsMinor:
          serializer.fromJson<int>(json['fixedCommitmentsMinor']),
      emergencyBufferMinor:
          serializer.fromJson<int>(json['emergencyBufferMinor']),
      carriedAmountMinor: serializer.fromJson<int>(json['carriedAmountMinor']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'name': serializer.toJson<String>(name),
      'limitMinor': serializer.toJson<int>(limitMinor),
      'categoryId': serializer.toJson<String?>(categoryId),
      'startsOn': serializer.toJson<DateTime>(startsOn),
      'endsOn': serializer.toJson<DateTime>(endsOn),
      'isOverall': serializer.toJson<bool>(isOverall),
      'rolloverMode': serializer.toJson<String>(rolloverMode),
      'cycleType': serializer.toJson<String>(cycleType),
      'payday': serializer.toJson<int?>(payday),
      'fixedCommitmentsMinor': serializer.toJson<int>(fixedCommitmentsMinor),
      'emergencyBufferMinor': serializer.toJson<int>(emergencyBufferMinor),
      'carriedAmountMinor': serializer.toJson<int>(carriedAmountMinor),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Budget copyWith(
          {String? id,
          String? profileId,
          String? name,
          int? limitMinor,
          Value<String?> categoryId = const Value.absent(),
          DateTime? startsOn,
          DateTime? endsOn,
          bool? isOverall,
          String? rolloverMode,
          String? cycleType,
          Value<int?> payday = const Value.absent(),
          int? fixedCommitmentsMinor,
          int? emergencyBufferMinor,
          int? carriedAmountMinor,
          bool? isActive,
          DateTime? createdAt}) =>
      Budget(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        name: name ?? this.name,
        limitMinor: limitMinor ?? this.limitMinor,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        startsOn: startsOn ?? this.startsOn,
        endsOn: endsOn ?? this.endsOn,
        isOverall: isOverall ?? this.isOverall,
        rolloverMode: rolloverMode ?? this.rolloverMode,
        cycleType: cycleType ?? this.cycleType,
        payday: payday.present ? payday.value : this.payday,
        fixedCommitmentsMinor:
            fixedCommitmentsMinor ?? this.fixedCommitmentsMinor,
        emergencyBufferMinor: emergencyBufferMinor ?? this.emergencyBufferMinor,
        carriedAmountMinor: carriedAmountMinor ?? this.carriedAmountMinor,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      limitMinor:
          data.limitMinor.present ? data.limitMinor.value : this.limitMinor,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      startsOn: data.startsOn.present ? data.startsOn.value : this.startsOn,
      endsOn: data.endsOn.present ? data.endsOn.value : this.endsOn,
      isOverall: data.isOverall.present ? data.isOverall.value : this.isOverall,
      rolloverMode: data.rolloverMode.present
          ? data.rolloverMode.value
          : this.rolloverMode,
      cycleType: data.cycleType.present ? data.cycleType.value : this.cycleType,
      payday: data.payday.present ? data.payday.value : this.payday,
      fixedCommitmentsMinor: data.fixedCommitmentsMinor.present
          ? data.fixedCommitmentsMinor.value
          : this.fixedCommitmentsMinor,
      emergencyBufferMinor: data.emergencyBufferMinor.present
          ? data.emergencyBufferMinor.value
          : this.emergencyBufferMinor,
      carriedAmountMinor: data.carriedAmountMinor.present
          ? data.carriedAmountMinor.value
          : this.carriedAmountMinor,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('limitMinor: $limitMinor, ')
          ..write('categoryId: $categoryId, ')
          ..write('startsOn: $startsOn, ')
          ..write('endsOn: $endsOn, ')
          ..write('isOverall: $isOverall, ')
          ..write('rolloverMode: $rolloverMode, ')
          ..write('cycleType: $cycleType, ')
          ..write('payday: $payday, ')
          ..write('fixedCommitmentsMinor: $fixedCommitmentsMinor, ')
          ..write('emergencyBufferMinor: $emergencyBufferMinor, ')
          ..write('carriedAmountMinor: $carriedAmountMinor, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      profileId,
      name,
      limitMinor,
      categoryId,
      startsOn,
      endsOn,
      isOverall,
      rolloverMode,
      cycleType,
      payday,
      fixedCommitmentsMinor,
      emergencyBufferMinor,
      carriedAmountMinor,
      isActive,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.limitMinor == this.limitMinor &&
          other.categoryId == this.categoryId &&
          other.startsOn == this.startsOn &&
          other.endsOn == this.endsOn &&
          other.isOverall == this.isOverall &&
          other.rolloverMode == this.rolloverMode &&
          other.cycleType == this.cycleType &&
          other.payday == this.payday &&
          other.fixedCommitmentsMinor == this.fixedCommitmentsMinor &&
          other.emergencyBufferMinor == this.emergencyBufferMinor &&
          other.carriedAmountMinor == this.carriedAmountMinor &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> name;
  final Value<int> limitMinor;
  final Value<String?> categoryId;
  final Value<DateTime> startsOn;
  final Value<DateTime> endsOn;
  final Value<bool> isOverall;
  final Value<String> rolloverMode;
  final Value<String> cycleType;
  final Value<int?> payday;
  final Value<int> fixedCommitmentsMinor;
  final Value<int> emergencyBufferMinor;
  final Value<int> carriedAmountMinor;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.limitMinor = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.startsOn = const Value.absent(),
    this.endsOn = const Value.absent(),
    this.isOverall = const Value.absent(),
    this.rolloverMode = const Value.absent(),
    this.cycleType = const Value.absent(),
    this.payday = const Value.absent(),
    this.fixedCommitmentsMinor = const Value.absent(),
    this.emergencyBufferMinor = const Value.absent(),
    this.carriedAmountMinor = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String id,
    required String profileId,
    required String name,
    required int limitMinor,
    this.categoryId = const Value.absent(),
    required DateTime startsOn,
    required DateTime endsOn,
    this.isOverall = const Value.absent(),
    this.rolloverMode = const Value.absent(),
    this.cycleType = const Value.absent(),
    this.payday = const Value.absent(),
    this.fixedCommitmentsMinor = const Value.absent(),
    this.emergencyBufferMinor = const Value.absent(),
    this.carriedAmountMinor = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        name = Value(name),
        limitMinor = Value(limitMinor),
        startsOn = Value(startsOn),
        endsOn = Value(endsOn);
  static Insertable<Budget> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<int>? limitMinor,
    Expression<String>? categoryId,
    Expression<DateTime>? startsOn,
    Expression<DateTime>? endsOn,
    Expression<bool>? isOverall,
    Expression<String>? rolloverMode,
    Expression<String>? cycleType,
    Expression<int>? payday,
    Expression<int>? fixedCommitmentsMinor,
    Expression<int>? emergencyBufferMinor,
    Expression<int>? carriedAmountMinor,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (limitMinor != null) 'limit_minor': limitMinor,
      if (categoryId != null) 'category_id': categoryId,
      if (startsOn != null) 'starts_on': startsOn,
      if (endsOn != null) 'ends_on': endsOn,
      if (isOverall != null) 'is_overall': isOverall,
      if (rolloverMode != null) 'rollover_mode': rolloverMode,
      if (cycleType != null) 'cycle_type': cycleType,
      if (payday != null) 'payday': payday,
      if (fixedCommitmentsMinor != null)
        'fixed_commitments_minor': fixedCommitmentsMinor,
      if (emergencyBufferMinor != null)
        'emergency_buffer_minor': emergencyBufferMinor,
      if (carriedAmountMinor != null)
        'carried_amount_minor': carriedAmountMinor,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? name,
      Value<int>? limitMinor,
      Value<String?>? categoryId,
      Value<DateTime>? startsOn,
      Value<DateTime>? endsOn,
      Value<bool>? isOverall,
      Value<String>? rolloverMode,
      Value<String>? cycleType,
      Value<int?>? payday,
      Value<int>? fixedCommitmentsMinor,
      Value<int>? emergencyBufferMinor,
      Value<int>? carriedAmountMinor,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return BudgetsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      limitMinor: limitMinor ?? this.limitMinor,
      categoryId: categoryId ?? this.categoryId,
      startsOn: startsOn ?? this.startsOn,
      endsOn: endsOn ?? this.endsOn,
      isOverall: isOverall ?? this.isOverall,
      rolloverMode: rolloverMode ?? this.rolloverMode,
      cycleType: cycleType ?? this.cycleType,
      payday: payday ?? this.payday,
      fixedCommitmentsMinor:
          fixedCommitmentsMinor ?? this.fixedCommitmentsMinor,
      emergencyBufferMinor: emergencyBufferMinor ?? this.emergencyBufferMinor,
      carriedAmountMinor: carriedAmountMinor ?? this.carriedAmountMinor,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (limitMinor.present) {
      map['limit_minor'] = Variable<int>(limitMinor.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (startsOn.present) {
      map['starts_on'] = Variable<DateTime>(startsOn.value);
    }
    if (endsOn.present) {
      map['ends_on'] = Variable<DateTime>(endsOn.value);
    }
    if (isOverall.present) {
      map['is_overall'] = Variable<bool>(isOverall.value);
    }
    if (rolloverMode.present) {
      map['rollover_mode'] = Variable<String>(rolloverMode.value);
    }
    if (cycleType.present) {
      map['cycle_type'] = Variable<String>(cycleType.value);
    }
    if (payday.present) {
      map['payday'] = Variable<int>(payday.value);
    }
    if (fixedCommitmentsMinor.present) {
      map['fixed_commitments_minor'] =
          Variable<int>(fixedCommitmentsMinor.value);
    }
    if (emergencyBufferMinor.present) {
      map['emergency_buffer_minor'] = Variable<int>(emergencyBufferMinor.value);
    }
    if (carriedAmountMinor.present) {
      map['carried_amount_minor'] = Variable<int>(carriedAmountMinor.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('limitMinor: $limitMinor, ')
          ..write('categoryId: $categoryId, ')
          ..write('startsOn: $startsOn, ')
          ..write('endsOn: $endsOn, ')
          ..write('isOverall: $isOverall, ')
          ..write('rolloverMode: $rolloverMode, ')
          ..write('cycleType: $cycleType, ')
          ..write('payday: $payday, ')
          ..write('fixedCommitmentsMinor: $fixedCommitmentsMinor, ')
          ..write('emergencyBufferMinor: $emergencyBufferMinor, ')
          ..write('carriedAmountMinor: $carriedAmountMinor, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTable extends SavingsGoals
    with TableInfo<$SavingsGoalsTable, SavingsGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetMinorMeta =
      const VerificationMeta('targetMinor');
  @override
  late final GeneratedColumn<int> targetMinor = GeneratedColumn<int>(
      'target_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentMinorMeta =
      const VerificationMeta('currentMinor');
  @override
  late final GeneratedColumn<int> currentMinor = GeneratedColumn<int>(
      'current_minor', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _targetDateMeta =
      const VerificationMeta('targetDate');
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
      'target_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _templateCodeMeta =
      const VerificationMeta('templateCode');
  @override
  late final GeneratedColumn<String> templateCode = GeneratedColumn<String>(
      'template_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        name,
        targetMinor,
        currentMinor,
        targetDate,
        templateCode,
        completedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(Insertable<SavingsGoal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_minor')) {
      context.handle(
          _targetMinorMeta,
          targetMinor.isAcceptableOrUnknown(
              data['target_minor']!, _targetMinorMeta));
    } else if (isInserting) {
      context.missing(_targetMinorMeta);
    }
    if (data.containsKey('current_minor')) {
      context.handle(
          _currentMinorMeta,
          currentMinor.isAcceptableOrUnknown(
              data['current_minor']!, _currentMinorMeta));
    }
    if (data.containsKey('target_date')) {
      context.handle(
          _targetDateMeta,
          targetDate.isAcceptableOrUnknown(
              data['target_date']!, _targetDateMeta));
    }
    if (data.containsKey('template_code')) {
      context.handle(
          _templateCodeMeta,
          templateCode.isAcceptableOrUnknown(
              data['template_code']!, _templateCodeMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      targetMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_minor'])!,
      currentMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_minor'])!,
      targetDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}target_date']),
      templateCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}template_code']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SavingsGoalsTable createAlias(String alias) {
    return $SavingsGoalsTable(attachedDatabase, alias);
  }
}

class SavingsGoal extends DataClass implements Insertable<SavingsGoal> {
  final String id;
  final String profileId;
  final String name;
  final int targetMinor;
  final int currentMinor;
  final DateTime? targetDate;
  final String? templateCode;
  final DateTime? completedAt;
  final DateTime createdAt;
  const SavingsGoal(
      {required this.id,
      required this.profileId,
      required this.name,
      required this.targetMinor,
      required this.currentMinor,
      this.targetDate,
      this.templateCode,
      this.completedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['name'] = Variable<String>(name);
    map['target_minor'] = Variable<int>(targetMinor);
    map['current_minor'] = Variable<int>(currentMinor);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    if (!nullToAbsent || templateCode != null) {
      map['template_code'] = Variable<String>(templateCode);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavingsGoalsCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      targetMinor: Value(targetMinor),
      currentMinor: Value(currentMinor),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      templateCode: templateCode == null && nullToAbsent
          ? const Value.absent()
          : Value(templateCode),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
    );
  }

  factory SavingsGoal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoal(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      targetMinor: serializer.fromJson<int>(json['targetMinor']),
      currentMinor: serializer.fromJson<int>(json['currentMinor']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      templateCode: serializer.fromJson<String?>(json['templateCode']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'name': serializer.toJson<String>(name),
      'targetMinor': serializer.toJson<int>(targetMinor),
      'currentMinor': serializer.toJson<int>(currentMinor),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'templateCode': serializer.toJson<String?>(templateCode),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SavingsGoal copyWith(
          {String? id,
          String? profileId,
          String? name,
          int? targetMinor,
          int? currentMinor,
          Value<DateTime?> targetDate = const Value.absent(),
          Value<String?> templateCode = const Value.absent(),
          Value<DateTime?> completedAt = const Value.absent(),
          DateTime? createdAt}) =>
      SavingsGoal(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        name: name ?? this.name,
        targetMinor: targetMinor ?? this.targetMinor,
        currentMinor: currentMinor ?? this.currentMinor,
        targetDate: targetDate.present ? targetDate.value : this.targetDate,
        templateCode:
            templateCode.present ? templateCode.value : this.templateCode,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  SavingsGoal copyWithCompanion(SavingsGoalsCompanion data) {
    return SavingsGoal(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      targetMinor:
          data.targetMinor.present ? data.targetMinor.value : this.targetMinor,
      currentMinor: data.currentMinor.present
          ? data.currentMinor.value
          : this.currentMinor,
      targetDate:
          data.targetDate.present ? data.targetDate.value : this.targetDate,
      templateCode: data.templateCode.present
          ? data.templateCode.value
          : this.templateCode,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoal(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('targetMinor: $targetMinor, ')
          ..write('currentMinor: $currentMinor, ')
          ..write('targetDate: $targetDate, ')
          ..write('templateCode: $templateCode, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, name, targetMinor,
      currentMinor, targetDate, templateCode, completedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoal &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.targetMinor == this.targetMinor &&
          other.currentMinor == this.currentMinor &&
          other.targetDate == this.targetDate &&
          other.templateCode == this.templateCode &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt);
}

class SavingsGoalsCompanion extends UpdateCompanion<SavingsGoal> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> name;
  final Value<int> targetMinor;
  final Value<int> currentMinor;
  final Value<DateTime?> targetDate;
  final Value<String?> templateCode;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SavingsGoalsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.targetMinor = const Value.absent(),
    this.currentMinor = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.templateCode = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavingsGoalsCompanion.insert({
    required String id,
    required String profileId,
    required String name,
    required int targetMinor,
    this.currentMinor = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.templateCode = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        name = Value(name),
        targetMinor = Value(targetMinor);
  static Insertable<SavingsGoal> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<int>? targetMinor,
    Expression<int>? currentMinor,
    Expression<DateTime>? targetDate,
    Expression<String>? templateCode,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (targetMinor != null) 'target_minor': targetMinor,
      if (currentMinor != null) 'current_minor': currentMinor,
      if (targetDate != null) 'target_date': targetDate,
      if (templateCode != null) 'template_code': templateCode,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavingsGoalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? name,
      Value<int>? targetMinor,
      Value<int>? currentMinor,
      Value<DateTime?>? targetDate,
      Value<String?>? templateCode,
      Value<DateTime?>? completedAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SavingsGoalsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      targetMinor: targetMinor ?? this.targetMinor,
      currentMinor: currentMinor ?? this.currentMinor,
      targetDate: targetDate ?? this.targetDate,
      templateCode: templateCode ?? this.templateCode,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetMinor.present) {
      map['target_minor'] = Variable<int>(targetMinor.value);
    }
    if (currentMinor.present) {
      map['current_minor'] = Variable<int>(currentMinor.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (templateCode.present) {
      map['template_code'] = Variable<String>(templateCode.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('targetMinor: $targetMinor, ')
          ..write('currentMinor: $currentMinor, ')
          ..write('targetDate: $targetDate, ')
          ..write('templateCode: $templateCode, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalContributionsTable extends GoalContributions
    with TableInfo<$GoalContributionsTable, GoalContribution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalContributionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMinorMeta =
      const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
      'amount_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _contributedAtMeta =
      const VerificationMeta('contributedAt');
  @override
  late final GeneratedColumn<DateTime> contributedAt =
      GeneratedColumn<DateTime>('contributed_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, profileId, goalId, amountMinor, contributedAt, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_contributions';
  @override
  VerificationContext validateIntegrity(Insertable<GoalContribution> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
          _amountMinorMeta,
          amountMinor.isAcceptableOrUnknown(
              data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('contributed_at')) {
      context.handle(
          _contributedAtMeta,
          contributedAt.isAcceptableOrUnknown(
              data['contributed_at']!, _contributedAtMeta));
    } else if (isInserting) {
      context.missing(_contributedAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalContribution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalContribution(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id'])!,
      amountMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_minor'])!,
      contributedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}contributed_at'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $GoalContributionsTable createAlias(String alias) {
    return $GoalContributionsTable(attachedDatabase, alias);
  }
}

class GoalContribution extends DataClass
    implements Insertable<GoalContribution> {
  final String id;
  final String profileId;
  final String goalId;
  final int amountMinor;
  final DateTime contributedAt;
  final String? note;
  const GoalContribution(
      {required this.id,
      required this.profileId,
      required this.goalId,
      required this.amountMinor,
      required this.contributedAt,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['goal_id'] = Variable<String>(goalId);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['contributed_at'] = Variable<DateTime>(contributedAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  GoalContributionsCompanion toCompanion(bool nullToAbsent) {
    return GoalContributionsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      goalId: Value(goalId),
      amountMinor: Value(amountMinor),
      contributedAt: Value(contributedAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory GoalContribution.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalContribution(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      goalId: serializer.fromJson<String>(json['goalId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      contributedAt: serializer.fromJson<DateTime>(json['contributedAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'goalId': serializer.toJson<String>(goalId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'contributedAt': serializer.toJson<DateTime>(contributedAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  GoalContribution copyWith(
          {String? id,
          String? profileId,
          String? goalId,
          int? amountMinor,
          DateTime? contributedAt,
          Value<String?> note = const Value.absent()}) =>
      GoalContribution(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        goalId: goalId ?? this.goalId,
        amountMinor: amountMinor ?? this.amountMinor,
        contributedAt: contributedAt ?? this.contributedAt,
        note: note.present ? note.value : this.note,
      );
  GoalContribution copyWithCompanion(GoalContributionsCompanion data) {
    return GoalContribution(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      amountMinor:
          data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      contributedAt: data.contributedAt.present
          ? data.contributedAt.value
          : this.contributedAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalContribution(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('goalId: $goalId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('contributedAt: $contributedAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, goalId, amountMinor, contributedAt, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalContribution &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.goalId == this.goalId &&
          other.amountMinor == this.amountMinor &&
          other.contributedAt == this.contributedAt &&
          other.note == this.note);
}

class GoalContributionsCompanion extends UpdateCompanion<GoalContribution> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> goalId;
  final Value<int> amountMinor;
  final Value<DateTime> contributedAt;
  final Value<String?> note;
  final Value<int> rowid;
  const GoalContributionsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.contributedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalContributionsCompanion.insert({
    required String id,
    required String profileId,
    required String goalId,
    required int amountMinor,
    required DateTime contributedAt,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        goalId = Value(goalId),
        amountMinor = Value(amountMinor),
        contributedAt = Value(contributedAt);
  static Insertable<GoalContribution> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? goalId,
    Expression<int>? amountMinor,
    Expression<DateTime>? contributedAt,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (goalId != null) 'goal_id': goalId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (contributedAt != null) 'contributed_at': contributedAt,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalContributionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? goalId,
      Value<int>? amountMinor,
      Value<DateTime>? contributedAt,
      Value<String?>? note,
      Value<int>? rowid}) {
    return GoalContributionsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      goalId: goalId ?? this.goalId,
      amountMinor: amountMinor ?? this.amountMinor,
      contributedAt: contributedAt ?? this.contributedAt,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (contributedAt.present) {
      map['contributed_at'] = Variable<DateTime>(contributedAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalContributionsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('goalId: $goalId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('contributedAt: $contributedAt, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BnplPlansTable extends BnplPlans
    with TableInfo<$BnplPlansTable, BnplPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BnplPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _merchantMeta =
      const VerificationMeta('merchant');
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
      'merchant', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _purchaseAmountMinorMeta =
      const VerificationMeta('purchaseAmountMinor');
  @override
  late final GeneratedColumn<int> purchaseAmountMinor = GeneratedColumn<int>(
      'purchase_amount_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('SAR'));
  static const VerificationMeta _instalmentCountMeta =
      const VerificationMeta('instalmentCount');
  @override
  late final GeneratedColumn<int> instalmentCount = GeneratedColumn<int>(
      'instalment_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _customProviderMeta =
      const VerificationMeta('customProvider');
  @override
  late final GeneratedColumn<String> customProvider = GeneratedColumn<String>(
      'custom_provider', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
      'purchase_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        provider,
        merchant,
        purchaseAmountMinor,
        currency,
        instalmentCount,
        status,
        customProvider,
        purchaseDate,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bnpl_plans';
  @override
  VerificationContext validateIntegrity(Insertable<BnplPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('merchant')) {
      context.handle(_merchantMeta,
          merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta));
    } else if (isInserting) {
      context.missing(_merchantMeta);
    }
    if (data.containsKey('purchase_amount_minor')) {
      context.handle(
          _purchaseAmountMinorMeta,
          purchaseAmountMinor.isAcceptableOrUnknown(
              data['purchase_amount_minor']!, _purchaseAmountMinorMeta));
    } else if (isInserting) {
      context.missing(_purchaseAmountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('instalment_count')) {
      context.handle(
          _instalmentCountMeta,
          instalmentCount.isAcceptableOrUnknown(
              data['instalment_count']!, _instalmentCountMeta));
    } else if (isInserting) {
      context.missing(_instalmentCountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('custom_provider')) {
      context.handle(
          _customProviderMeta,
          customProvider.isAcceptableOrUnknown(
              data['custom_provider']!, _customProviderMeta));
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BnplPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BnplPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider'])!,
      merchant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}merchant'])!,
      purchaseAmountMinor: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}purchase_amount_minor'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      instalmentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}instalment_count'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      customProvider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_provider']),
      purchaseDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}purchase_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BnplPlansTable createAlias(String alias) {
    return $BnplPlansTable(attachedDatabase, alias);
  }
}

class BnplPlan extends DataClass implements Insertable<BnplPlan> {
  final String id;
  final String profileId;
  final String provider;
  final String merchant;
  final int purchaseAmountMinor;
  final String currency;
  final int instalmentCount;
  final String status;
  final String? customProvider;
  final DateTime purchaseDate;
  final DateTime createdAt;
  const BnplPlan(
      {required this.id,
      required this.profileId,
      required this.provider,
      required this.merchant,
      required this.purchaseAmountMinor,
      required this.currency,
      required this.instalmentCount,
      required this.status,
      this.customProvider,
      required this.purchaseDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['provider'] = Variable<String>(provider);
    map['merchant'] = Variable<String>(merchant);
    map['purchase_amount_minor'] = Variable<int>(purchaseAmountMinor);
    map['currency'] = Variable<String>(currency);
    map['instalment_count'] = Variable<int>(instalmentCount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || customProvider != null) {
      map['custom_provider'] = Variable<String>(customProvider);
    }
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BnplPlansCompanion toCompanion(bool nullToAbsent) {
    return BnplPlansCompanion(
      id: Value(id),
      profileId: Value(profileId),
      provider: Value(provider),
      merchant: Value(merchant),
      purchaseAmountMinor: Value(purchaseAmountMinor),
      currency: Value(currency),
      instalmentCount: Value(instalmentCount),
      status: Value(status),
      customProvider: customProvider == null && nullToAbsent
          ? const Value.absent()
          : Value(customProvider),
      purchaseDate: Value(purchaseDate),
      createdAt: Value(createdAt),
    );
  }

  factory BnplPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BnplPlan(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      provider: serializer.fromJson<String>(json['provider']),
      merchant: serializer.fromJson<String>(json['merchant']),
      purchaseAmountMinor:
          serializer.fromJson<int>(json['purchaseAmountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      instalmentCount: serializer.fromJson<int>(json['instalmentCount']),
      status: serializer.fromJson<String>(json['status']),
      customProvider: serializer.fromJson<String?>(json['customProvider']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'provider': serializer.toJson<String>(provider),
      'merchant': serializer.toJson<String>(merchant),
      'purchaseAmountMinor': serializer.toJson<int>(purchaseAmountMinor),
      'currency': serializer.toJson<String>(currency),
      'instalmentCount': serializer.toJson<int>(instalmentCount),
      'status': serializer.toJson<String>(status),
      'customProvider': serializer.toJson<String?>(customProvider),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BnplPlan copyWith(
          {String? id,
          String? profileId,
          String? provider,
          String? merchant,
          int? purchaseAmountMinor,
          String? currency,
          int? instalmentCount,
          String? status,
          Value<String?> customProvider = const Value.absent(),
          DateTime? purchaseDate,
          DateTime? createdAt}) =>
      BnplPlan(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        provider: provider ?? this.provider,
        merchant: merchant ?? this.merchant,
        purchaseAmountMinor: purchaseAmountMinor ?? this.purchaseAmountMinor,
        currency: currency ?? this.currency,
        instalmentCount: instalmentCount ?? this.instalmentCount,
        status: status ?? this.status,
        customProvider:
            customProvider.present ? customProvider.value : this.customProvider,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        createdAt: createdAt ?? this.createdAt,
      );
  BnplPlan copyWithCompanion(BnplPlansCompanion data) {
    return BnplPlan(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      provider: data.provider.present ? data.provider.value : this.provider,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      purchaseAmountMinor: data.purchaseAmountMinor.present
          ? data.purchaseAmountMinor.value
          : this.purchaseAmountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      instalmentCount: data.instalmentCount.present
          ? data.instalmentCount.value
          : this.instalmentCount,
      status: data.status.present ? data.status.value : this.status,
      customProvider: data.customProvider.present
          ? data.customProvider.value
          : this.customProvider,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BnplPlan(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('provider: $provider, ')
          ..write('merchant: $merchant, ')
          ..write('purchaseAmountMinor: $purchaseAmountMinor, ')
          ..write('currency: $currency, ')
          ..write('instalmentCount: $instalmentCount, ')
          ..write('status: $status, ')
          ..write('customProvider: $customProvider, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      profileId,
      provider,
      merchant,
      purchaseAmountMinor,
      currency,
      instalmentCount,
      status,
      customProvider,
      purchaseDate,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BnplPlan &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.provider == this.provider &&
          other.merchant == this.merchant &&
          other.purchaseAmountMinor == this.purchaseAmountMinor &&
          other.currency == this.currency &&
          other.instalmentCount == this.instalmentCount &&
          other.status == this.status &&
          other.customProvider == this.customProvider &&
          other.purchaseDate == this.purchaseDate &&
          other.createdAt == this.createdAt);
}

class BnplPlansCompanion extends UpdateCompanion<BnplPlan> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> provider;
  final Value<String> merchant;
  final Value<int> purchaseAmountMinor;
  final Value<String> currency;
  final Value<int> instalmentCount;
  final Value<String> status;
  final Value<String?> customProvider;
  final Value<DateTime> purchaseDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BnplPlansCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.provider = const Value.absent(),
    this.merchant = const Value.absent(),
    this.purchaseAmountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.instalmentCount = const Value.absent(),
    this.status = const Value.absent(),
    this.customProvider = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BnplPlansCompanion.insert({
    required String id,
    required String profileId,
    required String provider,
    required String merchant,
    required int purchaseAmountMinor,
    this.currency = const Value.absent(),
    required int instalmentCount,
    this.status = const Value.absent(),
    this.customProvider = const Value.absent(),
    required DateTime purchaseDate,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        provider = Value(provider),
        merchant = Value(merchant),
        purchaseAmountMinor = Value(purchaseAmountMinor),
        instalmentCount = Value(instalmentCount),
        purchaseDate = Value(purchaseDate);
  static Insertable<BnplPlan> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? provider,
    Expression<String>? merchant,
    Expression<int>? purchaseAmountMinor,
    Expression<String>? currency,
    Expression<int>? instalmentCount,
    Expression<String>? status,
    Expression<String>? customProvider,
    Expression<DateTime>? purchaseDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (provider != null) 'provider': provider,
      if (merchant != null) 'merchant': merchant,
      if (purchaseAmountMinor != null)
        'purchase_amount_minor': purchaseAmountMinor,
      if (currency != null) 'currency': currency,
      if (instalmentCount != null) 'instalment_count': instalmentCount,
      if (status != null) 'status': status,
      if (customProvider != null) 'custom_provider': customProvider,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BnplPlansCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? provider,
      Value<String>? merchant,
      Value<int>? purchaseAmountMinor,
      Value<String>? currency,
      Value<int>? instalmentCount,
      Value<String>? status,
      Value<String?>? customProvider,
      Value<DateTime>? purchaseDate,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return BnplPlansCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      provider: provider ?? this.provider,
      merchant: merchant ?? this.merchant,
      purchaseAmountMinor: purchaseAmountMinor ?? this.purchaseAmountMinor,
      currency: currency ?? this.currency,
      instalmentCount: instalmentCount ?? this.instalmentCount,
      status: status ?? this.status,
      customProvider: customProvider ?? this.customProvider,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (purchaseAmountMinor.present) {
      map['purchase_amount_minor'] = Variable<int>(purchaseAmountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (instalmentCount.present) {
      map['instalment_count'] = Variable<int>(instalmentCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (customProvider.present) {
      map['custom_provider'] = Variable<String>(customProvider.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BnplPlansCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('provider: $provider, ')
          ..write('merchant: $merchant, ')
          ..write('purchaseAmountMinor: $purchaseAmountMinor, ')
          ..write('currency: $currency, ')
          ..write('instalmentCount: $instalmentCount, ')
          ..write('status: $status, ')
          ..write('customProvider: $customProvider, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BnplInstalmentsTable extends BnplInstalments
    with TableInfo<$BnplInstalmentsTable, BnplInstalment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BnplInstalmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
      'plan_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMinorMeta =
      const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
      'amount_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
      'is_paid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_paid" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, profileId, planId, amountMinor, dueDate, isPaid, paidAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bnpl_instalments';
  @override
  VerificationContext validateIntegrity(Insertable<BnplInstalment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta,
          planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
          _amountMinorMeta,
          amountMinor.isAcceptableOrUnknown(
              data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('is_paid')) {
      context.handle(_isPaidMeta,
          isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta));
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BnplInstalment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BnplInstalment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      planId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan_id'])!,
      amountMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_minor'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date'])!,
      isPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_paid'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at']),
    );
  }

  @override
  $BnplInstalmentsTable createAlias(String alias) {
    return $BnplInstalmentsTable(attachedDatabase, alias);
  }
}

class BnplInstalment extends DataClass implements Insertable<BnplInstalment> {
  final String id;
  final String profileId;
  final String planId;
  final int amountMinor;
  final DateTime dueDate;
  final bool isPaid;
  final DateTime? paidAt;
  const BnplInstalment(
      {required this.id,
      required this.profileId,
      required this.planId,
      required this.amountMinor,
      required this.dueDate,
      required this.isPaid,
      this.paidAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['plan_id'] = Variable<String>(planId);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['is_paid'] = Variable<bool>(isPaid);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    return map;
  }

  BnplInstalmentsCompanion toCompanion(bool nullToAbsent) {
    return BnplInstalmentsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      planId: Value(planId),
      amountMinor: Value(amountMinor),
      dueDate: Value(dueDate),
      isPaid: Value(isPaid),
      paidAt:
          paidAt == null && nullToAbsent ? const Value.absent() : Value(paidAt),
    );
  }

  factory BnplInstalment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BnplInstalment(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      planId: serializer.fromJson<String>(json['planId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'planId': serializer.toJson<String>(planId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'isPaid': serializer.toJson<bool>(isPaid),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
    };
  }

  BnplInstalment copyWith(
          {String? id,
          String? profileId,
          String? planId,
          int? amountMinor,
          DateTime? dueDate,
          bool? isPaid,
          Value<DateTime?> paidAt = const Value.absent()}) =>
      BnplInstalment(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        planId: planId ?? this.planId,
        amountMinor: amountMinor ?? this.amountMinor,
        dueDate: dueDate ?? this.dueDate,
        isPaid: isPaid ?? this.isPaid,
        paidAt: paidAt.present ? paidAt.value : this.paidAt,
      );
  BnplInstalment copyWithCompanion(BnplInstalmentsCompanion data) {
    return BnplInstalment(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      planId: data.planId.present ? data.planId.value : this.planId,
      amountMinor:
          data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BnplInstalment(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('planId: $planId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('dueDate: $dueDate, ')
          ..write('isPaid: $isPaid, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, planId, amountMinor, dueDate, isPaid, paidAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BnplInstalment &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.planId == this.planId &&
          other.amountMinor == this.amountMinor &&
          other.dueDate == this.dueDate &&
          other.isPaid == this.isPaid &&
          other.paidAt == this.paidAt);
}

class BnplInstalmentsCompanion extends UpdateCompanion<BnplInstalment> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> planId;
  final Value<int> amountMinor;
  final Value<DateTime> dueDate;
  final Value<bool> isPaid;
  final Value<DateTime?> paidAt;
  final Value<int> rowid;
  const BnplInstalmentsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.planId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BnplInstalmentsCompanion.insert({
    required String id,
    required String profileId,
    required String planId,
    required int amountMinor,
    required DateTime dueDate,
    this.isPaid = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        planId = Value(planId),
        amountMinor = Value(amountMinor),
        dueDate = Value(dueDate);
  static Insertable<BnplInstalment> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? planId,
    Expression<int>? amountMinor,
    Expression<DateTime>? dueDate,
    Expression<bool>? isPaid,
    Expression<DateTime>? paidAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (planId != null) 'plan_id': planId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (dueDate != null) 'due_date': dueDate,
      if (isPaid != null) 'is_paid': isPaid,
      if (paidAt != null) 'paid_at': paidAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BnplInstalmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? planId,
      Value<int>? amountMinor,
      Value<DateTime>? dueDate,
      Value<bool>? isPaid,
      Value<DateTime?>? paidAt,
      Value<int>? rowid}) {
    return BnplInstalmentsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      planId: planId ?? this.planId,
      amountMinor: amountMinor ?? this.amountMinor,
      dueDate: dueDate ?? this.dueDate,
      isPaid: isPaid ?? this.isPaid,
      paidAt: paidAt ?? this.paidAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BnplInstalmentsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('planId: $planId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('dueDate: $dueDate, ')
          ..write('isPaid: $isPaid, ')
          ..write('paidAt: $paidAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringPaymentsTable extends RecurringPayments
    with TableInfo<$RecurringPaymentsTable, RecurringPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMinorMeta =
      const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
      'amount_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('SAR'));
  static const VerificationMeta _recurrenceMeta =
      const VerificationMeta('recurrence');
  @override
  late final GeneratedColumn<String> recurrence = GeneratedColumn<String>(
      'recurrence', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nextPaymentDateMeta =
      const VerificationMeta('nextPaymentDate');
  @override
  late final GeneratedColumn<DateTime> nextPaymentDate =
      GeneratedColumn<DateTime>('next_payment_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isSubscriptionMeta =
      const VerificationMeta('isSubscription');
  @override
  late final GeneratedColumn<bool> isSubscription = GeneratedColumn<bool>(
      'is_subscription', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_subscription" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _maxOccurrencesMeta =
      const VerificationMeta('maxOccurrences');
  @override
  late final GeneratedColumn<int> maxOccurrences = GeneratedColumn<int>(
      'max_occurrences', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _generatedOccurrencesMeta =
      const VerificationMeta('generatedOccurrences');
  @override
  late final GeneratedColumn<int> generatedOccurrences = GeneratedColumn<int>(
      'generated_occurrences', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _intervalCountMeta =
      const VerificationMeta('intervalCount');
  @override
  late final GeneratedColumn<int> intervalCount = GeneratedColumn<int>(
      'interval_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _lastReconciledAtMeta =
      const VerificationMeta('lastReconciledAt');
  @override
  late final GeneratedColumn<DateTime> lastReconciledAt =
      GeneratedColumn<DateTime>('last_reconciled_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        name,
        amountMinor,
        currency,
        recurrence,
        categoryId,
        nextPaymentDate,
        isSubscription,
        isActive,
        startDate,
        endDate,
        maxOccurrences,
        generatedOccurrences,
        intervalCount,
        status,
        lastReconciledAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_payments';
  @override
  VerificationContext validateIntegrity(Insertable<RecurringPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
          _amountMinorMeta,
          amountMinor.isAcceptableOrUnknown(
              data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('recurrence')) {
      context.handle(
          _recurrenceMeta,
          recurrence.isAcceptableOrUnknown(
              data['recurrence']!, _recurrenceMeta));
    } else if (isInserting) {
      context.missing(_recurrenceMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('next_payment_date')) {
      context.handle(
          _nextPaymentDateMeta,
          nextPaymentDate.isAcceptableOrUnknown(
              data['next_payment_date']!, _nextPaymentDateMeta));
    } else if (isInserting) {
      context.missing(_nextPaymentDateMeta);
    }
    if (data.containsKey('is_subscription')) {
      context.handle(
          _isSubscriptionMeta,
          isSubscription.isAcceptableOrUnknown(
              data['is_subscription']!, _isSubscriptionMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('max_occurrences')) {
      context.handle(
          _maxOccurrencesMeta,
          maxOccurrences.isAcceptableOrUnknown(
              data['max_occurrences']!, _maxOccurrencesMeta));
    }
    if (data.containsKey('generated_occurrences')) {
      context.handle(
          _generatedOccurrencesMeta,
          generatedOccurrences.isAcceptableOrUnknown(
              data['generated_occurrences']!, _generatedOccurrencesMeta));
    }
    if (data.containsKey('interval_count')) {
      context.handle(
          _intervalCountMeta,
          intervalCount.isAcceptableOrUnknown(
              data['interval_count']!, _intervalCountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('last_reconciled_at')) {
      context.handle(
          _lastReconciledAtMeta,
          lastReconciledAt.isAcceptableOrUnknown(
              data['last_reconciled_at']!, _lastReconciledAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringPayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amountMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_minor'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      recurrence: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurrence'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      nextPaymentDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_payment_date'])!,
      isSubscription: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_subscription'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      maxOccurrences: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_occurrences']),
      generatedOccurrences: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}generated_occurrences'])!,
      intervalCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_count'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      lastReconciledAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_reconciled_at']),
    );
  }

  @override
  $RecurringPaymentsTable createAlias(String alias) {
    return $RecurringPaymentsTable(attachedDatabase, alias);
  }
}

class RecurringPayment extends DataClass
    implements Insertable<RecurringPayment> {
  final String id;
  final String profileId;
  final String name;
  final int amountMinor;
  final String currency;
  final String recurrence;
  final String? categoryId;
  final DateTime nextPaymentDate;
  final bool isSubscription;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? maxOccurrences;
  final int generatedOccurrences;
  final int intervalCount;
  final String status;
  final DateTime? lastReconciledAt;
  const RecurringPayment(
      {required this.id,
      required this.profileId,
      required this.name,
      required this.amountMinor,
      required this.currency,
      required this.recurrence,
      this.categoryId,
      required this.nextPaymentDate,
      required this.isSubscription,
      required this.isActive,
      this.startDate,
      this.endDate,
      this.maxOccurrences,
      required this.generatedOccurrences,
      required this.intervalCount,
      required this.status,
      this.lastReconciledAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['name'] = Variable<String>(name);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    map['recurrence'] = Variable<String>(recurrence);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['next_payment_date'] = Variable<DateTime>(nextPaymentDate);
    map['is_subscription'] = Variable<bool>(isSubscription);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || maxOccurrences != null) {
      map['max_occurrences'] = Variable<int>(maxOccurrences);
    }
    map['generated_occurrences'] = Variable<int>(generatedOccurrences);
    map['interval_count'] = Variable<int>(intervalCount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastReconciledAt != null) {
      map['last_reconciled_at'] = Variable<DateTime>(lastReconciledAt);
    }
    return map;
  }

  RecurringPaymentsCompanion toCompanion(bool nullToAbsent) {
    return RecurringPaymentsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      recurrence: Value(recurrence),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      nextPaymentDate: Value(nextPaymentDate),
      isSubscription: Value(isSubscription),
      isActive: Value(isActive),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      maxOccurrences: maxOccurrences == null && nullToAbsent
          ? const Value.absent()
          : Value(maxOccurrences),
      generatedOccurrences: Value(generatedOccurrences),
      intervalCount: Value(intervalCount),
      status: Value(status),
      lastReconciledAt: lastReconciledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReconciledAt),
    );
  }

  factory RecurringPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringPayment(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      recurrence: serializer.fromJson<String>(json['recurrence']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      nextPaymentDate: serializer.fromJson<DateTime>(json['nextPaymentDate']),
      isSubscription: serializer.fromJson<bool>(json['isSubscription']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      maxOccurrences: serializer.fromJson<int?>(json['maxOccurrences']),
      generatedOccurrences:
          serializer.fromJson<int>(json['generatedOccurrences']),
      intervalCount: serializer.fromJson<int>(json['intervalCount']),
      status: serializer.fromJson<String>(json['status']),
      lastReconciledAt:
          serializer.fromJson<DateTime?>(json['lastReconciledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'name': serializer.toJson<String>(name),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'recurrence': serializer.toJson<String>(recurrence),
      'categoryId': serializer.toJson<String?>(categoryId),
      'nextPaymentDate': serializer.toJson<DateTime>(nextPaymentDate),
      'isSubscription': serializer.toJson<bool>(isSubscription),
      'isActive': serializer.toJson<bool>(isActive),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'maxOccurrences': serializer.toJson<int?>(maxOccurrences),
      'generatedOccurrences': serializer.toJson<int>(generatedOccurrences),
      'intervalCount': serializer.toJson<int>(intervalCount),
      'status': serializer.toJson<String>(status),
      'lastReconciledAt': serializer.toJson<DateTime?>(lastReconciledAt),
    };
  }

  RecurringPayment copyWith(
          {String? id,
          String? profileId,
          String? name,
          int? amountMinor,
          String? currency,
          String? recurrence,
          Value<String?> categoryId = const Value.absent(),
          DateTime? nextPaymentDate,
          bool? isSubscription,
          bool? isActive,
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent(),
          Value<int?> maxOccurrences = const Value.absent(),
          int? generatedOccurrences,
          int? intervalCount,
          String? status,
          Value<DateTime?> lastReconciledAt = const Value.absent()}) =>
      RecurringPayment(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        name: name ?? this.name,
        amountMinor: amountMinor ?? this.amountMinor,
        currency: currency ?? this.currency,
        recurrence: recurrence ?? this.recurrence,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
        isSubscription: isSubscription ?? this.isSubscription,
        isActive: isActive ?? this.isActive,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        maxOccurrences:
            maxOccurrences.present ? maxOccurrences.value : this.maxOccurrences,
        generatedOccurrences: generatedOccurrences ?? this.generatedOccurrences,
        intervalCount: intervalCount ?? this.intervalCount,
        status: status ?? this.status,
        lastReconciledAt: lastReconciledAt.present
            ? lastReconciledAt.value
            : this.lastReconciledAt,
      );
  RecurringPayment copyWithCompanion(RecurringPaymentsCompanion data) {
    return RecurringPayment(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      amountMinor:
          data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      recurrence:
          data.recurrence.present ? data.recurrence.value : this.recurrence,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      nextPaymentDate: data.nextPaymentDate.present
          ? data.nextPaymentDate.value
          : this.nextPaymentDate,
      isSubscription: data.isSubscription.present
          ? data.isSubscription.value
          : this.isSubscription,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      maxOccurrences: data.maxOccurrences.present
          ? data.maxOccurrences.value
          : this.maxOccurrences,
      generatedOccurrences: data.generatedOccurrences.present
          ? data.generatedOccurrences.value
          : this.generatedOccurrences,
      intervalCount: data.intervalCount.present
          ? data.intervalCount.value
          : this.intervalCount,
      status: data.status.present ? data.status.value : this.status,
      lastReconciledAt: data.lastReconciledAt.present
          ? data.lastReconciledAt.value
          : this.lastReconciledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringPayment(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('recurrence: $recurrence, ')
          ..write('categoryId: $categoryId, ')
          ..write('nextPaymentDate: $nextPaymentDate, ')
          ..write('isSubscription: $isSubscription, ')
          ..write('isActive: $isActive, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('maxOccurrences: $maxOccurrences, ')
          ..write('generatedOccurrences: $generatedOccurrences, ')
          ..write('intervalCount: $intervalCount, ')
          ..write('status: $status, ')
          ..write('lastReconciledAt: $lastReconciledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      profileId,
      name,
      amountMinor,
      currency,
      recurrence,
      categoryId,
      nextPaymentDate,
      isSubscription,
      isActive,
      startDate,
      endDate,
      maxOccurrences,
      generatedOccurrences,
      intervalCount,
      status,
      lastReconciledAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringPayment &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.recurrence == this.recurrence &&
          other.categoryId == this.categoryId &&
          other.nextPaymentDate == this.nextPaymentDate &&
          other.isSubscription == this.isSubscription &&
          other.isActive == this.isActive &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.maxOccurrences == this.maxOccurrences &&
          other.generatedOccurrences == this.generatedOccurrences &&
          other.intervalCount == this.intervalCount &&
          other.status == this.status &&
          other.lastReconciledAt == this.lastReconciledAt);
}

class RecurringPaymentsCompanion extends UpdateCompanion<RecurringPayment> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> name;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<String> recurrence;
  final Value<String?> categoryId;
  final Value<DateTime> nextPaymentDate;
  final Value<bool> isSubscription;
  final Value<bool> isActive;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<int?> maxOccurrences;
  final Value<int> generatedOccurrences;
  final Value<int> intervalCount;
  final Value<String> status;
  final Value<DateTime?> lastReconciledAt;
  final Value<int> rowid;
  const RecurringPaymentsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.nextPaymentDate = const Value.absent(),
    this.isSubscription = const Value.absent(),
    this.isActive = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.maxOccurrences = const Value.absent(),
    this.generatedOccurrences = const Value.absent(),
    this.intervalCount = const Value.absent(),
    this.status = const Value.absent(),
    this.lastReconciledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringPaymentsCompanion.insert({
    required String id,
    required String profileId,
    required String name,
    required int amountMinor,
    this.currency = const Value.absent(),
    required String recurrence,
    this.categoryId = const Value.absent(),
    required DateTime nextPaymentDate,
    this.isSubscription = const Value.absent(),
    this.isActive = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.maxOccurrences = const Value.absent(),
    this.generatedOccurrences = const Value.absent(),
    this.intervalCount = const Value.absent(),
    this.status = const Value.absent(),
    this.lastReconciledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        name = Value(name),
        amountMinor = Value(amountMinor),
        recurrence = Value(recurrence),
        nextPaymentDate = Value(nextPaymentDate);
  static Insertable<RecurringPayment> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<String>? recurrence,
    Expression<String>? categoryId,
    Expression<DateTime>? nextPaymentDate,
    Expression<bool>? isSubscription,
    Expression<bool>? isActive,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? maxOccurrences,
    Expression<int>? generatedOccurrences,
    Expression<int>? intervalCount,
    Expression<String>? status,
    Expression<DateTime>? lastReconciledAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (recurrence != null) 'recurrence': recurrence,
      if (categoryId != null) 'category_id': categoryId,
      if (nextPaymentDate != null) 'next_payment_date': nextPaymentDate,
      if (isSubscription != null) 'is_subscription': isSubscription,
      if (isActive != null) 'is_active': isActive,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (maxOccurrences != null) 'max_occurrences': maxOccurrences,
      if (generatedOccurrences != null)
        'generated_occurrences': generatedOccurrences,
      if (intervalCount != null) 'interval_count': intervalCount,
      if (status != null) 'status': status,
      if (lastReconciledAt != null) 'last_reconciled_at': lastReconciledAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringPaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? name,
      Value<int>? amountMinor,
      Value<String>? currency,
      Value<String>? recurrence,
      Value<String?>? categoryId,
      Value<DateTime>? nextPaymentDate,
      Value<bool>? isSubscription,
      Value<bool>? isActive,
      Value<DateTime?>? startDate,
      Value<DateTime?>? endDate,
      Value<int?>? maxOccurrences,
      Value<int>? generatedOccurrences,
      Value<int>? intervalCount,
      Value<String>? status,
      Value<DateTime?>? lastReconciledAt,
      Value<int>? rowid}) {
    return RecurringPaymentsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      recurrence: recurrence ?? this.recurrence,
      categoryId: categoryId ?? this.categoryId,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
      isSubscription: isSubscription ?? this.isSubscription,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      maxOccurrences: maxOccurrences ?? this.maxOccurrences,
      generatedOccurrences: generatedOccurrences ?? this.generatedOccurrences,
      intervalCount: intervalCount ?? this.intervalCount,
      status: status ?? this.status,
      lastReconciledAt: lastReconciledAt ?? this.lastReconciledAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(recurrence.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (nextPaymentDate.present) {
      map['next_payment_date'] = Variable<DateTime>(nextPaymentDate.value);
    }
    if (isSubscription.present) {
      map['is_subscription'] = Variable<bool>(isSubscription.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (maxOccurrences.present) {
      map['max_occurrences'] = Variable<int>(maxOccurrences.value);
    }
    if (generatedOccurrences.present) {
      map['generated_occurrences'] = Variable<int>(generatedOccurrences.value);
    }
    if (intervalCount.present) {
      map['interval_count'] = Variable<int>(intervalCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastReconciledAt.present) {
      map['last_reconciled_at'] = Variable<DateTime>(lastReconciledAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('recurrence: $recurrence, ')
          ..write('categoryId: $categoryId, ')
          ..write('nextPaymentDate: $nextPaymentDate, ')
          ..write('isSubscription: $isSubscription, ')
          ..write('isActive: $isActive, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('maxOccurrences: $maxOccurrences, ')
          ..write('generatedOccurrences: $generatedOccurrences, ')
          ..write('intervalCount: $intervalCount, ')
          ..write('status: $status, ')
          ..write('lastReconciledAt: $lastReconciledAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinancialPreferencesTable extends FinancialPreferences
    with TableInfo<$FinancialPreferencesTable, FinancialPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _monthlyIncomeMinorMeta =
      const VerificationMeta('monthlyIncomeMinor');
  @override
  late final GeneratedColumn<int> monthlyIncomeMinor = GeneratedColumn<int>(
      'monthly_income_minor', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _paydayMeta = const VerificationMeta('payday');
  @override
  late final GeneratedColumn<int> payday = GeneratedColumn<int>(
      'payday', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('SAR'));
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
      'notifications_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notifications_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _defaultPaymentMethodIdMeta =
      const VerificationMeta('defaultPaymentMethodId');
  @override
  late final GeneratedColumn<String> defaultPaymentMethodId =
      GeneratedColumn<String>('default_payment_method_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _widgetPrivacyEnabledMeta =
      const VerificationMeta('widgetPrivacyEnabled');
  @override
  late final GeneratedColumn<bool> widgetPrivacyEnabled = GeneratedColumn<bool>(
      'widget_privacy_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("widget_privacy_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        profileId,
        monthlyIncomeMinor,
        payday,
        currency,
        notificationsEnabled,
        defaultPaymentMethodId,
        widgetPrivacyEnabled
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_preferences';
  @override
  VerificationContext validateIntegrity(
      Insertable<FinancialPreference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('monthly_income_minor')) {
      context.handle(
          _monthlyIncomeMinorMeta,
          monthlyIncomeMinor.isAcceptableOrUnknown(
              data['monthly_income_minor']!, _monthlyIncomeMinorMeta));
    }
    if (data.containsKey('payday')) {
      context.handle(_paydayMeta,
          payday.isAcceptableOrUnknown(data['payday']!, _paydayMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
          _notificationsEnabledMeta,
          notificationsEnabled.isAcceptableOrUnknown(
              data['notifications_enabled']!, _notificationsEnabledMeta));
    }
    if (data.containsKey('default_payment_method_id')) {
      context.handle(
          _defaultPaymentMethodIdMeta,
          defaultPaymentMethodId.isAcceptableOrUnknown(
              data['default_payment_method_id']!, _defaultPaymentMethodIdMeta));
    }
    if (data.containsKey('widget_privacy_enabled')) {
      context.handle(
          _widgetPrivacyEnabledMeta,
          widgetPrivacyEnabled.isAcceptableOrUnknown(
              data['widget_privacy_enabled']!, _widgetPrivacyEnabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId};
  @override
  FinancialPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialPreference(
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      monthlyIncomeMinor: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}monthly_income_minor'])!,
      payday: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}payday'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}notifications_enabled'])!,
      defaultPaymentMethodId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}default_payment_method_id']),
      widgetPrivacyEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}widget_privacy_enabled'])!,
    );
  }

  @override
  $FinancialPreferencesTable createAlias(String alias) {
    return $FinancialPreferencesTable(attachedDatabase, alias);
  }
}

class FinancialPreference extends DataClass
    implements Insertable<FinancialPreference> {
  final String profileId;
  final int monthlyIncomeMinor;
  final int payday;
  final String currency;
  final bool notificationsEnabled;
  final String? defaultPaymentMethodId;
  final bool widgetPrivacyEnabled;
  const FinancialPreference(
      {required this.profileId,
      required this.monthlyIncomeMinor,
      required this.payday,
      required this.currency,
      required this.notificationsEnabled,
      this.defaultPaymentMethodId,
      required this.widgetPrivacyEnabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['monthly_income_minor'] = Variable<int>(monthlyIncomeMinor);
    map['payday'] = Variable<int>(payday);
    map['currency'] = Variable<String>(currency);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    if (!nullToAbsent || defaultPaymentMethodId != null) {
      map['default_payment_method_id'] =
          Variable<String>(defaultPaymentMethodId);
    }
    map['widget_privacy_enabled'] = Variable<bool>(widgetPrivacyEnabled);
    return map;
  }

  FinancialPreferencesCompanion toCompanion(bool nullToAbsent) {
    return FinancialPreferencesCompanion(
      profileId: Value(profileId),
      monthlyIncomeMinor: Value(monthlyIncomeMinor),
      payday: Value(payday),
      currency: Value(currency),
      notificationsEnabled: Value(notificationsEnabled),
      defaultPaymentMethodId: defaultPaymentMethodId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultPaymentMethodId),
      widgetPrivacyEnabled: Value(widgetPrivacyEnabled),
    );
  }

  factory FinancialPreference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialPreference(
      profileId: serializer.fromJson<String>(json['profileId']),
      monthlyIncomeMinor: serializer.fromJson<int>(json['monthlyIncomeMinor']),
      payday: serializer.fromJson<int>(json['payday']),
      currency: serializer.fromJson<String>(json['currency']),
      notificationsEnabled:
          serializer.fromJson<bool>(json['notificationsEnabled']),
      defaultPaymentMethodId:
          serializer.fromJson<String?>(json['defaultPaymentMethodId']),
      widgetPrivacyEnabled:
          serializer.fromJson<bool>(json['widgetPrivacyEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'monthlyIncomeMinor': serializer.toJson<int>(monthlyIncomeMinor),
      'payday': serializer.toJson<int>(payday),
      'currency': serializer.toJson<String>(currency),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'defaultPaymentMethodId':
          serializer.toJson<String?>(defaultPaymentMethodId),
      'widgetPrivacyEnabled': serializer.toJson<bool>(widgetPrivacyEnabled),
    };
  }

  FinancialPreference copyWith(
          {String? profileId,
          int? monthlyIncomeMinor,
          int? payday,
          String? currency,
          bool? notificationsEnabled,
          Value<String?> defaultPaymentMethodId = const Value.absent(),
          bool? widgetPrivacyEnabled}) =>
      FinancialPreference(
        profileId: profileId ?? this.profileId,
        monthlyIncomeMinor: monthlyIncomeMinor ?? this.monthlyIncomeMinor,
        payday: payday ?? this.payday,
        currency: currency ?? this.currency,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        defaultPaymentMethodId: defaultPaymentMethodId.present
            ? defaultPaymentMethodId.value
            : this.defaultPaymentMethodId,
        widgetPrivacyEnabled: widgetPrivacyEnabled ?? this.widgetPrivacyEnabled,
      );
  FinancialPreference copyWithCompanion(FinancialPreferencesCompanion data) {
    return FinancialPreference(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      monthlyIncomeMinor: data.monthlyIncomeMinor.present
          ? data.monthlyIncomeMinor.value
          : this.monthlyIncomeMinor,
      payday: data.payday.present ? data.payday.value : this.payday,
      currency: data.currency.present ? data.currency.value : this.currency,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      defaultPaymentMethodId: data.defaultPaymentMethodId.present
          ? data.defaultPaymentMethodId.value
          : this.defaultPaymentMethodId,
      widgetPrivacyEnabled: data.widgetPrivacyEnabled.present
          ? data.widgetPrivacyEnabled.value
          : this.widgetPrivacyEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialPreference(')
          ..write('profileId: $profileId, ')
          ..write('monthlyIncomeMinor: $monthlyIncomeMinor, ')
          ..write('payday: $payday, ')
          ..write('currency: $currency, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('defaultPaymentMethodId: $defaultPaymentMethodId, ')
          ..write('widgetPrivacyEnabled: $widgetPrivacyEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      profileId,
      monthlyIncomeMinor,
      payday,
      currency,
      notificationsEnabled,
      defaultPaymentMethodId,
      widgetPrivacyEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialPreference &&
          other.profileId == this.profileId &&
          other.monthlyIncomeMinor == this.monthlyIncomeMinor &&
          other.payday == this.payday &&
          other.currency == this.currency &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.defaultPaymentMethodId == this.defaultPaymentMethodId &&
          other.widgetPrivacyEnabled == this.widgetPrivacyEnabled);
}

class FinancialPreferencesCompanion
    extends UpdateCompanion<FinancialPreference> {
  final Value<String> profileId;
  final Value<int> monthlyIncomeMinor;
  final Value<int> payday;
  final Value<String> currency;
  final Value<bool> notificationsEnabled;
  final Value<String?> defaultPaymentMethodId;
  final Value<bool> widgetPrivacyEnabled;
  final Value<int> rowid;
  const FinancialPreferencesCompanion({
    this.profileId = const Value.absent(),
    this.monthlyIncomeMinor = const Value.absent(),
    this.payday = const Value.absent(),
    this.currency = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.defaultPaymentMethodId = const Value.absent(),
    this.widgetPrivacyEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinancialPreferencesCompanion.insert({
    required String profileId,
    this.monthlyIncomeMinor = const Value.absent(),
    this.payday = const Value.absent(),
    this.currency = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.defaultPaymentMethodId = const Value.absent(),
    this.widgetPrivacyEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId);
  static Insertable<FinancialPreference> custom({
    Expression<String>? profileId,
    Expression<int>? monthlyIncomeMinor,
    Expression<int>? payday,
    Expression<String>? currency,
    Expression<bool>? notificationsEnabled,
    Expression<String>? defaultPaymentMethodId,
    Expression<bool>? widgetPrivacyEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (monthlyIncomeMinor != null)
        'monthly_income_minor': monthlyIncomeMinor,
      if (payday != null) 'payday': payday,
      if (currency != null) 'currency': currency,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (defaultPaymentMethodId != null)
        'default_payment_method_id': defaultPaymentMethodId,
      if (widgetPrivacyEnabled != null)
        'widget_privacy_enabled': widgetPrivacyEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinancialPreferencesCompanion copyWith(
      {Value<String>? profileId,
      Value<int>? monthlyIncomeMinor,
      Value<int>? payday,
      Value<String>? currency,
      Value<bool>? notificationsEnabled,
      Value<String?>? defaultPaymentMethodId,
      Value<bool>? widgetPrivacyEnabled,
      Value<int>? rowid}) {
    return FinancialPreferencesCompanion(
      profileId: profileId ?? this.profileId,
      monthlyIncomeMinor: monthlyIncomeMinor ?? this.monthlyIncomeMinor,
      payday: payday ?? this.payday,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultPaymentMethodId:
          defaultPaymentMethodId ?? this.defaultPaymentMethodId,
      widgetPrivacyEnabled: widgetPrivacyEnabled ?? this.widgetPrivacyEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (monthlyIncomeMinor.present) {
      map['monthly_income_minor'] = Variable<int>(monthlyIncomeMinor.value);
    }
    if (payday.present) {
      map['payday'] = Variable<int>(payday.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (defaultPaymentMethodId.present) {
      map['default_payment_method_id'] =
          Variable<String>(defaultPaymentMethodId.value);
    }
    if (widgetPrivacyEnabled.present) {
      map['widget_privacy_enabled'] =
          Variable<bool>(widgetPrivacyEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialPreferencesCompanion(')
          ..write('profileId: $profileId, ')
          ..write('monthlyIncomeMinor: $monthlyIncomeMinor, ')
          ..write('payday: $payday, ')
          ..write('currency: $currency, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('defaultPaymentMethodId: $defaultPaymentMethodId, ')
          ..write('widgetPrivacyEnabled: $widgetPrivacyEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentMethodsTable extends PaymentMethods
    with TableInfo<$PaymentMethodsTable, PaymentMethod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentMethodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _systemCodeMeta =
      const VerificationMeta('systemCode');
  @override
  late final GeneratedColumn<String> systemCode = GeneratedColumn<String>(
      'system_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('payments'));
  static const VerificationMeta _isSystemMeta =
      const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
      'is_system', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_system" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastUsedAtMeta =
      const VerificationMeta('lastUsedAt');
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
      'last_used_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        systemCode,
        name,
        iconName,
        isSystem,
        isDefault,
        lastUsedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_methods';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentMethod> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('system_code')) {
      context.handle(
          _systemCodeMeta,
          systemCode.isAcceptableOrUnknown(
              data['system_code']!, _systemCodeMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta,
          isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
          _lastUsedAtMeta,
          lastUsedAt.isAcceptableOrUnknown(
              data['last_used_at']!, _lastUsedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {profileId, name},
      ];
  @override
  PaymentMethod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentMethod(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      systemCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}system_code']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name'])!,
      isSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      lastUsedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_used_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PaymentMethodsTable createAlias(String alias) {
    return $PaymentMethodsTable(attachedDatabase, alias);
  }
}

class PaymentMethod extends DataClass implements Insertable<PaymentMethod> {
  final String id;
  final String profileId;
  final String? systemCode;
  final String name;
  final String iconName;
  final bool isSystem;
  final bool isDefault;
  final DateTime? lastUsedAt;
  final DateTime createdAt;
  const PaymentMethod(
      {required this.id,
      required this.profileId,
      this.systemCode,
      required this.name,
      required this.iconName,
      required this.isSystem,
      required this.isDefault,
      this.lastUsedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    if (!nullToAbsent || systemCode != null) {
      map['system_code'] = Variable<String>(systemCode);
    }
    map['name'] = Variable<String>(name);
    map['icon_name'] = Variable<String>(iconName);
    map['is_system'] = Variable<bool>(isSystem);
    map['is_default'] = Variable<bool>(isDefault);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentMethodsCompanion toCompanion(bool nullToAbsent) {
    return PaymentMethodsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      systemCode: systemCode == null && nullToAbsent
          ? const Value.absent()
          : Value(systemCode),
      name: Value(name),
      iconName: Value(iconName),
      isSystem: Value(isSystem),
      isDefault: Value(isDefault),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentMethod(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      systemCode: serializer.fromJson<String?>(json['systemCode']),
      name: serializer.fromJson<String>(json['name']),
      iconName: serializer.fromJson<String>(json['iconName']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'systemCode': serializer.toJson<String?>(systemCode),
      'name': serializer.toJson<String>(name),
      'iconName': serializer.toJson<String>(iconName),
      'isSystem': serializer.toJson<bool>(isSystem),
      'isDefault': serializer.toJson<bool>(isDefault),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentMethod copyWith(
          {String? id,
          String? profileId,
          Value<String?> systemCode = const Value.absent(),
          String? name,
          String? iconName,
          bool? isSystem,
          bool? isDefault,
          Value<DateTime?> lastUsedAt = const Value.absent(),
          DateTime? createdAt}) =>
      PaymentMethod(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        systemCode: systemCode.present ? systemCode.value : this.systemCode,
        name: name ?? this.name,
        iconName: iconName ?? this.iconName,
        isSystem: isSystem ?? this.isSystem,
        isDefault: isDefault ?? this.isDefault,
        lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  PaymentMethod copyWithCompanion(PaymentMethodsCompanion data) {
    return PaymentMethod(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      systemCode:
          data.systemCode.present ? data.systemCode.value : this.systemCode,
      name: data.name.present ? data.name.value : this.name,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      lastUsedAt:
          data.lastUsedAt.present ? data.lastUsedAt.value : this.lastUsedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethod(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('systemCode: $systemCode, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('isSystem: $isSystem, ')
          ..write('isDefault: $isDefault, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, systemCode, name, iconName,
      isSystem, isDefault, lastUsedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentMethod &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.systemCode == this.systemCode &&
          other.name == this.name &&
          other.iconName == this.iconName &&
          other.isSystem == this.isSystem &&
          other.isDefault == this.isDefault &&
          other.lastUsedAt == this.lastUsedAt &&
          other.createdAt == this.createdAt);
}

class PaymentMethodsCompanion extends UpdateCompanion<PaymentMethod> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String?> systemCode;
  final Value<String> name;
  final Value<String> iconName;
  final Value<bool> isSystem;
  final Value<bool> isDefault;
  final Value<DateTime?> lastUsedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PaymentMethodsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.systemCode = const Value.absent(),
    this.name = const Value.absent(),
    this.iconName = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentMethodsCompanion.insert({
    required String id,
    required String profileId,
    this.systemCode = const Value.absent(),
    required String name,
    this.iconName = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        name = Value(name);
  static Insertable<PaymentMethod> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? systemCode,
    Expression<String>? name,
    Expression<String>? iconName,
    Expression<bool>? isSystem,
    Expression<bool>? isDefault,
    Expression<DateTime>? lastUsedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (systemCode != null) 'system_code': systemCode,
      if (name != null) 'name': name,
      if (iconName != null) 'icon_name': iconName,
      if (isSystem != null) 'is_system': isSystem,
      if (isDefault != null) 'is_default': isDefault,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentMethodsCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String?>? systemCode,
      Value<String>? name,
      Value<String>? iconName,
      Value<bool>? isSystem,
      Value<bool>? isDefault,
      Value<DateTime?>? lastUsedAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PaymentMethodsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      systemCode: systemCode ?? this.systemCode,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      isSystem: isSystem ?? this.isSystem,
      isDefault: isDefault ?? this.isDefault,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (systemCode.present) {
      map['system_code'] = Variable<String>(systemCode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethodsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('systemCode: $systemCode, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('isSystem: $isSystem, ')
          ..write('isDefault: $isDefault, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReceiptAttachmentsTable extends ReceiptAttachments
    with TableInfo<$ReceiptAttachmentsTable, ReceiptAttachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceiptAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
      'transaction_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _thumbnailPathMeta =
      const VerificationMeta('thumbnailPath');
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
      'thumbnail_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sizeBytesMeta =
      const VerificationMeta('sizeBytes');
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
      'size_bytes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
      'width', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
      'height', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        transactionId,
        filePath,
        thumbnailPath,
        mimeType,
        sizeBytes,
        width,
        height,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receipt_attachments';
  @override
  VerificationContext validateIntegrity(Insertable<ReceiptAttachment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
          _thumbnailPathMeta,
          thumbnailPath.isAcceptableOrUnknown(
              data['thumbnail_path']!, _thumbnailPathMeta));
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(_sizeBytesMeta,
          sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta));
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
          _widthMeta, width.isAcceptableOrUnknown(data['width']!, _widthMeta));
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {transactionId},
      ];
  @override
  ReceiptAttachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReceiptAttachment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transaction_id'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      thumbnailPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumbnail_path']),
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type'])!,
      sizeBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size_bytes'])!,
      width: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}width']),
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}height']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ReceiptAttachmentsTable createAlias(String alias) {
    return $ReceiptAttachmentsTable(attachedDatabase, alias);
  }
}

class ReceiptAttachment extends DataClass
    implements Insertable<ReceiptAttachment> {
  final String id;
  final String profileId;
  final String transactionId;
  final String filePath;
  final String? thumbnailPath;
  final String mimeType;
  final int sizeBytes;
  final int? width;
  final int? height;
  final DateTime createdAt;
  const ReceiptAttachment(
      {required this.id,
      required this.profileId,
      required this.transactionId,
      required this.filePath,
      this.thumbnailPath,
      required this.mimeType,
      required this.sizeBytes,
      this.width,
      this.height,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['transaction_id'] = Variable<String>(transactionId);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    map['mime_type'] = Variable<String>(mimeType);
    map['size_bytes'] = Variable<int>(sizeBytes);
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReceiptAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return ReceiptAttachmentsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      transactionId: Value(transactionId),
      filePath: Value(filePath),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      mimeType: Value(mimeType),
      sizeBytes: Value(sizeBytes),
      width:
          width == null && nullToAbsent ? const Value.absent() : Value(width),
      height:
          height == null && nullToAbsent ? const Value.absent() : Value(height),
      createdAt: Value(createdAt),
    );
  }

  factory ReceiptAttachment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReceiptAttachment(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'transactionId': serializer.toJson<String>(transactionId),
      'filePath': serializer.toJson<String>(filePath),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'mimeType': serializer.toJson<String>(mimeType),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReceiptAttachment copyWith(
          {String? id,
          String? profileId,
          String? transactionId,
          String? filePath,
          Value<String?> thumbnailPath = const Value.absent(),
          String? mimeType,
          int? sizeBytes,
          Value<int?> width = const Value.absent(),
          Value<int?> height = const Value.absent(),
          DateTime? createdAt}) =>
      ReceiptAttachment(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        transactionId: transactionId ?? this.transactionId,
        filePath: filePath ?? this.filePath,
        thumbnailPath:
            thumbnailPath.present ? thumbnailPath.value : this.thumbnailPath,
        mimeType: mimeType ?? this.mimeType,
        sizeBytes: sizeBytes ?? this.sizeBytes,
        width: width.present ? width.value : this.width,
        height: height.present ? height.value : this.height,
        createdAt: createdAt ?? this.createdAt,
      );
  ReceiptAttachment copyWithCompanion(ReceiptAttachmentsCompanion data) {
    return ReceiptAttachment(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptAttachment(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('transactionId: $transactionId, ')
          ..write('filePath: $filePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, transactionId, filePath,
      thumbnailPath, mimeType, sizeBytes, width, height, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceiptAttachment &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.transactionId == this.transactionId &&
          other.filePath == this.filePath &&
          other.thumbnailPath == this.thumbnailPath &&
          other.mimeType == this.mimeType &&
          other.sizeBytes == this.sizeBytes &&
          other.width == this.width &&
          other.height == this.height &&
          other.createdAt == this.createdAt);
}

class ReceiptAttachmentsCompanion extends UpdateCompanion<ReceiptAttachment> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> transactionId;
  final Value<String> filePath;
  final Value<String?> thumbnailPath;
  final Value<String> mimeType;
  final Value<int> sizeBytes;
  final Value<int?> width;
  final Value<int?> height;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReceiptAttachmentsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReceiptAttachmentsCompanion.insert({
    required String id,
    required String profileId,
    required String transactionId,
    required String filePath,
    this.thumbnailPath = const Value.absent(),
    required String mimeType,
    required int sizeBytes,
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        transactionId = Value(transactionId),
        filePath = Value(filePath),
        mimeType = Value(mimeType),
        sizeBytes = Value(sizeBytes);
  static Insertable<ReceiptAttachment> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? transactionId,
    Expression<String>? filePath,
    Expression<String>? thumbnailPath,
    Expression<String>? mimeType,
    Expression<int>? sizeBytes,
    Expression<int>? width,
    Expression<int>? height,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (transactionId != null) 'transaction_id': transactionId,
      if (filePath != null) 'file_path': filePath,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (mimeType != null) 'mime_type': mimeType,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReceiptAttachmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? transactionId,
      Value<String>? filePath,
      Value<String?>? thumbnailPath,
      Value<String>? mimeType,
      Value<int>? sizeBytes,
      Value<int?>? width,
      Value<int?>? height,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ReceiptAttachmentsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      transactionId: transactionId ?? this.transactionId,
      filePath: filePath ?? this.filePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      width: width ?? this.width,
      height: height ?? this.height,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('transactionId: $transactionId, ')
          ..write('filePath: $filePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetCategoriesTable extends BudgetCategories
    with TableInfo<$BudgetCategoriesTable, BudgetCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _budgetIdMeta =
      const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
      'budget_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _limitMinorMeta =
      const VerificationMeta('limitMinor');
  @override
  late final GeneratedColumn<int> limitMinor = GeneratedColumn<int>(
      'limit_minor', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, profileId, budgetId, categoryId, limitMinor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_categories';
  @override
  VerificationContext validateIntegrity(Insertable<BudgetCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(_budgetIdMeta,
          budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta));
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('limit_minor')) {
      context.handle(
          _limitMinorMeta,
          limitMinor.isAcceptableOrUnknown(
              data['limit_minor']!, _limitMinorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {budgetId, categoryId},
      ];
  @override
  BudgetCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      budgetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}budget_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      limitMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}limit_minor']),
    );
  }

  @override
  $BudgetCategoriesTable createAlias(String alias) {
    return $BudgetCategoriesTable(attachedDatabase, alias);
  }
}

class BudgetCategory extends DataClass implements Insertable<BudgetCategory> {
  final String id;
  final String profileId;
  final String budgetId;
  final String categoryId;
  final int? limitMinor;
  const BudgetCategory(
      {required this.id,
      required this.profileId,
      required this.budgetId,
      required this.categoryId,
      this.limitMinor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['budget_id'] = Variable<String>(budgetId);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || limitMinor != null) {
      map['limit_minor'] = Variable<int>(limitMinor);
    }
    return map;
  }

  BudgetCategoriesCompanion toCompanion(bool nullToAbsent) {
    return BudgetCategoriesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      budgetId: Value(budgetId),
      categoryId: Value(categoryId),
      limitMinor: limitMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(limitMinor),
    );
  }

  factory BudgetCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetCategory(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      limitMinor: serializer.fromJson<int?>(json['limitMinor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'budgetId': serializer.toJson<String>(budgetId),
      'categoryId': serializer.toJson<String>(categoryId),
      'limitMinor': serializer.toJson<int?>(limitMinor),
    };
  }

  BudgetCategory copyWith(
          {String? id,
          String? profileId,
          String? budgetId,
          String? categoryId,
          Value<int?> limitMinor = const Value.absent()}) =>
      BudgetCategory(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        budgetId: budgetId ?? this.budgetId,
        categoryId: categoryId ?? this.categoryId,
        limitMinor: limitMinor.present ? limitMinor.value : this.limitMinor,
      );
  BudgetCategory copyWithCompanion(BudgetCategoriesCompanion data) {
    return BudgetCategory(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      limitMinor:
          data.limitMinor.present ? data.limitMinor.value : this.limitMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategory(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('budgetId: $budgetId, ')
          ..write('categoryId: $categoryId, ')
          ..write('limitMinor: $limitMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, budgetId, categoryId, limitMinor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetCategory &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.budgetId == this.budgetId &&
          other.categoryId == this.categoryId &&
          other.limitMinor == this.limitMinor);
}

class BudgetCategoriesCompanion extends UpdateCompanion<BudgetCategory> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> budgetId;
  final Value<String> categoryId;
  final Value<int?> limitMinor;
  final Value<int> rowid;
  const BudgetCategoriesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.limitMinor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetCategoriesCompanion.insert({
    required String id,
    required String profileId,
    required String budgetId,
    required String categoryId,
    this.limitMinor = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        budgetId = Value(budgetId),
        categoryId = Value(categoryId);
  static Insertable<BudgetCategory> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? budgetId,
    Expression<String>? categoryId,
    Expression<int>? limitMinor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (budgetId != null) 'budget_id': budgetId,
      if (categoryId != null) 'category_id': categoryId,
      if (limitMinor != null) 'limit_minor': limitMinor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? budgetId,
      Value<String>? categoryId,
      Value<int?>? limitMinor,
      Value<int>? rowid}) {
    return BudgetCategoriesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      budgetId: budgetId ?? this.budgetId,
      categoryId: categoryId ?? this.categoryId,
      limitMinor: limitMinor ?? this.limitMinor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (limitMinor.present) {
      map['limit_minor'] = Variable<int>(limitMinor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('budgetId: $budgetId, ')
          ..write('categoryId: $categoryId, ')
          ..write('limitMinor: $limitMinor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetHistoryTable extends BudgetHistory
    with TableInfo<$BudgetHistoryTable, BudgetHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _budgetIdMeta =
      const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
      'budget_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _periodStartMeta =
      const VerificationMeta('periodStart');
  @override
  late final GeneratedColumn<DateTime> periodStart = GeneratedColumn<DateTime>(
      'period_start', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _periodEndMeta =
      const VerificationMeta('periodEnd');
  @override
  late final GeneratedColumn<DateTime> periodEnd = GeneratedColumn<DateTime>(
      'period_end', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _limitMinorMeta =
      const VerificationMeta('limitMinor');
  @override
  late final GeneratedColumn<int> limitMinor = GeneratedColumn<int>(
      'limit_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _spentMinorMeta =
      const VerificationMeta('spentMinor');
  @override
  late final GeneratedColumn<int> spentMinor = GeneratedColumn<int>(
      'spent_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _carriedMinorMeta =
      const VerificationMeta('carriedMinor');
  @override
  late final GeneratedColumn<int> carriedMinor = GeneratedColumn<int>(
      'carried_minor', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        budgetId,
        periodStart,
        periodEnd,
        limitMinor,
        spentMinor,
        carriedMinor,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_history';
  @override
  VerificationContext validateIntegrity(Insertable<BudgetHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(_budgetIdMeta,
          budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta));
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('period_start')) {
      context.handle(
          _periodStartMeta,
          periodStart.isAcceptableOrUnknown(
              data['period_start']!, _periodStartMeta));
    } else if (isInserting) {
      context.missing(_periodStartMeta);
    }
    if (data.containsKey('period_end')) {
      context.handle(_periodEndMeta,
          periodEnd.isAcceptableOrUnknown(data['period_end']!, _periodEndMeta));
    } else if (isInserting) {
      context.missing(_periodEndMeta);
    }
    if (data.containsKey('limit_minor')) {
      context.handle(
          _limitMinorMeta,
          limitMinor.isAcceptableOrUnknown(
              data['limit_minor']!, _limitMinorMeta));
    } else if (isInserting) {
      context.missing(_limitMinorMeta);
    }
    if (data.containsKey('spent_minor')) {
      context.handle(
          _spentMinorMeta,
          spentMinor.isAcceptableOrUnknown(
              data['spent_minor']!, _spentMinorMeta));
    } else if (isInserting) {
      context.missing(_spentMinorMeta);
    }
    if (data.containsKey('carried_minor')) {
      context.handle(
          _carriedMinorMeta,
          carriedMinor.isAcceptableOrUnknown(
              data['carried_minor']!, _carriedMinorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      budgetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}budget_id'])!,
      periodStart: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}period_start'])!,
      periodEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}period_end'])!,
      limitMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}limit_minor'])!,
      spentMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}spent_minor'])!,
      carriedMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}carried_minor'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BudgetHistoryTable createAlias(String alias) {
    return $BudgetHistoryTable(attachedDatabase, alias);
  }
}

class BudgetHistoryData extends DataClass
    implements Insertable<BudgetHistoryData> {
  final String id;
  final String profileId;
  final String budgetId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int limitMinor;
  final int spentMinor;
  final int carriedMinor;
  final DateTime createdAt;
  const BudgetHistoryData(
      {required this.id,
      required this.profileId,
      required this.budgetId,
      required this.periodStart,
      required this.periodEnd,
      required this.limitMinor,
      required this.spentMinor,
      required this.carriedMinor,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['budget_id'] = Variable<String>(budgetId);
    map['period_start'] = Variable<DateTime>(periodStart);
    map['period_end'] = Variable<DateTime>(periodEnd);
    map['limit_minor'] = Variable<int>(limitMinor);
    map['spent_minor'] = Variable<int>(spentMinor);
    map['carried_minor'] = Variable<int>(carriedMinor);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BudgetHistoryCompanion toCompanion(bool nullToAbsent) {
    return BudgetHistoryCompanion(
      id: Value(id),
      profileId: Value(profileId),
      budgetId: Value(budgetId),
      periodStart: Value(periodStart),
      periodEnd: Value(periodEnd),
      limitMinor: Value(limitMinor),
      spentMinor: Value(spentMinor),
      carriedMinor: Value(carriedMinor),
      createdAt: Value(createdAt),
    );
  }

  factory BudgetHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetHistoryData(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      periodStart: serializer.fromJson<DateTime>(json['periodStart']),
      periodEnd: serializer.fromJson<DateTime>(json['periodEnd']),
      limitMinor: serializer.fromJson<int>(json['limitMinor']),
      spentMinor: serializer.fromJson<int>(json['spentMinor']),
      carriedMinor: serializer.fromJson<int>(json['carriedMinor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'budgetId': serializer.toJson<String>(budgetId),
      'periodStart': serializer.toJson<DateTime>(periodStart),
      'periodEnd': serializer.toJson<DateTime>(periodEnd),
      'limitMinor': serializer.toJson<int>(limitMinor),
      'spentMinor': serializer.toJson<int>(spentMinor),
      'carriedMinor': serializer.toJson<int>(carriedMinor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BudgetHistoryData copyWith(
          {String? id,
          String? profileId,
          String? budgetId,
          DateTime? periodStart,
          DateTime? periodEnd,
          int? limitMinor,
          int? spentMinor,
          int? carriedMinor,
          DateTime? createdAt}) =>
      BudgetHistoryData(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        budgetId: budgetId ?? this.budgetId,
        periodStart: periodStart ?? this.periodStart,
        periodEnd: periodEnd ?? this.periodEnd,
        limitMinor: limitMinor ?? this.limitMinor,
        spentMinor: spentMinor ?? this.spentMinor,
        carriedMinor: carriedMinor ?? this.carriedMinor,
        createdAt: createdAt ?? this.createdAt,
      );
  BudgetHistoryData copyWithCompanion(BudgetHistoryCompanion data) {
    return BudgetHistoryData(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      periodStart:
          data.periodStart.present ? data.periodStart.value : this.periodStart,
      periodEnd: data.periodEnd.present ? data.periodEnd.value : this.periodEnd,
      limitMinor:
          data.limitMinor.present ? data.limitMinor.value : this.limitMinor,
      spentMinor:
          data.spentMinor.present ? data.spentMinor.value : this.spentMinor,
      carriedMinor: data.carriedMinor.present
          ? data.carriedMinor.value
          : this.carriedMinor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetHistoryData(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('budgetId: $budgetId, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('limitMinor: $limitMinor, ')
          ..write('spentMinor: $spentMinor, ')
          ..write('carriedMinor: $carriedMinor, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, budgetId, periodStart,
      periodEnd, limitMinor, spentMinor, carriedMinor, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetHistoryData &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.budgetId == this.budgetId &&
          other.periodStart == this.periodStart &&
          other.periodEnd == this.periodEnd &&
          other.limitMinor == this.limitMinor &&
          other.spentMinor == this.spentMinor &&
          other.carriedMinor == this.carriedMinor &&
          other.createdAt == this.createdAt);
}

class BudgetHistoryCompanion extends UpdateCompanion<BudgetHistoryData> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> budgetId;
  final Value<DateTime> periodStart;
  final Value<DateTime> periodEnd;
  final Value<int> limitMinor;
  final Value<int> spentMinor;
  final Value<int> carriedMinor;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BudgetHistoryCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.limitMinor = const Value.absent(),
    this.spentMinor = const Value.absent(),
    this.carriedMinor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetHistoryCompanion.insert({
    required String id,
    required String profileId,
    required String budgetId,
    required DateTime periodStart,
    required DateTime periodEnd,
    required int limitMinor,
    required int spentMinor,
    this.carriedMinor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        budgetId = Value(budgetId),
        periodStart = Value(periodStart),
        periodEnd = Value(periodEnd),
        limitMinor = Value(limitMinor),
        spentMinor = Value(spentMinor);
  static Insertable<BudgetHistoryData> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? budgetId,
    Expression<DateTime>? periodStart,
    Expression<DateTime>? periodEnd,
    Expression<int>? limitMinor,
    Expression<int>? spentMinor,
    Expression<int>? carriedMinor,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (budgetId != null) 'budget_id': budgetId,
      if (periodStart != null) 'period_start': periodStart,
      if (periodEnd != null) 'period_end': periodEnd,
      if (limitMinor != null) 'limit_minor': limitMinor,
      if (spentMinor != null) 'spent_minor': spentMinor,
      if (carriedMinor != null) 'carried_minor': carriedMinor,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetHistoryCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? budgetId,
      Value<DateTime>? periodStart,
      Value<DateTime>? periodEnd,
      Value<int>? limitMinor,
      Value<int>? spentMinor,
      Value<int>? carriedMinor,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return BudgetHistoryCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      budgetId: budgetId ?? this.budgetId,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      limitMinor: limitMinor ?? this.limitMinor,
      spentMinor: spentMinor ?? this.spentMinor,
      carriedMinor: carriedMinor ?? this.carriedMinor,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (periodStart.present) {
      map['period_start'] = Variable<DateTime>(periodStart.value);
    }
    if (periodEnd.present) {
      map['period_end'] = Variable<DateTime>(periodEnd.value);
    }
    if (limitMinor.present) {
      map['limit_minor'] = Variable<int>(limitMinor.value);
    }
    if (spentMinor.present) {
      map['spent_minor'] = Variable<int>(spentMinor.value);
    }
    if (carriedMinor.present) {
      map['carried_minor'] = Variable<int>(carriedMinor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetHistoryCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('budgetId: $budgetId, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('limitMinor: $limitMinor, ')
          ..write('spentMinor: $spentMinor, ')
          ..write('carriedMinor: $carriedMinor, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringOccurrencesTable extends RecurringOccurrences
    with TableInfo<$RecurringOccurrencesTable, RecurringOccurrence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringOccurrencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recurringPaymentIdMeta =
      const VerificationMeta('recurringPaymentId');
  @override
  late final GeneratedColumn<String> recurringPaymentId =
      GeneratedColumn<String>('recurring_payment_id', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduledAtMeta =
      const VerificationMeta('scheduledAt');
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
      'scheduled_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _amountMinorMeta =
      const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
      'amount_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('upcoming'));
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
      'transaction_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isOverrideMeta =
      const VerificationMeta('isOverride');
  @override
  late final GeneratedColumn<bool> isOverride = GeneratedColumn<bool>(
      'is_override', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_override" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        recurringPaymentId,
        scheduledAt,
        amountMinor,
        status,
        transactionId,
        isOverride,
        paidAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_occurrences';
  @override
  VerificationContext validateIntegrity(
      Insertable<RecurringOccurrence> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('recurring_payment_id')) {
      context.handle(
          _recurringPaymentIdMeta,
          recurringPaymentId.isAcceptableOrUnknown(
              data['recurring_payment_id']!, _recurringPaymentIdMeta));
    } else if (isInserting) {
      context.missing(_recurringPaymentIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
          _scheduledAtMeta,
          scheduledAt.isAcceptableOrUnknown(
              data['scheduled_at']!, _scheduledAtMeta));
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
          _amountMinorMeta,
          amountMinor.isAcceptableOrUnknown(
              data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    }
    if (data.containsKey('is_override')) {
      context.handle(
          _isOverrideMeta,
          isOverride.isAcceptableOrUnknown(
              data['is_override']!, _isOverrideMeta));
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {recurringPaymentId, scheduledAt},
      ];
  @override
  RecurringOccurrence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringOccurrence(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      recurringPaymentId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recurring_payment_id'])!,
      scheduledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scheduled_at'])!,
      amountMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_minor'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transaction_id']),
      isOverride: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_override'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RecurringOccurrencesTable createAlias(String alias) {
    return $RecurringOccurrencesTable(attachedDatabase, alias);
  }
}

class RecurringOccurrence extends DataClass
    implements Insertable<RecurringOccurrence> {
  final String id;
  final String profileId;
  final String recurringPaymentId;
  final DateTime scheduledAt;
  final int amountMinor;
  final String status;
  final String? transactionId;
  final bool isOverride;
  final DateTime? paidAt;
  final DateTime createdAt;
  const RecurringOccurrence(
      {required this.id,
      required this.profileId,
      required this.recurringPaymentId,
      required this.scheduledAt,
      required this.amountMinor,
      required this.status,
      this.transactionId,
      required this.isOverride,
      this.paidAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['recurring_payment_id'] = Variable<String>(recurringPaymentId);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    map['is_override'] = Variable<bool>(isOverride);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecurringOccurrencesCompanion toCompanion(bool nullToAbsent) {
    return RecurringOccurrencesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      recurringPaymentId: Value(recurringPaymentId),
      scheduledAt: Value(scheduledAt),
      amountMinor: Value(amountMinor),
      status: Value(status),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      isOverride: Value(isOverride),
      paidAt:
          paidAt == null && nullToAbsent ? const Value.absent() : Value(paidAt),
      createdAt: Value(createdAt),
    );
  }

  factory RecurringOccurrence.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringOccurrence(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      recurringPaymentId:
          serializer.fromJson<String>(json['recurringPaymentId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      status: serializer.fromJson<String>(json['status']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      isOverride: serializer.fromJson<bool>(json['isOverride']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'recurringPaymentId': serializer.toJson<String>(recurringPaymentId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'status': serializer.toJson<String>(status),
      'transactionId': serializer.toJson<String?>(transactionId),
      'isOverride': serializer.toJson<bool>(isOverride),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RecurringOccurrence copyWith(
          {String? id,
          String? profileId,
          String? recurringPaymentId,
          DateTime? scheduledAt,
          int? amountMinor,
          String? status,
          Value<String?> transactionId = const Value.absent(),
          bool? isOverride,
          Value<DateTime?> paidAt = const Value.absent(),
          DateTime? createdAt}) =>
      RecurringOccurrence(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        recurringPaymentId: recurringPaymentId ?? this.recurringPaymentId,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        amountMinor: amountMinor ?? this.amountMinor,
        status: status ?? this.status,
        transactionId:
            transactionId.present ? transactionId.value : this.transactionId,
        isOverride: isOverride ?? this.isOverride,
        paidAt: paidAt.present ? paidAt.value : this.paidAt,
        createdAt: createdAt ?? this.createdAt,
      );
  RecurringOccurrence copyWithCompanion(RecurringOccurrencesCompanion data) {
    return RecurringOccurrence(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      recurringPaymentId: data.recurringPaymentId.present
          ? data.recurringPaymentId.value
          : this.recurringPaymentId,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      amountMinor:
          data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      status: data.status.present ? data.status.value : this.status,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      isOverride:
          data.isOverride.present ? data.isOverride.value : this.isOverride,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringOccurrence(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('recurringPaymentId: $recurringPaymentId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('status: $status, ')
          ..write('transactionId: $transactionId, ')
          ..write('isOverride: $isOverride, ')
          ..write('paidAt: $paidAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      profileId,
      recurringPaymentId,
      scheduledAt,
      amountMinor,
      status,
      transactionId,
      isOverride,
      paidAt,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringOccurrence &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.recurringPaymentId == this.recurringPaymentId &&
          other.scheduledAt == this.scheduledAt &&
          other.amountMinor == this.amountMinor &&
          other.status == this.status &&
          other.transactionId == this.transactionId &&
          other.isOverride == this.isOverride &&
          other.paidAt == this.paidAt &&
          other.createdAt == this.createdAt);
}

class RecurringOccurrencesCompanion
    extends UpdateCompanion<RecurringOccurrence> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> recurringPaymentId;
  final Value<DateTime> scheduledAt;
  final Value<int> amountMinor;
  final Value<String> status;
  final Value<String?> transactionId;
  final Value<bool> isOverride;
  final Value<DateTime?> paidAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RecurringOccurrencesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.recurringPaymentId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.status = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.isOverride = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringOccurrencesCompanion.insert({
    required String id,
    required String profileId,
    required String recurringPaymentId,
    required DateTime scheduledAt,
    required int amountMinor,
    this.status = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.isOverride = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        recurringPaymentId = Value(recurringPaymentId),
        scheduledAt = Value(scheduledAt),
        amountMinor = Value(amountMinor);
  static Insertable<RecurringOccurrence> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? recurringPaymentId,
    Expression<DateTime>? scheduledAt,
    Expression<int>? amountMinor,
    Expression<String>? status,
    Expression<String>? transactionId,
    Expression<bool>? isOverride,
    Expression<DateTime>? paidAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (recurringPaymentId != null)
        'recurring_payment_id': recurringPaymentId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (status != null) 'status': status,
      if (transactionId != null) 'transaction_id': transactionId,
      if (isOverride != null) 'is_override': isOverride,
      if (paidAt != null) 'paid_at': paidAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringOccurrencesCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? recurringPaymentId,
      Value<DateTime>? scheduledAt,
      Value<int>? amountMinor,
      Value<String>? status,
      Value<String?>? transactionId,
      Value<bool>? isOverride,
      Value<DateTime?>? paidAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return RecurringOccurrencesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      recurringPaymentId: recurringPaymentId ?? this.recurringPaymentId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      amountMinor: amountMinor ?? this.amountMinor,
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      isOverride: isOverride ?? this.isOverride,
      paidAt: paidAt ?? this.paidAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (recurringPaymentId.present) {
      map['recurring_payment_id'] = Variable<String>(recurringPaymentId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (isOverride.present) {
      map['is_override'] = Variable<bool>(isOverride.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringOccurrencesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('recurringPaymentId: $recurringPaymentId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('status: $status, ')
          ..write('transactionId: $transactionId, ')
          ..write('isOverride: $isOverride, ')
          ..write('paidAt: $paidAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringPaymentHistoryTable extends RecurringPaymentHistory
    with TableInfo<$RecurringPaymentHistoryTable, RecurringPaymentHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringPaymentHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recurringPaymentIdMeta =
      const VerificationMeta('recurringPaymentId');
  @override
  late final GeneratedColumn<String> recurringPaymentId =
      GeneratedColumn<String>('recurring_payment_id', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _occurrenceIdMeta =
      const VerificationMeta('occurrenceId');
  @override
  late final GeneratedColumn<String> occurrenceId = GeneratedColumn<String>(
      'occurrence_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMinorMeta =
      const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
      'amount_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
      'transaction_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        recurringPaymentId,
        occurrenceId,
        amountMinor,
        paidAt,
        transactionId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_payment_history';
  @override
  VerificationContext validateIntegrity(
      Insertable<RecurringPaymentHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('recurring_payment_id')) {
      context.handle(
          _recurringPaymentIdMeta,
          recurringPaymentId.isAcceptableOrUnknown(
              data['recurring_payment_id']!, _recurringPaymentIdMeta));
    } else if (isInserting) {
      context.missing(_recurringPaymentIdMeta);
    }
    if (data.containsKey('occurrence_id')) {
      context.handle(
          _occurrenceIdMeta,
          occurrenceId.isAcceptableOrUnknown(
              data['occurrence_id']!, _occurrenceIdMeta));
    } else if (isInserting) {
      context.missing(_occurrenceIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
          _amountMinorMeta,
          amountMinor.isAcceptableOrUnknown(
              data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringPaymentHistoryData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringPaymentHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      recurringPaymentId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recurring_payment_id'])!,
      occurrenceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}occurrence_id'])!,
      amountMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_minor'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transaction_id']),
    );
  }

  @override
  $RecurringPaymentHistoryTable createAlias(String alias) {
    return $RecurringPaymentHistoryTable(attachedDatabase, alias);
  }
}

class RecurringPaymentHistoryData extends DataClass
    implements Insertable<RecurringPaymentHistoryData> {
  final String id;
  final String profileId;
  final String recurringPaymentId;
  final String occurrenceId;
  final int amountMinor;
  final DateTime paidAt;
  final String? transactionId;
  const RecurringPaymentHistoryData(
      {required this.id,
      required this.profileId,
      required this.recurringPaymentId,
      required this.occurrenceId,
      required this.amountMinor,
      required this.paidAt,
      this.transactionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['recurring_payment_id'] = Variable<String>(recurringPaymentId);
    map['occurrence_id'] = Variable<String>(occurrenceId);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['paid_at'] = Variable<DateTime>(paidAt);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    return map;
  }

  RecurringPaymentHistoryCompanion toCompanion(bool nullToAbsent) {
    return RecurringPaymentHistoryCompanion(
      id: Value(id),
      profileId: Value(profileId),
      recurringPaymentId: Value(recurringPaymentId),
      occurrenceId: Value(occurrenceId),
      amountMinor: Value(amountMinor),
      paidAt: Value(paidAt),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
    );
  }

  factory RecurringPaymentHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringPaymentHistoryData(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      recurringPaymentId:
          serializer.fromJson<String>(json['recurringPaymentId']),
      occurrenceId: serializer.fromJson<String>(json['occurrenceId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'recurringPaymentId': serializer.toJson<String>(recurringPaymentId),
      'occurrenceId': serializer.toJson<String>(occurrenceId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'paidAt': serializer.toJson<DateTime>(paidAt),
      'transactionId': serializer.toJson<String?>(transactionId),
    };
  }

  RecurringPaymentHistoryData copyWith(
          {String? id,
          String? profileId,
          String? recurringPaymentId,
          String? occurrenceId,
          int? amountMinor,
          DateTime? paidAt,
          Value<String?> transactionId = const Value.absent()}) =>
      RecurringPaymentHistoryData(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        recurringPaymentId: recurringPaymentId ?? this.recurringPaymentId,
        occurrenceId: occurrenceId ?? this.occurrenceId,
        amountMinor: amountMinor ?? this.amountMinor,
        paidAt: paidAt ?? this.paidAt,
        transactionId:
            transactionId.present ? transactionId.value : this.transactionId,
      );
  RecurringPaymentHistoryData copyWithCompanion(
      RecurringPaymentHistoryCompanion data) {
    return RecurringPaymentHistoryData(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      recurringPaymentId: data.recurringPaymentId.present
          ? data.recurringPaymentId.value
          : this.recurringPaymentId,
      occurrenceId: data.occurrenceId.present
          ? data.occurrenceId.value
          : this.occurrenceId,
      amountMinor:
          data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringPaymentHistoryData(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('recurringPaymentId: $recurringPaymentId, ')
          ..write('occurrenceId: $occurrenceId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('paidAt: $paidAt, ')
          ..write('transactionId: $transactionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, recurringPaymentId,
      occurrenceId, amountMinor, paidAt, transactionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringPaymentHistoryData &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.recurringPaymentId == this.recurringPaymentId &&
          other.occurrenceId == this.occurrenceId &&
          other.amountMinor == this.amountMinor &&
          other.paidAt == this.paidAt &&
          other.transactionId == this.transactionId);
}

class RecurringPaymentHistoryCompanion
    extends UpdateCompanion<RecurringPaymentHistoryData> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> recurringPaymentId;
  final Value<String> occurrenceId;
  final Value<int> amountMinor;
  final Value<DateTime> paidAt;
  final Value<String?> transactionId;
  final Value<int> rowid;
  const RecurringPaymentHistoryCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.recurringPaymentId = const Value.absent(),
    this.occurrenceId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringPaymentHistoryCompanion.insert({
    required String id,
    required String profileId,
    required String recurringPaymentId,
    required String occurrenceId,
    required int amountMinor,
    required DateTime paidAt,
    this.transactionId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        recurringPaymentId = Value(recurringPaymentId),
        occurrenceId = Value(occurrenceId),
        amountMinor = Value(amountMinor),
        paidAt = Value(paidAt);
  static Insertable<RecurringPaymentHistoryData> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? recurringPaymentId,
    Expression<String>? occurrenceId,
    Expression<int>? amountMinor,
    Expression<DateTime>? paidAt,
    Expression<String>? transactionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (recurringPaymentId != null)
        'recurring_payment_id': recurringPaymentId,
      if (occurrenceId != null) 'occurrence_id': occurrenceId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (paidAt != null) 'paid_at': paidAt,
      if (transactionId != null) 'transaction_id': transactionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringPaymentHistoryCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? recurringPaymentId,
      Value<String>? occurrenceId,
      Value<int>? amountMinor,
      Value<DateTime>? paidAt,
      Value<String?>? transactionId,
      Value<int>? rowid}) {
    return RecurringPaymentHistoryCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      recurringPaymentId: recurringPaymentId ?? this.recurringPaymentId,
      occurrenceId: occurrenceId ?? this.occurrenceId,
      amountMinor: amountMinor ?? this.amountMinor,
      paidAt: paidAt ?? this.paidAt,
      transactionId: transactionId ?? this.transactionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (recurringPaymentId.present) {
      map['recurring_payment_id'] = Variable<String>(recurringPaymentId.value);
    }
    if (occurrenceId.present) {
      map['occurrence_id'] = Variable<String>(occurrenceId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringPaymentHistoryCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('recurringPaymentId: $recurringPaymentId, ')
          ..write('occurrenceId: $occurrenceId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('paidAt: $paidAt, ')
          ..write('transactionId: $transactionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionPriceHistoryTable extends SubscriptionPriceHistory
    with
        TableInfo<$SubscriptionPriceHistoryTable,
            SubscriptionPriceHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionPriceHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recurringPaymentIdMeta =
      const VerificationMeta('recurringPaymentId');
  @override
  late final GeneratedColumn<String> recurringPaymentId =
      GeneratedColumn<String>('recurring_payment_id', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _oldAmountMinorMeta =
      const VerificationMeta('oldAmountMinor');
  @override
  late final GeneratedColumn<int> oldAmountMinor = GeneratedColumn<int>(
      'old_amount_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _newAmountMinorMeta =
      const VerificationMeta('newAmountMinor');
  @override
  late final GeneratedColumn<int> newAmountMinor = GeneratedColumn<int>(
      'new_amount_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _changedAtMeta =
      const VerificationMeta('changedAt');
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
      'changed_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        recurringPaymentId,
        oldAmountMinor,
        newAmountMinor,
        changedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscription_price_history';
  @override
  VerificationContext validateIntegrity(
      Insertable<SubscriptionPriceHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('recurring_payment_id')) {
      context.handle(
          _recurringPaymentIdMeta,
          recurringPaymentId.isAcceptableOrUnknown(
              data['recurring_payment_id']!, _recurringPaymentIdMeta));
    } else if (isInserting) {
      context.missing(_recurringPaymentIdMeta);
    }
    if (data.containsKey('old_amount_minor')) {
      context.handle(
          _oldAmountMinorMeta,
          oldAmountMinor.isAcceptableOrUnknown(
              data['old_amount_minor']!, _oldAmountMinorMeta));
    } else if (isInserting) {
      context.missing(_oldAmountMinorMeta);
    }
    if (data.containsKey('new_amount_minor')) {
      context.handle(
          _newAmountMinorMeta,
          newAmountMinor.isAcceptableOrUnknown(
              data['new_amount_minor']!, _newAmountMinorMeta));
    } else if (isInserting) {
      context.missing(_newAmountMinorMeta);
    }
    if (data.containsKey('changed_at')) {
      context.handle(_changedAtMeta,
          changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubscriptionPriceHistoryData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionPriceHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      recurringPaymentId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recurring_payment_id'])!,
      oldAmountMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}old_amount_minor'])!,
      newAmountMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}new_amount_minor'])!,
      changedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}changed_at'])!,
    );
  }

  @override
  $SubscriptionPriceHistoryTable createAlias(String alias) {
    return $SubscriptionPriceHistoryTable(attachedDatabase, alias);
  }
}

class SubscriptionPriceHistoryData extends DataClass
    implements Insertable<SubscriptionPriceHistoryData> {
  final String id;
  final String profileId;
  final String recurringPaymentId;
  final int oldAmountMinor;
  final int newAmountMinor;
  final DateTime changedAt;
  const SubscriptionPriceHistoryData(
      {required this.id,
      required this.profileId,
      required this.recurringPaymentId,
      required this.oldAmountMinor,
      required this.newAmountMinor,
      required this.changedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['recurring_payment_id'] = Variable<String>(recurringPaymentId);
    map['old_amount_minor'] = Variable<int>(oldAmountMinor);
    map['new_amount_minor'] = Variable<int>(newAmountMinor);
    map['changed_at'] = Variable<DateTime>(changedAt);
    return map;
  }

  SubscriptionPriceHistoryCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionPriceHistoryCompanion(
      id: Value(id),
      profileId: Value(profileId),
      recurringPaymentId: Value(recurringPaymentId),
      oldAmountMinor: Value(oldAmountMinor),
      newAmountMinor: Value(newAmountMinor),
      changedAt: Value(changedAt),
    );
  }

  factory SubscriptionPriceHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionPriceHistoryData(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      recurringPaymentId:
          serializer.fromJson<String>(json['recurringPaymentId']),
      oldAmountMinor: serializer.fromJson<int>(json['oldAmountMinor']),
      newAmountMinor: serializer.fromJson<int>(json['newAmountMinor']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'recurringPaymentId': serializer.toJson<String>(recurringPaymentId),
      'oldAmountMinor': serializer.toJson<int>(oldAmountMinor),
      'newAmountMinor': serializer.toJson<int>(newAmountMinor),
      'changedAt': serializer.toJson<DateTime>(changedAt),
    };
  }

  SubscriptionPriceHistoryData copyWith(
          {String? id,
          String? profileId,
          String? recurringPaymentId,
          int? oldAmountMinor,
          int? newAmountMinor,
          DateTime? changedAt}) =>
      SubscriptionPriceHistoryData(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        recurringPaymentId: recurringPaymentId ?? this.recurringPaymentId,
        oldAmountMinor: oldAmountMinor ?? this.oldAmountMinor,
        newAmountMinor: newAmountMinor ?? this.newAmountMinor,
        changedAt: changedAt ?? this.changedAt,
      );
  SubscriptionPriceHistoryData copyWithCompanion(
      SubscriptionPriceHistoryCompanion data) {
    return SubscriptionPriceHistoryData(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      recurringPaymentId: data.recurringPaymentId.present
          ? data.recurringPaymentId.value
          : this.recurringPaymentId,
      oldAmountMinor: data.oldAmountMinor.present
          ? data.oldAmountMinor.value
          : this.oldAmountMinor,
      newAmountMinor: data.newAmountMinor.present
          ? data.newAmountMinor.value
          : this.newAmountMinor,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionPriceHistoryData(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('recurringPaymentId: $recurringPaymentId, ')
          ..write('oldAmountMinor: $oldAmountMinor, ')
          ..write('newAmountMinor: $newAmountMinor, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, recurringPaymentId,
      oldAmountMinor, newAmountMinor, changedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionPriceHistoryData &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.recurringPaymentId == this.recurringPaymentId &&
          other.oldAmountMinor == this.oldAmountMinor &&
          other.newAmountMinor == this.newAmountMinor &&
          other.changedAt == this.changedAt);
}

class SubscriptionPriceHistoryCompanion
    extends UpdateCompanion<SubscriptionPriceHistoryData> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> recurringPaymentId;
  final Value<int> oldAmountMinor;
  final Value<int> newAmountMinor;
  final Value<DateTime> changedAt;
  final Value<int> rowid;
  const SubscriptionPriceHistoryCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.recurringPaymentId = const Value.absent(),
    this.oldAmountMinor = const Value.absent(),
    this.newAmountMinor = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionPriceHistoryCompanion.insert({
    required String id,
    required String profileId,
    required String recurringPaymentId,
    required int oldAmountMinor,
    required int newAmountMinor,
    this.changedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        recurringPaymentId = Value(recurringPaymentId),
        oldAmountMinor = Value(oldAmountMinor),
        newAmountMinor = Value(newAmountMinor);
  static Insertable<SubscriptionPriceHistoryData> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? recurringPaymentId,
    Expression<int>? oldAmountMinor,
    Expression<int>? newAmountMinor,
    Expression<DateTime>? changedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (recurringPaymentId != null)
        'recurring_payment_id': recurringPaymentId,
      if (oldAmountMinor != null) 'old_amount_minor': oldAmountMinor,
      if (newAmountMinor != null) 'new_amount_minor': newAmountMinor,
      if (changedAt != null) 'changed_at': changedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionPriceHistoryCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? recurringPaymentId,
      Value<int>? oldAmountMinor,
      Value<int>? newAmountMinor,
      Value<DateTime>? changedAt,
      Value<int>? rowid}) {
    return SubscriptionPriceHistoryCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      recurringPaymentId: recurringPaymentId ?? this.recurringPaymentId,
      oldAmountMinor: oldAmountMinor ?? this.oldAmountMinor,
      newAmountMinor: newAmountMinor ?? this.newAmountMinor,
      changedAt: changedAt ?? this.changedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (recurringPaymentId.present) {
      map['recurring_payment_id'] = Variable<String>(recurringPaymentId.value);
    }
    if (oldAmountMinor.present) {
      map['old_amount_minor'] = Variable<int>(oldAmountMinor.value);
    }
    if (newAmountMinor.present) {
      map['new_amount_minor'] = Variable<int>(newAmountMinor.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionPriceHistoryCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('recurringPaymentId: $recurringPaymentId, ')
          ..write('oldAmountMinor: $oldAmountMinor, ')
          ..write('newAmountMinor: $newAmountMinor, ')
          ..write('changedAt: $changedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BnplPaymentHistoryTable extends BnplPaymentHistory
    with TableInfo<$BnplPaymentHistoryTable, BnplPaymentHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BnplPaymentHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
      'plan_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _instalmentIdMeta =
      const VerificationMeta('instalmentId');
  @override
  late final GeneratedColumn<String> instalmentId = GeneratedColumn<String>(
      'instalment_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMinorMeta =
      const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
      'amount_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, profileId, planId, instalmentId, amountMinor, action, occurredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bnpl_payment_history';
  @override
  VerificationContext validateIntegrity(
      Insertable<BnplPaymentHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta,
          planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('instalment_id')) {
      context.handle(
          _instalmentIdMeta,
          instalmentId.isAcceptableOrUnknown(
              data['instalment_id']!, _instalmentIdMeta));
    } else if (isInserting) {
      context.missing(_instalmentIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
          _amountMinorMeta,
          amountMinor.isAcceptableOrUnknown(
              data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BnplPaymentHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BnplPaymentHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      planId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan_id'])!,
      instalmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instalment_id'])!,
      amountMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_minor'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
    );
  }

  @override
  $BnplPaymentHistoryTable createAlias(String alias) {
    return $BnplPaymentHistoryTable(attachedDatabase, alias);
  }
}

class BnplPaymentHistoryData extends DataClass
    implements Insertable<BnplPaymentHistoryData> {
  final String id;
  final String profileId;
  final String planId;
  final String instalmentId;
  final int amountMinor;
  final String action;
  final DateTime occurredAt;
  const BnplPaymentHistoryData(
      {required this.id,
      required this.profileId,
      required this.planId,
      required this.instalmentId,
      required this.amountMinor,
      required this.action,
      required this.occurredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['plan_id'] = Variable<String>(planId);
    map['instalment_id'] = Variable<String>(instalmentId);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['action'] = Variable<String>(action);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  BnplPaymentHistoryCompanion toCompanion(bool nullToAbsent) {
    return BnplPaymentHistoryCompanion(
      id: Value(id),
      profileId: Value(profileId),
      planId: Value(planId),
      instalmentId: Value(instalmentId),
      amountMinor: Value(amountMinor),
      action: Value(action),
      occurredAt: Value(occurredAt),
    );
  }

  factory BnplPaymentHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BnplPaymentHistoryData(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      planId: serializer.fromJson<String>(json['planId']),
      instalmentId: serializer.fromJson<String>(json['instalmentId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      action: serializer.fromJson<String>(json['action']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'planId': serializer.toJson<String>(planId),
      'instalmentId': serializer.toJson<String>(instalmentId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'action': serializer.toJson<String>(action),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  BnplPaymentHistoryData copyWith(
          {String? id,
          String? profileId,
          String? planId,
          String? instalmentId,
          int? amountMinor,
          String? action,
          DateTime? occurredAt}) =>
      BnplPaymentHistoryData(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        planId: planId ?? this.planId,
        instalmentId: instalmentId ?? this.instalmentId,
        amountMinor: amountMinor ?? this.amountMinor,
        action: action ?? this.action,
        occurredAt: occurredAt ?? this.occurredAt,
      );
  BnplPaymentHistoryData copyWithCompanion(BnplPaymentHistoryCompanion data) {
    return BnplPaymentHistoryData(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      planId: data.planId.present ? data.planId.value : this.planId,
      instalmentId: data.instalmentId.present
          ? data.instalmentId.value
          : this.instalmentId,
      amountMinor:
          data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      action: data.action.present ? data.action.value : this.action,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BnplPaymentHistoryData(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('planId: $planId, ')
          ..write('instalmentId: $instalmentId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('action: $action, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, profileId, planId, instalmentId, amountMinor, action, occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BnplPaymentHistoryData &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.planId == this.planId &&
          other.instalmentId == this.instalmentId &&
          other.amountMinor == this.amountMinor &&
          other.action == this.action &&
          other.occurredAt == this.occurredAt);
}

class BnplPaymentHistoryCompanion
    extends UpdateCompanion<BnplPaymentHistoryData> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> planId;
  final Value<String> instalmentId;
  final Value<int> amountMinor;
  final Value<String> action;
  final Value<DateTime> occurredAt;
  final Value<int> rowid;
  const BnplPaymentHistoryCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.planId = const Value.absent(),
    this.instalmentId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.action = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BnplPaymentHistoryCompanion.insert({
    required String id,
    required String profileId,
    required String planId,
    required String instalmentId,
    required int amountMinor,
    required String action,
    this.occurredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        planId = Value(planId),
        instalmentId = Value(instalmentId),
        amountMinor = Value(amountMinor),
        action = Value(action);
  static Insertable<BnplPaymentHistoryData> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? planId,
    Expression<String>? instalmentId,
    Expression<int>? amountMinor,
    Expression<String>? action,
    Expression<DateTime>? occurredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (planId != null) 'plan_id': planId,
      if (instalmentId != null) 'instalment_id': instalmentId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (action != null) 'action': action,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BnplPaymentHistoryCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? planId,
      Value<String>? instalmentId,
      Value<int>? amountMinor,
      Value<String>? action,
      Value<DateTime>? occurredAt,
      Value<int>? rowid}) {
    return BnplPaymentHistoryCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      planId: planId ?? this.planId,
      instalmentId: instalmentId ?? this.instalmentId,
      amountMinor: amountMinor ?? this.amountMinor,
      action: action ?? this.action,
      occurredAt: occurredAt ?? this.occurredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (instalmentId.present) {
      map['instalment_id'] = Variable<String>(instalmentId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BnplPaymentHistoryCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('planId: $planId, ')
          ..write('instalmentId: $instalmentId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('action: $action, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationSchedulesTable extends NotificationSchedules
    with TableInfo<$NotificationSchedulesTable, NotificationSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordTypeMeta =
      const VerificationMeta('recordType');
  @override
  late final GeneratedColumn<String> recordType = GeneratedColumn<String>(
      'record_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
      'record_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notificationTypeMeta =
      const VerificationMeta('notificationType');
  @override
  late final GeneratedColumn<String> notificationType = GeneratedColumn<String>(
      'notification_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduledAtMeta =
      const VerificationMeta('scheduledAt');
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
      'scheduled_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
      'locale', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('en'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('scheduled'));
  static const VerificationMeta _deliveredAtMeta =
      const VerificationMeta('deliveredAt');
  @override
  late final GeneratedColumn<DateTime> deliveredAt = GeneratedColumn<DateTime>(
      'delivered_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        recordType,
        recordId,
        notificationType,
        scheduledAt,
        locale,
        status,
        deliveredAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_schedules';
  @override
  VerificationContext validateIntegrity(
      Insertable<NotificationSchedule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('record_type')) {
      context.handle(
          _recordTypeMeta,
          recordType.isAcceptableOrUnknown(
              data['record_type']!, _recordTypeMeta));
    } else if (isInserting) {
      context.missing(_recordTypeMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('notification_type')) {
      context.handle(
          _notificationTypeMeta,
          notificationType.isAcceptableOrUnknown(
              data['notification_type']!, _notificationTypeMeta));
    } else if (isInserting) {
      context.missing(_notificationTypeMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
          _scheduledAtMeta,
          scheduledAt.isAcceptableOrUnknown(
              data['scheduled_at']!, _scheduledAtMeta));
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(_localeMeta,
          locale.isAcceptableOrUnknown(data['locale']!, _localeMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('delivered_at')) {
      context.handle(
          _deliveredAtMeta,
          deliveredAt.isAcceptableOrUnknown(
              data['delivered_at']!, _deliveredAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {recordType, recordId, notificationType, scheduledAt},
      ];
  @override
  NotificationSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationSchedule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      recordType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_type'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      notificationType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_type'])!,
      scheduledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scheduled_at'])!,
      locale: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}locale'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      deliveredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}delivered_at']),
    );
  }

  @override
  $NotificationSchedulesTable createAlias(String alias) {
    return $NotificationSchedulesTable(attachedDatabase, alias);
  }
}

class NotificationSchedule extends DataClass
    implements Insertable<NotificationSchedule> {
  final String id;
  final String profileId;
  final String recordType;
  final String recordId;
  final String notificationType;
  final DateTime scheduledAt;
  final String locale;
  final String status;
  final DateTime? deliveredAt;
  const NotificationSchedule(
      {required this.id,
      required this.profileId,
      required this.recordType,
      required this.recordId,
      required this.notificationType,
      required this.scheduledAt,
      required this.locale,
      required this.status,
      this.deliveredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['record_type'] = Variable<String>(recordType);
    map['record_id'] = Variable<String>(recordId);
    map['notification_type'] = Variable<String>(notificationType);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['locale'] = Variable<String>(locale);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || deliveredAt != null) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt);
    }
    return map;
  }

  NotificationSchedulesCompanion toCompanion(bool nullToAbsent) {
    return NotificationSchedulesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      recordType: Value(recordType),
      recordId: Value(recordId),
      notificationType: Value(notificationType),
      scheduledAt: Value(scheduledAt),
      locale: Value(locale),
      status: Value(status),
      deliveredAt: deliveredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveredAt),
    );
  }

  factory NotificationSchedule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationSchedule(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      recordType: serializer.fromJson<String>(json['recordType']),
      recordId: serializer.fromJson<String>(json['recordId']),
      notificationType: serializer.fromJson<String>(json['notificationType']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      locale: serializer.fromJson<String>(json['locale']),
      status: serializer.fromJson<String>(json['status']),
      deliveredAt: serializer.fromJson<DateTime?>(json['deliveredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'recordType': serializer.toJson<String>(recordType),
      'recordId': serializer.toJson<String>(recordId),
      'notificationType': serializer.toJson<String>(notificationType),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'locale': serializer.toJson<String>(locale),
      'status': serializer.toJson<String>(status),
      'deliveredAt': serializer.toJson<DateTime?>(deliveredAt),
    };
  }

  NotificationSchedule copyWith(
          {String? id,
          String? profileId,
          String? recordType,
          String? recordId,
          String? notificationType,
          DateTime? scheduledAt,
          String? locale,
          String? status,
          Value<DateTime?> deliveredAt = const Value.absent()}) =>
      NotificationSchedule(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        recordType: recordType ?? this.recordType,
        recordId: recordId ?? this.recordId,
        notificationType: notificationType ?? this.notificationType,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        locale: locale ?? this.locale,
        status: status ?? this.status,
        deliveredAt: deliveredAt.present ? deliveredAt.value : this.deliveredAt,
      );
  NotificationSchedule copyWithCompanion(NotificationSchedulesCompanion data) {
    return NotificationSchedule(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      recordType:
          data.recordType.present ? data.recordType.value : this.recordType,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      notificationType: data.notificationType.present
          ? data.notificationType.value
          : this.notificationType,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      locale: data.locale.present ? data.locale.value : this.locale,
      status: data.status.present ? data.status.value : this.status,
      deliveredAt:
          data.deliveredAt.present ? data.deliveredAt.value : this.deliveredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationSchedule(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('recordType: $recordType, ')
          ..write('recordId: $recordId, ')
          ..write('notificationType: $notificationType, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('locale: $locale, ')
          ..write('status: $status, ')
          ..write('deliveredAt: $deliveredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, recordType, recordId,
      notificationType, scheduledAt, locale, status, deliveredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationSchedule &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.recordType == this.recordType &&
          other.recordId == this.recordId &&
          other.notificationType == this.notificationType &&
          other.scheduledAt == this.scheduledAt &&
          other.locale == this.locale &&
          other.status == this.status &&
          other.deliveredAt == this.deliveredAt);
}

class NotificationSchedulesCompanion
    extends UpdateCompanion<NotificationSchedule> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> recordType;
  final Value<String> recordId;
  final Value<String> notificationType;
  final Value<DateTime> scheduledAt;
  final Value<String> locale;
  final Value<String> status;
  final Value<DateTime?> deliveredAt;
  final Value<int> rowid;
  const NotificationSchedulesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.recordType = const Value.absent(),
    this.recordId = const Value.absent(),
    this.notificationType = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.locale = const Value.absent(),
    this.status = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationSchedulesCompanion.insert({
    required String id,
    required String profileId,
    required String recordType,
    required String recordId,
    required String notificationType,
    required DateTime scheduledAt,
    this.locale = const Value.absent(),
    this.status = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        recordType = Value(recordType),
        recordId = Value(recordId),
        notificationType = Value(notificationType),
        scheduledAt = Value(scheduledAt);
  static Insertable<NotificationSchedule> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? recordType,
    Expression<String>? recordId,
    Expression<String>? notificationType,
    Expression<DateTime>? scheduledAt,
    Expression<String>? locale,
    Expression<String>? status,
    Expression<DateTime>? deliveredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (recordType != null) 'record_type': recordType,
      if (recordId != null) 'record_id': recordId,
      if (notificationType != null) 'notification_type': notificationType,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (locale != null) 'locale': locale,
      if (status != null) 'status': status,
      if (deliveredAt != null) 'delivered_at': deliveredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationSchedulesCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? recordType,
      Value<String>? recordId,
      Value<String>? notificationType,
      Value<DateTime>? scheduledAt,
      Value<String>? locale,
      Value<String>? status,
      Value<DateTime?>? deliveredAt,
      Value<int>? rowid}) {
    return NotificationSchedulesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      recordType: recordType ?? this.recordType,
      recordId: recordId ?? this.recordId,
      notificationType: notificationType ?? this.notificationType,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      locale: locale ?? this.locale,
      status: status ?? this.status,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (recordType.present) {
      map['record_type'] = Variable<String>(recordType.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (notificationType.present) {
      map['notification_type'] = Variable<String>(notificationType.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (deliveredAt.present) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('recordType: $recordType, ')
          ..write('recordId: $recordId, ')
          ..write('notificationType: $notificationType, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('locale: $locale, ')
          ..write('status: $status, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExchangeRatesTable extends ExchangeRates
    with TableInfo<$ExchangeRatesTable, ExchangeRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseCurrencyMeta =
      const VerificationMeta('baseCurrency');
  @override
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
      'base_currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quoteCurrencyMeta =
      const VerificationMeta('quoteCurrency');
  @override
  late final GeneratedColumn<String> quoteCurrency = GeneratedColumn<String>(
      'quote_currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rateMicrosMeta =
      const VerificationMeta('rateMicros');
  @override
  late final GeneratedColumn<int> rateMicros = GeneratedColumn<int>(
      'rate_micros', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _rateDateMeta =
      const VerificationMeta('rateDate');
  @override
  late final GeneratedColumn<DateTime> rateDate = GeneratedColumn<DateTime>(
      'rate_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('manual'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        baseCurrency,
        quoteCurrency,
        rateMicros,
        rateDate,
        source,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rates';
  @override
  VerificationContext validateIntegrity(Insertable<ExchangeRate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('base_currency')) {
      context.handle(
          _baseCurrencyMeta,
          baseCurrency.isAcceptableOrUnknown(
              data['base_currency']!, _baseCurrencyMeta));
    } else if (isInserting) {
      context.missing(_baseCurrencyMeta);
    }
    if (data.containsKey('quote_currency')) {
      context.handle(
          _quoteCurrencyMeta,
          quoteCurrency.isAcceptableOrUnknown(
              data['quote_currency']!, _quoteCurrencyMeta));
    } else if (isInserting) {
      context.missing(_quoteCurrencyMeta);
    }
    if (data.containsKey('rate_micros')) {
      context.handle(
          _rateMicrosMeta,
          rateMicros.isAcceptableOrUnknown(
              data['rate_micros']!, _rateMicrosMeta));
    } else if (isInserting) {
      context.missing(_rateMicrosMeta);
    }
    if (data.containsKey('rate_date')) {
      context.handle(_rateDateMeta,
          rateDate.isAcceptableOrUnknown(data['rate_date']!, _rateDateMeta));
    } else if (isInserting) {
      context.missing(_rateDateMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {profileId, baseCurrency, quoteCurrency, rateDate},
      ];
  @override
  ExchangeRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      baseCurrency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_currency'])!,
      quoteCurrency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quote_currency'])!,
      rateMicros: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rate_micros'])!,
      rateDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}rate_date'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExchangeRatesTable createAlias(String alias) {
    return $ExchangeRatesTable(attachedDatabase, alias);
  }
}

class ExchangeRate extends DataClass implements Insertable<ExchangeRate> {
  final String id;
  final String profileId;
  final String baseCurrency;
  final String quoteCurrency;
  final int rateMicros;
  final DateTime rateDate;
  final String source;
  final DateTime createdAt;
  const ExchangeRate(
      {required this.id,
      required this.profileId,
      required this.baseCurrency,
      required this.quoteCurrency,
      required this.rateMicros,
      required this.rateDate,
      required this.source,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['base_currency'] = Variable<String>(baseCurrency);
    map['quote_currency'] = Variable<String>(quoteCurrency);
    map['rate_micros'] = Variable<int>(rateMicros);
    map['rate_date'] = Variable<DateTime>(rateDate);
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExchangeRatesCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRatesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      baseCurrency: Value(baseCurrency),
      quoteCurrency: Value(quoteCurrency),
      rateMicros: Value(rateMicros),
      rateDate: Value(rateDate),
      source: Value(source),
      createdAt: Value(createdAt),
    );
  }

  factory ExchangeRate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRate(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      baseCurrency: serializer.fromJson<String>(json['baseCurrency']),
      quoteCurrency: serializer.fromJson<String>(json['quoteCurrency']),
      rateMicros: serializer.fromJson<int>(json['rateMicros']),
      rateDate: serializer.fromJson<DateTime>(json['rateDate']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'baseCurrency': serializer.toJson<String>(baseCurrency),
      'quoteCurrency': serializer.toJson<String>(quoteCurrency),
      'rateMicros': serializer.toJson<int>(rateMicros),
      'rateDate': serializer.toJson<DateTime>(rateDate),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExchangeRate copyWith(
          {String? id,
          String? profileId,
          String? baseCurrency,
          String? quoteCurrency,
          int? rateMicros,
          DateTime? rateDate,
          String? source,
          DateTime? createdAt}) =>
      ExchangeRate(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        baseCurrency: baseCurrency ?? this.baseCurrency,
        quoteCurrency: quoteCurrency ?? this.quoteCurrency,
        rateMicros: rateMicros ?? this.rateMicros,
        rateDate: rateDate ?? this.rateDate,
        source: source ?? this.source,
        createdAt: createdAt ?? this.createdAt,
      );
  ExchangeRate copyWithCompanion(ExchangeRatesCompanion data) {
    return ExchangeRate(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      baseCurrency: data.baseCurrency.present
          ? data.baseCurrency.value
          : this.baseCurrency,
      quoteCurrency: data.quoteCurrency.present
          ? data.quoteCurrency.value
          : this.quoteCurrency,
      rateMicros:
          data.rateMicros.present ? data.rateMicros.value : this.rateMicros,
      rateDate: data.rateDate.present ? data.rateDate.value : this.rateDate,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRate(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('quoteCurrency: $quoteCurrency, ')
          ..write('rateMicros: $rateMicros, ')
          ..write('rateDate: $rateDate, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, baseCurrency, quoteCurrency,
      rateMicros, rateDate, source, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRate &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.baseCurrency == this.baseCurrency &&
          other.quoteCurrency == this.quoteCurrency &&
          other.rateMicros == this.rateMicros &&
          other.rateDate == this.rateDate &&
          other.source == this.source &&
          other.createdAt == this.createdAt);
}

class ExchangeRatesCompanion extends UpdateCompanion<ExchangeRate> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> baseCurrency;
  final Value<String> quoteCurrency;
  final Value<int> rateMicros;
  final Value<DateTime> rateDate;
  final Value<String> source;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExchangeRatesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.quoteCurrency = const Value.absent(),
    this.rateMicros = const Value.absent(),
    this.rateDate = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExchangeRatesCompanion.insert({
    required String id,
    required String profileId,
    required String baseCurrency,
    required String quoteCurrency,
    required int rateMicros,
    required DateTime rateDate,
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        profileId = Value(profileId),
        baseCurrency = Value(baseCurrency),
        quoteCurrency = Value(quoteCurrency),
        rateMicros = Value(rateMicros),
        rateDate = Value(rateDate);
  static Insertable<ExchangeRate> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? baseCurrency,
    Expression<String>? quoteCurrency,
    Expression<int>? rateMicros,
    Expression<DateTime>? rateDate,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (quoteCurrency != null) 'quote_currency': quoteCurrency,
      if (rateMicros != null) 'rate_micros': rateMicros,
      if (rateDate != null) 'rate_date': rateDate,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExchangeRatesCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? baseCurrency,
      Value<String>? quoteCurrency,
      Value<int>? rateMicros,
      Value<DateTime>? rateDate,
      Value<String>? source,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ExchangeRatesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      quoteCurrency: quoteCurrency ?? this.quoteCurrency,
      rateMicros: rateMicros ?? this.rateMicros,
      rateDate: rateDate ?? this.rateDate,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (quoteCurrency.present) {
      map['quote_currency'] = Variable<String>(quoteCurrency.value);
    }
    if (rateMicros.present) {
      map['rate_micros'] = Variable<int>(rateMicros.value);
    }
    if (rateDate.present) {
      map['rate_date'] = Variable<DateTime>(rateDate.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('quoteCurrency: $quoteCurrency, ')
          ..write('rateMicros: $rateMicros, ')
          ..write('rateDate: $rateDate, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SecurityPreferencesTable extends SecurityPreferences
    with TableInfo<$SecurityPreferencesTable, SecurityPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SecurityPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pinSaltMeta =
      const VerificationMeta('pinSalt');
  @override
  late final GeneratedColumn<String> pinSalt = GeneratedColumn<String>(
      'pin_salt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _biometricEnabledMeta =
      const VerificationMeta('biometricEnabled');
  @override
  late final GeneratedColumn<bool> biometricEnabled = GeneratedColumn<bool>(
      'biometric_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("biometric_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _autoLockSecondsMeta =
      const VerificationMeta('autoLockSeconds');
  @override
  late final GeneratedColumn<int> autoLockSeconds = GeneratedColumn<int>(
      'auto_lock_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lockOnBackgroundMeta =
      const VerificationMeta('lockOnBackground');
  @override
  late final GeneratedColumn<bool> lockOnBackground = GeneratedColumn<bool>(
      'lock_on_background', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("lock_on_background" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        profileId,
        pinHash,
        pinSalt,
        biometricEnabled,
        autoLockSeconds,
        lockOnBackground,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'security_preferences';
  @override
  VerificationContext validateIntegrity(Insertable<SecurityPreference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    }
    if (data.containsKey('pin_salt')) {
      context.handle(_pinSaltMeta,
          pinSalt.isAcceptableOrUnknown(data['pin_salt']!, _pinSaltMeta));
    }
    if (data.containsKey('biometric_enabled')) {
      context.handle(
          _biometricEnabledMeta,
          biometricEnabled.isAcceptableOrUnknown(
              data['biometric_enabled']!, _biometricEnabledMeta));
    }
    if (data.containsKey('auto_lock_seconds')) {
      context.handle(
          _autoLockSecondsMeta,
          autoLockSeconds.isAcceptableOrUnknown(
              data['auto_lock_seconds']!, _autoLockSecondsMeta));
    }
    if (data.containsKey('lock_on_background')) {
      context.handle(
          _lockOnBackgroundMeta,
          lockOnBackground.isAcceptableOrUnknown(
              data['lock_on_background']!, _lockOnBackgroundMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId};
  @override
  SecurityPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SecurityPreference(
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash']),
      pinSalt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_salt']),
      biometricEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}biometric_enabled'])!,
      autoLockSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}auto_lock_seconds'])!,
      lockOnBackground: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}lock_on_background'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SecurityPreferencesTable createAlias(String alias) {
    return $SecurityPreferencesTable(attachedDatabase, alias);
  }
}

class SecurityPreference extends DataClass
    implements Insertable<SecurityPreference> {
  final String profileId;
  final String? pinHash;
  final String? pinSalt;
  final bool biometricEnabled;
  final int autoLockSeconds;
  final bool lockOnBackground;
  final DateTime updatedAt;
  const SecurityPreference(
      {required this.profileId,
      this.pinHash,
      this.pinSalt,
      required this.biometricEnabled,
      required this.autoLockSeconds,
      required this.lockOnBackground,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    if (!nullToAbsent || pinSalt != null) {
      map['pin_salt'] = Variable<String>(pinSalt);
    }
    map['biometric_enabled'] = Variable<bool>(biometricEnabled);
    map['auto_lock_seconds'] = Variable<int>(autoLockSeconds);
    map['lock_on_background'] = Variable<bool>(lockOnBackground);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SecurityPreferencesCompanion toCompanion(bool nullToAbsent) {
    return SecurityPreferencesCompanion(
      profileId: Value(profileId),
      pinHash: pinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinHash),
      pinSalt: pinSalt == null && nullToAbsent
          ? const Value.absent()
          : Value(pinSalt),
      biometricEnabled: Value(biometricEnabled),
      autoLockSeconds: Value(autoLockSeconds),
      lockOnBackground: Value(lockOnBackground),
      updatedAt: Value(updatedAt),
    );
  }

  factory SecurityPreference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SecurityPreference(
      profileId: serializer.fromJson<String>(json['profileId']),
      pinHash: serializer.fromJson<String?>(json['pinHash']),
      pinSalt: serializer.fromJson<String?>(json['pinSalt']),
      biometricEnabled: serializer.fromJson<bool>(json['biometricEnabled']),
      autoLockSeconds: serializer.fromJson<int>(json['autoLockSeconds']),
      lockOnBackground: serializer.fromJson<bool>(json['lockOnBackground']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'pinHash': serializer.toJson<String?>(pinHash),
      'pinSalt': serializer.toJson<String?>(pinSalt),
      'biometricEnabled': serializer.toJson<bool>(biometricEnabled),
      'autoLockSeconds': serializer.toJson<int>(autoLockSeconds),
      'lockOnBackground': serializer.toJson<bool>(lockOnBackground),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SecurityPreference copyWith(
          {String? profileId,
          Value<String?> pinHash = const Value.absent(),
          Value<String?> pinSalt = const Value.absent(),
          bool? biometricEnabled,
          int? autoLockSeconds,
          bool? lockOnBackground,
          DateTime? updatedAt}) =>
      SecurityPreference(
        profileId: profileId ?? this.profileId,
        pinHash: pinHash.present ? pinHash.value : this.pinHash,
        pinSalt: pinSalt.present ? pinSalt.value : this.pinSalt,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        autoLockSeconds: autoLockSeconds ?? this.autoLockSeconds,
        lockOnBackground: lockOnBackground ?? this.lockOnBackground,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SecurityPreference copyWithCompanion(SecurityPreferencesCompanion data) {
    return SecurityPreference(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      pinSalt: data.pinSalt.present ? data.pinSalt.value : this.pinSalt,
      biometricEnabled: data.biometricEnabled.present
          ? data.biometricEnabled.value
          : this.biometricEnabled,
      autoLockSeconds: data.autoLockSeconds.present
          ? data.autoLockSeconds.value
          : this.autoLockSeconds,
      lockOnBackground: data.lockOnBackground.present
          ? data.lockOnBackground.value
          : this.lockOnBackground,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SecurityPreference(')
          ..write('profileId: $profileId, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('autoLockSeconds: $autoLockSeconds, ')
          ..write('lockOnBackground: $lockOnBackground, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, pinHash, pinSalt, biometricEnabled,
      autoLockSeconds, lockOnBackground, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SecurityPreference &&
          other.profileId == this.profileId &&
          other.pinHash == this.pinHash &&
          other.pinSalt == this.pinSalt &&
          other.biometricEnabled == this.biometricEnabled &&
          other.autoLockSeconds == this.autoLockSeconds &&
          other.lockOnBackground == this.lockOnBackground &&
          other.updatedAt == this.updatedAt);
}

class SecurityPreferencesCompanion extends UpdateCompanion<SecurityPreference> {
  final Value<String> profileId;
  final Value<String?> pinHash;
  final Value<String?> pinSalt;
  final Value<bool> biometricEnabled;
  final Value<int> autoLockSeconds;
  final Value<bool> lockOnBackground;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SecurityPreferencesCompanion({
    this.profileId = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.autoLockSeconds = const Value.absent(),
    this.lockOnBackground = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SecurityPreferencesCompanion.insert({
    required String profileId,
    this.pinHash = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.autoLockSeconds = const Value.absent(),
    this.lockOnBackground = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId);
  static Insertable<SecurityPreference> custom({
    Expression<String>? profileId,
    Expression<String>? pinHash,
    Expression<String>? pinSalt,
    Expression<bool>? biometricEnabled,
    Expression<int>? autoLockSeconds,
    Expression<bool>? lockOnBackground,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (pinHash != null) 'pin_hash': pinHash,
      if (pinSalt != null) 'pin_salt': pinSalt,
      if (biometricEnabled != null) 'biometric_enabled': biometricEnabled,
      if (autoLockSeconds != null) 'auto_lock_seconds': autoLockSeconds,
      if (lockOnBackground != null) 'lock_on_background': lockOnBackground,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SecurityPreferencesCompanion copyWith(
      {Value<String>? profileId,
      Value<String?>? pinHash,
      Value<String?>? pinSalt,
      Value<bool>? biometricEnabled,
      Value<int>? autoLockSeconds,
      Value<bool>? lockOnBackground,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SecurityPreferencesCompanion(
      profileId: profileId ?? this.profileId,
      pinHash: pinHash ?? this.pinHash,
      pinSalt: pinSalt ?? this.pinSalt,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autoLockSeconds: autoLockSeconds ?? this.autoLockSeconds,
      lockOnBackground: lockOnBackground ?? this.lockOnBackground,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (pinSalt.present) {
      map['pin_salt'] = Variable<String>(pinSalt.value);
    }
    if (biometricEnabled.present) {
      map['biometric_enabled'] = Variable<bool>(biometricEnabled.value);
    }
    if (autoLockSeconds.present) {
      map['auto_lock_seconds'] = Variable<int>(autoLockSeconds.value);
    }
    if (lockOnBackground.present) {
      map['lock_on_background'] = Variable<bool>(lockOnBackground.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SecurityPreferencesCompanion(')
          ..write('profileId: $profileId, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('autoLockSeconds: $autoLockSeconds, ')
          ..write('lockOnBackground: $lockOnBackground, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UiPreferencesTable extends UiPreferences
    with TableInfo<$UiPreferencesTable, UiPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UiPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _historySearchMeta =
      const VerificationMeta('historySearch');
  @override
  late final GeneratedColumn<String> historySearch = GeneratedColumn<String>(
      'history_search', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _historyTypeMeta =
      const VerificationMeta('historyType');
  @override
  late final GeneratedColumn<String> historyType = GeneratedColumn<String>(
      'history_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('all'));
  static const VerificationMeta _historyCategoryIdMeta =
      const VerificationMeta('historyCategoryId');
  @override
  late final GeneratedColumn<String> historyCategoryId =
      GeneratedColumn<String>('history_category_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _historyPaymentMethodIdMeta =
      const VerificationMeta('historyPaymentMethodId');
  @override
  late final GeneratedColumn<String> historyPaymentMethodId =
      GeneratedColumn<String>('history_payment_method_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _historyFromMeta =
      const VerificationMeta('historyFrom');
  @override
  late final GeneratedColumn<DateTime> historyFrom = GeneratedColumn<DateTime>(
      'history_from', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _historyToMeta =
      const VerificationMeta('historyTo');
  @override
  late final GeneratedColumn<DateTime> historyTo = GeneratedColumn<DateTime>(
      'history_to', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _historySortMeta =
      const VerificationMeta('historySort');
  @override
  late final GeneratedColumn<String> historySort = GeneratedColumn<String>(
      'history_sort', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('newest'));
  static const VerificationMeta _historyViewMeta =
      const VerificationMeta('historyView');
  @override
  late final GeneratedColumn<String> historyView = GeneratedColumn<String>(
      'history_view', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('list'));
  static const VerificationMeta _calendarMonthMeta =
      const VerificationMeta('calendarMonth');
  @override
  late final GeneratedColumn<DateTime> calendarMonth =
      GeneratedColumn<DateTime>('calendar_month', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _firstWeekdayMeta =
      const VerificationMeta('firstWeekday');
  @override
  late final GeneratedColumn<int> firstWeekday = GeneratedColumn<int>(
      'first_weekday', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _showHijriMeta =
      const VerificationMeta('showHijri');
  @override
  late final GeneratedColumn<bool> showHijri = GeneratedColumn<bool>(
      'show_hijri', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_hijri" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _categorySortMeta =
      const VerificationMeta('categorySort');
  @override
  late final GeneratedColumn<String> categorySort = GeneratedColumn<String>(
      'category_sort', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('most_used'));
  @override
  List<GeneratedColumn> get $columns => [
        profileId,
        historySearch,
        historyType,
        historyCategoryId,
        historyPaymentMethodId,
        historyFrom,
        historyTo,
        historySort,
        historyView,
        calendarMonth,
        firstWeekday,
        showHijri,
        categorySort
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ui_preferences';
  @override
  VerificationContext validateIntegrity(Insertable<UiPreference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('history_search')) {
      context.handle(
          _historySearchMeta,
          historySearch.isAcceptableOrUnknown(
              data['history_search']!, _historySearchMeta));
    }
    if (data.containsKey('history_type')) {
      context.handle(
          _historyTypeMeta,
          historyType.isAcceptableOrUnknown(
              data['history_type']!, _historyTypeMeta));
    }
    if (data.containsKey('history_category_id')) {
      context.handle(
          _historyCategoryIdMeta,
          historyCategoryId.isAcceptableOrUnknown(
              data['history_category_id']!, _historyCategoryIdMeta));
    }
    if (data.containsKey('history_payment_method_id')) {
      context.handle(
          _historyPaymentMethodIdMeta,
          historyPaymentMethodId.isAcceptableOrUnknown(
              data['history_payment_method_id']!, _historyPaymentMethodIdMeta));
    }
    if (data.containsKey('history_from')) {
      context.handle(
          _historyFromMeta,
          historyFrom.isAcceptableOrUnknown(
              data['history_from']!, _historyFromMeta));
    }
    if (data.containsKey('history_to')) {
      context.handle(_historyToMeta,
          historyTo.isAcceptableOrUnknown(data['history_to']!, _historyToMeta));
    }
    if (data.containsKey('history_sort')) {
      context.handle(
          _historySortMeta,
          historySort.isAcceptableOrUnknown(
              data['history_sort']!, _historySortMeta));
    }
    if (data.containsKey('history_view')) {
      context.handle(
          _historyViewMeta,
          historyView.isAcceptableOrUnknown(
              data['history_view']!, _historyViewMeta));
    }
    if (data.containsKey('calendar_month')) {
      context.handle(
          _calendarMonthMeta,
          calendarMonth.isAcceptableOrUnknown(
              data['calendar_month']!, _calendarMonthMeta));
    }
    if (data.containsKey('first_weekday')) {
      context.handle(
          _firstWeekdayMeta,
          firstWeekday.isAcceptableOrUnknown(
              data['first_weekday']!, _firstWeekdayMeta));
    }
    if (data.containsKey('show_hijri')) {
      context.handle(_showHijriMeta,
          showHijri.isAcceptableOrUnknown(data['show_hijri']!, _showHijriMeta));
    }
    if (data.containsKey('category_sort')) {
      context.handle(
          _categorySortMeta,
          categorySort.isAcceptableOrUnknown(
              data['category_sort']!, _categorySortMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId};
  @override
  UiPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UiPreference(
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      historySearch: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}history_search'])!,
      historyType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}history_type'])!,
      historyCategoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}history_category_id']),
      historyPaymentMethodId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}history_payment_method_id']),
      historyFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}history_from']),
      historyTo: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}history_to']),
      historySort: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}history_sort'])!,
      historyView: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}history_view'])!,
      calendarMonth: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}calendar_month']),
      firstWeekday: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}first_weekday'])!,
      showHijri: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_hijri'])!,
      categorySort: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_sort'])!,
    );
  }

  @override
  $UiPreferencesTable createAlias(String alias) {
    return $UiPreferencesTable(attachedDatabase, alias);
  }
}

class UiPreference extends DataClass implements Insertable<UiPreference> {
  final String profileId;
  final String historySearch;
  final String historyType;
  final String? historyCategoryId;
  final String? historyPaymentMethodId;
  final DateTime? historyFrom;
  final DateTime? historyTo;
  final String historySort;
  final String historyView;
  final DateTime? calendarMonth;
  final int firstWeekday;
  final bool showHijri;
  final String categorySort;
  const UiPreference(
      {required this.profileId,
      required this.historySearch,
      required this.historyType,
      this.historyCategoryId,
      this.historyPaymentMethodId,
      this.historyFrom,
      this.historyTo,
      required this.historySort,
      required this.historyView,
      this.calendarMonth,
      required this.firstWeekday,
      required this.showHijri,
      required this.categorySort});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['history_search'] = Variable<String>(historySearch);
    map['history_type'] = Variable<String>(historyType);
    if (!nullToAbsent || historyCategoryId != null) {
      map['history_category_id'] = Variable<String>(historyCategoryId);
    }
    if (!nullToAbsent || historyPaymentMethodId != null) {
      map['history_payment_method_id'] =
          Variable<String>(historyPaymentMethodId);
    }
    if (!nullToAbsent || historyFrom != null) {
      map['history_from'] = Variable<DateTime>(historyFrom);
    }
    if (!nullToAbsent || historyTo != null) {
      map['history_to'] = Variable<DateTime>(historyTo);
    }
    map['history_sort'] = Variable<String>(historySort);
    map['history_view'] = Variable<String>(historyView);
    if (!nullToAbsent || calendarMonth != null) {
      map['calendar_month'] = Variable<DateTime>(calendarMonth);
    }
    map['first_weekday'] = Variable<int>(firstWeekday);
    map['show_hijri'] = Variable<bool>(showHijri);
    map['category_sort'] = Variable<String>(categorySort);
    return map;
  }

  UiPreferencesCompanion toCompanion(bool nullToAbsent) {
    return UiPreferencesCompanion(
      profileId: Value(profileId),
      historySearch: Value(historySearch),
      historyType: Value(historyType),
      historyCategoryId: historyCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(historyCategoryId),
      historyPaymentMethodId: historyPaymentMethodId == null && nullToAbsent
          ? const Value.absent()
          : Value(historyPaymentMethodId),
      historyFrom: historyFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(historyFrom),
      historyTo: historyTo == null && nullToAbsent
          ? const Value.absent()
          : Value(historyTo),
      historySort: Value(historySort),
      historyView: Value(historyView),
      calendarMonth: calendarMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(calendarMonth),
      firstWeekday: Value(firstWeekday),
      showHijri: Value(showHijri),
      categorySort: Value(categorySort),
    );
  }

  factory UiPreference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UiPreference(
      profileId: serializer.fromJson<String>(json['profileId']),
      historySearch: serializer.fromJson<String>(json['historySearch']),
      historyType: serializer.fromJson<String>(json['historyType']),
      historyCategoryId:
          serializer.fromJson<String?>(json['historyCategoryId']),
      historyPaymentMethodId:
          serializer.fromJson<String?>(json['historyPaymentMethodId']),
      historyFrom: serializer.fromJson<DateTime?>(json['historyFrom']),
      historyTo: serializer.fromJson<DateTime?>(json['historyTo']),
      historySort: serializer.fromJson<String>(json['historySort']),
      historyView: serializer.fromJson<String>(json['historyView']),
      calendarMonth: serializer.fromJson<DateTime?>(json['calendarMonth']),
      firstWeekday: serializer.fromJson<int>(json['firstWeekday']),
      showHijri: serializer.fromJson<bool>(json['showHijri']),
      categorySort: serializer.fromJson<String>(json['categorySort']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'historySearch': serializer.toJson<String>(historySearch),
      'historyType': serializer.toJson<String>(historyType),
      'historyCategoryId': serializer.toJson<String?>(historyCategoryId),
      'historyPaymentMethodId':
          serializer.toJson<String?>(historyPaymentMethodId),
      'historyFrom': serializer.toJson<DateTime?>(historyFrom),
      'historyTo': serializer.toJson<DateTime?>(historyTo),
      'historySort': serializer.toJson<String>(historySort),
      'historyView': serializer.toJson<String>(historyView),
      'calendarMonth': serializer.toJson<DateTime?>(calendarMonth),
      'firstWeekday': serializer.toJson<int>(firstWeekday),
      'showHijri': serializer.toJson<bool>(showHijri),
      'categorySort': serializer.toJson<String>(categorySort),
    };
  }

  UiPreference copyWith(
          {String? profileId,
          String? historySearch,
          String? historyType,
          Value<String?> historyCategoryId = const Value.absent(),
          Value<String?> historyPaymentMethodId = const Value.absent(),
          Value<DateTime?> historyFrom = const Value.absent(),
          Value<DateTime?> historyTo = const Value.absent(),
          String? historySort,
          String? historyView,
          Value<DateTime?> calendarMonth = const Value.absent(),
          int? firstWeekday,
          bool? showHijri,
          String? categorySort}) =>
      UiPreference(
        profileId: profileId ?? this.profileId,
        historySearch: historySearch ?? this.historySearch,
        historyType: historyType ?? this.historyType,
        historyCategoryId: historyCategoryId.present
            ? historyCategoryId.value
            : this.historyCategoryId,
        historyPaymentMethodId: historyPaymentMethodId.present
            ? historyPaymentMethodId.value
            : this.historyPaymentMethodId,
        historyFrom: historyFrom.present ? historyFrom.value : this.historyFrom,
        historyTo: historyTo.present ? historyTo.value : this.historyTo,
        historySort: historySort ?? this.historySort,
        historyView: historyView ?? this.historyView,
        calendarMonth:
            calendarMonth.present ? calendarMonth.value : this.calendarMonth,
        firstWeekday: firstWeekday ?? this.firstWeekday,
        showHijri: showHijri ?? this.showHijri,
        categorySort: categorySort ?? this.categorySort,
      );
  UiPreference copyWithCompanion(UiPreferencesCompanion data) {
    return UiPreference(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      historySearch: data.historySearch.present
          ? data.historySearch.value
          : this.historySearch,
      historyType:
          data.historyType.present ? data.historyType.value : this.historyType,
      historyCategoryId: data.historyCategoryId.present
          ? data.historyCategoryId.value
          : this.historyCategoryId,
      historyPaymentMethodId: data.historyPaymentMethodId.present
          ? data.historyPaymentMethodId.value
          : this.historyPaymentMethodId,
      historyFrom:
          data.historyFrom.present ? data.historyFrom.value : this.historyFrom,
      historyTo: data.historyTo.present ? data.historyTo.value : this.historyTo,
      historySort:
          data.historySort.present ? data.historySort.value : this.historySort,
      historyView:
          data.historyView.present ? data.historyView.value : this.historyView,
      calendarMonth: data.calendarMonth.present
          ? data.calendarMonth.value
          : this.calendarMonth,
      firstWeekday: data.firstWeekday.present
          ? data.firstWeekday.value
          : this.firstWeekday,
      showHijri: data.showHijri.present ? data.showHijri.value : this.showHijri,
      categorySort: data.categorySort.present
          ? data.categorySort.value
          : this.categorySort,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UiPreference(')
          ..write('profileId: $profileId, ')
          ..write('historySearch: $historySearch, ')
          ..write('historyType: $historyType, ')
          ..write('historyCategoryId: $historyCategoryId, ')
          ..write('historyPaymentMethodId: $historyPaymentMethodId, ')
          ..write('historyFrom: $historyFrom, ')
          ..write('historyTo: $historyTo, ')
          ..write('historySort: $historySort, ')
          ..write('historyView: $historyView, ')
          ..write('calendarMonth: $calendarMonth, ')
          ..write('firstWeekday: $firstWeekday, ')
          ..write('showHijri: $showHijri, ')
          ..write('categorySort: $categorySort')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      profileId,
      historySearch,
      historyType,
      historyCategoryId,
      historyPaymentMethodId,
      historyFrom,
      historyTo,
      historySort,
      historyView,
      calendarMonth,
      firstWeekday,
      showHijri,
      categorySort);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UiPreference &&
          other.profileId == this.profileId &&
          other.historySearch == this.historySearch &&
          other.historyType == this.historyType &&
          other.historyCategoryId == this.historyCategoryId &&
          other.historyPaymentMethodId == this.historyPaymentMethodId &&
          other.historyFrom == this.historyFrom &&
          other.historyTo == this.historyTo &&
          other.historySort == this.historySort &&
          other.historyView == this.historyView &&
          other.calendarMonth == this.calendarMonth &&
          other.firstWeekday == this.firstWeekday &&
          other.showHijri == this.showHijri &&
          other.categorySort == this.categorySort);
}

class UiPreferencesCompanion extends UpdateCompanion<UiPreference> {
  final Value<String> profileId;
  final Value<String> historySearch;
  final Value<String> historyType;
  final Value<String?> historyCategoryId;
  final Value<String?> historyPaymentMethodId;
  final Value<DateTime?> historyFrom;
  final Value<DateTime?> historyTo;
  final Value<String> historySort;
  final Value<String> historyView;
  final Value<DateTime?> calendarMonth;
  final Value<int> firstWeekday;
  final Value<bool> showHijri;
  final Value<String> categorySort;
  final Value<int> rowid;
  const UiPreferencesCompanion({
    this.profileId = const Value.absent(),
    this.historySearch = const Value.absent(),
    this.historyType = const Value.absent(),
    this.historyCategoryId = const Value.absent(),
    this.historyPaymentMethodId = const Value.absent(),
    this.historyFrom = const Value.absent(),
    this.historyTo = const Value.absent(),
    this.historySort = const Value.absent(),
    this.historyView = const Value.absent(),
    this.calendarMonth = const Value.absent(),
    this.firstWeekday = const Value.absent(),
    this.showHijri = const Value.absent(),
    this.categorySort = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UiPreferencesCompanion.insert({
    required String profileId,
    this.historySearch = const Value.absent(),
    this.historyType = const Value.absent(),
    this.historyCategoryId = const Value.absent(),
    this.historyPaymentMethodId = const Value.absent(),
    this.historyFrom = const Value.absent(),
    this.historyTo = const Value.absent(),
    this.historySort = const Value.absent(),
    this.historyView = const Value.absent(),
    this.calendarMonth = const Value.absent(),
    this.firstWeekday = const Value.absent(),
    this.showHijri = const Value.absent(),
    this.categorySort = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId);
  static Insertable<UiPreference> custom({
    Expression<String>? profileId,
    Expression<String>? historySearch,
    Expression<String>? historyType,
    Expression<String>? historyCategoryId,
    Expression<String>? historyPaymentMethodId,
    Expression<DateTime>? historyFrom,
    Expression<DateTime>? historyTo,
    Expression<String>? historySort,
    Expression<String>? historyView,
    Expression<DateTime>? calendarMonth,
    Expression<int>? firstWeekday,
    Expression<bool>? showHijri,
    Expression<String>? categorySort,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (historySearch != null) 'history_search': historySearch,
      if (historyType != null) 'history_type': historyType,
      if (historyCategoryId != null) 'history_category_id': historyCategoryId,
      if (historyPaymentMethodId != null)
        'history_payment_method_id': historyPaymentMethodId,
      if (historyFrom != null) 'history_from': historyFrom,
      if (historyTo != null) 'history_to': historyTo,
      if (historySort != null) 'history_sort': historySort,
      if (historyView != null) 'history_view': historyView,
      if (calendarMonth != null) 'calendar_month': calendarMonth,
      if (firstWeekday != null) 'first_weekday': firstWeekday,
      if (showHijri != null) 'show_hijri': showHijri,
      if (categorySort != null) 'category_sort': categorySort,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UiPreferencesCompanion copyWith(
      {Value<String>? profileId,
      Value<String>? historySearch,
      Value<String>? historyType,
      Value<String?>? historyCategoryId,
      Value<String?>? historyPaymentMethodId,
      Value<DateTime?>? historyFrom,
      Value<DateTime?>? historyTo,
      Value<String>? historySort,
      Value<String>? historyView,
      Value<DateTime?>? calendarMonth,
      Value<int>? firstWeekday,
      Value<bool>? showHijri,
      Value<String>? categorySort,
      Value<int>? rowid}) {
    return UiPreferencesCompanion(
      profileId: profileId ?? this.profileId,
      historySearch: historySearch ?? this.historySearch,
      historyType: historyType ?? this.historyType,
      historyCategoryId: historyCategoryId ?? this.historyCategoryId,
      historyPaymentMethodId:
          historyPaymentMethodId ?? this.historyPaymentMethodId,
      historyFrom: historyFrom ?? this.historyFrom,
      historyTo: historyTo ?? this.historyTo,
      historySort: historySort ?? this.historySort,
      historyView: historyView ?? this.historyView,
      calendarMonth: calendarMonth ?? this.calendarMonth,
      firstWeekday: firstWeekday ?? this.firstWeekday,
      showHijri: showHijri ?? this.showHijri,
      categorySort: categorySort ?? this.categorySort,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (historySearch.present) {
      map['history_search'] = Variable<String>(historySearch.value);
    }
    if (historyType.present) {
      map['history_type'] = Variable<String>(historyType.value);
    }
    if (historyCategoryId.present) {
      map['history_category_id'] = Variable<String>(historyCategoryId.value);
    }
    if (historyPaymentMethodId.present) {
      map['history_payment_method_id'] =
          Variable<String>(historyPaymentMethodId.value);
    }
    if (historyFrom.present) {
      map['history_from'] = Variable<DateTime>(historyFrom.value);
    }
    if (historyTo.present) {
      map['history_to'] = Variable<DateTime>(historyTo.value);
    }
    if (historySort.present) {
      map['history_sort'] = Variable<String>(historySort.value);
    }
    if (historyView.present) {
      map['history_view'] = Variable<String>(historyView.value);
    }
    if (calendarMonth.present) {
      map['calendar_month'] = Variable<DateTime>(calendarMonth.value);
    }
    if (firstWeekday.present) {
      map['first_weekday'] = Variable<int>(firstWeekday.value);
    }
    if (showHijri.present) {
      map['show_hijri'] = Variable<bool>(showHijri.value);
    }
    if (categorySort.present) {
      map['category_sort'] = Variable<String>(categorySort.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UiPreferencesCompanion(')
          ..write('profileId: $profileId, ')
          ..write('historySearch: $historySearch, ')
          ..write('historyType: $historyType, ')
          ..write('historyCategoryId: $historyCategoryId, ')
          ..write('historyPaymentMethodId: $historyPaymentMethodId, ')
          ..write('historyFrom: $historyFrom, ')
          ..write('historyTo: $historyTo, ')
          ..write('historySort: $historySort, ')
          ..write('historyView: $historyView, ')
          ..write('calendarMonth: $calendarMonth, ')
          ..write('firstWeekday: $firstWeekday, ')
          ..write('showHijri: $showHijri, ')
          ..write('categorySort: $categorySort, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FinancialTransactionsTable financialTransactions =
      $FinancialTransactionsTable(this);
  late final $ExpenseCategoriesTable expenseCategories =
      $ExpenseCategoriesTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $SavingsGoalsTable savingsGoals = $SavingsGoalsTable(this);
  late final $GoalContributionsTable goalContributions =
      $GoalContributionsTable(this);
  late final $BnplPlansTable bnplPlans = $BnplPlansTable(this);
  late final $BnplInstalmentsTable bnplInstalments =
      $BnplInstalmentsTable(this);
  late final $RecurringPaymentsTable recurringPayments =
      $RecurringPaymentsTable(this);
  late final $FinancialPreferencesTable financialPreferences =
      $FinancialPreferencesTable(this);
  late final $PaymentMethodsTable paymentMethods = $PaymentMethodsTable(this);
  late final $ReceiptAttachmentsTable receiptAttachments =
      $ReceiptAttachmentsTable(this);
  late final $BudgetCategoriesTable budgetCategories =
      $BudgetCategoriesTable(this);
  late final $BudgetHistoryTable budgetHistory = $BudgetHistoryTable(this);
  late final $RecurringOccurrencesTable recurringOccurrences =
      $RecurringOccurrencesTable(this);
  late final $RecurringPaymentHistoryTable recurringPaymentHistory =
      $RecurringPaymentHistoryTable(this);
  late final $SubscriptionPriceHistoryTable subscriptionPriceHistory =
      $SubscriptionPriceHistoryTable(this);
  late final $BnplPaymentHistoryTable bnplPaymentHistory =
      $BnplPaymentHistoryTable(this);
  late final $NotificationSchedulesTable notificationSchedules =
      $NotificationSchedulesTable(this);
  late final $ExchangeRatesTable exchangeRates = $ExchangeRatesTable(this);
  late final $SecurityPreferencesTable securityPreferences =
      $SecurityPreferencesTable(this);
  late final $UiPreferencesTable uiPreferences = $UiPreferencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        financialTransactions,
        expenseCategories,
        budgets,
        savingsGoals,
        goalContributions,
        bnplPlans,
        bnplInstalments,
        recurringPayments,
        financialPreferences,
        paymentMethods,
        receiptAttachments,
        budgetCategories,
        budgetHistory,
        recurringOccurrences,
        recurringPaymentHistory,
        subscriptionPriceHistory,
        bnplPaymentHistory,
        notificationSchedules,
        exchangeRates,
        securityPreferences,
        uiPreferences
      ];
}

typedef $$FinancialTransactionsTableCreateCompanionBuilder
    = FinancialTransactionsCompanion Function({
  required String id,
  required String profileId,
  Value<String> type,
  required int amountMinor,
  Value<String> currency,
  Value<String?> merchant,
  Value<String?> description,
  required String categoryId,
  required DateTime transactedAt,
  Value<String?> paymentMethod,
  Value<String?> paymentMethodId,
  Value<String?> receiptAttachmentId,
  Value<String?> originalCurrency,
  Value<int?> originalAmountMinor,
  Value<String?> exchangeRateId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$FinancialTransactionsTableUpdateCompanionBuilder
    = FinancialTransactionsCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> type,
  Value<int> amountMinor,
  Value<String> currency,
  Value<String?> merchant,
  Value<String?> description,
  Value<String> categoryId,
  Value<DateTime> transactedAt,
  Value<String?> paymentMethod,
  Value<String?> paymentMethodId,
  Value<String?> receiptAttachmentId,
  Value<String?> originalCurrency,
  Value<int?> originalAmountMinor,
  Value<String?> exchangeRateId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$FinancialTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialTransactionsTable> {
  $$FinancialTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get merchant => $composableBuilder(
      column: $table.merchant, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transactedAt => $composableBuilder(
      column: $table.transactedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethodId => $composableBuilder(
      column: $table.paymentMethodId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiptAttachmentId => $composableBuilder(
      column: $table.receiptAttachmentId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalCurrency => $composableBuilder(
      column: $table.originalCurrency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get originalAmountMinor => $composableBuilder(
      column: $table.originalAmountMinor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exchangeRateId => $composableBuilder(
      column: $table.exchangeRateId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FinancialTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialTransactionsTable> {
  $$FinancialTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get merchant => $composableBuilder(
      column: $table.merchant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transactedAt => $composableBuilder(
      column: $table.transactedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethodId => $composableBuilder(
      column: $table.paymentMethodId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiptAttachmentId => $composableBuilder(
      column: $table.receiptAttachmentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalCurrency => $composableBuilder(
      column: $table.originalCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get originalAmountMinor => $composableBuilder(
      column: $table.originalAmountMinor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exchangeRateId => $composableBuilder(
      column: $table.exchangeRateId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FinancialTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialTransactionsTable> {
  $$FinancialTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<DateTime> get transactedAt => $composableBuilder(
      column: $table.transactedAt, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get paymentMethodId => $composableBuilder(
      column: $table.paymentMethodId, builder: (column) => column);

  GeneratedColumn<String> get receiptAttachmentId => $composableBuilder(
      column: $table.receiptAttachmentId, builder: (column) => column);

  GeneratedColumn<String> get originalCurrency => $composableBuilder(
      column: $table.originalCurrency, builder: (column) => column);

  GeneratedColumn<int> get originalAmountMinor => $composableBuilder(
      column: $table.originalAmountMinor, builder: (column) => column);

  GeneratedColumn<String> get exchangeRateId => $composableBuilder(
      column: $table.exchangeRateId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FinancialTransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FinancialTransactionsTable,
    FinancialTransaction,
    $$FinancialTransactionsTableFilterComposer,
    $$FinancialTransactionsTableOrderingComposer,
    $$FinancialTransactionsTableAnnotationComposer,
    $$FinancialTransactionsTableCreateCompanionBuilder,
    $$FinancialTransactionsTableUpdateCompanionBuilder,
    (
      FinancialTransaction,
      BaseReferences<_$AppDatabase, $FinancialTransactionsTable,
          FinancialTransaction>
    ),
    FinancialTransaction,
    PrefetchHooks Function()> {
  $$FinancialTransactionsTableTableManager(
      _$AppDatabase db, $FinancialTransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialTransactionsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancialTransactionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinancialTransactionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> amountMinor = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> merchant = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<DateTime> transactedAt = const Value.absent(),
            Value<String?> paymentMethod = const Value.absent(),
            Value<String?> paymentMethodId = const Value.absent(),
            Value<String?> receiptAttachmentId = const Value.absent(),
            Value<String?> originalCurrency = const Value.absent(),
            Value<int?> originalAmountMinor = const Value.absent(),
            Value<String?> exchangeRateId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FinancialTransactionsCompanion(
            id: id,
            profileId: profileId,
            type: type,
            amountMinor: amountMinor,
            currency: currency,
            merchant: merchant,
            description: description,
            categoryId: categoryId,
            transactedAt: transactedAt,
            paymentMethod: paymentMethod,
            paymentMethodId: paymentMethodId,
            receiptAttachmentId: receiptAttachmentId,
            originalCurrency: originalCurrency,
            originalAmountMinor: originalAmountMinor,
            exchangeRateId: exchangeRateId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            Value<String> type = const Value.absent(),
            required int amountMinor,
            Value<String> currency = const Value.absent(),
            Value<String?> merchant = const Value.absent(),
            Value<String?> description = const Value.absent(),
            required String categoryId,
            required DateTime transactedAt,
            Value<String?> paymentMethod = const Value.absent(),
            Value<String?> paymentMethodId = const Value.absent(),
            Value<String?> receiptAttachmentId = const Value.absent(),
            Value<String?> originalCurrency = const Value.absent(),
            Value<int?> originalAmountMinor = const Value.absent(),
            Value<String?> exchangeRateId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FinancialTransactionsCompanion.insert(
            id: id,
            profileId: profileId,
            type: type,
            amountMinor: amountMinor,
            currency: currency,
            merchant: merchant,
            description: description,
            categoryId: categoryId,
            transactedAt: transactedAt,
            paymentMethod: paymentMethod,
            paymentMethodId: paymentMethodId,
            receiptAttachmentId: receiptAttachmentId,
            originalCurrency: originalCurrency,
            originalAmountMinor: originalAmountMinor,
            exchangeRateId: exchangeRateId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FinancialTransactionsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $FinancialTransactionsTable,
        FinancialTransaction,
        $$FinancialTransactionsTableFilterComposer,
        $$FinancialTransactionsTableOrderingComposer,
        $$FinancialTransactionsTableAnnotationComposer,
        $$FinancialTransactionsTableCreateCompanionBuilder,
        $$FinancialTransactionsTableUpdateCompanionBuilder,
        (
          FinancialTransaction,
          BaseReferences<_$AppDatabase, $FinancialTransactionsTable,
              FinancialTransaction>
        ),
        FinancialTransaction,
        PrefetchHooks Function()>;
typedef $$ExpenseCategoriesTableCreateCompanionBuilder
    = ExpenseCategoriesCompanion Function({
  required String id,
  required String profileId,
  Value<String?> systemCode,
  required String name,
  Value<bool> isSystem,
  Value<int> iconCodePoint,
  Value<int> colorValue,
  Value<String?> emoji,
  Value<DateTime?> lastUsedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ExpenseCategoriesTableUpdateCompanionBuilder
    = ExpenseCategoriesCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String?> systemCode,
  Value<String> name,
  Value<bool> isSystem,
  Value<int> iconCodePoint,
  Value<int> colorValue,
  Value<String?> emoji,
  Value<DateTime?> lastUsedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ExpenseCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get systemCode => $composableBuilder(
      column: $table.systemCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ExpenseCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get systemCode => $composableBuilder(
      column: $table.systemCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ExpenseCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get systemCode => $composableBuilder(
      column: $table.systemCode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ExpenseCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpenseCategoriesTable,
    ExpenseCategory,
    $$ExpenseCategoriesTableFilterComposer,
    $$ExpenseCategoriesTableOrderingComposer,
    $$ExpenseCategoriesTableAnnotationComposer,
    $$ExpenseCategoriesTableCreateCompanionBuilder,
    $$ExpenseCategoriesTableUpdateCompanionBuilder,
    (
      ExpenseCategory,
      BaseReferences<_$AppDatabase, $ExpenseCategoriesTable, ExpenseCategory>
    ),
    ExpenseCategory,
    PrefetchHooks Function()> {
  $$ExpenseCategoriesTableTableManager(
      _$AppDatabase db, $ExpenseCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String?> systemCode = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<int> iconCodePoint = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<String?> emoji = const Value.absent(),
            Value<DateTime?> lastUsedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseCategoriesCompanion(
            id: id,
            profileId: profileId,
            systemCode: systemCode,
            name: name,
            isSystem: isSystem,
            iconCodePoint: iconCodePoint,
            colorValue: colorValue,
            emoji: emoji,
            lastUsedAt: lastUsedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            Value<String?> systemCode = const Value.absent(),
            required String name,
            Value<bool> isSystem = const Value.absent(),
            Value<int> iconCodePoint = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<String?> emoji = const Value.absent(),
            Value<DateTime?> lastUsedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseCategoriesCompanion.insert(
            id: id,
            profileId: profileId,
            systemCode: systemCode,
            name: name,
            isSystem: isSystem,
            iconCodePoint: iconCodePoint,
            colorValue: colorValue,
            emoji: emoji,
            lastUsedAt: lastUsedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpenseCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpenseCategoriesTable,
    ExpenseCategory,
    $$ExpenseCategoriesTableFilterComposer,
    $$ExpenseCategoriesTableOrderingComposer,
    $$ExpenseCategoriesTableAnnotationComposer,
    $$ExpenseCategoriesTableCreateCompanionBuilder,
    $$ExpenseCategoriesTableUpdateCompanionBuilder,
    (
      ExpenseCategory,
      BaseReferences<_$AppDatabase, $ExpenseCategoriesTable, ExpenseCategory>
    ),
    ExpenseCategory,
    PrefetchHooks Function()>;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  required String id,
  required String profileId,
  required String name,
  required int limitMinor,
  Value<String?> categoryId,
  required DateTime startsOn,
  required DateTime endsOn,
  Value<bool> isOverall,
  Value<String> rolloverMode,
  Value<String> cycleType,
  Value<int?> payday,
  Value<int> fixedCommitmentsMinor,
  Value<int> emergencyBufferMinor,
  Value<int> carriedAmountMinor,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> name,
  Value<int> limitMinor,
  Value<String?> categoryId,
  Value<DateTime> startsOn,
  Value<DateTime> endsOn,
  Value<bool> isOverall,
  Value<String> rolloverMode,
  Value<String> cycleType,
  Value<int?> payday,
  Value<int> fixedCommitmentsMinor,
  Value<int> emergencyBufferMinor,
  Value<int> carriedAmountMinor,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get limitMinor => $composableBuilder(
      column: $table.limitMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startsOn => $composableBuilder(
      column: $table.startsOn, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endsOn => $composableBuilder(
      column: $table.endsOn, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isOverall => $composableBuilder(
      column: $table.isOverall, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rolloverMode => $composableBuilder(
      column: $table.rolloverMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cycleType => $composableBuilder(
      column: $table.cycleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get payday => $composableBuilder(
      column: $table.payday, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fixedCommitmentsMinor => $composableBuilder(
      column: $table.fixedCommitmentsMinor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get emergencyBufferMinor => $composableBuilder(
      column: $table.emergencyBufferMinor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get carriedAmountMinor => $composableBuilder(
      column: $table.carriedAmountMinor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get limitMinor => $composableBuilder(
      column: $table.limitMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startsOn => $composableBuilder(
      column: $table.startsOn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endsOn => $composableBuilder(
      column: $table.endsOn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOverall => $composableBuilder(
      column: $table.isOverall, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rolloverMode => $composableBuilder(
      column: $table.rolloverMode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cycleType => $composableBuilder(
      column: $table.cycleType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get payday => $composableBuilder(
      column: $table.payday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fixedCommitmentsMinor => $composableBuilder(
      column: $table.fixedCommitmentsMinor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get emergencyBufferMinor => $composableBuilder(
      column: $table.emergencyBufferMinor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get carriedAmountMinor => $composableBuilder(
      column: $table.carriedAmountMinor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get limitMinor => $composableBuilder(
      column: $table.limitMinor, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<DateTime> get startsOn =>
      $composableBuilder(column: $table.startsOn, builder: (column) => column);

  GeneratedColumn<DateTime> get endsOn =>
      $composableBuilder(column: $table.endsOn, builder: (column) => column);

  GeneratedColumn<bool> get isOverall =>
      $composableBuilder(column: $table.isOverall, builder: (column) => column);

  GeneratedColumn<String> get rolloverMode => $composableBuilder(
      column: $table.rolloverMode, builder: (column) => column);

  GeneratedColumn<String> get cycleType =>
      $composableBuilder(column: $table.cycleType, builder: (column) => column);

  GeneratedColumn<int> get payday =>
      $composableBuilder(column: $table.payday, builder: (column) => column);

  GeneratedColumn<int> get fixedCommitmentsMinor => $composableBuilder(
      column: $table.fixedCommitmentsMinor, builder: (column) => column);

  GeneratedColumn<int> get emergencyBufferMinor => $composableBuilder(
      column: $table.emergencyBufferMinor, builder: (column) => column);

  GeneratedColumn<int> get carriedAmountMinor => $composableBuilder(
      column: $table.carriedAmountMinor, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BudgetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetsTable,
    Budget,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
    Budget,
    PrefetchHooks Function()> {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> limitMinor = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<DateTime> startsOn = const Value.absent(),
            Value<DateTime> endsOn = const Value.absent(),
            Value<bool> isOverall = const Value.absent(),
            Value<String> rolloverMode = const Value.absent(),
            Value<String> cycleType = const Value.absent(),
            Value<int?> payday = const Value.absent(),
            Value<int> fixedCommitmentsMinor = const Value.absent(),
            Value<int> emergencyBufferMinor = const Value.absent(),
            Value<int> carriedAmountMinor = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsCompanion(
            id: id,
            profileId: profileId,
            name: name,
            limitMinor: limitMinor,
            categoryId: categoryId,
            startsOn: startsOn,
            endsOn: endsOn,
            isOverall: isOverall,
            rolloverMode: rolloverMode,
            cycleType: cycleType,
            payday: payday,
            fixedCommitmentsMinor: fixedCommitmentsMinor,
            emergencyBufferMinor: emergencyBufferMinor,
            carriedAmountMinor: carriedAmountMinor,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String name,
            required int limitMinor,
            Value<String?> categoryId = const Value.absent(),
            required DateTime startsOn,
            required DateTime endsOn,
            Value<bool> isOverall = const Value.absent(),
            Value<String> rolloverMode = const Value.absent(),
            Value<String> cycleType = const Value.absent(),
            Value<int?> payday = const Value.absent(),
            Value<int> fixedCommitmentsMinor = const Value.absent(),
            Value<int> emergencyBufferMinor = const Value.absent(),
            Value<int> carriedAmountMinor = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsCompanion.insert(
            id: id,
            profileId: profileId,
            name: name,
            limitMinor: limitMinor,
            categoryId: categoryId,
            startsOn: startsOn,
            endsOn: endsOn,
            isOverall: isOverall,
            rolloverMode: rolloverMode,
            cycleType: cycleType,
            payday: payday,
            fixedCommitmentsMinor: fixedCommitmentsMinor,
            emergencyBufferMinor: emergencyBufferMinor,
            carriedAmountMinor: carriedAmountMinor,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BudgetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetsTable,
    Budget,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
    Budget,
    PrefetchHooks Function()>;
typedef $$SavingsGoalsTableCreateCompanionBuilder = SavingsGoalsCompanion
    Function({
  required String id,
  required String profileId,
  required String name,
  required int targetMinor,
  Value<int> currentMinor,
  Value<DateTime?> targetDate,
  Value<String?> templateCode,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$SavingsGoalsTableUpdateCompanionBuilder = SavingsGoalsCompanion
    Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> name,
  Value<int> targetMinor,
  Value<int> currentMinor,
  Value<DateTime?> targetDate,
  Value<String?> templateCode,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SavingsGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetMinor => $composableBuilder(
      column: $table.targetMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentMinor => $composableBuilder(
      column: $table.currentMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get templateCode => $composableBuilder(
      column: $table.templateCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SavingsGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetMinor => $composableBuilder(
      column: $table.targetMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentMinor => $composableBuilder(
      column: $table.currentMinor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get templateCode => $composableBuilder(
      column: $table.templateCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SavingsGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetMinor => $composableBuilder(
      column: $table.targetMinor, builder: (column) => column);

  GeneratedColumn<int> get currentMinor => $composableBuilder(
      column: $table.currentMinor, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => column);

  GeneratedColumn<String> get templateCode => $composableBuilder(
      column: $table.templateCode, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SavingsGoalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SavingsGoalsTable,
    SavingsGoal,
    $$SavingsGoalsTableFilterComposer,
    $$SavingsGoalsTableOrderingComposer,
    $$SavingsGoalsTableAnnotationComposer,
    $$SavingsGoalsTableCreateCompanionBuilder,
    $$SavingsGoalsTableUpdateCompanionBuilder,
    (
      SavingsGoal,
      BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoal>
    ),
    SavingsGoal,
    PrefetchHooks Function()> {
  $$SavingsGoalsTableTableManager(_$AppDatabase db, $SavingsGoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> targetMinor = const Value.absent(),
            Value<int> currentMinor = const Value.absent(),
            Value<DateTime?> targetDate = const Value.absent(),
            Value<String?> templateCode = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SavingsGoalsCompanion(
            id: id,
            profileId: profileId,
            name: name,
            targetMinor: targetMinor,
            currentMinor: currentMinor,
            targetDate: targetDate,
            templateCode: templateCode,
            completedAt: completedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String name,
            required int targetMinor,
            Value<int> currentMinor = const Value.absent(),
            Value<DateTime?> targetDate = const Value.absent(),
            Value<String?> templateCode = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SavingsGoalsCompanion.insert(
            id: id,
            profileId: profileId,
            name: name,
            targetMinor: targetMinor,
            currentMinor: currentMinor,
            targetDate: targetDate,
            templateCode: templateCode,
            completedAt: completedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SavingsGoalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SavingsGoalsTable,
    SavingsGoal,
    $$SavingsGoalsTableFilterComposer,
    $$SavingsGoalsTableOrderingComposer,
    $$SavingsGoalsTableAnnotationComposer,
    $$SavingsGoalsTableCreateCompanionBuilder,
    $$SavingsGoalsTableUpdateCompanionBuilder,
    (
      SavingsGoal,
      BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoal>
    ),
    SavingsGoal,
    PrefetchHooks Function()>;
typedef $$GoalContributionsTableCreateCompanionBuilder
    = GoalContributionsCompanion Function({
  required String id,
  required String profileId,
  required String goalId,
  required int amountMinor,
  required DateTime contributedAt,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$GoalContributionsTableUpdateCompanionBuilder
    = GoalContributionsCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> goalId,
  Value<int> amountMinor,
  Value<DateTime> contributedAt,
  Value<String?> note,
  Value<int> rowid,
});

class $$GoalContributionsTableFilterComposer
    extends Composer<_$AppDatabase, $GoalContributionsTable> {
  $$GoalContributionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goalId => $composableBuilder(
      column: $table.goalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get contributedAt => $composableBuilder(
      column: $table.contributedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$GoalContributionsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalContributionsTable> {
  $$GoalContributionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goalId => $composableBuilder(
      column: $table.goalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get contributedAt => $composableBuilder(
      column: $table.contributedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$GoalContributionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalContributionsTable> {
  $$GoalContributionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<DateTime> get contributedAt => $composableBuilder(
      column: $table.contributedAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$GoalContributionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalContributionsTable,
    GoalContribution,
    $$GoalContributionsTableFilterComposer,
    $$GoalContributionsTableOrderingComposer,
    $$GoalContributionsTableAnnotationComposer,
    $$GoalContributionsTableCreateCompanionBuilder,
    $$GoalContributionsTableUpdateCompanionBuilder,
    (
      GoalContribution,
      BaseReferences<_$AppDatabase, $GoalContributionsTable, GoalContribution>
    ),
    GoalContribution,
    PrefetchHooks Function()> {
  $$GoalContributionsTableTableManager(
      _$AppDatabase db, $GoalContributionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalContributionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalContributionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalContributionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> goalId = const Value.absent(),
            Value<int> amountMinor = const Value.absent(),
            Value<DateTime> contributedAt = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalContributionsCompanion(
            id: id,
            profileId: profileId,
            goalId: goalId,
            amountMinor: amountMinor,
            contributedAt: contributedAt,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String goalId,
            required int amountMinor,
            required DateTime contributedAt,
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalContributionsCompanion.insert(
            id: id,
            profileId: profileId,
            goalId: goalId,
            amountMinor: amountMinor,
            contributedAt: contributedAt,
            note: note,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GoalContributionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GoalContributionsTable,
    GoalContribution,
    $$GoalContributionsTableFilterComposer,
    $$GoalContributionsTableOrderingComposer,
    $$GoalContributionsTableAnnotationComposer,
    $$GoalContributionsTableCreateCompanionBuilder,
    $$GoalContributionsTableUpdateCompanionBuilder,
    (
      GoalContribution,
      BaseReferences<_$AppDatabase, $GoalContributionsTable, GoalContribution>
    ),
    GoalContribution,
    PrefetchHooks Function()>;
typedef $$BnplPlansTableCreateCompanionBuilder = BnplPlansCompanion Function({
  required String id,
  required String profileId,
  required String provider,
  required String merchant,
  required int purchaseAmountMinor,
  Value<String> currency,
  required int instalmentCount,
  Value<String> status,
  Value<String?> customProvider,
  required DateTime purchaseDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$BnplPlansTableUpdateCompanionBuilder = BnplPlansCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> provider,
  Value<String> merchant,
  Value<int> purchaseAmountMinor,
  Value<String> currency,
  Value<int> instalmentCount,
  Value<String> status,
  Value<String?> customProvider,
  Value<DateTime> purchaseDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$BnplPlansTableFilterComposer
    extends Composer<_$AppDatabase, $BnplPlansTable> {
  $$BnplPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get merchant => $composableBuilder(
      column: $table.merchant, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get purchaseAmountMinor => $composableBuilder(
      column: $table.purchaseAmountMinor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get instalmentCount => $composableBuilder(
      column: $table.instalmentCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customProvider => $composableBuilder(
      column: $table.customProvider,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$BnplPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $BnplPlansTable> {
  $$BnplPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get merchant => $composableBuilder(
      column: $table.merchant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get purchaseAmountMinor => $composableBuilder(
      column: $table.purchaseAmountMinor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get instalmentCount => $composableBuilder(
      column: $table.instalmentCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customProvider => $composableBuilder(
      column: $table.customProvider,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BnplPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $BnplPlansTable> {
  $$BnplPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<int> get purchaseAmountMinor => $composableBuilder(
      column: $table.purchaseAmountMinor, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get instalmentCount => $composableBuilder(
      column: $table.instalmentCount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get customProvider => $composableBuilder(
      column: $table.customProvider, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BnplPlansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BnplPlansTable,
    BnplPlan,
    $$BnplPlansTableFilterComposer,
    $$BnplPlansTableOrderingComposer,
    $$BnplPlansTableAnnotationComposer,
    $$BnplPlansTableCreateCompanionBuilder,
    $$BnplPlansTableUpdateCompanionBuilder,
    (BnplPlan, BaseReferences<_$AppDatabase, $BnplPlansTable, BnplPlan>),
    BnplPlan,
    PrefetchHooks Function()> {
  $$BnplPlansTableTableManager(_$AppDatabase db, $BnplPlansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BnplPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BnplPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BnplPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> provider = const Value.absent(),
            Value<String> merchant = const Value.absent(),
            Value<int> purchaseAmountMinor = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<int> instalmentCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> customProvider = const Value.absent(),
            Value<DateTime> purchaseDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BnplPlansCompanion(
            id: id,
            profileId: profileId,
            provider: provider,
            merchant: merchant,
            purchaseAmountMinor: purchaseAmountMinor,
            currency: currency,
            instalmentCount: instalmentCount,
            status: status,
            customProvider: customProvider,
            purchaseDate: purchaseDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String provider,
            required String merchant,
            required int purchaseAmountMinor,
            Value<String> currency = const Value.absent(),
            required int instalmentCount,
            Value<String> status = const Value.absent(),
            Value<String?> customProvider = const Value.absent(),
            required DateTime purchaseDate,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BnplPlansCompanion.insert(
            id: id,
            profileId: profileId,
            provider: provider,
            merchant: merchant,
            purchaseAmountMinor: purchaseAmountMinor,
            currency: currency,
            instalmentCount: instalmentCount,
            status: status,
            customProvider: customProvider,
            purchaseDate: purchaseDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BnplPlansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BnplPlansTable,
    BnplPlan,
    $$BnplPlansTableFilterComposer,
    $$BnplPlansTableOrderingComposer,
    $$BnplPlansTableAnnotationComposer,
    $$BnplPlansTableCreateCompanionBuilder,
    $$BnplPlansTableUpdateCompanionBuilder,
    (BnplPlan, BaseReferences<_$AppDatabase, $BnplPlansTable, BnplPlan>),
    BnplPlan,
    PrefetchHooks Function()>;
typedef $$BnplInstalmentsTableCreateCompanionBuilder = BnplInstalmentsCompanion
    Function({
  required String id,
  required String profileId,
  required String planId,
  required int amountMinor,
  required DateTime dueDate,
  Value<bool> isPaid,
  Value<DateTime?> paidAt,
  Value<int> rowid,
});
typedef $$BnplInstalmentsTableUpdateCompanionBuilder = BnplInstalmentsCompanion
    Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> planId,
  Value<int> amountMinor,
  Value<DateTime> dueDate,
  Value<bool> isPaid,
  Value<DateTime?> paidAt,
  Value<int> rowid,
});

class $$BnplInstalmentsTableFilterComposer
    extends Composer<_$AppDatabase, $BnplInstalmentsTable> {
  $$BnplInstalmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get planId => $composableBuilder(
      column: $table.planId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnFilters(column));
}

class $$BnplInstalmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $BnplInstalmentsTable> {
  $$BnplInstalmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get planId => $composableBuilder(
      column: $table.planId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnOrderings(column));
}

class $$BnplInstalmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BnplInstalmentsTable> {
  $$BnplInstalmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);
}

class $$BnplInstalmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BnplInstalmentsTable,
    BnplInstalment,
    $$BnplInstalmentsTableFilterComposer,
    $$BnplInstalmentsTableOrderingComposer,
    $$BnplInstalmentsTableAnnotationComposer,
    $$BnplInstalmentsTableCreateCompanionBuilder,
    $$BnplInstalmentsTableUpdateCompanionBuilder,
    (
      BnplInstalment,
      BaseReferences<_$AppDatabase, $BnplInstalmentsTable, BnplInstalment>
    ),
    BnplInstalment,
    PrefetchHooks Function()> {
  $$BnplInstalmentsTableTableManager(
      _$AppDatabase db, $BnplInstalmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BnplInstalmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BnplInstalmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BnplInstalmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> planId = const Value.absent(),
            Value<int> amountMinor = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
            Value<DateTime?> paidAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BnplInstalmentsCompanion(
            id: id,
            profileId: profileId,
            planId: planId,
            amountMinor: amountMinor,
            dueDate: dueDate,
            isPaid: isPaid,
            paidAt: paidAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String planId,
            required int amountMinor,
            required DateTime dueDate,
            Value<bool> isPaid = const Value.absent(),
            Value<DateTime?> paidAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BnplInstalmentsCompanion.insert(
            id: id,
            profileId: profileId,
            planId: planId,
            amountMinor: amountMinor,
            dueDate: dueDate,
            isPaid: isPaid,
            paidAt: paidAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BnplInstalmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BnplInstalmentsTable,
    BnplInstalment,
    $$BnplInstalmentsTableFilterComposer,
    $$BnplInstalmentsTableOrderingComposer,
    $$BnplInstalmentsTableAnnotationComposer,
    $$BnplInstalmentsTableCreateCompanionBuilder,
    $$BnplInstalmentsTableUpdateCompanionBuilder,
    (
      BnplInstalment,
      BaseReferences<_$AppDatabase, $BnplInstalmentsTable, BnplInstalment>
    ),
    BnplInstalment,
    PrefetchHooks Function()>;
typedef $$RecurringPaymentsTableCreateCompanionBuilder
    = RecurringPaymentsCompanion Function({
  required String id,
  required String profileId,
  required String name,
  required int amountMinor,
  Value<String> currency,
  required String recurrence,
  Value<String?> categoryId,
  required DateTime nextPaymentDate,
  Value<bool> isSubscription,
  Value<bool> isActive,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<int?> maxOccurrences,
  Value<int> generatedOccurrences,
  Value<int> intervalCount,
  Value<String> status,
  Value<DateTime?> lastReconciledAt,
  Value<int> rowid,
});
typedef $$RecurringPaymentsTableUpdateCompanionBuilder
    = RecurringPaymentsCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> name,
  Value<int> amountMinor,
  Value<String> currency,
  Value<String> recurrence,
  Value<String?> categoryId,
  Value<DateTime> nextPaymentDate,
  Value<bool> isSubscription,
  Value<bool> isActive,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<int?> maxOccurrences,
  Value<int> generatedOccurrences,
  Value<int> intervalCount,
  Value<String> status,
  Value<DateTime?> lastReconciledAt,
  Value<int> rowid,
});

class $$RecurringPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringPaymentsTable> {
  $$RecurringPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrence => $composableBuilder(
      column: $table.recurrence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextPaymentDate => $composableBuilder(
      column: $table.nextPaymentDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSubscription => $composableBuilder(
      column: $table.isSubscription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxOccurrences => $composableBuilder(
      column: $table.maxOccurrences,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get generatedOccurrences => $composableBuilder(
      column: $table.generatedOccurrences,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalCount => $composableBuilder(
      column: $table.intervalCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReconciledAt => $composableBuilder(
      column: $table.lastReconciledAt,
      builder: (column) => ColumnFilters(column));
}

class $$RecurringPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringPaymentsTable> {
  $$RecurringPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrence => $composableBuilder(
      column: $table.recurrence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextPaymentDate => $composableBuilder(
      column: $table.nextPaymentDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSubscription => $composableBuilder(
      column: $table.isSubscription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxOccurrences => $composableBuilder(
      column: $table.maxOccurrences,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get generatedOccurrences => $composableBuilder(
      column: $table.generatedOccurrences,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalCount => $composableBuilder(
      column: $table.intervalCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReconciledAt => $composableBuilder(
      column: $table.lastReconciledAt,
      builder: (column) => ColumnOrderings(column));
}

class $$RecurringPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringPaymentsTable> {
  $$RecurringPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get recurrence => $composableBuilder(
      column: $table.recurrence, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<DateTime> get nextPaymentDate => $composableBuilder(
      column: $table.nextPaymentDate, builder: (column) => column);

  GeneratedColumn<bool> get isSubscription => $composableBuilder(
      column: $table.isSubscription, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get maxOccurrences => $composableBuilder(
      column: $table.maxOccurrences, builder: (column) => column);

  GeneratedColumn<int> get generatedOccurrences => $composableBuilder(
      column: $table.generatedOccurrences, builder: (column) => column);

  GeneratedColumn<int> get intervalCount => $composableBuilder(
      column: $table.intervalCount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReconciledAt => $composableBuilder(
      column: $table.lastReconciledAt, builder: (column) => column);
}

class $$RecurringPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurringPaymentsTable,
    RecurringPayment,
    $$RecurringPaymentsTableFilterComposer,
    $$RecurringPaymentsTableOrderingComposer,
    $$RecurringPaymentsTableAnnotationComposer,
    $$RecurringPaymentsTableCreateCompanionBuilder,
    $$RecurringPaymentsTableUpdateCompanionBuilder,
    (
      RecurringPayment,
      BaseReferences<_$AppDatabase, $RecurringPaymentsTable, RecurringPayment>
    ),
    RecurringPayment,
    PrefetchHooks Function()> {
  $$RecurringPaymentsTableTableManager(
      _$AppDatabase db, $RecurringPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringPaymentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> amountMinor = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> recurrence = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<DateTime> nextPaymentDate = const Value.absent(),
            Value<bool> isSubscription = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<int?> maxOccurrences = const Value.absent(),
            Value<int> generatedOccurrences = const Value.absent(),
            Value<int> intervalCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> lastReconciledAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringPaymentsCompanion(
            id: id,
            profileId: profileId,
            name: name,
            amountMinor: amountMinor,
            currency: currency,
            recurrence: recurrence,
            categoryId: categoryId,
            nextPaymentDate: nextPaymentDate,
            isSubscription: isSubscription,
            isActive: isActive,
            startDate: startDate,
            endDate: endDate,
            maxOccurrences: maxOccurrences,
            generatedOccurrences: generatedOccurrences,
            intervalCount: intervalCount,
            status: status,
            lastReconciledAt: lastReconciledAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String name,
            required int amountMinor,
            Value<String> currency = const Value.absent(),
            required String recurrence,
            Value<String?> categoryId = const Value.absent(),
            required DateTime nextPaymentDate,
            Value<bool> isSubscription = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<int?> maxOccurrences = const Value.absent(),
            Value<int> generatedOccurrences = const Value.absent(),
            Value<int> intervalCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> lastReconciledAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringPaymentsCompanion.insert(
            id: id,
            profileId: profileId,
            name: name,
            amountMinor: amountMinor,
            currency: currency,
            recurrence: recurrence,
            categoryId: categoryId,
            nextPaymentDate: nextPaymentDate,
            isSubscription: isSubscription,
            isActive: isActive,
            startDate: startDate,
            endDate: endDate,
            maxOccurrences: maxOccurrences,
            generatedOccurrences: generatedOccurrences,
            intervalCount: intervalCount,
            status: status,
            lastReconciledAt: lastReconciledAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecurringPaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecurringPaymentsTable,
    RecurringPayment,
    $$RecurringPaymentsTableFilterComposer,
    $$RecurringPaymentsTableOrderingComposer,
    $$RecurringPaymentsTableAnnotationComposer,
    $$RecurringPaymentsTableCreateCompanionBuilder,
    $$RecurringPaymentsTableUpdateCompanionBuilder,
    (
      RecurringPayment,
      BaseReferences<_$AppDatabase, $RecurringPaymentsTable, RecurringPayment>
    ),
    RecurringPayment,
    PrefetchHooks Function()>;
typedef $$FinancialPreferencesTableCreateCompanionBuilder
    = FinancialPreferencesCompanion Function({
  required String profileId,
  Value<int> monthlyIncomeMinor,
  Value<int> payday,
  Value<String> currency,
  Value<bool> notificationsEnabled,
  Value<String?> defaultPaymentMethodId,
  Value<bool> widgetPrivacyEnabled,
  Value<int> rowid,
});
typedef $$FinancialPreferencesTableUpdateCompanionBuilder
    = FinancialPreferencesCompanion Function({
  Value<String> profileId,
  Value<int> monthlyIncomeMinor,
  Value<int> payday,
  Value<String> currency,
  Value<bool> notificationsEnabled,
  Value<String?> defaultPaymentMethodId,
  Value<bool> widgetPrivacyEnabled,
  Value<int> rowid,
});

class $$FinancialPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialPreferencesTable> {
  $$FinancialPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get monthlyIncomeMinor => $composableBuilder(
      column: $table.monthlyIncomeMinor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get payday => $composableBuilder(
      column: $table.payday, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultPaymentMethodId => $composableBuilder(
      column: $table.defaultPaymentMethodId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get widgetPrivacyEnabled => $composableBuilder(
      column: $table.widgetPrivacyEnabled,
      builder: (column) => ColumnFilters(column));
}

class $$FinancialPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialPreferencesTable> {
  $$FinancialPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get monthlyIncomeMinor => $composableBuilder(
      column: $table.monthlyIncomeMinor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get payday => $composableBuilder(
      column: $table.payday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultPaymentMethodId => $composableBuilder(
      column: $table.defaultPaymentMethodId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get widgetPrivacyEnabled => $composableBuilder(
      column: $table.widgetPrivacyEnabled,
      builder: (column) => ColumnOrderings(column));
}

class $$FinancialPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialPreferencesTable> {
  $$FinancialPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get monthlyIncomeMinor => $composableBuilder(
      column: $table.monthlyIncomeMinor, builder: (column) => column);

  GeneratedColumn<int> get payday =>
      $composableBuilder(column: $table.payday, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled, builder: (column) => column);

  GeneratedColumn<String> get defaultPaymentMethodId => $composableBuilder(
      column: $table.defaultPaymentMethodId, builder: (column) => column);

  GeneratedColumn<bool> get widgetPrivacyEnabled => $composableBuilder(
      column: $table.widgetPrivacyEnabled, builder: (column) => column);
}

class $$FinancialPreferencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FinancialPreferencesTable,
    FinancialPreference,
    $$FinancialPreferencesTableFilterComposer,
    $$FinancialPreferencesTableOrderingComposer,
    $$FinancialPreferencesTableAnnotationComposer,
    $$FinancialPreferencesTableCreateCompanionBuilder,
    $$FinancialPreferencesTableUpdateCompanionBuilder,
    (
      FinancialPreference,
      BaseReferences<_$AppDatabase, $FinancialPreferencesTable,
          FinancialPreference>
    ),
    FinancialPreference,
    PrefetchHooks Function()> {
  $$FinancialPreferencesTableTableManager(
      _$AppDatabase db, $FinancialPreferencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancialPreferencesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinancialPreferencesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> profileId = const Value.absent(),
            Value<int> monthlyIncomeMinor = const Value.absent(),
            Value<int> payday = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
            Value<String?> defaultPaymentMethodId = const Value.absent(),
            Value<bool> widgetPrivacyEnabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FinancialPreferencesCompanion(
            profileId: profileId,
            monthlyIncomeMinor: monthlyIncomeMinor,
            payday: payday,
            currency: currency,
            notificationsEnabled: notificationsEnabled,
            defaultPaymentMethodId: defaultPaymentMethodId,
            widgetPrivacyEnabled: widgetPrivacyEnabled,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String profileId,
            Value<int> monthlyIncomeMinor = const Value.absent(),
            Value<int> payday = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
            Value<String?> defaultPaymentMethodId = const Value.absent(),
            Value<bool> widgetPrivacyEnabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FinancialPreferencesCompanion.insert(
            profileId: profileId,
            monthlyIncomeMinor: monthlyIncomeMinor,
            payday: payday,
            currency: currency,
            notificationsEnabled: notificationsEnabled,
            defaultPaymentMethodId: defaultPaymentMethodId,
            widgetPrivacyEnabled: widgetPrivacyEnabled,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FinancialPreferencesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $FinancialPreferencesTable,
        FinancialPreference,
        $$FinancialPreferencesTableFilterComposer,
        $$FinancialPreferencesTableOrderingComposer,
        $$FinancialPreferencesTableAnnotationComposer,
        $$FinancialPreferencesTableCreateCompanionBuilder,
        $$FinancialPreferencesTableUpdateCompanionBuilder,
        (
          FinancialPreference,
          BaseReferences<_$AppDatabase, $FinancialPreferencesTable,
              FinancialPreference>
        ),
        FinancialPreference,
        PrefetchHooks Function()>;
typedef $$PaymentMethodsTableCreateCompanionBuilder = PaymentMethodsCompanion
    Function({
  required String id,
  required String profileId,
  Value<String?> systemCode,
  required String name,
  Value<String> iconName,
  Value<bool> isSystem,
  Value<bool> isDefault,
  Value<DateTime?> lastUsedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$PaymentMethodsTableUpdateCompanionBuilder = PaymentMethodsCompanion
    Function({
  Value<String> id,
  Value<String> profileId,
  Value<String?> systemCode,
  Value<String> name,
  Value<String> iconName,
  Value<bool> isSystem,
  Value<bool> isDefault,
  Value<DateTime?> lastUsedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$PaymentMethodsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get systemCode => $composableBuilder(
      column: $table.systemCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$PaymentMethodsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get systemCode => $composableBuilder(
      column: $table.systemCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PaymentMethodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get systemCode => $composableBuilder(
      column: $table.systemCode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PaymentMethodsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentMethodsTable,
    PaymentMethod,
    $$PaymentMethodsTableFilterComposer,
    $$PaymentMethodsTableOrderingComposer,
    $$PaymentMethodsTableAnnotationComposer,
    $$PaymentMethodsTableCreateCompanionBuilder,
    $$PaymentMethodsTableUpdateCompanionBuilder,
    (
      PaymentMethod,
      BaseReferences<_$AppDatabase, $PaymentMethodsTable, PaymentMethod>
    ),
    PaymentMethod,
    PrefetchHooks Function()> {
  $$PaymentMethodsTableTableManager(
      _$AppDatabase db, $PaymentMethodsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentMethodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentMethodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentMethodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String?> systemCode = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> iconName = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<DateTime?> lastUsedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentMethodsCompanion(
            id: id,
            profileId: profileId,
            systemCode: systemCode,
            name: name,
            iconName: iconName,
            isSystem: isSystem,
            isDefault: isDefault,
            lastUsedAt: lastUsedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            Value<String?> systemCode = const Value.absent(),
            required String name,
            Value<String> iconName = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<DateTime?> lastUsedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentMethodsCompanion.insert(
            id: id,
            profileId: profileId,
            systemCode: systemCode,
            name: name,
            iconName: iconName,
            isSystem: isSystem,
            isDefault: isDefault,
            lastUsedAt: lastUsedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PaymentMethodsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentMethodsTable,
    PaymentMethod,
    $$PaymentMethodsTableFilterComposer,
    $$PaymentMethodsTableOrderingComposer,
    $$PaymentMethodsTableAnnotationComposer,
    $$PaymentMethodsTableCreateCompanionBuilder,
    $$PaymentMethodsTableUpdateCompanionBuilder,
    (
      PaymentMethod,
      BaseReferences<_$AppDatabase, $PaymentMethodsTable, PaymentMethod>
    ),
    PaymentMethod,
    PrefetchHooks Function()>;
typedef $$ReceiptAttachmentsTableCreateCompanionBuilder
    = ReceiptAttachmentsCompanion Function({
  required String id,
  required String profileId,
  required String transactionId,
  required String filePath,
  Value<String?> thumbnailPath,
  required String mimeType,
  required int sizeBytes,
  Value<int?> width,
  Value<int?> height,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ReceiptAttachmentsTableUpdateCompanionBuilder
    = ReceiptAttachmentsCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> transactionId,
  Value<String> filePath,
  Value<String?> thumbnailPath,
  Value<String> mimeType,
  Value<int> sizeBytes,
  Value<int?> width,
  Value<int?> height,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ReceiptAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $ReceiptAttachmentsTable> {
  $$ReceiptAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
      column: $table.thumbnailPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get width => $composableBuilder(
      column: $table.width, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ReceiptAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceiptAttachmentsTable> {
  $$ReceiptAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transactionId => $composableBuilder(
      column: $table.transactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
      column: $table.thumbnailPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get width => $composableBuilder(
      column: $table.width, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ReceiptAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceiptAttachmentsTable> {
  $$ReceiptAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
      column: $table.thumbnailPath, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReceiptAttachmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReceiptAttachmentsTable,
    ReceiptAttachment,
    $$ReceiptAttachmentsTableFilterComposer,
    $$ReceiptAttachmentsTableOrderingComposer,
    $$ReceiptAttachmentsTableAnnotationComposer,
    $$ReceiptAttachmentsTableCreateCompanionBuilder,
    $$ReceiptAttachmentsTableUpdateCompanionBuilder,
    (
      ReceiptAttachment,
      BaseReferences<_$AppDatabase, $ReceiptAttachmentsTable, ReceiptAttachment>
    ),
    ReceiptAttachment,
    PrefetchHooks Function()> {
  $$ReceiptAttachmentsTableTableManager(
      _$AppDatabase db, $ReceiptAttachmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceiptAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceiptAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceiptAttachmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> transactionId = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String?> thumbnailPath = const Value.absent(),
            Value<String> mimeType = const Value.absent(),
            Value<int> sizeBytes = const Value.absent(),
            Value<int?> width = const Value.absent(),
            Value<int?> height = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReceiptAttachmentsCompanion(
            id: id,
            profileId: profileId,
            transactionId: transactionId,
            filePath: filePath,
            thumbnailPath: thumbnailPath,
            mimeType: mimeType,
            sizeBytes: sizeBytes,
            width: width,
            height: height,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String transactionId,
            required String filePath,
            Value<String?> thumbnailPath = const Value.absent(),
            required String mimeType,
            required int sizeBytes,
            Value<int?> width = const Value.absent(),
            Value<int?> height = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReceiptAttachmentsCompanion.insert(
            id: id,
            profileId: profileId,
            transactionId: transactionId,
            filePath: filePath,
            thumbnailPath: thumbnailPath,
            mimeType: mimeType,
            sizeBytes: sizeBytes,
            width: width,
            height: height,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReceiptAttachmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReceiptAttachmentsTable,
    ReceiptAttachment,
    $$ReceiptAttachmentsTableFilterComposer,
    $$ReceiptAttachmentsTableOrderingComposer,
    $$ReceiptAttachmentsTableAnnotationComposer,
    $$ReceiptAttachmentsTableCreateCompanionBuilder,
    $$ReceiptAttachmentsTableUpdateCompanionBuilder,
    (
      ReceiptAttachment,
      BaseReferences<_$AppDatabase, $ReceiptAttachmentsTable, ReceiptAttachment>
    ),
    ReceiptAttachment,
    PrefetchHooks Function()>;
typedef $$BudgetCategoriesTableCreateCompanionBuilder
    = BudgetCategoriesCompanion Function({
  required String id,
  required String profileId,
  required String budgetId,
  required String categoryId,
  Value<int?> limitMinor,
  Value<int> rowid,
});
typedef $$BudgetCategoriesTableUpdateCompanionBuilder
    = BudgetCategoriesCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> budgetId,
  Value<String> categoryId,
  Value<int?> limitMinor,
  Value<int> rowid,
});

class $$BudgetCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTable> {
  $$BudgetCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetId => $composableBuilder(
      column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get limitMinor => $composableBuilder(
      column: $table.limitMinor, builder: (column) => ColumnFilters(column));
}

class $$BudgetCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTable> {
  $$BudgetCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetId => $composableBuilder(
      column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get limitMinor => $composableBuilder(
      column: $table.limitMinor, builder: (column) => ColumnOrderings(column));
}

class $$BudgetCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTable> {
  $$BudgetCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<int> get limitMinor => $composableBuilder(
      column: $table.limitMinor, builder: (column) => column);
}

class $$BudgetCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetCategoriesTable,
    BudgetCategory,
    $$BudgetCategoriesTableFilterComposer,
    $$BudgetCategoriesTableOrderingComposer,
    $$BudgetCategoriesTableAnnotationComposer,
    $$BudgetCategoriesTableCreateCompanionBuilder,
    $$BudgetCategoriesTableUpdateCompanionBuilder,
    (
      BudgetCategory,
      BaseReferences<_$AppDatabase, $BudgetCategoriesTable, BudgetCategory>
    ),
    BudgetCategory,
    PrefetchHooks Function()> {
  $$BudgetCategoriesTableTableManager(
      _$AppDatabase db, $BudgetCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> budgetId = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<int?> limitMinor = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetCategoriesCompanion(
            id: id,
            profileId: profileId,
            budgetId: budgetId,
            categoryId: categoryId,
            limitMinor: limitMinor,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String budgetId,
            required String categoryId,
            Value<int?> limitMinor = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetCategoriesCompanion.insert(
            id: id,
            profileId: profileId,
            budgetId: budgetId,
            categoryId: categoryId,
            limitMinor: limitMinor,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BudgetCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetCategoriesTable,
    BudgetCategory,
    $$BudgetCategoriesTableFilterComposer,
    $$BudgetCategoriesTableOrderingComposer,
    $$BudgetCategoriesTableAnnotationComposer,
    $$BudgetCategoriesTableCreateCompanionBuilder,
    $$BudgetCategoriesTableUpdateCompanionBuilder,
    (
      BudgetCategory,
      BaseReferences<_$AppDatabase, $BudgetCategoriesTable, BudgetCategory>
    ),
    BudgetCategory,
    PrefetchHooks Function()>;
typedef $$BudgetHistoryTableCreateCompanionBuilder = BudgetHistoryCompanion
    Function({
  required String id,
  required String profileId,
  required String budgetId,
  required DateTime periodStart,
  required DateTime periodEnd,
  required int limitMinor,
  required int spentMinor,
  Value<int> carriedMinor,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$BudgetHistoryTableUpdateCompanionBuilder = BudgetHistoryCompanion
    Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> budgetId,
  Value<DateTime> periodStart,
  Value<DateTime> periodEnd,
  Value<int> limitMinor,
  Value<int> spentMinor,
  Value<int> carriedMinor,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$BudgetHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetHistoryTable> {
  $$BudgetHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetId => $composableBuilder(
      column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodEnd => $composableBuilder(
      column: $table.periodEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get limitMinor => $composableBuilder(
      column: $table.limitMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get spentMinor => $composableBuilder(
      column: $table.spentMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get carriedMinor => $composableBuilder(
      column: $table.carriedMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$BudgetHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetHistoryTable> {
  $$BudgetHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetId => $composableBuilder(
      column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodEnd => $composableBuilder(
      column: $table.periodEnd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get limitMinor => $composableBuilder(
      column: $table.limitMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get spentMinor => $composableBuilder(
      column: $table.spentMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get carriedMinor => $composableBuilder(
      column: $table.carriedMinor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BudgetHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetHistoryTable> {
  $$BudgetHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => column);

  GeneratedColumn<DateTime> get periodEnd =>
      $composableBuilder(column: $table.periodEnd, builder: (column) => column);

  GeneratedColumn<int> get limitMinor => $composableBuilder(
      column: $table.limitMinor, builder: (column) => column);

  GeneratedColumn<int> get spentMinor => $composableBuilder(
      column: $table.spentMinor, builder: (column) => column);

  GeneratedColumn<int> get carriedMinor => $composableBuilder(
      column: $table.carriedMinor, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BudgetHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetHistoryTable,
    BudgetHistoryData,
    $$BudgetHistoryTableFilterComposer,
    $$BudgetHistoryTableOrderingComposer,
    $$BudgetHistoryTableAnnotationComposer,
    $$BudgetHistoryTableCreateCompanionBuilder,
    $$BudgetHistoryTableUpdateCompanionBuilder,
    (
      BudgetHistoryData,
      BaseReferences<_$AppDatabase, $BudgetHistoryTable, BudgetHistoryData>
    ),
    BudgetHistoryData,
    PrefetchHooks Function()> {
  $$BudgetHistoryTableTableManager(_$AppDatabase db, $BudgetHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> budgetId = const Value.absent(),
            Value<DateTime> periodStart = const Value.absent(),
            Value<DateTime> periodEnd = const Value.absent(),
            Value<int> limitMinor = const Value.absent(),
            Value<int> spentMinor = const Value.absent(),
            Value<int> carriedMinor = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetHistoryCompanion(
            id: id,
            profileId: profileId,
            budgetId: budgetId,
            periodStart: periodStart,
            periodEnd: periodEnd,
            limitMinor: limitMinor,
            spentMinor: spentMinor,
            carriedMinor: carriedMinor,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String budgetId,
            required DateTime periodStart,
            required DateTime periodEnd,
            required int limitMinor,
            required int spentMinor,
            Value<int> carriedMinor = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetHistoryCompanion.insert(
            id: id,
            profileId: profileId,
            budgetId: budgetId,
            periodStart: periodStart,
            periodEnd: periodEnd,
            limitMinor: limitMinor,
            spentMinor: spentMinor,
            carriedMinor: carriedMinor,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BudgetHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetHistoryTable,
    BudgetHistoryData,
    $$BudgetHistoryTableFilterComposer,
    $$BudgetHistoryTableOrderingComposer,
    $$BudgetHistoryTableAnnotationComposer,
    $$BudgetHistoryTableCreateCompanionBuilder,
    $$BudgetHistoryTableUpdateCompanionBuilder,
    (
      BudgetHistoryData,
      BaseReferences<_$AppDatabase, $BudgetHistoryTable, BudgetHistoryData>
    ),
    BudgetHistoryData,
    PrefetchHooks Function()>;
typedef $$RecurringOccurrencesTableCreateCompanionBuilder
    = RecurringOccurrencesCompanion Function({
  required String id,
  required String profileId,
  required String recurringPaymentId,
  required DateTime scheduledAt,
  required int amountMinor,
  Value<String> status,
  Value<String?> transactionId,
  Value<bool> isOverride,
  Value<DateTime?> paidAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$RecurringOccurrencesTableUpdateCompanionBuilder
    = RecurringOccurrencesCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> recurringPaymentId,
  Value<DateTime> scheduledAt,
  Value<int> amountMinor,
  Value<String> status,
  Value<String?> transactionId,
  Value<bool> isOverride,
  Value<DateTime?> paidAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$RecurringOccurrencesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringOccurrencesTable> {
  $$RecurringOccurrencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurringPaymentId => $composableBuilder(
      column: $table.recurringPaymentId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isOverride => $composableBuilder(
      column: $table.isOverride, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$RecurringOccurrencesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringOccurrencesTable> {
  $$RecurringOccurrencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurringPaymentId => $composableBuilder(
      column: $table.recurringPaymentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transactionId => $composableBuilder(
      column: $table.transactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOverride => $composableBuilder(
      column: $table.isOverride, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$RecurringOccurrencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringOccurrencesTable> {
  $$RecurringOccurrencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get recurringPaymentId => $composableBuilder(
      column: $table.recurringPaymentId, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => column);

  GeneratedColumn<bool> get isOverride => $composableBuilder(
      column: $table.isOverride, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RecurringOccurrencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurringOccurrencesTable,
    RecurringOccurrence,
    $$RecurringOccurrencesTableFilterComposer,
    $$RecurringOccurrencesTableOrderingComposer,
    $$RecurringOccurrencesTableAnnotationComposer,
    $$RecurringOccurrencesTableCreateCompanionBuilder,
    $$RecurringOccurrencesTableUpdateCompanionBuilder,
    (
      RecurringOccurrence,
      BaseReferences<_$AppDatabase, $RecurringOccurrencesTable,
          RecurringOccurrence>
    ),
    RecurringOccurrence,
    PrefetchHooks Function()> {
  $$RecurringOccurrencesTableTableManager(
      _$AppDatabase db, $RecurringOccurrencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringOccurrencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringOccurrencesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringOccurrencesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> recurringPaymentId = const Value.absent(),
            Value<DateTime> scheduledAt = const Value.absent(),
            Value<int> amountMinor = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> transactionId = const Value.absent(),
            Value<bool> isOverride = const Value.absent(),
            Value<DateTime?> paidAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringOccurrencesCompanion(
            id: id,
            profileId: profileId,
            recurringPaymentId: recurringPaymentId,
            scheduledAt: scheduledAt,
            amountMinor: amountMinor,
            status: status,
            transactionId: transactionId,
            isOverride: isOverride,
            paidAt: paidAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String recurringPaymentId,
            required DateTime scheduledAt,
            required int amountMinor,
            Value<String> status = const Value.absent(),
            Value<String?> transactionId = const Value.absent(),
            Value<bool> isOverride = const Value.absent(),
            Value<DateTime?> paidAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringOccurrencesCompanion.insert(
            id: id,
            profileId: profileId,
            recurringPaymentId: recurringPaymentId,
            scheduledAt: scheduledAt,
            amountMinor: amountMinor,
            status: status,
            transactionId: transactionId,
            isOverride: isOverride,
            paidAt: paidAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecurringOccurrencesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $RecurringOccurrencesTable,
        RecurringOccurrence,
        $$RecurringOccurrencesTableFilterComposer,
        $$RecurringOccurrencesTableOrderingComposer,
        $$RecurringOccurrencesTableAnnotationComposer,
        $$RecurringOccurrencesTableCreateCompanionBuilder,
        $$RecurringOccurrencesTableUpdateCompanionBuilder,
        (
          RecurringOccurrence,
          BaseReferences<_$AppDatabase, $RecurringOccurrencesTable,
              RecurringOccurrence>
        ),
        RecurringOccurrence,
        PrefetchHooks Function()>;
typedef $$RecurringPaymentHistoryTableCreateCompanionBuilder
    = RecurringPaymentHistoryCompanion Function({
  required String id,
  required String profileId,
  required String recurringPaymentId,
  required String occurrenceId,
  required int amountMinor,
  required DateTime paidAt,
  Value<String?> transactionId,
  Value<int> rowid,
});
typedef $$RecurringPaymentHistoryTableUpdateCompanionBuilder
    = RecurringPaymentHistoryCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> recurringPaymentId,
  Value<String> occurrenceId,
  Value<int> amountMinor,
  Value<DateTime> paidAt,
  Value<String?> transactionId,
  Value<int> rowid,
});

class $$RecurringPaymentHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringPaymentHistoryTable> {
  $$RecurringPaymentHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurringPaymentId => $composableBuilder(
      column: $table.recurringPaymentId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get occurrenceId => $composableBuilder(
      column: $table.occurrenceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => ColumnFilters(column));
}

class $$RecurringPaymentHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringPaymentHistoryTable> {
  $$RecurringPaymentHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurringPaymentId => $composableBuilder(
      column: $table.recurringPaymentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get occurrenceId => $composableBuilder(
      column: $table.occurrenceId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transactionId => $composableBuilder(
      column: $table.transactionId,
      builder: (column) => ColumnOrderings(column));
}

class $$RecurringPaymentHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringPaymentHistoryTable> {
  $$RecurringPaymentHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get recurringPaymentId => $composableBuilder(
      column: $table.recurringPaymentId, builder: (column) => column);

  GeneratedColumn<String> get occurrenceId => $composableBuilder(
      column: $table.occurrenceId, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => column);
}

class $$RecurringPaymentHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurringPaymentHistoryTable,
    RecurringPaymentHistoryData,
    $$RecurringPaymentHistoryTableFilterComposer,
    $$RecurringPaymentHistoryTableOrderingComposer,
    $$RecurringPaymentHistoryTableAnnotationComposer,
    $$RecurringPaymentHistoryTableCreateCompanionBuilder,
    $$RecurringPaymentHistoryTableUpdateCompanionBuilder,
    (
      RecurringPaymentHistoryData,
      BaseReferences<_$AppDatabase, $RecurringPaymentHistoryTable,
          RecurringPaymentHistoryData>
    ),
    RecurringPaymentHistoryData,
    PrefetchHooks Function()> {
  $$RecurringPaymentHistoryTableTableManager(
      _$AppDatabase db, $RecurringPaymentHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringPaymentHistoryTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringPaymentHistoryTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringPaymentHistoryTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> recurringPaymentId = const Value.absent(),
            Value<String> occurrenceId = const Value.absent(),
            Value<int> amountMinor = const Value.absent(),
            Value<DateTime> paidAt = const Value.absent(),
            Value<String?> transactionId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringPaymentHistoryCompanion(
            id: id,
            profileId: profileId,
            recurringPaymentId: recurringPaymentId,
            occurrenceId: occurrenceId,
            amountMinor: amountMinor,
            paidAt: paidAt,
            transactionId: transactionId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String recurringPaymentId,
            required String occurrenceId,
            required int amountMinor,
            required DateTime paidAt,
            Value<String?> transactionId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringPaymentHistoryCompanion.insert(
            id: id,
            profileId: profileId,
            recurringPaymentId: recurringPaymentId,
            occurrenceId: occurrenceId,
            amountMinor: amountMinor,
            paidAt: paidAt,
            transactionId: transactionId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecurringPaymentHistoryTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $RecurringPaymentHistoryTable,
        RecurringPaymentHistoryData,
        $$RecurringPaymentHistoryTableFilterComposer,
        $$RecurringPaymentHistoryTableOrderingComposer,
        $$RecurringPaymentHistoryTableAnnotationComposer,
        $$RecurringPaymentHistoryTableCreateCompanionBuilder,
        $$RecurringPaymentHistoryTableUpdateCompanionBuilder,
        (
          RecurringPaymentHistoryData,
          BaseReferences<_$AppDatabase, $RecurringPaymentHistoryTable,
              RecurringPaymentHistoryData>
        ),
        RecurringPaymentHistoryData,
        PrefetchHooks Function()>;
typedef $$SubscriptionPriceHistoryTableCreateCompanionBuilder
    = SubscriptionPriceHistoryCompanion Function({
  required String id,
  required String profileId,
  required String recurringPaymentId,
  required int oldAmountMinor,
  required int newAmountMinor,
  Value<DateTime> changedAt,
  Value<int> rowid,
});
typedef $$SubscriptionPriceHistoryTableUpdateCompanionBuilder
    = SubscriptionPriceHistoryCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> recurringPaymentId,
  Value<int> oldAmountMinor,
  Value<int> newAmountMinor,
  Value<DateTime> changedAt,
  Value<int> rowid,
});

class $$SubscriptionPriceHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionPriceHistoryTable> {
  $$SubscriptionPriceHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurringPaymentId => $composableBuilder(
      column: $table.recurringPaymentId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get oldAmountMinor => $composableBuilder(
      column: $table.oldAmountMinor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get newAmountMinor => $composableBuilder(
      column: $table.newAmountMinor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
      column: $table.changedAt, builder: (column) => ColumnFilters(column));
}

class $$SubscriptionPriceHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionPriceHistoryTable> {
  $$SubscriptionPriceHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurringPaymentId => $composableBuilder(
      column: $table.recurringPaymentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get oldAmountMinor => $composableBuilder(
      column: $table.oldAmountMinor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get newAmountMinor => $composableBuilder(
      column: $table.newAmountMinor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
      column: $table.changedAt, builder: (column) => ColumnOrderings(column));
}

class $$SubscriptionPriceHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionPriceHistoryTable> {
  $$SubscriptionPriceHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get recurringPaymentId => $composableBuilder(
      column: $table.recurringPaymentId, builder: (column) => column);

  GeneratedColumn<int> get oldAmountMinor => $composableBuilder(
      column: $table.oldAmountMinor, builder: (column) => column);

  GeneratedColumn<int> get newAmountMinor => $composableBuilder(
      column: $table.newAmountMinor, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);
}

class $$SubscriptionPriceHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubscriptionPriceHistoryTable,
    SubscriptionPriceHistoryData,
    $$SubscriptionPriceHistoryTableFilterComposer,
    $$SubscriptionPriceHistoryTableOrderingComposer,
    $$SubscriptionPriceHistoryTableAnnotationComposer,
    $$SubscriptionPriceHistoryTableCreateCompanionBuilder,
    $$SubscriptionPriceHistoryTableUpdateCompanionBuilder,
    (
      SubscriptionPriceHistoryData,
      BaseReferences<_$AppDatabase, $SubscriptionPriceHistoryTable,
          SubscriptionPriceHistoryData>
    ),
    SubscriptionPriceHistoryData,
    PrefetchHooks Function()> {
  $$SubscriptionPriceHistoryTableTableManager(
      _$AppDatabase db, $SubscriptionPriceHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionPriceHistoryTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionPriceHistoryTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionPriceHistoryTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> recurringPaymentId = const Value.absent(),
            Value<int> oldAmountMinor = const Value.absent(),
            Value<int> newAmountMinor = const Value.absent(),
            Value<DateTime> changedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubscriptionPriceHistoryCompanion(
            id: id,
            profileId: profileId,
            recurringPaymentId: recurringPaymentId,
            oldAmountMinor: oldAmountMinor,
            newAmountMinor: newAmountMinor,
            changedAt: changedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String recurringPaymentId,
            required int oldAmountMinor,
            required int newAmountMinor,
            Value<DateTime> changedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubscriptionPriceHistoryCompanion.insert(
            id: id,
            profileId: profileId,
            recurringPaymentId: recurringPaymentId,
            oldAmountMinor: oldAmountMinor,
            newAmountMinor: newAmountMinor,
            changedAt: changedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubscriptionPriceHistoryTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $SubscriptionPriceHistoryTable,
        SubscriptionPriceHistoryData,
        $$SubscriptionPriceHistoryTableFilterComposer,
        $$SubscriptionPriceHistoryTableOrderingComposer,
        $$SubscriptionPriceHistoryTableAnnotationComposer,
        $$SubscriptionPriceHistoryTableCreateCompanionBuilder,
        $$SubscriptionPriceHistoryTableUpdateCompanionBuilder,
        (
          SubscriptionPriceHistoryData,
          BaseReferences<_$AppDatabase, $SubscriptionPriceHistoryTable,
              SubscriptionPriceHistoryData>
        ),
        SubscriptionPriceHistoryData,
        PrefetchHooks Function()>;
typedef $$BnplPaymentHistoryTableCreateCompanionBuilder
    = BnplPaymentHistoryCompanion Function({
  required String id,
  required String profileId,
  required String planId,
  required String instalmentId,
  required int amountMinor,
  required String action,
  Value<DateTime> occurredAt,
  Value<int> rowid,
});
typedef $$BnplPaymentHistoryTableUpdateCompanionBuilder
    = BnplPaymentHistoryCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> planId,
  Value<String> instalmentId,
  Value<int> amountMinor,
  Value<String> action,
  Value<DateTime> occurredAt,
  Value<int> rowid,
});

class $$BnplPaymentHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $BnplPaymentHistoryTable> {
  $$BnplPaymentHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get planId => $composableBuilder(
      column: $table.planId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instalmentId => $composableBuilder(
      column: $table.instalmentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnFilters(column));
}

class $$BnplPaymentHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $BnplPaymentHistoryTable> {
  $$BnplPaymentHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get planId => $composableBuilder(
      column: $table.planId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instalmentId => $composableBuilder(
      column: $table.instalmentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnOrderings(column));
}

class $$BnplPaymentHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $BnplPaymentHistoryTable> {
  $$BnplPaymentHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<String> get instalmentId => $composableBuilder(
      column: $table.instalmentId, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => column);
}

class $$BnplPaymentHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BnplPaymentHistoryTable,
    BnplPaymentHistoryData,
    $$BnplPaymentHistoryTableFilterComposer,
    $$BnplPaymentHistoryTableOrderingComposer,
    $$BnplPaymentHistoryTableAnnotationComposer,
    $$BnplPaymentHistoryTableCreateCompanionBuilder,
    $$BnplPaymentHistoryTableUpdateCompanionBuilder,
    (
      BnplPaymentHistoryData,
      BaseReferences<_$AppDatabase, $BnplPaymentHistoryTable,
          BnplPaymentHistoryData>
    ),
    BnplPaymentHistoryData,
    PrefetchHooks Function()> {
  $$BnplPaymentHistoryTableTableManager(
      _$AppDatabase db, $BnplPaymentHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BnplPaymentHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BnplPaymentHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BnplPaymentHistoryTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> planId = const Value.absent(),
            Value<String> instalmentId = const Value.absent(),
            Value<int> amountMinor = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BnplPaymentHistoryCompanion(
            id: id,
            profileId: profileId,
            planId: planId,
            instalmentId: instalmentId,
            amountMinor: amountMinor,
            action: action,
            occurredAt: occurredAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String planId,
            required String instalmentId,
            required int amountMinor,
            required String action,
            Value<DateTime> occurredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BnplPaymentHistoryCompanion.insert(
            id: id,
            profileId: profileId,
            planId: planId,
            instalmentId: instalmentId,
            amountMinor: amountMinor,
            action: action,
            occurredAt: occurredAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BnplPaymentHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BnplPaymentHistoryTable,
    BnplPaymentHistoryData,
    $$BnplPaymentHistoryTableFilterComposer,
    $$BnplPaymentHistoryTableOrderingComposer,
    $$BnplPaymentHistoryTableAnnotationComposer,
    $$BnplPaymentHistoryTableCreateCompanionBuilder,
    $$BnplPaymentHistoryTableUpdateCompanionBuilder,
    (
      BnplPaymentHistoryData,
      BaseReferences<_$AppDatabase, $BnplPaymentHistoryTable,
          BnplPaymentHistoryData>
    ),
    BnplPaymentHistoryData,
    PrefetchHooks Function()>;
typedef $$NotificationSchedulesTableCreateCompanionBuilder
    = NotificationSchedulesCompanion Function({
  required String id,
  required String profileId,
  required String recordType,
  required String recordId,
  required String notificationType,
  required DateTime scheduledAt,
  Value<String> locale,
  Value<String> status,
  Value<DateTime?> deliveredAt,
  Value<int> rowid,
});
typedef $$NotificationSchedulesTableUpdateCompanionBuilder
    = NotificationSchedulesCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> recordType,
  Value<String> recordId,
  Value<String> notificationType,
  Value<DateTime> scheduledAt,
  Value<String> locale,
  Value<String> status,
  Value<DateTime?> deliveredAt,
  Value<int> rowid,
});

class $$NotificationSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationSchedulesTable> {
  $$NotificationSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordType => $composableBuilder(
      column: $table.recordType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationType => $composableBuilder(
      column: $table.notificationType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locale => $composableBuilder(
      column: $table.locale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deliveredAt => $composableBuilder(
      column: $table.deliveredAt, builder: (column) => ColumnFilters(column));
}

class $$NotificationSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationSchedulesTable> {
  $$NotificationSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordType => $composableBuilder(
      column: $table.recordType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationType => $composableBuilder(
      column: $table.notificationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locale => $composableBuilder(
      column: $table.locale, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deliveredAt => $composableBuilder(
      column: $table.deliveredAt, builder: (column) => ColumnOrderings(column));
}

class $$NotificationSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationSchedulesTable> {
  $$NotificationSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get recordType => $composableBuilder(
      column: $table.recordType, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get notificationType => $composableBuilder(
      column: $table.notificationType, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get deliveredAt => $composableBuilder(
      column: $table.deliveredAt, builder: (column) => column);
}

class $$NotificationSchedulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotificationSchedulesTable,
    NotificationSchedule,
    $$NotificationSchedulesTableFilterComposer,
    $$NotificationSchedulesTableOrderingComposer,
    $$NotificationSchedulesTableAnnotationComposer,
    $$NotificationSchedulesTableCreateCompanionBuilder,
    $$NotificationSchedulesTableUpdateCompanionBuilder,
    (
      NotificationSchedule,
      BaseReferences<_$AppDatabase, $NotificationSchedulesTable,
          NotificationSchedule>
    ),
    NotificationSchedule,
    PrefetchHooks Function()> {
  $$NotificationSchedulesTableTableManager(
      _$AppDatabase db, $NotificationSchedulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationSchedulesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationSchedulesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationSchedulesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> recordType = const Value.absent(),
            Value<String> recordId = const Value.absent(),
            Value<String> notificationType = const Value.absent(),
            Value<DateTime> scheduledAt = const Value.absent(),
            Value<String> locale = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> deliveredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationSchedulesCompanion(
            id: id,
            profileId: profileId,
            recordType: recordType,
            recordId: recordId,
            notificationType: notificationType,
            scheduledAt: scheduledAt,
            locale: locale,
            status: status,
            deliveredAt: deliveredAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String recordType,
            required String recordId,
            required String notificationType,
            required DateTime scheduledAt,
            Value<String> locale = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> deliveredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationSchedulesCompanion.insert(
            id: id,
            profileId: profileId,
            recordType: recordType,
            recordId: recordId,
            notificationType: notificationType,
            scheduledAt: scheduledAt,
            locale: locale,
            status: status,
            deliveredAt: deliveredAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotificationSchedulesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $NotificationSchedulesTable,
        NotificationSchedule,
        $$NotificationSchedulesTableFilterComposer,
        $$NotificationSchedulesTableOrderingComposer,
        $$NotificationSchedulesTableAnnotationComposer,
        $$NotificationSchedulesTableCreateCompanionBuilder,
        $$NotificationSchedulesTableUpdateCompanionBuilder,
        (
          NotificationSchedule,
          BaseReferences<_$AppDatabase, $NotificationSchedulesTable,
              NotificationSchedule>
        ),
        NotificationSchedule,
        PrefetchHooks Function()>;
typedef $$ExchangeRatesTableCreateCompanionBuilder = ExchangeRatesCompanion
    Function({
  required String id,
  required String profileId,
  required String baseCurrency,
  required String quoteCurrency,
  required int rateMicros,
  required DateTime rateDate,
  Value<String> source,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ExchangeRatesTableUpdateCompanionBuilder = ExchangeRatesCompanion
    Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> baseCurrency,
  Value<String> quoteCurrency,
  Value<int> rateMicros,
  Value<DateTime> rateDate,
  Value<String> source,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ExchangeRatesTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseCurrency => $composableBuilder(
      column: $table.baseCurrency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get quoteCurrency => $composableBuilder(
      column: $table.quoteCurrency, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rateMicros => $composableBuilder(
      column: $table.rateMicros, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get rateDate => $composableBuilder(
      column: $table.rateDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ExchangeRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseCurrency => $composableBuilder(
      column: $table.baseCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get quoteCurrency => $composableBuilder(
      column: $table.quoteCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rateMicros => $composableBuilder(
      column: $table.rateMicros, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get rateDate => $composableBuilder(
      column: $table.rateDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ExchangeRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get baseCurrency => $composableBuilder(
      column: $table.baseCurrency, builder: (column) => column);

  GeneratedColumn<String> get quoteCurrency => $composableBuilder(
      column: $table.quoteCurrency, builder: (column) => column);

  GeneratedColumn<int> get rateMicros => $composableBuilder(
      column: $table.rateMicros, builder: (column) => column);

  GeneratedColumn<DateTime> get rateDate =>
      $composableBuilder(column: $table.rateDate, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ExchangeRatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExchangeRatesTable,
    ExchangeRate,
    $$ExchangeRatesTableFilterComposer,
    $$ExchangeRatesTableOrderingComposer,
    $$ExchangeRatesTableAnnotationComposer,
    $$ExchangeRatesTableCreateCompanionBuilder,
    $$ExchangeRatesTableUpdateCompanionBuilder,
    (
      ExchangeRate,
      BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRate>
    ),
    ExchangeRate,
    PrefetchHooks Function()> {
  $$ExchangeRatesTableTableManager(_$AppDatabase db, $ExchangeRatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExchangeRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExchangeRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExchangeRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> baseCurrency = const Value.absent(),
            Value<String> quoteCurrency = const Value.absent(),
            Value<int> rateMicros = const Value.absent(),
            Value<DateTime> rateDate = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExchangeRatesCompanion(
            id: id,
            profileId: profileId,
            baseCurrency: baseCurrency,
            quoteCurrency: quoteCurrency,
            rateMicros: rateMicros,
            rateDate: rateDate,
            source: source,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String profileId,
            required String baseCurrency,
            required String quoteCurrency,
            required int rateMicros,
            required DateTime rateDate,
            Value<String> source = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExchangeRatesCompanion.insert(
            id: id,
            profileId: profileId,
            baseCurrency: baseCurrency,
            quoteCurrency: quoteCurrency,
            rateMicros: rateMicros,
            rateDate: rateDate,
            source: source,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExchangeRatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExchangeRatesTable,
    ExchangeRate,
    $$ExchangeRatesTableFilterComposer,
    $$ExchangeRatesTableOrderingComposer,
    $$ExchangeRatesTableAnnotationComposer,
    $$ExchangeRatesTableCreateCompanionBuilder,
    $$ExchangeRatesTableUpdateCompanionBuilder,
    (
      ExchangeRate,
      BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRate>
    ),
    ExchangeRate,
    PrefetchHooks Function()>;
typedef $$SecurityPreferencesTableCreateCompanionBuilder
    = SecurityPreferencesCompanion Function({
  required String profileId,
  Value<String?> pinHash,
  Value<String?> pinSalt,
  Value<bool> biometricEnabled,
  Value<int> autoLockSeconds,
  Value<bool> lockOnBackground,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$SecurityPreferencesTableUpdateCompanionBuilder
    = SecurityPreferencesCompanion Function({
  Value<String> profileId,
  Value<String?> pinHash,
  Value<String?> pinSalt,
  Value<bool> biometricEnabled,
  Value<int> autoLockSeconds,
  Value<bool> lockOnBackground,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SecurityPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $SecurityPreferencesTable> {
  $$SecurityPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinSalt => $composableBuilder(
      column: $table.pinSalt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get biometricEnabled => $composableBuilder(
      column: $table.biometricEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get autoLockSeconds => $composableBuilder(
      column: $table.autoLockSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get lockOnBackground => $composableBuilder(
      column: $table.lockOnBackground,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SecurityPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $SecurityPreferencesTable> {
  $$SecurityPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinSalt => $composableBuilder(
      column: $table.pinSalt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get biometricEnabled => $composableBuilder(
      column: $table.biometricEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get autoLockSeconds => $composableBuilder(
      column: $table.autoLockSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get lockOnBackground => $composableBuilder(
      column: $table.lockOnBackground,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SecurityPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SecurityPreferencesTable> {
  $$SecurityPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get pinSalt =>
      $composableBuilder(column: $table.pinSalt, builder: (column) => column);

  GeneratedColumn<bool> get biometricEnabled => $composableBuilder(
      column: $table.biometricEnabled, builder: (column) => column);

  GeneratedColumn<int> get autoLockSeconds => $composableBuilder(
      column: $table.autoLockSeconds, builder: (column) => column);

  GeneratedColumn<bool> get lockOnBackground => $composableBuilder(
      column: $table.lockOnBackground, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SecurityPreferencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SecurityPreferencesTable,
    SecurityPreference,
    $$SecurityPreferencesTableFilterComposer,
    $$SecurityPreferencesTableOrderingComposer,
    $$SecurityPreferencesTableAnnotationComposer,
    $$SecurityPreferencesTableCreateCompanionBuilder,
    $$SecurityPreferencesTableUpdateCompanionBuilder,
    (
      SecurityPreference,
      BaseReferences<_$AppDatabase, $SecurityPreferencesTable,
          SecurityPreference>
    ),
    SecurityPreference,
    PrefetchHooks Function()> {
  $$SecurityPreferencesTableTableManager(
      _$AppDatabase db, $SecurityPreferencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SecurityPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SecurityPreferencesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SecurityPreferencesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> profileId = const Value.absent(),
            Value<String?> pinHash = const Value.absent(),
            Value<String?> pinSalt = const Value.absent(),
            Value<bool> biometricEnabled = const Value.absent(),
            Value<int> autoLockSeconds = const Value.absent(),
            Value<bool> lockOnBackground = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SecurityPreferencesCompanion(
            profileId: profileId,
            pinHash: pinHash,
            pinSalt: pinSalt,
            biometricEnabled: biometricEnabled,
            autoLockSeconds: autoLockSeconds,
            lockOnBackground: lockOnBackground,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String profileId,
            Value<String?> pinHash = const Value.absent(),
            Value<String?> pinSalt = const Value.absent(),
            Value<bool> biometricEnabled = const Value.absent(),
            Value<int> autoLockSeconds = const Value.absent(),
            Value<bool> lockOnBackground = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SecurityPreferencesCompanion.insert(
            profileId: profileId,
            pinHash: pinHash,
            pinSalt: pinSalt,
            biometricEnabled: biometricEnabled,
            autoLockSeconds: autoLockSeconds,
            lockOnBackground: lockOnBackground,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SecurityPreferencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SecurityPreferencesTable,
    SecurityPreference,
    $$SecurityPreferencesTableFilterComposer,
    $$SecurityPreferencesTableOrderingComposer,
    $$SecurityPreferencesTableAnnotationComposer,
    $$SecurityPreferencesTableCreateCompanionBuilder,
    $$SecurityPreferencesTableUpdateCompanionBuilder,
    (
      SecurityPreference,
      BaseReferences<_$AppDatabase, $SecurityPreferencesTable,
          SecurityPreference>
    ),
    SecurityPreference,
    PrefetchHooks Function()>;
typedef $$UiPreferencesTableCreateCompanionBuilder = UiPreferencesCompanion
    Function({
  required String profileId,
  Value<String> historySearch,
  Value<String> historyType,
  Value<String?> historyCategoryId,
  Value<String?> historyPaymentMethodId,
  Value<DateTime?> historyFrom,
  Value<DateTime?> historyTo,
  Value<String> historySort,
  Value<String> historyView,
  Value<DateTime?> calendarMonth,
  Value<int> firstWeekday,
  Value<bool> showHijri,
  Value<String> categorySort,
  Value<int> rowid,
});
typedef $$UiPreferencesTableUpdateCompanionBuilder = UiPreferencesCompanion
    Function({
  Value<String> profileId,
  Value<String> historySearch,
  Value<String> historyType,
  Value<String?> historyCategoryId,
  Value<String?> historyPaymentMethodId,
  Value<DateTime?> historyFrom,
  Value<DateTime?> historyTo,
  Value<String> historySort,
  Value<String> historyView,
  Value<DateTime?> calendarMonth,
  Value<int> firstWeekday,
  Value<bool> showHijri,
  Value<String> categorySort,
  Value<int> rowid,
});

class $$UiPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $UiPreferencesTable> {
  $$UiPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get historySearch => $composableBuilder(
      column: $table.historySearch, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get historyType => $composableBuilder(
      column: $table.historyType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get historyCategoryId => $composableBuilder(
      column: $table.historyCategoryId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get historyPaymentMethodId => $composableBuilder(
      column: $table.historyPaymentMethodId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get historyFrom => $composableBuilder(
      column: $table.historyFrom, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get historyTo => $composableBuilder(
      column: $table.historyTo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get historySort => $composableBuilder(
      column: $table.historySort, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get historyView => $composableBuilder(
      column: $table.historyView, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get calendarMonth => $composableBuilder(
      column: $table.calendarMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get firstWeekday => $composableBuilder(
      column: $table.firstWeekday, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showHijri => $composableBuilder(
      column: $table.showHijri, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categorySort => $composableBuilder(
      column: $table.categorySort, builder: (column) => ColumnFilters(column));
}

class $$UiPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $UiPreferencesTable> {
  $$UiPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get historySearch => $composableBuilder(
      column: $table.historySearch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get historyType => $composableBuilder(
      column: $table.historyType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get historyCategoryId => $composableBuilder(
      column: $table.historyCategoryId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get historyPaymentMethodId => $composableBuilder(
      column: $table.historyPaymentMethodId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get historyFrom => $composableBuilder(
      column: $table.historyFrom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get historyTo => $composableBuilder(
      column: $table.historyTo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get historySort => $composableBuilder(
      column: $table.historySort, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get historyView => $composableBuilder(
      column: $table.historyView, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get calendarMonth => $composableBuilder(
      column: $table.calendarMonth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get firstWeekday => $composableBuilder(
      column: $table.firstWeekday,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showHijri => $composableBuilder(
      column: $table.showHijri, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categorySort => $composableBuilder(
      column: $table.categorySort,
      builder: (column) => ColumnOrderings(column));
}

class $$UiPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UiPreferencesTable> {
  $$UiPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get historySearch => $composableBuilder(
      column: $table.historySearch, builder: (column) => column);

  GeneratedColumn<String> get historyType => $composableBuilder(
      column: $table.historyType, builder: (column) => column);

  GeneratedColumn<String> get historyCategoryId => $composableBuilder(
      column: $table.historyCategoryId, builder: (column) => column);

  GeneratedColumn<String> get historyPaymentMethodId => $composableBuilder(
      column: $table.historyPaymentMethodId, builder: (column) => column);

  GeneratedColumn<DateTime> get historyFrom => $composableBuilder(
      column: $table.historyFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get historyTo =>
      $composableBuilder(column: $table.historyTo, builder: (column) => column);

  GeneratedColumn<String> get historySort => $composableBuilder(
      column: $table.historySort, builder: (column) => column);

  GeneratedColumn<String> get historyView => $composableBuilder(
      column: $table.historyView, builder: (column) => column);

  GeneratedColumn<DateTime> get calendarMonth => $composableBuilder(
      column: $table.calendarMonth, builder: (column) => column);

  GeneratedColumn<int> get firstWeekday => $composableBuilder(
      column: $table.firstWeekday, builder: (column) => column);

  GeneratedColumn<bool> get showHijri =>
      $composableBuilder(column: $table.showHijri, builder: (column) => column);

  GeneratedColumn<String> get categorySort => $composableBuilder(
      column: $table.categorySort, builder: (column) => column);
}

class $$UiPreferencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UiPreferencesTable,
    UiPreference,
    $$UiPreferencesTableFilterComposer,
    $$UiPreferencesTableOrderingComposer,
    $$UiPreferencesTableAnnotationComposer,
    $$UiPreferencesTableCreateCompanionBuilder,
    $$UiPreferencesTableUpdateCompanionBuilder,
    (
      UiPreference,
      BaseReferences<_$AppDatabase, $UiPreferencesTable, UiPreference>
    ),
    UiPreference,
    PrefetchHooks Function()> {
  $$UiPreferencesTableTableManager(_$AppDatabase db, $UiPreferencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UiPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UiPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UiPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> profileId = const Value.absent(),
            Value<String> historySearch = const Value.absent(),
            Value<String> historyType = const Value.absent(),
            Value<String?> historyCategoryId = const Value.absent(),
            Value<String?> historyPaymentMethodId = const Value.absent(),
            Value<DateTime?> historyFrom = const Value.absent(),
            Value<DateTime?> historyTo = const Value.absent(),
            Value<String> historySort = const Value.absent(),
            Value<String> historyView = const Value.absent(),
            Value<DateTime?> calendarMonth = const Value.absent(),
            Value<int> firstWeekday = const Value.absent(),
            Value<bool> showHijri = const Value.absent(),
            Value<String> categorySort = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UiPreferencesCompanion(
            profileId: profileId,
            historySearch: historySearch,
            historyType: historyType,
            historyCategoryId: historyCategoryId,
            historyPaymentMethodId: historyPaymentMethodId,
            historyFrom: historyFrom,
            historyTo: historyTo,
            historySort: historySort,
            historyView: historyView,
            calendarMonth: calendarMonth,
            firstWeekday: firstWeekday,
            showHijri: showHijri,
            categorySort: categorySort,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String profileId,
            Value<String> historySearch = const Value.absent(),
            Value<String> historyType = const Value.absent(),
            Value<String?> historyCategoryId = const Value.absent(),
            Value<String?> historyPaymentMethodId = const Value.absent(),
            Value<DateTime?> historyFrom = const Value.absent(),
            Value<DateTime?> historyTo = const Value.absent(),
            Value<String> historySort = const Value.absent(),
            Value<String> historyView = const Value.absent(),
            Value<DateTime?> calendarMonth = const Value.absent(),
            Value<int> firstWeekday = const Value.absent(),
            Value<bool> showHijri = const Value.absent(),
            Value<String> categorySort = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UiPreferencesCompanion.insert(
            profileId: profileId,
            historySearch: historySearch,
            historyType: historyType,
            historyCategoryId: historyCategoryId,
            historyPaymentMethodId: historyPaymentMethodId,
            historyFrom: historyFrom,
            historyTo: historyTo,
            historySort: historySort,
            historyView: historyView,
            calendarMonth: calendarMonth,
            firstWeekday: firstWeekday,
            showHijri: showHijri,
            categorySort: categorySort,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UiPreferencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UiPreferencesTable,
    UiPreference,
    $$UiPreferencesTableFilterComposer,
    $$UiPreferencesTableOrderingComposer,
    $$UiPreferencesTableAnnotationComposer,
    $$UiPreferencesTableCreateCompanionBuilder,
    $$UiPreferencesTableUpdateCompanionBuilder,
    (
      UiPreference,
      BaseReferences<_$AppDatabase, $UiPreferencesTable, UiPreference>
    ),
    UiPreference,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FinancialTransactionsTableTableManager get financialTransactions =>
      $$FinancialTransactionsTableTableManager(_db, _db.financialTransactions);
  $$ExpenseCategoriesTableTableManager get expenseCategories =>
      $$ExpenseCategoriesTableTableManager(_db, _db.expenseCategories);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$SavingsGoalsTableTableManager get savingsGoals =>
      $$SavingsGoalsTableTableManager(_db, _db.savingsGoals);
  $$GoalContributionsTableTableManager get goalContributions =>
      $$GoalContributionsTableTableManager(_db, _db.goalContributions);
  $$BnplPlansTableTableManager get bnplPlans =>
      $$BnplPlansTableTableManager(_db, _db.bnplPlans);
  $$BnplInstalmentsTableTableManager get bnplInstalments =>
      $$BnplInstalmentsTableTableManager(_db, _db.bnplInstalments);
  $$RecurringPaymentsTableTableManager get recurringPayments =>
      $$RecurringPaymentsTableTableManager(_db, _db.recurringPayments);
  $$FinancialPreferencesTableTableManager get financialPreferences =>
      $$FinancialPreferencesTableTableManager(_db, _db.financialPreferences);
  $$PaymentMethodsTableTableManager get paymentMethods =>
      $$PaymentMethodsTableTableManager(_db, _db.paymentMethods);
  $$ReceiptAttachmentsTableTableManager get receiptAttachments =>
      $$ReceiptAttachmentsTableTableManager(_db, _db.receiptAttachments);
  $$BudgetCategoriesTableTableManager get budgetCategories =>
      $$BudgetCategoriesTableTableManager(_db, _db.budgetCategories);
  $$BudgetHistoryTableTableManager get budgetHistory =>
      $$BudgetHistoryTableTableManager(_db, _db.budgetHistory);
  $$RecurringOccurrencesTableTableManager get recurringOccurrences =>
      $$RecurringOccurrencesTableTableManager(_db, _db.recurringOccurrences);
  $$RecurringPaymentHistoryTableTableManager get recurringPaymentHistory =>
      $$RecurringPaymentHistoryTableTableManager(
          _db, _db.recurringPaymentHistory);
  $$SubscriptionPriceHistoryTableTableManager get subscriptionPriceHistory =>
      $$SubscriptionPriceHistoryTableTableManager(
          _db, _db.subscriptionPriceHistory);
  $$BnplPaymentHistoryTableTableManager get bnplPaymentHistory =>
      $$BnplPaymentHistoryTableTableManager(_db, _db.bnplPaymentHistory);
  $$NotificationSchedulesTableTableManager get notificationSchedules =>
      $$NotificationSchedulesTableTableManager(_db, _db.notificationSchedules);
  $$ExchangeRatesTableTableManager get exchangeRates =>
      $$ExchangeRatesTableTableManager(_db, _db.exchangeRates);
  $$SecurityPreferencesTableTableManager get securityPreferences =>
      $$SecurityPreferencesTableTableManager(_db, _db.securityPreferences);
  $$UiPreferencesTableTableManager get uiPreferences =>
      $$UiPreferencesTableTableManager(_db, _db.uiPreferences);
}
