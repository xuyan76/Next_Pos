import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../config/app_config.dart';
import '../models/version_info.dart';
import 'http_client.dart';

class UpdateService {
  static final UpdateService _instance = UpdateService._internal();
  factory UpdateService() => _instance;
  UpdateService._internal();

  final _client = HttpClient();

  Future<bool> checkForUpdates() async {
    try {
      // 获取当前版本信息
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      print('当前版本: $currentVersion');

      // 从服务器获取最新版本信息
      final response = await _client.get(
        '/public/version/check',
        (json) {
          if (json['code'] != 200) return null;
          return VersionInfo.fromJson(json['data']);
        },
      );

      if (response == null) return false;

      print('服务器版本: ${response.version}');

      // 比较版本号
      final needUpdate = _compareVersions(currentVersion, response.version) < 0;

      // 如果需要更新，检查是否低于最低支持版本
      if (needUpdate && response.minVersion != null) {
        final isObsolete =
            _compareVersions(currentVersion, response.minVersion!) < 0;
        if (isObsolete) {
          print('当前版本低于最低支持版本，需要强制更新');
          return true;
        }
      }

      return needUpdate;
    } catch (e) {
      print('检查更新失败: $e');
      return false;
    }
  }

  Future<void> downloadUpdate(VersionInfo versionInfo) async {
    try {
      // 获取下载目录
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/update.exe';

      // 下载文件
      final response = await http.get(Uri.parse(versionInfo.downloadUrl));
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // 启动安装程序
      await Process.start(filePath, []);

      // 退出当前应用
      exit(0);
    } catch (e) {
      print('下载更新失败: $e');
      rethrow;
    }
  }

  int _compareVersions(String v1, String v2) {
    List<int> v1Parts = v1.split('.').map(int.parse).toList();
    List<int> v2Parts = v2.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      if (v1Parts[i] < v2Parts[i]) return -1;
      if (v1Parts[i] > v2Parts[i]) return 1;
    }
    return 0;
  }
}
