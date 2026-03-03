import 'package:demo_prc_skynet_tech/core/database/app_database.dart';
import 'package:demo_prc_skynet_tech/features/auth/entity/user.dart';
import 'package:flutter/foundation.dart';

class UserTable {
  static String tableName = 'users';
  Future<User?> registerUser(String email, String password) async {
    try {
      final db = await AppDatabase.database;
      final existingUser = await db?.query(
        tableName,
        where: 'email=?',
        whereArgs: [email],
        limit: 1,
      );
      if ((existingUser ?? []).isNotEmpty) {
        throw Exception('Email already registered');
      }

      var result = await db?.insert(tableName, {
        "email": email,
        "password": password,
      });
      return User(id: int.parse((result).toString()), email: email);
    } catch (e) {
      if (kDebugMode) {
        print("error at register $e");
      }
      return null;
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      final db = await AppDatabase.database;

      var result = await db?.query(
        tableName,
        where: "email=? AND password=?",
        whereArgs: [email, password],
      );
      if ((result ?? []).isEmpty) {
        throw Exception('Invalid Credentials');
      }
      return User(
        id: int.parse((result?.first['id'] ?? '0').toString()),
        email: email,
      );
    } catch (e) {
      if (kDebugMode) {
        print("error at login $e");
      }
      return null;
    }
  }
}
