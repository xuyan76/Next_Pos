import 'package:flutter/material.dart';
import '../models/version_info.dart';

class UpdateDialog extends StatelessWidget {
  final VersionInfo versionInfo;
  final VoidCallback onUpdate;
  final VoidCallback? onCancel;

  const UpdateDialog({
    super.key,
    required this.versionInfo,
    required this.onUpdate,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('发现新版本'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('新版本: ${versionInfo.version}'),
          const SizedBox(height: 8),
          const Text('更新内容：'),
          Text(versionInfo.releaseNotes),
        ],
      ),
      actions: [
        if (!versionInfo.forceUpdate)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
            child: const Text('稍后再说'),
          ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onUpdate();
          },
          child: const Text('立即更新'),
        ),
      ],
    );
  }
}
