import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../models/auth_tokens.dart';
import '../../models/auth_user.dart';
import '../../../../core/network/api_interceptors.dart';
import '../dto/auth_response_dto.dart';
import '../dto/login_request_dto.dart';
import '../mapper/auth_mapper.dart';

class AuthRepository {
  AuthRepository(this._apiClient);

  static const _loginPath = 'auth/login';
  static const _refreshPath = 'auth/refresh';
  static const _logoutPath = 'auth/logout';
  static const _mePath = 'auth/me';
  static const _changePasswordPath = 'auth/change-password';
  final ApiClient _apiClient;

  Future<AuthTokens> login({
    required String phone,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      _loginPath,
      data: LoginRequestDto(phone: phone, password: password).toJson(),
      options: Options(
        extra: {AuthenticationInterceptor.skipAuthRefreshKey: true},
      ),
    );
    final body = response.data;
    if (body == null) throw const FormatException('Empty login response.');
    return AuthMapper.toTokens(AuthResponseDto.fromJson(body));
  }

  Future<AuthTokens> refresh(String refreshToken) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      _refreshPath,
      data: {'refresh_token': refreshToken},
      options: Options(
        extra: {AuthenticationInterceptor.skipAuthRefreshKey: true},
      ),
    );
    final body = response.data;
    if (body == null) {
      throw const FormatException('Empty token refresh response.');
    }
    return AuthMapper.toTokens(AuthResponseDto.fromJson(body));
  }

  Future<AuthUser> currentUser() async {
    final response = await _apiClient.get<Map<String, dynamic>>(_mePath);
    final body = response.data;
    if (body == null) {
      throw const FormatException('Empty current user response.');
    }
    return AuthMapper.toUser(body);
  }

  Future<void> logout() => _apiClient.post<void>(
    _logoutPath,
    options: Options(
      extra: {AuthenticationInterceptor.skipAuthRefreshKey: true},
    ),
  );

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) => _apiClient.post<void>(
    _changePasswordPath,
    data: {'old_password': oldPassword, 'new_password': newPassword},
  );

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
