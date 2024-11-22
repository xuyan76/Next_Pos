import 'app_config.dart';

class ProdConfig extends AppConfig {
  ProdConfig()
      : super(
          apiBaseUrl: 'https://api.yourproduction.com/api',
          environment: 'production',
          debugMode: false,
        );
}
