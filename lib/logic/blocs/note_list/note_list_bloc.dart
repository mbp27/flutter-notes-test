import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/data/models/note.dart';
import 'package:flutternotestest/data/repositories/note_repository.dart';

part 'note_list_event.dart';
part 'note_list_state.dart';

class NoteListBloc extends Bloc<NoteListEvent, NoteListState> {
  final NoteRepository _noteRepository;

  NoteListBloc({required NoteRepository noteRepository})
      : _noteRepository = noteRepository,
        super(NoteListInitial()) {
    on<NoteListLoad>(_onNoteListLoad);
  }

  FutureOr<void> _onNoteListLoad(
      NoteListLoad event, Emitter<NoteListState> emit) async {
    try {
      emit(NoteListLoadInProgress());
      final notes = await _noteRepository.getNotes();
      emit(NoteListLoadSuccess(notes: notes));
    } catch (e) {
      emit(NoteListLoadFailure(error: e.toString()));
    }
  }
}
