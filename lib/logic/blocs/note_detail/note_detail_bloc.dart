import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/data/models/note.dart';
import 'package:flutternotestest/data/repositories/note_repository.dart';

part 'note_detail_event.dart';
part 'note_detail_state.dart';

class NoteDetailBloc extends Bloc<NoteDetailEvent, NoteDetailState> {
  final NoteRepository _noteRepository;

  NoteDetailBloc({required NoteRepository noteRepository})
      : _noteRepository = noteRepository,
        super(NoteDetailInitial()) {
    on<NoteDetailLoad>(_onNoteDetailLoad);
  }

  FutureOr<void> _onNoteDetailLoad(
      NoteDetailLoad event, Emitter<NoteDetailState> emit) async {
    try {
      emit(NoteDetailLoadInProgress());
      final noteId = event.note.id;
      if (noteId == null) throw 'An error occured';
      final note = await _noteRepository.getNoteDetail(noteId);
      if (note == null) throw 'Data not found';
      emit(NoteDetailLoadSuccess(note: note));
    } catch (e) {
      emit(NoteDetailLoadFailure(error: e.toString()));
    }
  }
}
