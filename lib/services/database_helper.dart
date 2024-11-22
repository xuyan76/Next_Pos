import 'package:sqflite/sqflite.dart';
import '../models/product_item.dart';
import '../models/transaction.dart';
import '../db/db_manager.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  final _dbManager = DbManager();

  Future<Database> get database async => await _dbManager.database;

  // 商品相关操作
  Future<int> insertProduct(ProductItem product) async {
    Database db = await database;
    return await db.insert(
      'products',
      {
        'barcode': product.barcode,
        'name': product.name,
        'unit': product.unit,
        'price': product.price,
        'stock': product.quantity,
        'is_deleted': product.isDeleted ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ProductItem>> getProducts({bool includeDeleted = false}) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: includeDeleted ? null : 'is_deleted = 0',
    );

    return List.generate(maps.length, (i) {
      return ProductItem(
        barcode: maps[i]['barcode'],
        name: maps[i]['name'],
        unit: maps[i]['unit'],
        price: maps[i]['price'],
        quantity: maps[i]['stock'],
      );
    });
  }

  Future<void> updateProduct(ProductItem product) async {
    Database db = await database;
    await db.update(
      'products',
      {
        'name': product.name,
        'unit': product.unit,
        'price': product.price,
        'stock': product.quantity,
        'is_deleted': product.isDeleted ? 1 : 0,
      },
      where: 'barcode = ?',
      whereArgs: [product.barcode],
    );
  }

  // 交易相关操作
  Future<int> insertTransaction(
      SaleTransaction transaction, List<ProductItem> items) async {
    Database db = await database;
    return await db.transaction((txn) async {
      // 插入交易主表
      final transactionId = await txn.insert(
        'transactions',
        {
          'amount': transaction.amount,
          'payment_method': transaction.method.toString(),
          'created_at': transaction.dateTime.toIso8601String(),
          'cashier_id': 'current_cashier_id', // 需要从登录信息中获取
          'receipt_no': 'receipt_${DateTime.now().millisecondsSinceEpoch}',
        },
      );

      // 插入交易明细
      for (var item in items) {
        await txn.insert(
          'transaction_items',
          {
            'transaction_id': transactionId,
            'barcode': item.barcode,
            'quantity': item.quantity,
            'price': item.price,
            'discount': item.discount,
          },
        );

        // 更新库存
        await txn.rawUpdate(
          'UPDATE products SET stock = stock - ? WHERE barcode = ?',
          [item.quantity, item.barcode],
        );
      }

      return transactionId;
    });
  }

  Future<List<Map<String, dynamic>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    Database db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (startDate != null) {
      whereClause += 'created_at >= ?';
      whereArgs.add(startDate.toIso8601String());
    }
    if (endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'created_at <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    return await db.query(
      'transactions',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'created_at DESC',
    );
  }

  // 设置相关操作
  Future<void> setSetting(String key, String value) async {
    Database db = await database;
    await db.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    return result.isNotEmpty ? result.first['value'] as String : null;
  }
}
