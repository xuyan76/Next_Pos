import 'dart:async';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'update_service.dart';
import '../models/version_info.dart';

enum CheckStatus {
  pending,
  checking,
  success,
  failed,
}

class CheckItem {
  final String name;
  final bool isCritical;
  CheckStatus status;
  String? errorMessage;

  CheckItem({
    required this.name,
    this.isCritical = false,
    this.status = CheckStatus.pending,
    this.errorMessage,
  });
}

class StartupCheckService {
  static final StartupCheckService _instance = StartupCheckService._internal();
  factory StartupCheckService() => _instance;
  StartupCheckService._internal();

  final List<CheckItem> checkItems = [
    CheckItem(name: '后台服务连接检查', isCritical: true),
    CheckItem(name: '版本更新检查', isCritical: false),
    CheckItem(name: 'POS参数配置', isCritical: true),
  ];

  Future<bool> checkBackendService() async {
    try {
      await ApiService().ping();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkForUpdates() async {
    try {
      return await UpdateService().checkForUpdates();
    } catch (e) {
      return false;
    }
  }

  Future<bool> loadPosConfig() async {
    try {
      await ApiService().getPosConfig();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> performStartupCheck(
    void Function(int index, CheckStatus status, String? error) onItemChecked,
  ) async {
    bool canContinue = true;

    // 检查后台服务
    onItemChecked(0, CheckStatus.checking, null);
    if (await checkBackendService()) {
      onItemChecked(0, CheckStatus.success, null);
    } else {
      onItemChecked(0, CheckStatus.failed, '无法连接到后台服务');
      return false; // 关键检查失败
    }

    // 检查更新
    onItemChecked(1, CheckStatus.checking, null);
    if (await checkForUpdates()) {
      onItemChecked(1, CheckStatus.success, null);
    } else {
      onItemChecked(1, CheckStatus.failed, '检查更新失败');
      // 非关键检查，继续执行
    }

    // 加载POS配置
    onItemChecked(2, CheckStatus.checking, null);
    if (await loadPosConfig()) {
      onItemChecked(2, CheckStatus.success, null);
    } else {
      onItemChecked(2, CheckStatus.failed, '无法加载POS配置');
      return false; // 关键检查失败
    }

    return canContinue;
  }
}
