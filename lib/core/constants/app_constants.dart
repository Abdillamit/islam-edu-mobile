class AppConstants {
  const AppConstants._();

  static const String defaultApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  static const int defaultPageSize = 20;
}
