import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dinarwise/core/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthSession {
  const AuthSession({
    required this.token,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.householdId,
  });

  final String token;
  final String userId;
  final String fullName;
  final String email;
  final String householdId;

  factory AuthSession.fromResponse(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return AuthSession(
      token: json['access_token'] as String,
      userId: user['id'] as String,
      fullName: user['full_name'] as String,
      email: user['email'] as String,
      householdId: user['household_id'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'userId': userId,
        'fullName': fullName,
        'email': email,
        'householdId': householdId,
      };

  factory AuthSession.fromStored(Map<String, dynamic> json) => AuthSession(
        token: json['token'] as String,
        userId: json['userId'] as String,
        fullName: json['fullName'] as String,
        email: json['email'] as String,
        householdId: json['householdId'] as String,
      );
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: 'access_token');
    final sessionJson = await storage.read(key: 'auth_session');
    if (token == null || sessionJson == null) return null;
    return AuthSession.fromStored(
      jsonDecode(sessionJson) as Map<String, dynamic>,
    );
  }

  Future<bool> login({required String email, required String password}) async {
    return _authenticate('/auth/login', {'email': email, 'password': password});
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String language,
  }) async {
    return _authenticate('/auth/register', {
      'full_name': fullName,
      'email': email,
      'password': password,
      'language': language,
      'country': 'SA',
    });
  }

  Future<bool> _authenticate(String path, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response =
          await ref.read(apiClientProvider).post<Map<String, dynamic>>(
                path,
                data: data,
              );
      final session = AuthSession.fromResponse(response.data!);
      final storage = ref.read(secureStorageProvider);
      await storage.write(key: 'access_token', value: session.token);
      await storage.write(
        key: 'auth_session',
        value: jsonEncode(session.toJson()),
      );
      state = AsyncData(session);
      return true;
    } on DioException catch (error, stackTrace) {
      final responseData = error.response?.data;
      final detail = responseData is Map<String, dynamic>
          ? responseData['detail']?.toString()
          : null;
      state = AsyncError(
        detail ?? 'Cannot connect to DinarWise. Make sure the API is running.',
        stackTrace,
      );
      return false;
    }
  }

  Future<void> logout() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'auth_session');
    state = const AsyncData(null);
  }
}
