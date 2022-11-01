import 'package:flutternotestest/data/models/user.dart';
import 'package:flutternotestest/data/providers/db_provider.dart';
import 'package:flutternotestest/data/providers/note_provider.dart';
import 'package:flutternotestest/data/providers/user_provider.dart';
import 'package:flutternotestest/logic/blocs/notification/notification_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class AuthProvider {
  final _userProvider = UserProvider();
  final _noteProvider = NoteProvider();

  final DBProvider _dbProvider = DBProvider();

  static const String tableAuth = 'auth';
  static const String columnId = '_id';
  static const String columnFirstName = 'firstName';
  static const String columnLastName = 'lastName';
  static const String columnEmail = 'email';
  static const String columnDateOfBirth = 'dateOfBirth';
  static const String columnGender = 'gender';
  static const String columnProfilePicture = 'profilePicture';

  Future<void> onCreate(Database db) async {
    await db.execute(
      "CREATE TABLE IF NOT EXISTS $tableAuth ("
      "$columnId INTEGER PRIMARY KEY,"
      "$columnFirstName TEXT NOT NULL,"
      "$columnLastName TEXT NOT NULL,"
      "$columnEmail TEXT NOT NULL,"
      "$columnDateOfBirth INTEGER NOT NULL,"
      "$columnGender TEXT NOT NULL,"
      "$columnProfilePicture TEXT DEFAULT NULL"
      ")",
    );
  }

  /// Login with email
  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _userProvider.getUserByEmailPassword(
        email: email,
        password: password,
      );
      if (user == null) {
        throw 'Email or password incorrect. Or not registered.';
      }
      Map<String, dynamic> map = Map<String, dynamic>.from(user);
      map.remove('password');
      await (await _dbProvider.database).insert(tableAuth, map);
      return map;
    } catch (e) {
      rethrow;
    }
  }

  /// Update user
  Future<Map<String, dynamic>> update(
      {required int id, required User user}) async {
    try {
      await _userProvider.update(id: id, user: user);
      final userUpdatedMap = await _userProvider.getUserDetail(id);
      if (userUpdatedMap == null) throw 'An error occured';
      final userUpdated = User.fromMap(userUpdatedMap);
      await (await _dbProvider.database).rawUpdate(
        'UPDATE $tableAuth SET $columnFirstName = ?, $columnLastName = ?, '
        '$columnGender = ?, $columnDateOfBirth = ?, $columnProfilePicture = ? WHERE $columnId = ?',
        [
          userUpdated.firstName,
          userUpdated.lastName,
          userUpdated.gender?.name.toUpperCase(),
          DateFormat('yyyy-MM-dd')
              .format(userUpdated.dateOfBirth ?? DateTime(1999, 1, 1)),
          (user.profilePicture?.isNotEmpty ?? false)
              ? user.profilePicture
              : null,
          id,
        ],
      );
      return userUpdatedMap;
    } catch (e) {
      rethrow;
    }
  }

  /// For logout current user
  Future<void> logout() async {
    try {
      await (await _dbProvider.database).execute("DELETE FROM $tableAuth");
      await _userProvider.clear();
      await _noteProvider.clear();
      await cancelAllNotification();
    } catch (e) {
      rethrow;
    }
  }

  /// For check if user is logged in or not
  Future<bool> isLoggedIn() async {
    try {
      return (await user()) != null;
    } catch (e) {
      rethrow;
    }
  }

  /// For get user data loggedin
  Future<Map<String, dynamic>?> user() async {
    try {
      final data = (await (await _dbProvider.database).query(tableAuth));
      if (data.isNotEmpty) {
        return data.first;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
