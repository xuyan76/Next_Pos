import 'package:flutter/material.dart';
import '../models/payment_record.dart';

class PaymentDialog extends StatefulWidget {
  final double totalAmount;

  const PaymentDialog({
    super.key,
    required this.totalAmount,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final String _inputAmount = '';
  final int _selectedPaymentMethod = 0;
  List<PaymentRecord> paymentRecords = [
    PaymentRecord(index: 1, method: '现金', amount: 50.00, change: 0.00),
    PaymentRecord(index: 2, method: '银行卡', amount: 100.00, change: 0.00),
    PaymentRecord(index: 3, method: '微信', amount: 88.88, change: 0.00),
    PaymentRecord(index: 4, method: '支付宝', amount: 66.66, change: 0.00),
  ];

  @override
  Widget build(BuildContext context) {
    double inputAmountValue = double.tryParse(_inputAmount) ?? 0;
    double changeAmount = inputAmountValue - widget.totalAmount;

    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: 800, // 加宽对话框
          height: 600, // 加高对话框
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 标题栏
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '收款',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),

              // 应收金额显示
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '应收金额：',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '¥${widget.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),

              // 支付记录表格
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      // 表头
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[700],
                        ),
                        child: Row(
                          children: [
                            _buildTableHeader('序号', 1),
                            _buildTableHeader('收款方式', 2),
                            _buildTableHeader('收款金额', 2),
                            _buildTableHeader('找零金额', 2),
                          ],
                        ),
                      ),
                      // 表格内容
                      Expanded(
                        child: Table(
                          border: TableBorder(
                            verticalInside:
                                BorderSide(color: Colors.grey[400]!),
                            horizontalInside:
                                BorderSide(color: Colors.grey[400]!),
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(2),
                          },
                          children: paymentRecords.map((record) {
                            int index = paymentRecords.indexOf(record);
                            return TableRow(
                              decoration: BoxDecoration(
                                color: index.isEven
                                    ? Colors.white
                                    : Colors.grey[50],
                              ),
                              children: [
                                _buildTableCell(record.index.toString(), 1),
                                _buildTableCell(record.method, 2),
                                _buildTableCell(
                                  '¥${record.amount.toStringAsFixed(2)}',
                                  2,
                                  color: Colors.blue[700],
                                ),
                                _buildTableCell(
                                  '¥${record.change.toStringAsFixed(2)}',
                                  2,
                                  color: Colors.orange[700],
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 底部按钮区域
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 处理确认逻辑
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        backgroundColor: Colors.blue[700],
                        minimumSize: const Size(120, 48),
                      ),
                      child: const Text(
                        '确认',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        backgroundColor: Colors.grey[300],
                        minimumSize: const Size(120, 48),
                      ),
                      child: Text(
                        '取消',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey[400]!),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, int flex, {Color? color}) {
    bool isAmount = text.startsWith('¥');
    bool isPaymentMethod =
        !text.startsWith('¥') && !RegExp(r'^\d+$').hasMatch(text);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        textAlign: isPaymentMethod
            ? TextAlign.left
            : (isAmount ? TextAlign.right : TextAlign.center),
      ),
    );
  }
}
