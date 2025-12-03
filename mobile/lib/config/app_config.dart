class AppConfig {
  // For Android device: Use your computer's local IP (check with ipconfig)
  // For Android emulator: Use 10.0.2.2
  // For iOS simulator: Use localhost
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue:
        'http://192.168.0.102:8000', // Your local IP for physical device
  );

  // API Key for backend authentication
  // IMPORTANT: Change this to match your backend's APP_API_KEY
  // For production, use environment variables or secure storage
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: 'your-api-key-here-change-in-production',
  );

  // Alternative: Use your computer's local IP for physical device
  // Find your IP with: ipconfig (Windows) or ifconfig (Mac/Linux)
  // Example: 'http://192.168.1.100:8000'

  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;
}
