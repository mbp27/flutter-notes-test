part of 'note_detail_bloc.dart';

abstract class NoteDetailEvent extends Equatable {
  const NoteDetailEvent();

  @override
  List<Object?> get props => [];
}

class NoteDetailLoad extends NoteDetailEvent {
  final Note note;

  const NoteDetailLoad({required this.note});

  @override
  List<Object?> get props => [note];
}
