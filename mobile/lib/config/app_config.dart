class AppConfig {
  // Production API Configuration
  // IMPORTANT: This is the live backend URL deployed on Render.com
  static const String apiBaseUrl =
      'https://constitution-vault-api.onrender.com';

  // API Key for backend authentication
  // This key must match the APP_API_KEY environment variable on Render
  static const String apiKey = 'r_yMTVAe20WCVEogqOAgFgLkN-NSL79Gw8YMscfAysA';

  // For local development, temporarily change apiBaseUrl to:
  // - Android device: 'http://YOUR_PC_IP:8000' (find IP with ipconfig)
  // - Android emulator: 'http://10.0.2.2:8000'
  // - iOS simulator: 'http://localhost:8000'

  // For local development, temporarily change apiBaseUrl to:
  // - Android device: 'http://YOUR_PC_IP:8000' (find IP with ipconfig)
  // - Android emulator: 'http://10.0.2.2:8000'
  // - iOS simulator: 'http://localhost:8000'

  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;
}
