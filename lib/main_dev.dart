import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'config/dev_config.dart';
import 'main.dart';

void main() {
  AppConfig.initialize(DevConfig());
  runApp(const PaymentApp());
}
