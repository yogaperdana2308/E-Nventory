import 'package:enventory/model/item_model.dart';
import 'package:enventory/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const tableUser = 'users';
  static const tableItem = 'items';

  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'enventory.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $tableUser(id INTEGER PRIMARY KEY AUTOINCREMENT,  username TEXT, nomorhp INTEGER, email TEXT, password TEXT)",
        );
        await db.execute(
          "CREATE TABLE $tableItem(id INTEGER PRIMARY KEY AUTOINCREMENT,  name TEXT, stock INTEGER, price INTEGER)",
        );
      },
      version: 1,
    );
  }

  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.insert(
      tableUser,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(user.toMap());
  }

  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final dbs = await db();
    //query adalah fungsi untuk menampilkan data (READ)
    final List<Map<String, dynamic>> results = await dbs.query(
      tableUser,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    final List<Map<String, dynamic>> check = await dbs.query(tableUser);

    print(check);
    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  static Future<List<UserModel>> getAllUser() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tableUser);
    print(results.map((e) => UserModel.fromMap(e)).toList());
    return results.map((e) => UserModel.fromMap(e)).toList();
  }

  static Future<List<ItemModel>> getAllItem() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tableItem);
    print(results.map((e) => ItemModel.fromMap(e)).toList());
    return results.map((e) => ItemModel.fromMap(e)).toList();
  }

  static Future<void> createItem(ItemModel item) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.insert(
      tableItem,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(item.toMap());
  }

  static Future<void> updateItem(ItemModel item) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.update(
      tableItem,
      item.toMap(),
      where: "id = ?",
      whereArgs: [item.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(item.toMap());
  }

  static Future<void> deleteItem(int id) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.delete(tableItem, where: "id = ?", whereArgs: [id]);
  }
}
