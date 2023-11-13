import 'package:point_of_sales/helpers/invoicedb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/helpers/categorydb.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../helpers/invoicelinedb.dart';

class DatabaseHandler {
  static const dbVersion = 1;
  static const dbname = 'itrack.db';
  static Future<Database> createDB() async {
    final dbpath = await getDatabasesPath();

    return openDatabase(
      p.join(dbpath, dbname),
      version: dbVersion,
      onCreate: (db, version) async {
        await CategoryDBHelper.createDB(db);
        await ProductDBHelper.createDB(db);
        await InvoiceDBHelper.createDB(db);
        await InvoiceLineDBHelper.createDB(db);
      },
    );
  }
}
