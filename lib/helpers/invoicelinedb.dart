import 'package:point_of_sales/database/table_handler.dart';
import 'package:point_of_sales/models/invoice_line_model.dart';
import 'package:point_of_sales/models/invoice_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/product_model.dart';

class InvoiceLineDBHelper {
  static const tblName = 'invoice_line';
  static const colId = 'id';
  static const colInvoiceID = 'invoice_id';
  static const colProductId = 'product_id';
  static const colPrice = 'product_price';
  static const colQty = 'qty';
  static Future<Database> openDb() async {
    final dbpath = await getDatabasesPath();
    return openDatabase(join(dbpath, DatabaseHandler.dbname));
  }

  static Future<void> createDB(Database db) async {
    await db.execute(
      '''
          CREATE TABLE $tblName(
            $colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $colInvoiceID TEXT,
            $colProductId INTEGER,
            $colPrice DECIMAL,
            $colQty INTEGER
          )
      ''',
    );
    print('InvoiceLine table created');
  }

  static void insert(InvoiceLine inv) async {
    final db = await openDb();
    await db.insert(
      tblName,
      inv.toMap(),
    );
  }

  static Future<void> firestoreInsert(element) async {
    final db = await openDb();
    await db.insert(tblName, element,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<InvoiceLine>> getListofSingleProduct(int id) async {
    List<InvoiceLine> list = [];
    final db = await openDb();
    List<Map<String, dynamic>> data =
        await db.query(tblName, where: '$colProductId = ?', whereArgs: [id]);
    data.forEach((element) {
      list.add(
        InvoiceLine(
          productId: element[colProductId],
          productPrice: double.parse(element[colPrice].toString()),
          qty: int.parse(element[colQty].toString()),
          invoiceId: element[colInvoiceID],
        ),
      );
    });
    return list;
  }

  static Future<List<Map<String, dynamic>>> storeInFirebase() async {
    final db = await openDb();
    return await db.query(tblName);
  }

  static Future<List<InvoiceLine>> getList() async {
    List<InvoiceLine> list = [];
    final db = await openDb();
    List<Map<String, dynamic>> data = await db.query(tblName);
    data.forEach((element) {
      list.add(
        InvoiceLine(
          productId: element[colProductId],
          productPrice: double.parse(element[colPrice].toString()),
          qty: int.parse(element[colQty].toString()),
          invoiceId: element[colInvoiceID],
        ),
      );
    });
    return list;
  }

  static Future<List<Map<String, dynamic>>> getPopularProduct() async {
    final db = await openDb();
    return await db.rawQuery(
        "SELECT $colProductId, sum($colQty) as total, sum($colPrice * $colQty) as totalSales from $tblName GROUP BY $colProductId ORDER BY total desc limit 3");
  }
}
