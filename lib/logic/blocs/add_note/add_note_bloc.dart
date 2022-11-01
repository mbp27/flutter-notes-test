import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/data/models/note.dart';
import 'package:flutternotestest/data/models/push_notification.dart';
import 'package:flutternotestest/data/repositories/note_repository.dart';
import 'package:flutternotestest/fields/fields.dart';
import 'package:flutternotestest/logic/blocs/notification/notification_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

part 'add_note_event.dart';
part 'add_note_state.dart';

class AddNoteBloc extends Bloc<AddNoteEvent, AddNoteState> {
  final NoteRepository _noteRepository;

  AddNoteBloc({
    required NoteRepository noteRepository,
  })  : _noteRepository = noteRepository,
        super(const AddNoteState()) {
    on<AddNoteInitial>(_onAddNoteInitial);
    on<AddNoteFileChanged>(_onAddNoteFileChanged);
    on<AddNoteTitleChanged>(_onAddNoteTitleChanged);
    on<AddNoteDescriptionChanged>(_onAddNoteDescriptionChanged);
    on<AddNoteReminderChanged>(_onAddNoteReminderChanged);
    on<AddNoteReminderTimeChanged>(_onAddNoteReminderTimeChanged);
    on<AddNoteReminderIntervalChanged>(_onAddNoteReminderIntervalChanged);
    on<AddNoteValidateForm>(_onAddNoteValidateForm);
    on<AddNoteFormSubmitted>(_onAddNoteFormSubmitted);
  }

  FutureOr<void> _onAddNoteInitial(
    AddNoteInitial event,
    Emitter<AddNoteState> emit,
  ) async {
    try {
      emit(const AddNoteState(loadState: AddNoteLoadState.inProgress));
      final noteId = event.note?.id;
      if (noteId != null) {
        final note = await _noteRepository.getNoteDetail(noteId);
        if (note == null) throw 'An error occured';
        add(AddNoteFileChanged(note.file));
        add(AddNoteTitleChanged(note.title));
        add(AddNoteDescriptionChanged(note.description));
        add(AddNoteReminderChanged(
          note.reminderTime != null,
          reminderTime: note.reminderTime,
          reminderInterval: note.reminderInterval,
        ));
        // add(AddNoteReminderTimeChanged(note.reminderTime));
        // add(AddNoteReminderIntervalChanged(note.reminderInterval));
      }
      emit(state.copyWith(loadState: AddNoteLoadState.success));
    } catch (e) {
      emit(state.copyWith(
        loadState: AddNoteLoadState.success,
        error: e.toString(),
      ));
    }
  }

  FutureOr<void> _onAddNoteFileChanged(
    AddNoteFileChanged event,
    Emitter<AddNoteState> emit,
  ) async {
    emit(state.copyWith(file: event.value));
    add(AddNoteValidateForm());
  }

  FutureOr<void> _onAddNoteTitleChanged(
    AddNoteTitleChanged event,
    Emitter<AddNoteState> emit,
  ) async {
    final titleField = TextField.dirty(
      isRequired: true,
      value: event.value?.trim(),
    );
    emit(state.copyWith(titleField: titleField));
    add(AddNoteValidateForm());
  }

  FutureOr<void> _onAddNoteDescriptionChanged(
    AddNoteDescriptionChanged event,
    Emitter<AddNoteState> emit,
  ) async {
    final descriptionField = TextField.dirty(
      isRequired: true,
      value: event.value?.trim(),
    );
    emit(state.copyWith(descriptionField: descriptionField));
    add(AddNoteValidateForm());
  }

  FutureOr<void> _onAddNoteReminderChanged(
    AddNoteReminderChanged event,
    Emitter<AddNoteState> emit,
  ) async {
    emit(state.copyWith(reminder: event.value));
    add(AddNoteValidateForm());
    add(AddNoteReminderTimeChanged(event.reminderTime));
    add(AddNoteReminderIntervalChanged(event.reminderInterval));
  }

  FutureOr<void> _onAddNoteReminderTimeChanged(
    AddNoteReminderTimeChanged event,
    Emitter<AddNoteState> emit,
  ) async {
    final reminderTimeField = DateTimeField.dirty(
      isRequired: state.reminder,
      value: event.value,
    );
    emit(state.copyWith(reminderTimeField: reminderTimeField));
    add(AddNoteValidateForm());
  }

  FutureOr<void> _onAddNoteReminderIntervalChanged(
    AddNoteReminderIntervalChanged event,
    Emitter<AddNoteState> emit,
  ) async {
    final reminderIntervalField = DropdownField<ReminderInterval>.dirty(
      isRequired: state.reminder,
      value: event.value,
    );
    emit(state.copyWith(reminderIntervalField: reminderIntervalField));
    add(AddNoteValidateForm());
  }

  FutureOr<void> _onAddNoteValidateForm(
    AddNoteValidateForm event,
    Emitter<AddNoteState> emit,
  ) {
    final fields = <FormzInput>[
      state.titleField,
      state.descriptionField,
      state.reminderTimeField,
      state.reminderIntervalField,
    ];
    emit(state.copyWith(status: Formz.validate(fields)));
  }

  FutureOr<void> _onAddNoteFormSubmitted(
    AddNoteFormSubmitted event,
    Emitter<AddNoteState> emit,
  ) async {
    if (state.status.isSubmissionInProgress) return;
    if (!state.status.isValidated) {
      return add(AddNoteValidateForm());
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final title = state.titleField.value;
      final description = state.descriptionField.value;
      final reminderTime =
          state.reminder ? state.reminderTimeField.value : null;
      final reminderInterval =
          state.reminder ? state.reminderIntervalField.value : null;
      final file = state.file;
      if (title == null || description == null) {
        throw 'An error occured';
      }
      final noteId = event.note?.id;
      final note = Note(
        title: title,
        description: description,
        reminderTime: reminderTime,
        reminderInterval: reminderInterval,
        file: file,
      );
      Note? noteUpdated;
      if (noteId == null) {
        noteUpdated = await _noteRepository.insert(note);
      } else {
        noteUpdated = await _noteRepository.update(id: noteId, note: note);
      }
      final noteUpdatedId = noteUpdated.id;
      if (noteUpdatedId != null) {
        if (reminderTime != null && reminderInterval != null) {
          if (reminderTime.isAfter(DateTime.now()) &&
              reminderInterval != ReminderInterval.no) {
            final time = DateFormat('HH:mm', 'id').format(reminderTime);
            await scheduledNotification(
              scheduledDate: reminderTime.subtract(
                Duration(hours: reminderInterval.durationInHour),
              ),
              payload: PushNotification(
                id: noteUpdatedId,
                title: title,
                body: reminderInterval == ReminderInterval.oneDay
                    ? 'Tomorrow at $time'
                    : 'Today $time',
                typeId: noteUpdatedId.toString(),
                type: PushNotificationType.note,
              ),
            );
          }
        } else {
          await cancelNotification(noteUpdatedId);
        }
      }
      emit(state.copyWith(
        note: noteUpdated,
        status: FormzStatus.submissionSuccess,
      ));
    } catch (e) {
      log(name: 'err', e.toString());
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        error: e.toString(),
      ));
    }
  }
}
