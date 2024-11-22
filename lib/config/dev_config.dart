import 'app_config.dart';

class DevConfig extends AppConfig {
  DevConfig()
      : super(
          apiBaseUrl: 'http://localhost:8080/api',
          environment: 'development',
          debugMode: true,
        );
}
