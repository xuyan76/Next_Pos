import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'config/app_config.dart';
import 'config/dev_config.dart';
import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 首先初始化配置
  AppConfig.initialize(DevConfig());

  // 然后初始化数据库
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const PaymentApp());
}
