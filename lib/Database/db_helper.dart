import 'package:enventory/model/item_model.dart';
import 'package:enventory/model/penjualan_model.dart';
import 'package:enventory/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const tableUser = 'users';
  static const tableItem = 'items';
  static const tableSales = 'sales';

  // ============================================
  // OPEN DATABASE
  // ============================================
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'enventory.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $tableUser(id INTEGER PRIMARY KEY AUTOINCREMENT,  username TEXT, nomorhp INTEGER, email TEXT, password TEXT, profil TEXT)",
        );
        await db.execute(
          "CREATE TABLE $tableItem(id INTEGER PRIMARY KEY AUTOINCREMENT,  name TEXT, stock INTEGER, price INTEGER, date TEXT)",
        );
        await db.execute(
          "CREATE TABLE $tableSales(id INTEGER PRIMARY KEY AUTOINCREMENT,  item_id INTEGER, quantity INTEGER, price INTEGER, sales INTEGER, date TEXT, FOREIGN KEY (item_id) REFERENCES $tableItem(id) ON DELETE CASCADE ON UPDATE CASCADE)",
        );
      },
      version: 1,
    );
  }

  // ============================================
  // USER
  // ============================================
  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();
    await dbs.insert(
      tableUser,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      tableUser,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  static Future<List<UserModel>> getAllUser() async {
    final dbs = await db();
    final results = await dbs.query(tableUser);
    return results.map((e) => UserModel.fromMap(e)).toList();
  }

  // ============================================
  // ITEM (STOCK)
  // ============================================
  static Future<List<ItemModel>> getAllItem() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tableItem);
    return results.map((e) => ItemModel.fromMap(e)).toList();
  }

  static Future<void> createItem(ItemModel item) async {
    final dbs = await db();
    await dbs.insert(
      tableItem,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateItem(ItemModel item) async {
    final dbs = await db();
    await dbs.update(
      tableItem,
      item.toMap(),
      where: "id = ?",
      whereArgs: [item.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteItem(int id) async {
    final dbs = await db();
    await dbs.delete(tableItem, where: "id = ?", whereArgs: [id]);
  }

  // ============================================
  // NEW: CEK ITEM DUPLIKAT (NAME + DATE)
  // ============================================
  static Future<ItemModel?> getItemByNameAndDate(
    String name,
    String date,
  ) async {
    final dbs = await db();
    final normalized = name.trim().toLowerCase();

    final res = await dbs.query(
      tableItem,
      where: "LOWER(name) = ? AND date = ?",
      whereArgs: [normalized, date],
    );

    if (res.isNotEmpty) {
      return ItemModel.fromMap(res.first);
    }
    return null;
  }

  // ============================================
  // SALES (PENJUALAN)
  // ============================================
  static Future<List<SalesModel>> getAllSales() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tableSales);
    return results.map((e) => SalesModel.fromMap(e)).toList();
  }

  static Future<void> deleteSales(int id) async {
    final dbs = await db();
    await dbs.delete(tableSales, where: "id = ?", whereArgs: [id]);
  }

  static Future<void> updateSales(ItemModel sales) async {
    final dbs = await db();
    await dbs.update(
      tableSales,
      sales.toMap(),
      where: "id = ?",
      whereArgs: [sales.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> createSales(SalesModel sales) async {
    final dbs = await db();
    await dbs.insert(
      tableSales,
      sales.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
