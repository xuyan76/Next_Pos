class ProductItem {
  final String barcode;
  final String name;
  final String unit;
  final double price;
  final int quantity;
  final double discount;
  bool isDeleted = false;

  ProductItem({
    required this.barcode,
    required this.name,
    required this.unit,
    required this.price,
    required this.quantity,
    this.discount = 0,
  });

  double get total => price * quantity - discount;
}
