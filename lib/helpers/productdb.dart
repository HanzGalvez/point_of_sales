import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../database/table_handler.dart';
import '../models/product_model.dart';

class ProductDBHelper {
  static const dbVersion = 1;
  static const String tblName = 'product';
  static const String colId = 'id';
  static const String colBarcode = 'barcode';
  static const String colTitle = 'title';
  static const String colCatId = 'catid';
  static const String colDescription = 'desc';
  static const String colStock = 'stock';
  static const String colPrice = 'price';

  static Future<Database> openDb() async {
    final dbpath = await getDatabasesPath();
    return openDatabase(p.join(dbpath, DatabaseHandler.dbname));
  }

  static Future<void> createDB(Database db) async {
    await db.execute(
      '''
          CREATE TABLE $tblName(
            $colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $colBarcode TEXT NOT NULL,
            $colTitle TEXT NOT NULL,
            $colCatId INTEGER ,
            $colDescription TEXT NOT NULL,
            $colStock INTEGER,
            $colPrice DECIMAL
          )
      ''',
    );
    print('Product table created');
  }

  static void minus({required int id, required int qty}) async {
    final db = await openDb();
    await db.execute('''
        UPDATE $tblName set $colStock = (
          SELECT $colStock FROM $tblName where $colId = $id
        ) - $qty WHERE $colId = $id;
    ''');
    print("success minus");
  }

  static Future<int> insert(Product product) async {
    final db = await openDb();
    int id = await db.insert(
      tblName,
      product.toMap(),
    );
    return id;
  }

  static Future<List<Product>> getList() async {
    final db = await openDb();
    List<Product> product = [];
    List<Map<String, dynamic>> data =
        await db.query(tblName, orderBy: '$colId DESC');

    data.forEach((element) {
      product.add(
        Product(
          id: element[colId],
          barcode: element[colBarcode],
          name: element[colTitle],
          catId: int.parse(element[colCatId].toString()),
          description: element[colDescription],
          stock: int.parse(element[colStock].toString()),
          price: double.parse(element[colPrice].toString()),
        ),
      );
    });

    return product;
  }

  static void delete(int id) async {
    final db = await openDb();
    await db.delete(tblName, where: '$colId = ?', whereArgs: [id]);
  }

  static void update(Product product) async {
    final db = await openDb();
    var data = product.toMap();
    data.remove(ProductDBHelper.colStock);
    await db.update(
      tblName,
      data,
      where: '$colId = ?',
      whereArgs: [product.id],
    );
  }

  static Future<List<Map<String, Object?>>> checkBarCode(
      {required String code}) async {
    final db = await openDb();
    return db.query(tblName, where: '$colBarcode = ?', whereArgs: [code]);
  }

  static void addStock({required int productId, required int value}) async {
    final db = await openDb();
    await db.update(
      tblName,
      {'$colStock': value},
      where: '$colId = ?',
      whereArgs: [productId],
    );
  }

  static Future<List<Map<String, dynamic>>> storeInFirebase() async {
    final db = await openDb();
    return await db.query(tblName);
  }

  static Future<void> firestoreInsert(element) async {
    final db = await openDb();
    await db.insert(tblName, element,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Product>> getSingleProduct(int id) async {
    final db = await openDb();
    List<Product> product = [];
    List<Map<String, dynamic>> data =
        await db.query(tblName, where: '$colId = ?', whereArgs: [id]);

    data.forEach((element) {
      product.add(
        Product(
          id: element[colId],
          barcode: element[colBarcode],
          name: element[colTitle],
          catId: int.parse(element[colCatId].toString()),
          description: element[colDescription],
          stock: int.parse(element[colStock].toString()),
          price: double.parse(element[colPrice].toString()),
        ),
      );
    });

    return product;
  }
}
