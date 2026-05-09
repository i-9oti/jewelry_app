import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/product_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('jewelry_multi_user_v2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // إذا كان الإصدار قديماً، نقوم بحذف الجدول وإعادة بنائه بالهيكلية الجديدة
    if (oldVersion < 5) {
      await db.execute('DROP TABLE IF EXISTS products');
      await _createProductsTable(db);
    }
  }

  Future _createProductsTable(Database db) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL, -- جعلناه اختيارياً
        category TEXT NOT NULL,
        karat TEXT NOT NULL,
        weight REAL NOT NULL,
        stoneWeight REAL NOT NULL,
        rating REAL NOT NULL,
        image TEXT NOT NULL
      )
    ''');
    for (var product in ProductData.products) {
      // ننشئ نسخة من البيانات ونضيف لها سعراً افتراضياً لتجنب الخطأ
      final Map<String, dynamic> p = Map<String, dynamic>.from(product);
      p['price'] = 0.0;
      await db.insert('products', p);
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        profile_image TEXT
      )
    ''');

    await _createProductsTable(db);

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userEmail TEXT NOT NULL,
        orderDate TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        productNames TEXT NOT NULL, 
        status TEXT DEFAULT 'Completed'
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userEmail TEXT NOT NULL,
        productName TEXT NOT NULL,
        UNIQUE(userEmail, productName)
      )
    ''');

    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userEmail TEXT NOT NULL,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        qty INTEGER NOT NULL,
        image TEXT DEFAULT "",
        UNIQUE(userEmail, name)
      )
    ''');
  }

  // --- السلة ---
  Future<int> addToCart(
    String userEmail,
    String name,
    double price,
    int qty, [
    String? image,
  ]) async {
    final db = await instance.database;
    return await db.insert('cart', {
      'userEmail': userEmail,
      'name': name,
      'price': price,
      'qty': qty,
      'image': image ?? '',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateCartQty(String userEmail, String name, int qty) async {
    final db = await instance.database;
    return await db.update(
      'cart',
      {'qty': qty},
      where: 'userEmail = ? AND name = ?',
      whereArgs: [userEmail, name],
    );
  }

  Future<List<Map<String, dynamic>>> getCartItems(String userEmail) async {
    final db = await instance.database;
    return await db.query(
      'cart',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
    );
  }

  Future<int> removeFromCart(String userEmail, String name) async {
    final db = await instance.database;
    return await db.delete(
      'cart',
      where: 'userEmail = ? AND name = ?',
      whereArgs: [userEmail, name],
    );
  }

  Future<void> clearCart(String userEmail) async {
    final db = await instance.database;
    await db.delete('cart', where: 'userEmail = ?', whereArgs: [userEmail]);
  }

  // --- الطلبات ---
  Future<int> saveOrder(String userEmail, double total, String products) async {
    final db = await instance.database;
    return await db.insert('orders', {
      'userEmail': userEmail,
      'orderDate': DateTime.now().toIso8601String(),
      'totalAmount': total,
      'productNames': products,
      'status': 'Completed',
    });
  }

  Future<List<Map<String, dynamic>>> getOrders(String userEmail) async {
    final db = await instance.database;
    return await db.query(
      'orders',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
      orderBy: 'orderDate DESC',
    );
  }

  // --- المفضلة ---
  Future<int> addFavorite(String userEmail, String name) async {
    final db = await instance.database;
    return await db.insert('favorites', {
      'userEmail': userEmail,
      'productName': name,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> removeFavorite(String userEmail, String name) async {
    final db = await instance.database;
    return await db.delete(
      'favorites',
      where: 'userEmail = ? AND productName = ?',
      whereArgs: [userEmail, name],
    );
  }

  Future<List<String>> getFavorites(String userEmail) async {
    final db = await instance.database;
    final result = await db.query(
      'favorites',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
    );
    return result.map((row) => row['productName'] as String).toList();
  }

  // --- هويات المستخدم ---
  Future<int> registerUser(
    String username,
    String email,
    String password,
  ) async {
    final db = await instance.database;
    return await db.insert('users', {
      'username': username,
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> loginUser(
    String username,
    String password,
  ) async {
    final db = await instance.database;
    final results = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<bool> checkUserExists(String username, String email) async {
    final db = await instance.database;
    final results = await db.query(
      'users',
      where: 'username = ? OR email = ?',
      whereArgs: [username, email],
    );
    return results.isNotEmpty;
  }

  Future<int> updateUser(
    String oldEmail,
    String username,
    String email,
    String password,
    String? profileImage,
  ) async {
    final db = await instance.database;
    return await db.update(
      'users',
      {
        'username': username,
        'email': email,
        'password': password,
        'profile_image': profileImage,
      },
      where: 'email = ?',
      whereArgs: [oldEmail],
    );
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await instance.database;
    return await db.query('products');
  }
}
