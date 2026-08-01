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

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appEnvironmentProvider);
  return Dio(
      BaseOptions(
        baseUrl: config.apiBaseUrl,
        contentType: ApiConfig.contentType,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
      ),
    )
    ..interceptors.addAll([
      AuthenticationInterceptor(ref.watch(tokenStorageProvider)),
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
