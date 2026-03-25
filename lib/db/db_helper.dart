import 'package:sqflite/sqflite.dart';
import 'package:remindue/models/task.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'task';

  static Future<void> initDb() async {
    if (_db != null) {
      print("Database already initialized");
      return;
    }

    try {
      String path = join(await getDatabasesPath(), 'task.db');

      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) async {
          print("Creating a new database");

          await db.execute('''
            CREATE TABLE $_tableName(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              note TEXT,
              date TEXT,
              startTime TEXT,
              endTime TEXT,
              remind INTEGER,
              repeat TEXT,
              color INTEGER,
              isCompleted INTEGER
            )
          ''');
        },
      );
    } catch (e) {
      print("Database error: $e");
    }
  }

  static Future<int> insert(Task task) async {
    await initDb();
    return await _db!.insert(_tableName, task.toJson());
  }

  static Future<List<Map<String, dynamic>>> query() async {
    await initDb();
    return await _db!.query(_tableName);
  }

  static Future<int> delete(int id) async {
    await initDb();
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> update(int id) async {
    await initDb();
    return await _db!.rawUpdate(
      '''
      UPDATE $_tableName
      SET isCompleted = ?
      WHERE id = ?
      ''',
      [1, id],
    );
  }

  static Future<int> updateTask(Task task) async {
    await initDb();
    return await _db!.update(
      _tableName,
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}
