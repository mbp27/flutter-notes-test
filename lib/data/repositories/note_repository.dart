import 'package:flutternotestest/data/models/note.dart';
import 'package:flutternotestest/data/providers/note_provider.dart';

class NoteRepository {
  final _noteProvider = NoteProvider();

  Future<List<Object?>> batchInsert(List<Note> notes) =>
      _noteProvider.batchInsert(notes);

  Future<Note> insert(Note note) => _noteProvider.insert(note);

  Future<List<Note>> getNotes() async {
    try {
      final data = await _noteProvider.getNotes();
      final list = data.map((e) => Note.fromMap(e)).toList();
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<Note?> getNoteDetail(int id) async {
    try {
      final data = await _noteProvider.getNoteDetail(id);
      if (data != null) {
        final note = Note.fromMap(data);
        return note;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<int?> delete(int id) => _noteProvider.delete(id);
  Future<Note> update({required int id, required Note note}) async {
    try {
      final noteUpdated = await _noteProvider.update(
        id: id,
        note: note,
      );
      return Note.fromMap(noteUpdated);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clear() => _noteProvider.clear();

  Future close() => _noteProvider.close();
}
