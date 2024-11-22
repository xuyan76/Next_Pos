import 'package:flutter/material.dart';
import '../services/startup_check_service.dart';
import 'login_screen.dart';

class StartupCheckScreen extends StatefulWidget {
  const StartupCheckScreen({super.key});

  @override
  State<StartupCheckScreen> createState() => _StartupCheckScreenState();
}

class _StartupCheckScreenState extends State<StartupCheckScreen> {
  final _checkService = StartupCheckService();
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _startCheck();
  }

  Future<void> _startCheck() async {
    final canContinue = await _checkService.performStartupCheck(
      (index, status, error) {
        setState(() {
          _checkService.checkItems[index].status = status;
          _checkService.checkItems[index].errorMessage = error;
        });
      },
    );

    setState(() {
      _isChecking = false;
    });

    if (canContinue && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '系统启动检查',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              ...List.generate(
                _checkService.checkItems.length,
                (index) => _buildCheckItem(_checkService.checkItems[index]),
              ),
              if (!_isChecking &&
                  _checkService.checkItems
                      .any((item) => item.status == CheckStatus.failed))
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isChecking = true;
                        for (var item in _checkService.checkItems) {
                          item.status = CheckStatus.pending;
                          item.errorMessage = null;
                        }
                      });
                      _startCheck();
                    },
                    child: const Text('重试'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckItem(CheckItem item) {
    IconData icon;
    Color iconColor;
    Widget? trailing;

    switch (item.status) {
      case CheckStatus.pending:
        icon = Icons.radio_button_unchecked;
        iconColor = Colors.grey;
        break;
      case CheckStatus.checking:
        icon = Icons.refresh;
        iconColor = Colors.blue;
        trailing = const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
        break;
      case CheckStatus.success:
        icon = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case CheckStatus.failed:
        icon = Icons.error;
        iconColor = Colors.red;
        trailing = item.errorMessage != null
            ? Text(
                item.errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              )
            : null;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Text(
            item.name,
            style: const TextStyle(fontSize: 16),
          ),
          if (item.isCritical)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                '(必需)',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          if (trailing != null) ...[
            const Spacer(),
            trailing,
          ],
        ],
      ),
    );
  }
}
