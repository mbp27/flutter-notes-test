part of 'add_note_bloc.dart';

enum AddNoteLoadState { initial, inProgress, success, failure }

class AddNoteState extends Equatable {
  final Note note;
  final String? file;
  final TextField titleField;
  final TextField descriptionField;
  final bool reminder;
  final DateTimeField reminderTimeField;
  final DropdownField<ReminderInterval> reminderIntervalField;
  final FormzStatus status;
  final AddNoteLoadState loadState;
  final String? error;

  const AddNoteState({
    this.note = const Note(),
    this.file,
    this.titleField = const TextField.pure(),
    this.descriptionField = const TextField.pure(),
    this.reminder = false,
    this.reminderTimeField = const DateTimeField.pure(isRequired: false),
    this.reminderIntervalField =
        const DropdownField<ReminderInterval>.pure(isRequired: false),
    this.status = FormzStatus.pure,
    this.loadState = AddNoteLoadState.initial,
    this.error,
  });

  bool get saveButtonActive =>
      status.isValid ||
      status.isSubmissionFailure ||
      status.isSubmissionSuccess;

  AddNoteState copyWith({
    Note? note,
    String? file,
    TextField? titleField,
    TextField? descriptionField,
    bool? reminder,
    DateTimeField? reminderTimeField,
    DropdownField<ReminderInterval>? reminderIntervalField,
    FormzStatus? status,
    AddNoteLoadState? loadState,
    String? error,
  }) {
    return AddNoteState(
      note: note ?? this.note,
      file: file ?? this.file,
      titleField: titleField ?? this.titleField,
      descriptionField: descriptionField ?? this.descriptionField,
      reminder: reminder ?? this.reminder,
      reminderTimeField: reminderTimeField ?? this.reminderTimeField,
      reminderIntervalField:
          reminderIntervalField ?? this.reminderIntervalField,
      status: status ?? this.status,
      loadState: loadState ?? this.loadState,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props {
    return [
      note,
      file,
      titleField,
      descriptionField,
      reminder,
      reminderTimeField,
      reminderIntervalField,
      status,
      loadState,
      error,
    ];
  }
}
