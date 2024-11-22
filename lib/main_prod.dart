import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'config/app_config.dart';
import 'config/prod_config.dart';
import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 sqflite_ffi
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  AppConfig.initialize(ProdConfig());
  runApp(const PaymentApp());
}
