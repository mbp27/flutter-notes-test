part of 'note_list_bloc.dart';

abstract class NoteListEvent extends Equatable {
  const NoteListEvent();

  @override
  List<Object?> get props => [];
}

class NoteListLoad extends NoteListEvent {}
