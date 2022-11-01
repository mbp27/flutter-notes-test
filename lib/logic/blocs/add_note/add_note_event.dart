part of 'add_note_bloc.dart';

abstract class AddNoteEvent extends Equatable {
  const AddNoteEvent();

  @override
  List<Object?> get props => [];
}

class AddNoteInitial extends AddNoteEvent {
  final Note? note;

  const AddNoteInitial({
    this.note,
  });

  @override
  List<Object?> get props => [note];
}

class AddNoteFileChanged extends AddNoteEvent {
  final String? value;

  const AddNoteFileChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class AddNoteTitleChanged extends AddNoteEvent {
  final String? value;

  const AddNoteTitleChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class AddNoteDescriptionChanged extends AddNoteEvent {
  final String? value;

  const AddNoteDescriptionChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class AddNoteReminderChanged extends AddNoteEvent {
  final bool? value;
  final DateTime? reminderTime;
  final ReminderInterval? reminderInterval;

  const AddNoteReminderChanged(
    this.value, {
    this.reminderTime,
    this.reminderInterval,
  });

  @override
  List<Object?> get props => [value, reminderTime, reminderInterval];
}

class AddNoteReminderTimeChanged extends AddNoteEvent {
  final DateTime? value;

  const AddNoteReminderTimeChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class AddNoteReminderIntervalChanged extends AddNoteEvent {
  final ReminderInterval? value;

  const AddNoteReminderIntervalChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class AddNoteValidateForm extends AddNoteEvent {}

class AddNoteFormSubmitted extends AddNoteEvent {
  final Note? note;

  const AddNoteFormSubmitted({
    required this.note,
  });

  @override
  List<Object?> get props => [note];
}
