class PaymentRecord {
  final int index;
  final String method;
  final double amount;
  final double change;

  PaymentRecord({
    required this.index,
    required this.method,
    required this.amount,
    required this.change,
  });
}
