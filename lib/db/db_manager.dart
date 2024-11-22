import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {
  static final DbManager _instance = DbManager._internal();
  static Database? _database;

  factory DbManager() => _instance;
  DbManager._internal();

  Future<String> get _dbPath async {
    // 获取应用文档目录
    final appDir = await getApplicationDocumentsDirectory();
    // 创建db子目录
    final dbDir = Directory('${appDir.path}/db');
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }

    // 生成今天的数据库文件名
    final today = DateFormat('yyyyMMdd').format(DateTime.now());
    return join(dbDir.path, 'posdata_$today.db');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await _dbPath;
    final dbExists = await File(path).exists();

    if (!dbExists) {
      // 如果数据库不存在，复制前一天的数据（如果有的话）
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayPath = join(
        dirname(path),
        'posdata_${DateFormat('yyyyMMdd').format(yesterday)}.db',
      );

      if (await File(yesterdayPath).exists()) {
        await File(yesterdayPath).copy(path);
      }
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 创建商品表
    await db.execute('''
      CREATE TABLE products (
        barcode TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        unit TEXT NOT NULL,
        price REAL NOT NULL,
        stock INTEGER DEFAULT 0,
        is_deleted INTEGER DEFAULT 0
      )
    ''');

    // 创建交易表
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        payment_method TEXT NOT NULL,
        created_at TEXT NOT NULL,
        cashier_id TEXT NOT NULL,
        receipt_no TEXT NOT NULL
      )
    ''');

    // 创建交易明细表
    await db.execute('''
      CREATE TABLE transaction_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transaction_id INTEGER NOT NULL,
        barcode TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        discount REAL DEFAULT 0,
        FOREIGN KEY (transaction_id) REFERENCES transactions (id),
        FOREIGN KEY (barcode) REFERENCES products (barcode)
      )
    ''');

    // 创建配置表
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  // 获取所有数据库文件
  Future<List<File>> getAllDatabases() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dbDir = Directory('${appDir.path}/db');
    if (!await dbDir.exists()) return [];

    return dbDir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.db'))
        .toList();
  }

  // 获取指定日期的数据库
  Future<Database?> getDatabaseForDate(DateTime date) async {
    final dateStr = DateFormat('yyyyMMdd').format(date);
    final appDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDir.path, 'db', 'posdata_$dateStr.db');

    if (!await File(dbPath).exists()) return null;

    return await openDatabase(dbPath, version: 1);
  }

  // 清理旧数据库文件（保留最近30天）
  Future<void> cleanupOldDatabases() async {
    final files = await getAllDatabases();
    final today = DateTime.now();

    for (var file in files) {
      final fileName = basename(file.path);
      final match = RegExp(r'posdata_(\d{8})\.db').firstMatch(fileName);
      if (match != null) {
        final dateStr = match.group(1)!;
        final fileDate = DateFormat('yyyyMMdd').parse(dateStr);
        final difference = today.difference(fileDate).inDays;

        if (difference > 30) {
          await file.delete();
        }
      }
    }
  }
}
