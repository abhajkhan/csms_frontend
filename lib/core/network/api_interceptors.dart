import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../errors/api_exception.dart';
import '../storage/token_storage.dart';

class AuthenticationInterceptor extends QueuedInterceptor {
  AuthenticationInterceptor(
    this._tokenStorage,
    this._refreshDio, {
    this.onSessionExpired,
  });

  static const skipAuthRefreshKey = 'skipAuthRefresh';
  static const _hasRetriedKey = 'hasRetriedAfterRefresh';
  final TokenStorage _tokenStorage;
  final Dio _refreshDio;
  final void Function()? onSessionExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final skipAuthentication = options.extra[skipAuthRefreshKey] == true;
    final token = await _tokenStorage.readAccessToken();
    if (!skipAuthentication && token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final canRefresh =
        err.response?.statusCode == 401 &&
        request.extra[skipAuthRefreshKey] != true &&
        request.extra[_hasRetriedKey] != true;
    if (!canRefresh) {
      handler.next(err);
      return;
    }

    try {
      final refreshToken = await _tokenStorage.readRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw StateError('No refresh token is available.');
      }
      final response = await _refreshDio.post<Map<String, dynamic>>(
        'auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final body = response.data;
      final accessToken = body?['access_token'];
      final nextRefreshToken = body?['refresh_token'];
      if (accessToken is! String || nextRefreshToken is! String) {
        throw const FormatException('Invalid token refresh response.');
      }
      await _tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: nextRefreshToken,
      );

      request.extra[_hasRetriedKey] = true;
      request.headers['Authorization'] = 'Bearer $accessToken';
      final responseAfterRefresh = await _refreshDio.fetch<dynamic>(request);
      handler.resolve(responseAfterRefresh);
    } catch (_) {
      await _tokenStorage.clear();
      onSessionExpired?.call();
      handler.next(err);
    }
  }
}

class ApiLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('API ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint('API ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    final message = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'The request timed out. Please try again.',
      DioExceptionType.connectionError =>
        'Unable to connect. Check your internet connection.',
      _ =>
        _responseMessage(response?.data) ??
            'Something went wrong. Please try again.',
    };
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: response,
        type: err.type,
        error: ApiException(message: message, statusCode: response?.statusCode),
      ),
    );
  }

  String? _responseMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'];
      if (message is String && message.isNotEmpty) return message;
      final detail = data['detail'];
      if (detail is String && detail.isNotEmpty) return detail;
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map && first['msg'] is String) {
          return first['msg'] as String;
        }
      }
    }
    return null;
  }
}
