enum PaymentMethod { cash, wechat, alipay }

class SaleTransaction {
  final double amount;
  final PaymentMethod method;
  final DateTime dateTime;

  SaleTransaction({
    required this.amount,
    required this.method,
    required this.dateTime,
  });
}
