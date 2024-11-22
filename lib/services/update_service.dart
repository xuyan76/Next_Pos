import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../config/app_config.dart';
import '../models/version_info.dart';

class UpdateService {
  static final UpdateService _instance = UpdateService._internal();
  factory UpdateService() => _instance;
  UpdateService._internal();

  Future<bool> checkForUpdates() async {
    try {
      // 获取当前版本信息
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // 从服务器获取最新版本信息
      final response = await http.get(
        Uri.parse('${AppConfig.instance.apiBaseUrl}/version'),
      );

      if (response.statusCode == 200) {
        final versionInfo = VersionInfo.fromJson(
          Map<String, dynamic>.from(response.body as Map),
        );

        // 比较版本号
        return _compareVersions(currentVersion, versionInfo.version) < 0;
      }
      return false;
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
