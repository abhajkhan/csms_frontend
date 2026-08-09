import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AppEnvironment { development, staging, production }

class AppEnvironmentConfig {
  const AppEnvironmentConfig({
    required this.environment,
    required this.apiBaseUrl,
  });

  final AppEnvironment environment;
  final String apiBaseUrl;

  factory AppEnvironmentConfig.fromBuildConfiguration() {
    const configuredEnvironmentName = String.fromEnvironment(
      'APP_ENV',
      defaultValue: '',
    );
    const configuredApiUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: '',
    );

    final environmentName = configuredEnvironmentName.isNotEmpty
        ? configuredEnvironmentName
        : dotenv.env['APP_ENV'] ?? '';
    final runtimeApiUrl = configuredApiUrl.isNotEmpty
        ? configuredApiUrl
        : dotenv.env['API_BASE_URL'] ?? '';

    final environment = switch (environmentName) {
      'production' => AppEnvironment.production,
      'staging' => AppEnvironment.staging,
      _ => AppEnvironment.development,
    };
    final fallbackUrl = switch (environment) {
      // Keep the versioned API prefix in endpoint paths. This makes an
      // API_BASE_URL build value the backend origin (for example,
      // https://api.example.com) rather than a partially-versioned path.
      AppEnvironment.development => 'http://localhost:8000',
      AppEnvironment.staging => 'https://staging-api.example.com',
      AppEnvironment.production => 'https://api.example.com',
    };
    return AppEnvironmentConfig(
      environment: environment,
      apiBaseUrl: runtimeApiUrl.isNotEmpty ? runtimeApiUrl : fallbackUrl,
    );
  }
}
