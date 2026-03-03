import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    final path = join(await getDatabasesPath(), 'app_demo.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT,email TEXT,password TEXT)
''');
      },
    );

    return _database;
  }
}
