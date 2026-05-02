// This file used to hold remote-API configuration. The app is now fully
// offline (data is bundled under `assets/data/`) so no API config is
// needed. The file is kept so any older references still resolve.
class AppConfig {
  /// True only in debug builds.
  static const bool isDebug =
      bool.fromEnvironment('dart.vm.product') == false;
}
