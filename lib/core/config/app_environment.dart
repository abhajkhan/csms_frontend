enum AppEnvironment { development, staging, production }

class AppEnvironmentConfig {
  const AppEnvironmentConfig({
    required this.environment,
    required this.apiBaseUrl,
  });

  final AppEnvironment environment;
  final String apiBaseUrl;

  factory AppEnvironmentConfig.fromBuildConfiguration() {
    const environmentName = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );
    const configuredApiUrl = String.fromEnvironment('API_BASE_URL');
    final environment = switch (environmentName) {
      'production' => AppEnvironment.production,
      'staging' => AppEnvironment.staging,
      _ => AppEnvironment.development,
    };
    final fallbackUrl = switch (environment) {
      AppEnvironment.development => 'http://localhost:8080/api',
      AppEnvironment.staging => 'https://staging-api.example.com/api',
      AppEnvironment.production => 'https://api.example.com/api',
    };
    return AppEnvironmentConfig(
      environment: environment,
      apiBaseUrl: configuredApiUrl.isEmpty ? fallbackUrl : configuredApiUrl,
    );
  }
}
