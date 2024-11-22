import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/login_screen.dart';
import 'services/update_service.dart';
import 'models/version_info.dart';
import 'widgets/update_dialog.dart';
import 'screens/startup_check_screen.dart';
import 'db/db_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 sqflite_ffi
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // 初始化数据库
  final dbManager = DbManager();
  await dbManager.database; // 确保今天的数据库已创建
  await dbManager.cleanupOldDatabases(); // 清理旧数据库

  // 检查更新
  final updateService = UpdateService();
  final hasUpdate = await updateService.checkForUpdates();

  runApp(PaymentApp(hasUpdate: hasUpdate));
}

class PaymentApp extends StatelessWidget {
  final bool hasUpdate;

  const PaymentApp({
    super.key,
    this.hasUpdate = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '收款系统',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const StartupCheckScreen(),
      builder: (context, child) {
        if (hasUpdate) {
          // 显示更新对话框
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => UpdateDialog(
                versionInfo: VersionInfo(
                  version: '1.0.1',
                  downloadUrl: 'https://example.com/update.exe',
                  releaseNotes: '1. 修复已知问题\n2. 优化用户体验',
                ),
                onUpdate: () async {
                  // 执行更新
                  await UpdateService().downloadUpdate(
                    VersionInfo(
                      version: '1.0.1',
                      downloadUrl: 'https://example.com/update.exe',
                      releaseNotes: '1. 修复已知问题\n2. 优化用户体验',
                    ),
                  );
                },
              ),
            );
          });
        }
        return child!;
      },
    );
  }
}
