import 'package:multistore_customer/providers/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class SQLHelper {
  static Database? _database;
  static get getDatabase async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  static Future<Database> initDatabase() async {
    var path = p.join(await getDatabasesPath(), 'shopping_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart_items (
        documentId TEXT PRIMARY KEY,
        name TEXT,
        price DOUBLE,
        orderedQuantity INT, 
        totalQuantity INT, 
        imageUrl TEXT,
        supplierId TEXT
      ) 
''');
    await db.execute('''
      CREATE TABLE wish_items (
        documentId TEXT PRIMARY KEY,
        name TEXT,
        price DOUBLE,
        orderedQuantity INT, 
        totalQuantity INT, 
        imageUrl TEXT,
        supplierId TEXT
      ) 
''');
    print("Oncreate called");
  }

  // using sql helper
  static Future insertCartItem(Product product) async {
    Database db = await getDatabase;
    await db.insert("cart_items", product.toMap());
    print(await db.query("cart_items"));
  }

  static Future insertWishItem(Product product) async {
    Database db = await getDatabase;
    await db.insert("wish_items", product.toMap());
    print(await db.query("wish_items"));
  }

  // using sql helper
  static Future<List<Map>> loadCartItems() async {
    Database db = await getDatabase;
    List<Map> maps = await db.query("cart_items");
    return maps;
  }

  static Future<List<Map>> loadWishItems() async {
    Database db = await getDatabase;
    List<Map> maps = await db.query("wish_items");
    return maps;
  }

  // using sql helper
  static Future updateCartItem(Product product) async {
    Database db = await getDatabase;
    await db.update("cart_items", product.toMap(),
        where: "documentId=?", whereArgs: [product.documentId]);
  }

  static Future updateWishItem(Product product) async {
    Database db = await getDatabase;
    await db.update("wish_items", product.toMap(),
        where: "documentId=?", whereArgs: [product.documentId]);
  }

  // using sql helper
  static Future deleteCartItem(String documentId) async {
    Database db = await getDatabase;
    await db
        .delete("cart_items", where: "documentId=?", whereArgs: [documentId]);
  }

  static Future deleteWishItem(String documentId) async {
    Database db = await getDatabase;
    await db
        .delete("wish_items", where: "documentId=?", whereArgs: [documentId]);
  }

  // using sql helper
  static Future deleteAllCartItems() async {
    Database db = await getDatabase;
    // await db.execute("DELETE FROM notes"); OR
    await db.delete("cart_items");
  }

  static Future deleteAllWishItems() async {
    Database db = await getDatabase;
    // await db.execute("DELETE FROM notes"); OR
    await db.delete("wish_items");
  }
}
