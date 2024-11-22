import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product_item.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '../widgets/payment_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String counterNo = "001";
  final String cashierName = "张三";
  String receiptNo = "0001";
  List<ProductItem> items = [
    ProductItem(
      barcode: '6901234567890',
      name: '可口可乐',
      unit: '瓶',
      price: 3.00,
      quantity: 2,
      discount: 1.00,
    ),
    ProductItem(
      barcode: '6902345678901',
      name: '百事可乐',
      unit: '瓶',
      price: 3.00,
      quantity: 1,
      discount: 0.00,
    ),
    ProductItem(
      barcode: '6903456789012',
      name: '康师傅方便面',
      unit: '袋',
      price: 4.50,
      quantity: 3,
      discount: 2.50,
    ),
    ProductItem(
      barcode: '6904567890123',
      name: '乐事薯片',
      unit: '包',
      price: 7.50,
      quantity: 2,
      discount: 1.00,
    ),
    ProductItem(
      barcode: '6905678901234',
      name: '农夫山泉矿泉水',
      unit: '瓶',
      price: 2.00,
      quantity: 5,
      discount: 1.00,
    ),
    ProductItem(
      barcode: '6906789012345',
      name: '奥利奥饼干',
      unit: '包',
      price: 8.50,
      quantity: 2,
      discount: 0.50,
    ),
    ProductItem(
      barcode: '6907890123456',
      name: '雪碧',
      unit: '瓶',
      price: 3.00,
      quantity: 3,
      discount: 1.50,
    ),
    ProductItem(
      barcode: '6908901234567',
      name: '红牛饮料',
      unit: '罐',
      price: 6.00,
      quantity: 4,
      discount: 2.00,
    ),
    ProductItem(
      barcode: '6909012345678',
      name: '卫龙辣条',
      unit: '包',
      price: 2.50,
      quantity: 5,
      discount: 1.00,
    ),
    ProductItem(
      barcode: '6900123456789',
      name: '旺旺雪饼',
      unit: '包',
      price: 5.50,
      quantity: 2,
      discount: 0.50,
    ),
    ProductItem(
      barcode: '6901234567891',
      name: '统一冰红茶',
      unit: '瓶',
      price: 3.50,
      quantity: 3,
      discount: 1.00,
    ),
    ProductItem(
      barcode: '6902345678902',
      name: '维他柠檬茶',
      unit: '瓶',
      price: 4.00,
      quantity: 2,
      discount: 0.50,
    ),
    ProductItem(
      barcode: '6903456789013',
      name: '好丽友派',
      unit: '盒',
      price: 12.00,
      quantity: 1,
      discount: 1.00,
    ),
    ProductItem(
      barcode: '6904567890124',
      name: '士力架巧克力',
      unit: '条',
      price: 5.00,
      quantity: 3,
      discount: 1.50,
    ),
    ProductItem(
      barcode: '6905678901235',
      name: '德芙巧克力',
      unit: '块',
      price: 7.50,
      quantity: 2,
      discount: 1.00,
    ),
    ProductItem(
      barcode: '6906789012346',
      name: '费列罗巧克力',
      unit: '盒',
      price: 48.00,
      quantity: 1,
      discount: 3.00,
    ),
    ProductItem(
      barcode: '6907890123457',
      name: '绿箭口香糖',
      unit: '盒',
      price: 6.00,
      quantity: 2,
      discount: 0.50,
    ),
    ProductItem(
      barcode: '6908901234568',
      name: '金丝猴奶糖',
      unit: '包',
      price: 8.50,
      quantity: 2,
      discount: 1.00,
    ),
    ProductItem(
      barcode: '6909012345679',
      name: '大白兔奶糖',
      unit: '包',
      price: 9.50,
      quantity: 2,
      discount: 1.00,
    ),
    ProductItem(
      barcode: '6900123456780',
      name: '喜之郎果冻',
      unit: '包',
      price: 4.50,
      quantity: 3,
      discount: 1.50,
    ),
    ProductItem(
      barcode: '6901234567892',
      name: '蒙牛纯牛奶',
      unit: '盒',
      price: 12.50,
      quantity: 2,
      discount: 1.00,
    ),
    ProductItem(
      barcode: '6902345678903',
      name: '伊利酸奶',
      unit: '盒',
      price: 8.50,
      quantity: 3,
      discount: 1.50,
    ),
    ProductItem(
      barcode: '6903456789014',
      name: '光明酸奶',
      unit: '瓶',
      price: 7.50,
      quantity: 2,
      discount: 1.00,
    ),
    ProductItem(
      barcode: '6904567890125',
      name: '三只松鼠坚果',
      unit: '包',
      price: 15.80,
      quantity: 2,
      discount: 2.00,
    ),
    ProductItem(
      barcode: '6905678901236',
      name: '良品铺子零食',
      unit: '包',
      price: 12.80,
      quantity: 2,
      discount: 1.50,
    ),
    ProductItem(
      barcode: '6906789012347',
      name: '百草味果干',
      unit: '包',
      price: 10.80,
      quantity: 3,
      discount: 2.00,
    ),
    ProductItem(
      barcode: '6907890123458',
      name: '洽洽瓜子',
      unit: '包',
      price: 8.80,
      quantity: 2,
      discount: 1.00,
    ),
    ProductItem(
      barcode: '6908901234569',
      name: '徐福记糖果',
      unit: '包',
      price: 9.80,
      quantity: 2,
      discount: 1.00,
    ),
    ProductItem(
      barcode: '6909012345670',
      name: '不二家棒棒糖',
      unit: '包',
      price: 7.80,
      quantity: 3,
      discount: 1.50,
    ),
    ProductItem(
      barcode: '6900123456781',
      name: '箭牌口香糖',
      unit: '盒',
      price: 6.80,
      quantity: 2,
      discount: 0.50,
    ),
  ];

  String _currentTime =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  late Timer _timer;

  // 添加选中行索引状态
  int selectedIndex = 0;
  // 添加焦点节点
  final FocusNode _tableFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _tableFocusNode.dispose(); // 释放焦点节点
    super.dispose();
  }

  // 修改键盘事件处理方法
  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      setState(() {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          if (selectedIndex > 0) {
            selectedIndex--;
          }
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          final visibleItems = items.where((item) => !item.isDeleted).toList();
          if (selectedIndex < visibleItems.length - 1) {
            selectedIndex++;
          }
        } else if (event.logicalKey == LogicalKeyboardKey.delete) {
          final visibleItems = items.where((item) => !item.isDeleted).toList();
          if (selectedIndex >= 0 && selectedIndex < visibleItems.length) {
            // 找到实际的项在原始列表中的索引
            final itemToDelete = visibleItems[selectedIndex];
            final originalIndex = items.indexOf(itemToDelete);
            items[originalIndex].isDeleted = true;

            // 更新选中索引
            if (selectedIndex >= visibleItems.length - 1) {
              selectedIndex = visibleItems.length - 2;
            }
            if (selectedIndex < 0) {
              selectedIndex = 0;
            }
          }
        } else if (event.logicalKey == LogicalKeyboardKey.keyU) {
          double totalAmount = items
              .where((item) => !item.isDeleted)
              .fold(0, (sum, item) => sum + item.total);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => PaymentDialog(totalAmount: totalAmount),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = items
        .where((item) => item.isDeleted == false)
        .fold(0, (sum, item) => sum + item.total);
    int totalItems = items.where((item) => item.isDeleted == false).length;
    int totalQuantity = items
        .where((item) => item.isDeleted == false)
        .fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 顶部信息区域
              Card(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(Icons.point_of_sale, '收款台号', counterNo),
                      _buildInfoItem(Icons.person, '收款员', cashierName),
                      _buildInfoItem(Icons.receipt, '小票号', receiptNo),
                      _buildInfoItem(
                        Icons.access_time,
                        '时间',
                        _currentTime,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 商品列表区域
              Expanded(
                flex: 2,
                child: Card(
                  elevation: 2,
                  child: KeyboardListener(
                    focusNode: _tableFocusNode,
                    onKeyEvent: _handleKeyEvent,
                    child: Column(
                      children: [
                        // 表头
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[700],
                            border: Border.all(color: Colors.grey[400]!),
                          ),
                          child: Row(
                            children: [
                              _buildTableHeader('序号', 1),
                              _buildTableHeader('条码', 2),
                              _buildTableHeader('名称', 4),
                              _buildTableHeader('单位', 1),
                              _buildTableHeader('单价', 2),
                              _buildTableHeader('数量', 2),
                              _buildTableHeader('金额', 2),
                              _buildTableHeader('折扣额', 2),
                            ],
                          ),
                        ),
                        // 商品列表
                        Expanded(
                          child: ListView.builder(
                            itemCount:
                                items.where((item) => !item.isDeleted).length,
                            itemBuilder: (context, index) {
                              // 获取未删除的项的列表
                              final visibleItems = items
                                  .where((item) => !item.isDeleted)
                                  .toList();
                              final item = visibleItems[index];
                              final isSelected = index == selectedIndex;

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                  _tableFocusNode.requestFocus();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blue[100]
                                        : (index.isEven
                                            ? Colors.grey[50]
                                            : Colors.white),
                                    border: Border(
                                      left:
                                          BorderSide(color: Colors.grey[400]!),
                                      right:
                                          BorderSide(color: Colors.grey[400]!),
                                      bottom:
                                          BorderSide(color: Colors.grey[400]!),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      _buildTableCell(
                                        '${index + 1}',
                                        1,
                                        alignment: TextAlign.center,
                                        backgroundColor: isSelected
                                            ? Colors.blue[100]
                                            : null,
                                      ),
                                      _buildTableCell(
                                        item.barcode,
                                        2,
                                        alignment: TextAlign.left,
                                        backgroundColor: isSelected
                                            ? Colors.blue[100]
                                            : null,
                                      ),
                                      _buildTableCell(
                                        item.name,
                                        4,
                                        fontWeight: FontWeight.w500,
                                        alignment: TextAlign.left,
                                        backgroundColor: isSelected
                                            ? Colors.blue[100]
                                            : null,
                                      ),
                                      _buildTableCell(item.unit, 1,
                                          backgroundColor: isSelected
                                              ? Colors.blue[100]
                                              : null),
                                      _buildTableCell(
                                        '¥${item.price.toStringAsFixed(2)}',
                                        2,
                                        color: Colors.blue[700],
                                        alignment: TextAlign.right,
                                        backgroundColor: isSelected
                                            ? Colors.blue[100]
                                            : null,
                                      ),
                                      _buildTableCell(
                                        '${item.quantity}',
                                        2,
                                        fontWeight: FontWeight.w500,
                                        alignment: TextAlign.right,
                                        backgroundColor: isSelected
                                            ? Colors.blue[100]
                                            : null,
                                      ),
                                      _buildTableCell(
                                        '¥${item.total.toStringAsFixed(2)}',
                                        2,
                                        fontWeight: FontWeight.w500,
                                        alignment: TextAlign.right,
                                        backgroundColor: isSelected
                                            ? Colors.blue[100]
                                            : null,
                                      ),
                                      _buildTableCell(
                                        '¥${item.discount.toStringAsFixed(2)}',
                                        2,
                                        color: Colors.red[700],
                                        alignment: TextAlign.right,
                                        backgroundColor: isSelected
                                            ? Colors.blue[100]
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 底部统计区域
              Card(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTotalItem(
                        '应收金额',
                        '¥${totalAmount.toStringAsFixed(2)}',
                        Colors.red[700]!,
                        28,
                      ),
                      _buildTotalItem(
                        '商品件数',
                        totalItems.toString(),
                        Colors.blue[700]!,
                        24,
                      ),
                      _buildTotalItem(
                        '商品总数量',
                        totalQuantity.toString(),
                        Colors.blue[700]!,
                        24,
                      ),
                    ],
                  ),
                ),
              ),

              // 快捷键信息区域
              const SizedBox(height: 16),

              Card(
                elevation: 2,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildShortcutItem(
                        Icons.keyboard_arrow_up,
                        '↑',
                        '向上选择',
                      ),
                      const SizedBox(width: 24),
                      _buildShortcutItem(
                        Icons.keyboard_arrow_down,
                        '↓',
                        '向下选择',
                      ),
                      const SizedBox(width: 24),
                      _buildShortcutItem(
                        Icons.keyboard_return,
                        'Enter',
                        '确认',
                      ),
                      const SizedBox(width: 24),
                      _buildShortcutItem(
                        Icons.space_bar,
                        'Space',
                        '数量',
                      ),
                      const SizedBox(width: 24),
                      _buildShortcutItem(
                        Icons.delete_outline,
                        'Del',
                        '删除',
                      ),
                      const SizedBox(width: 24),
                      _buildShortcutItem(
                        Icons.keyboard_tab,
                        'Tab',
                        '切换',
                      ),
                      const SizedBox(width: 24),
                      _buildShortcutItem(
                        Icons.payment,
                        'U',
                        '收款',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.blue[700],
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalItem(
    String label,
    String value,
    Color valueColor,
    double fontSize,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
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
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTableCell(
    String text,
    int flex, {
    Color? color,
    FontWeight? fontWeight,
    TextAlign alignment = TextAlign.center,
    Color? backgroundColor,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            right: BorderSide(color: Colors.grey[400]!),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: fontWeight,
            fontSize: 16,
          ),
          textAlign: alignment,
        ),
      ),
    );
  }

  Widget _buildShortcutItem(IconData icon, String key, String description) {
    return InkWell(
      onTap: () {
        // 模拟对应的键盘事件
        switch (key) {
          case '↑':
            _handleKeyEvent(const KeyDownEvent(
              physicalKey: PhysicalKeyboardKey.arrowUp,
              logicalKey: LogicalKeyboardKey.arrowUp,
              timeStamp: Duration.zero,
            ));
            break;
          case '↓':
            _handleKeyEvent(const KeyDownEvent(
              physicalKey: PhysicalKeyboardKey.arrowDown,
              logicalKey: LogicalKeyboardKey.arrowDown,
              timeStamp: Duration.zero,
            ));
            break;
          case 'Enter':
            // 处理Enter键事件
            break;
          case 'Space':
            // 处理空格键事件
            break;
          case 'Del':
            // 处理删除键事件
            break;
          case 'Tab':
            // 处理Tab键事件
            break;
          case 'U':
            _handleKeyEvent(const KeyDownEvent(
              physicalKey: PhysicalKeyboardKey.keyU,
              logicalKey: LogicalKeyboardKey.keyU,
              timeStamp: Duration.zero,
            ));
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: Text(
                key,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
