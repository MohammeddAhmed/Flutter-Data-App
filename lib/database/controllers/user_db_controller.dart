import 'package:sqflite/sqflite.dart';
import 'package:data/database/db_controller.dart';
import 'package:data/models/process_response.dart';
import 'package:data/models/user.dart';
import 'package:data/pref/shared_pref_controller.dart';

class UserDbController {
  //TODO: -  Operations
  //TODO: 1- Register => Create => insert
  //TODO: 2- Login => read, show => query
  //TODO: 3- EmailUnique or CheckIfEmailExisted => read, show => query

  final Database _database = DbController().database;

  Future<ProcessResponse> register(User user) async {
    if (!await _emailUnique(user.email)) {
      int newRowId = await _database.insert(User.tableName, user.toMap());
      return ProcessResponse(
        newRowId != 0 ? "Registered successfully .." : "Registration failed ..",
      );
    }
    return ProcessResponse("Email registered, user another", false);
  }

  Future<ProcessResponse> login(String email, String password) async {
    List<Map<String, dynamic>> rows = await _database.query(User.tableName,
        where: "email = ? AND password = ?", whereArgs: [email, password]);
    if (rows.isNotEmpty) {
      User user = User.fromMap(rows.first);
      await SharedPrefController().save(user);
      return ProcessResponse("Logged in successfully ..");
    }
    return ProcessResponse("Login failed, check credentials", false);
  }

  Future<bool> _emailUnique(String email) async {
    List<Map<String, dynamic>> rows = await _database
        .query(User.tableName, where: "email = ?", whereArgs: [email]);
    return rows.isNotEmpty;
  }
}
