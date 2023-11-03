import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../database/table_handler.dart';
import '../models/category_model.dart';

class CategoryDBHelper {
  static const dbVersion = 1;
  static const tblName = 'category';
  static const colId = 'id';
  static const colTitle = 'title';
  static const colDescription = 'desc';
  static const colIcon = 'icon';

  static Future<Database> openDb() async {
    final dbpath = await getDatabasesPath();
    return openDatabase(
      p.join(dbpath, DatabaseHandler.dbname),
    );
  }

  static Future<void> createDB(Database db) async {
    await db.execute(
      '''
          CREATE TABLE $tblName(
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colTitle TEXT NOT NULL,
          $colDescription TEXT NOT NULL,
           $colIcon INTEGER NOT NULL
          )
          ''',
    );
    print('Category table created');
  }

  static Future<int> insert(Category category) async {
    final db = await openDb();
    int id = await db.rawInsert(
      '''
    INSERT INTO $tblName(
      $colTitle,
      $colDescription,
      $colIcon
    )
    VALUES(?,?,?)
    ''',
      category.toList(),
    );
    return id;
  }

  static Future<void> firestoreInsert(element) async {
    final db = await openDb();
    await db.insert(tblName, element,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getList() async {
    final db = await openDb();
    return db.query(tblName);
  }

  static Future<int> delete(int id) async {
    final db = await openDb();
    return db.delete(tblName, where: '$colId = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getSingleList(int id) async {
    final db = await openDb();
    return db.query(tblName, where: '$colId = ?', whereArgs: [id]);
  }

  static void update(Category category) async {
    final db = await openDb();
    db.update(
      tblName,
      category.toMap(),
      where: '$colId = ?',
      whereArgs: [category.id],
    );
  }
}
