import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../models/auth_session.dart';
import '../dto/auth_response_dto.dart';
import '../dto/login_request_dto.dart';
import '../mapper/auth_mapper.dart';

class AuthRepository {
  AuthRepository(this._apiClient);

  static const _loginPath = '/auth/login';
  final ApiClient _apiClient;

  Future<AuthSession> login({
    required String usernameOrPhone,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      _loginPath,
      data: LoginRequestDto(
        usernameOrPhone: usernameOrPhone,
        password: password,
      ).toJson(),
    );
    final body = response.data;
    if (body == null) throw const FormatException('Empty login response.');
    final payload = body['data'] is Map<String, dynamic>
        ? body['data'] as Map<String, dynamic>
        : body;
    return AuthMapper.toSession(AuthResponseDto.fromJson(payload));
  }

  /// TODO(api): Replace these paths and implementations when password recovery
  /// endpoints are supplied by the CSMS backend contract.
  Future<void> requestPasswordResetOtp(String phone) =>
      _passwordRecoveryUnavailable();

  Future<void> verifyPasswordResetOtp({
    required String phone,
    required String otp,
  }) => _passwordRecoveryUnavailable();

  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) => _passwordRecoveryUnavailable();

  Future<void> _passwordRecoveryUnavailable() => Future<void>.error(
    DioException(
      requestOptions: RequestOptions(path: '/auth/password-recovery'),
      error: 'Password recovery API is not configured.',
    ),
  );
}
