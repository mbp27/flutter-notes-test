part of 'note_delete_bloc.dart';

abstract class NoteDeleteState extends Equatable {
  const NoteDeleteState();

  @override
  List<Object?> get props => [];
}

class NoteDeleteInitial extends NoteDeleteState {}

class NoteDeleteStartedInProgress extends NoteDeleteState {}

class NoteDeleteStartedSuccess extends NoteDeleteState {
  final Note note;

  const NoteDeleteStartedSuccess({
    required this.note,
  });

  @override
  List<Object?> get props => [note];
}

class NoteDeleteStartedFailure extends NoteDeleteState {
  final String error;

  const NoteDeleteStartedFailure({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
