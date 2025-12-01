class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;
}
