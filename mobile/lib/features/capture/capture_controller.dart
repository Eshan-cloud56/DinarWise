import 'package:dio/dio.dart';
import 'package:dinarwise/core/api_client.dart';
import 'package:dinarwise/features/auth/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Expense {
  const Expense({
    required this.id,
    required this.merchant,
    required this.amountMinor,
    required this.currency,
    required this.category,
    required this.transactedAt,
  });

  final String id;
  final String? merchant;
  final int amountMinor;
  final String currency;
  final String category;
  final DateTime transactedAt;

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json['id'] as String,
        merchant: json['merchant_name'] as String?,
        amountMinor: json['amount_minor'] as int,
        currency: json['currency'] as String,
        category: json['category_code'] as String,
        transactedAt: DateTime.parse(json['transacted_at'] as String),
      );
}

final expensesProvider =
    AsyncNotifierProvider<ExpensesController, List<Expense>>(
  ExpensesController.new,
);

class ExpensesController extends AsyncNotifier<List<Expense>> {
  @override
  Future<List<Expense>> build() => load();

  Future<List<Expense>> load() async {
    final session = ref.read(authControllerProvider).valueOrNull;
    if (session == null) return [];
    final response =
        await ref.read(apiClientProvider).get<List<dynamic>>(
      '/transactions',
      queryParameters: {'household_id': session.householdId},
    );
    return response.data!
        .map((item) => Expense.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<String?> addExpense({
    required String merchant,
    required String amount,
    required String category,
    required String notes,
    required DateTime date,
  }) async {
    final session = ref.read(authControllerProvider).valueOrNull;
    if (session == null) return 'Please sign in again.';
    final parsedAmount = double.tryParse(amount.trim());
    if (parsedAmount == null || parsedAmount <= 0) {
      return 'Enter a valid amount.';
    }
    try {
      await ref.read(apiClientProvider).post<Map<String, dynamic>>(
        '/transactions',
        data: {
          'household_id': session.householdId,
          'type': 'expense',
          'amount_minor': (parsedAmount * 100).round(),
          'currency': 'SAR',
          'merchant_name': merchant.trim(),
          'description': notes.trim().isEmpty ? null : notes.trim(),
          'category_code': category,
          'transacted_at': date.toUtc().toIso8601String(),
          'confirmed': true,
        },
      );
      state = await AsyncValue.guard(load);
      return null;
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map<String, dynamic> && data['detail'] != null) {
        return data['detail'].toString();
      }
      return 'Could not save the expense. Make sure the API is running.';
    }
  }
}
