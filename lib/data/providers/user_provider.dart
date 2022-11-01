import 'dart:io';

import 'package:flutternotestest/data/models/user.dart';
import 'package:flutternotestest/data/providers/db_provider.dart';
import 'package:flutternotestest/helpers/utils.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class UserProvider {
  final DBProvider _dbProvider = DBProvider();

  static const String tableUser = 'user';
  static const String columnId = '_id';
  static const String columnFirstName = 'firstName';
  static const String columnLastName = 'lastName';
  static const String columnEmail = 'email';
  static const String columnDateOfBirth = 'dateOfBirth';
  static const String columnGender = 'gender';
  static const String columnPassword = 'password';
  static const String columnProfilePicture = 'profilePicture';

  Future<void> onCreate(Database db) async {
    await db.execute(
      "CREATE TABLE IF NOT EXISTS $tableUser ("
      "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
      "$columnFirstName TEXT NOT NULL,"
      "$columnLastName TEXT NOT NULL,"
      "$columnEmail TEXT NOT NULL,"
      "$columnDateOfBirth INTEGER NOT NULL,"
      "$columnGender TEXT NOT NULL,"
      "$columnPassword TEXT NOT NULL,"
      "$columnProfilePicture TEXT DEFAULT NULL"
      ")",
    );
  }

  Future<List<Object?>> batchInsert(List<User> users) async {
    try {
      final batch = (await _dbProvider.database).batch();
      await Future.forEach(
        users,
        (element) => batch.insert(tableUser, element.toMap()),
      );
      return batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  Future<User> insert(User user) async {
    try {
      final id =
          await (await _dbProvider.database).insert(tableUser, user.toMap());
      return user.copyWith(id: id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      return (await _dbProvider.database).query(tableUser);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserDetail(int id) async {
    try {
      final data = await (await _dbProvider.database).query(
        tableUser,
        where: '$columnId = ?',
        whereArgs: [id],
      );
      if (data.isNotEmpty) {
        return data.first;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserByEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final users = await getUsers();
      if (users.isEmpty) {
        await insert(
          User(
            firstName: 'Administrator',
            lastName: 'MBP',
            dateOfBirth: DateTime(2000, 1, 1),
            email: 'administrator@gmail.com',
            gender: Gender.male,
            password: MyUtils.generateMd5('secret'),
          ),
        );
      }
      final data = await (await _dbProvider.database).query(
        tableUser,
        where: '$columnEmail = ? AND $columnPassword = ?',
        whereArgs: [email, MyUtils.generateMd5(password)],
      );
      if (data.isNotEmpty) {
        return data.first;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<User> update({required int id, required User user}) async {
    try {
      String? profilePicture = user.profilePicture;
      if (profilePicture != null && profilePicture.isNotEmpty) {
        final dir = await getApplicationDocumentsDirectory();
        final ext = p.extension(profilePicture);
        final newPath =
            await File(profilePicture).copy('${dir.path}/user_photo$ext');
        profilePicture = newPath.path;
      }
      await (await _dbProvider.database).rawUpdate(
        'UPDATE $tableUser SET $columnFirstName = ?, $columnLastName = ?, '
        '$columnGender = ?, $columnDateOfBirth = ?, $columnProfilePicture = ? WHERE $columnId = ?',
        [
          user.firstName,
          user.lastName,
          user.gender?.name.toUpperCase(),
          DateFormat('yyyy-MM-dd')
              .format(user.dateOfBirth ?? DateTime(1999, 1, 1)),
          (profilePicture?.isNotEmpty ?? false) ? profilePicture : null,
          id,
        ],
      );
      return user.copyWith(id: id);
    } catch (e) {
      rethrow;
    }
  }

  Future<int?> delete(int id) async {
    try {
      return await (await _dbProvider.database)
          .delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clear() async {
    try {
      await (await _dbProvider.database).execute("DELETE FROM $tableUser");
    } catch (e) {
      rethrow;
    }
  }

  Future close() async => (await _dbProvider.database).close();
}
