part of 'note_list_bloc.dart';

abstract class NoteListState extends Equatable {
  const NoteListState();

  @override
  List<Object?> get props => [];
}

class NoteListInitial extends NoteListState {}

class NoteListLoadInProgress extends NoteListState {}

class NoteListLoadSuccess extends NoteListState {
  final List<Note> notes;

  const NoteListLoadSuccess({required this.notes});

  @override
  List<Object?> get props => [notes];
}

class NoteListLoadFailure extends NoteListState {
  final String error;

  const NoteListLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
