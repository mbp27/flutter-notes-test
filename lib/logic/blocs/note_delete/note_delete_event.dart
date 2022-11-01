part of 'note_delete_bloc.dart';

abstract class NoteDeleteEvent extends Equatable {
  const NoteDeleteEvent();

  @override
  List<Object?> get props => [];
}

class NoteDeleteStarted extends NoteDeleteEvent {
  final Note note;

  const NoteDeleteStarted({
    required this.note,
  });

  @override
  List<Object?> get props => [note];
}
