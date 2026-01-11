// DEPRECATED: This file is no longer used.
// The app now runs completely offline using LocalDataService.
// All law data is bundled in assets/data/ and loaded locally.

class AppConfig {
  // OFFLINE MODE: No API configuration needed
  // The app now uses LocalDataService instead of ApiService

  @Deprecated('App is now fully offline. API not used.')
  static const String apiBaseUrl = '';

  @Deprecated('App is now fully offline. API not used.')
  static const String apiKey = '';

  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;
}
