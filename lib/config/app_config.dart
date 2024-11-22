class AppConfig {
  final String apiBaseUrl;
  final String environment;
  final bool debugMode;

  AppConfig({
    required this.apiBaseUrl,
    required this.environment,
    required this.debugMode,
  });

  static late AppConfig _instance;

  static void initialize(AppConfig config) {
    _instance = config;
  }

  static AppConfig get instance => _instance;
}
