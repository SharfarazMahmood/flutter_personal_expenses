import 'package:sqflite/sqflite.dart' as sqlflite;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sqlflite.Database> database() async {
    final dbPath = await sqlflite.getDatabasesPath();
    return sqlflite.openDatabase(
      path.join(dbPath, 'personal_expences.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE user_expenses(id TEXT PRIMARY KEY , title TEXT, amount NUMERIC , date TEXT )',
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sqlflite.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBHelper.database();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAllRowsOfATable(String table) async {
    final db = await DBHelper.database();
    db.execute('delete * from' + table);
  }
}
