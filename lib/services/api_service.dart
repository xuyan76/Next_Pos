import 'http_client.dart';
import 'database_helper.dart';
import '../models/product_item.dart';
import '../models/transaction.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final _client = HttpClient();
  final _db = DatabaseHelper();

  Future<bool> ping() async {
    try {
      await _client.get(
        '/ping',
        (json) => json['status'] == 'ok',
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getPosConfig() async {
    return _client.get(
      '/pos/config',
      (json) => json['data'] as Map<String, dynamic>,
    );
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    return _client.post(
      '/login',
      {
        'username': username,
        'password': password,
      },
      (json) => json,
    );
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    return _client.get(
      '/products',
      (json) => List<Map<String, dynamic>>.from(json['data']),
    );
  }

  Future<void> syncProducts() async {
    try {
      // 从服务器获取商品数据
      final products = await getProducts();

      // 保存到本地数据库
      for (var product in products) {
        await _db.insertProduct(ProductItem(
          barcode: product['barcode'],
          name: product['name'],
          unit: product['unit'],
          price: product['price'],
          quantity: product['stock'],
        ));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveTransaction(
      SaleTransaction transaction, List<ProductItem> items) async {
    try {
      // 保存到本地数据库
      final transactionId = await _db.insertTransaction(transaction, items);

      // 同步到服务器
      await _client.post(
        '/transactions',
        {
          'id': transactionId,
          'amount': transaction.amount,
          'payment_method': transaction.method.toString(),
          'items': items
              .map((item) => {
                    'barcode': item.barcode,
                    'quantity': item.quantity,
                    'price': item.price,
                    'discount': item.discount,
                  })
              .toList(),
        },
        (json) => json,
      );
    } catch (e) {
      rethrow;
    }
  }

  // 添加更多API方法...
}
