part of 'note_detail_bloc.dart';

abstract class NoteDetailState extends Equatable {
  const NoteDetailState();

  @override
  List<Object?> get props => [];
}

class NoteDetailInitial extends NoteDetailState {}

class NoteDetailLoadInProgress extends NoteDetailState {}

class NoteDetailLoadSuccess extends NoteDetailState {
  final Note note;

  const NoteDetailLoadSuccess({required this.note});

  @override
  List<Object?> get props => [note];
}

class NoteDetailLoadFailure extends NoteDetailState {
  final String error;

  const NoteDetailLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
