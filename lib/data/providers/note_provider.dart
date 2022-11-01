import 'dart:io';

import 'package:flutternotestest/data/models/note.dart';
import 'package:flutternotestest/data/providers/db_provider.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NoteProvider {
  final DBProvider _dbProvider = DBProvider();

  static const String tableNote = 'note';
  static const String columnId = '_id';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnReminderTime = 'reminderTime';
  static const String columnReminderInterval = 'reminderInterval';
  static const String columnFile = 'file';

  Future<void> onCreate(Database db) async {
    await db.execute(
      "CREATE TABLE IF NOT EXISTS $tableNote ("
      "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
      "$columnTitle TEXT NOT NULL,"
      "$columnDescription TEXT NOT NULL,"
      "$columnReminderTime INTEGER DEFAULT NULL,"
      "$columnReminderInterval INTEGER DEFAULT NULL,"
      "$columnFile TEXT DEFAULT NULL"
      ")",
    );
  }

  Future<List<Object?>> batchInsert(List<Note> notes) async {
    try {
      final batch = (await _dbProvider.database).batch();
      await Future.forEach(
        notes,
        (element) => batch.insert(tableNote, element.toMap()),
      );
      return batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  Future<Note> insert(Note note) async {
    try {
      String? file = note.file;
      if (file != null && file.isNotEmpty) {
        final dir = await getApplicationDocumentsDirectory();
        final filename = p.basename(file);
        final newPath = await File(file).copy('${dir.path}/$filename');
        file = newPath.path;
      }
      final id = await (await _dbProvider.database).insert(
        tableNote,
        note.copyWith(file: file).toMap(),
      );
      return note.copyWith(id: id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    try {
      return (await _dbProvider.database).query(tableNote);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getNoteDetail(int id) async {
    try {
      final data = await (await _dbProvider.database).query(
        tableNote,
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

  Future<Map<String, dynamic>> update(
      {required int id, required Note note}) async {
    try {
      String? file = note.file;
      if (file != null && file.isNotEmpty) {
        final dir = await getApplicationDocumentsDirectory();
        final filename = p.basename(file);
        final newPath = await File(file).copy('${dir.path}/$filename');
        file = newPath.path;
      }
      await (await _dbProvider.database).update(
        tableNote,
        note.copyWith(file: file).toUpdate(),
        where: '$columnId = ?',
        whereArgs: [id],
      );
      return note.copyWith(id: id).toMap();
    } catch (e) {
      rethrow;
    }
  }

  Future<int?> delete(int id) async {
    try {
      return await (await _dbProvider.database)
          .delete(tableNote, where: '$columnId = ?', whereArgs: [id]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clear() async {
    try {
      await (await _dbProvider.database).execute("DELETE FROM $tableNote");
    } catch (e) {
      rethrow;
    }
  }

  Future close() async => (await _dbProvider.database).close();
}
