import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'config/prod_config.dart';
import 'main.dart';

void main() {
  AppConfig.initialize(ProdConfig());
  runApp(const PaymentApp());
}
