import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_config.dart';
import '../core/config/app_environment.dart';
import '../core/network/api_client.dart';
import '../core/network/api_interceptors.dart';
import '../core/storage/token_storage.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'SharedPreferences must be initialized in bootstrap.',
  ),
);

final appEnvironmentProvider = Provider<AppEnvironmentConfig>(
  (ref) => AppEnvironmentConfig.fromBuildConfiguration(),
);

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(ref.watch(secureStorageProvider)),
);

/// Incremented when refresh authentication fails so the UI can leave an
/// invalid server session immediately.
final sessionInvalidationProvider = StateProvider<int>((ref) => 0);

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appEnvironmentProvider);
  final options = BaseOptions(
    baseUrl: config.apiBaseUrl,
    contentType: ApiConfig.contentType,
    connectTimeout: ApiConfig.connectTimeout,
    receiveTimeout: ApiConfig.receiveTimeout,
    sendTimeout: ApiConfig.sendTimeout,
  );
  final refreshDio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      contentType: ApiConfig.contentType,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
    ),
  );
  return Dio(options)
    ..interceptors.addAll([
      AuthenticationInterceptor(
        ref.watch(tokenStorageProvider),
        refreshDio,
        onSessionExpired: () =>
            ref.read(sessionInvalidationProvider.notifier).state++,
      ),
      ApiLogInterceptor(),
    ]);
});

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(dioProvider)),
);

class ThemeModeController extends Notifier<ThemeMode> {
  static const _themeKey = 'theme_mode';

  @override
  ThemeMode build() {
    final savedValue = ref
        .watch(sharedPreferencesProvider)
        .getString(_themeKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == savedValue,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref.read(sharedPreferencesProvider).setString(_themeKey, mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);
