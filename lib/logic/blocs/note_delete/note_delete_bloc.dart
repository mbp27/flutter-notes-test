import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/data/models/note.dart';
import 'package:flutternotestest/data/repositories/note_repository.dart';
import 'package:flutternotestest/logic/blocs/notification/notification_bloc.dart';

part 'note_delete_event.dart';
part 'note_delete_state.dart';

class NoteDeleteBloc extends Bloc<NoteDeleteEvent, NoteDeleteState> {
  final NoteRepository _noteRepository;

  NoteDeleteBloc({required NoteRepository noteRepository})
      : _noteRepository = noteRepository,
        super(NoteDeleteInitial()) {
    on<NoteDeleteStarted>(_onNoteDeleteStarted);
  }

  FutureOr<void> _onNoteDeleteStarted(
      NoteDeleteStarted event, Emitter<NoteDeleteState> emit) async {
    try {
      emit(NoteDeleteStartedInProgress());
      final noteId = event.note.id;
      if (noteId == null) throw 'An error occured';
      await _noteRepository.delete(noteId);
      await cancelNotification(noteId);
      emit(NoteDeleteStartedSuccess(note: event.note));
    } catch (e) {
      emit(NoteDeleteStartedFailure(error: e.toString()));
    }
  }
}
