import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/data/models/user.dart';
import 'package:flutternotestest/data/repositories/auth_repository.dart';
import 'package:flutternotestest/fields/fields.dart';
import 'package:formz/formz.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final AuthRepository _authRepository;

  UpdateProfileBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const UpdateProfileState()) {
    on<UpdateProfileInitial>(_onUpdateProfileInitial);
    on<UpdateProfilePhotoChanged>(_onUpdateProfilePhotoChanged);
    on<UpdateProfileFirstNameChanged>(_onUpdateProfileFirstNameChanged);
    on<UpdateProfileLastNameChanged>(_onUpdateProfileLastNameChanged);
    on<UpdateProfileGenderChanged>(_onUpdateProfileGenderChanged);
    on<UpdateProfileDateOfBirthChanged>(_onUpdateProfileDateOfBirthChanged);
    on<UpdateProfileValidateForm>(_onUpdateProfileValidateForm);
    on<UpdateProfileFormSubmitted>(_onUpdateProfileFormSubmitted);
  }

  FutureOr<void> _onUpdateProfileInitial(
    UpdateProfileInitial event,
    Emitter<UpdateProfileState> emit,
  ) async {
    try {
      emit(const UpdateProfileState(
        loadState: UpdateProfileLoadState.inProgress,
      ));
      add(UpdateProfilePhotoChanged(event.user.profilePicture));
      add(UpdateProfileFirstNameChanged(event.user.firstName));
      add(UpdateProfileLastNameChanged(event.user.lastName));
      add(UpdateProfileGenderChanged(event.user.gender));
      add(UpdateProfileDateOfBirthChanged(event.user.dateOfBirth));
      emit(state.copyWith(loadState: UpdateProfileLoadState.success));
    } catch (e) {
      emit(state.copyWith(
        loadState: UpdateProfileLoadState.success,
        error: e.toString(),
      ));
    }
  }

  FutureOr<void> _onUpdateProfilePhotoChanged(
    UpdateProfilePhotoChanged event,
    Emitter<UpdateProfileState> emit,
  ) async {
    emit(state.copyWith(photo: event.value));
    add(UpdateProfileValidateForm());
  }

  FutureOr<void> _onUpdateProfileFirstNameChanged(
    UpdateProfileFirstNameChanged event,
    Emitter<UpdateProfileState> emit,
  ) async {
    final firstNameField = TextField.dirty(
      isRequired: true,
      value: event.value?.trim(),
    );
    emit(state.copyWith(firstNameField: firstNameField));
    add(UpdateProfileValidateForm());
  }

  FutureOr<void> _onUpdateProfileLastNameChanged(
    UpdateProfileLastNameChanged event,
    Emitter<UpdateProfileState> emit,
  ) async {
    final lastNameField = TextField.dirty(
      isRequired: true,
      value: event.value?.trim(),
    );
    emit(state.copyWith(lastNameField: lastNameField));
    add(UpdateProfileValidateForm());
  }

  FutureOr<void> _onUpdateProfileGenderChanged(
    UpdateProfileGenderChanged event,
    Emitter<UpdateProfileState> emit,
  ) async {
    final genderField = DropdownField<Gender>.dirty(
      isRequired: true,
      value: event.value,
    );
    emit(state.copyWith(genderField: genderField));
    add(UpdateProfileValidateForm());
  }

  FutureOr<void> _onUpdateProfileDateOfBirthChanged(
    UpdateProfileDateOfBirthChanged event,
    Emitter<UpdateProfileState> emit,
  ) async {
    final dateOfBirthField = DateTimeField.dirty(
      isRequired: true,
      value: event.value,
    );
    emit(state.copyWith(dateOfBirthField: dateOfBirthField));
    add(UpdateProfileValidateForm());
  }

  FutureOr<void> _onUpdateProfileValidateForm(
    UpdateProfileValidateForm event,
    Emitter<UpdateProfileState> emit,
  ) {
    final fields = <FormzInput>[
      state.firstNameField,
      state.lastNameField,
      state.genderField,
      state.dateOfBirthField,
    ];
    emit(state.copyWith(status: Formz.validate(fields)));
  }

  FutureOr<void> _onUpdateProfileFormSubmitted(
    UpdateProfileFormSubmitted event,
    Emitter<UpdateProfileState> emit,
  ) async {
    if (state.status.isSubmissionInProgress) return;
    if (!state.status.isValidated) {
      return add(UpdateProfileValidateForm());
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final userId = event.user.id;
      final firstName = state.firstNameField.value;
      final lastName = state.lastNameField.value;
      final gender = state.genderField.value;
      final dateOfBirth = state.dateOfBirthField.value;
      final profilePicture = state.photo;
      if (userId == null ||
          firstName == null ||
          lastName == null ||
          gender == null ||
          dateOfBirth == null) {
        throw 'An error occured';
      }
      final user = await _authRepository.update(
        id: userId,
        user: User(
          id: userId,
          firstName: firstName,
          lastName: lastName,
          gender: gender,
          dateOfBirth: dateOfBirth,
          profilePicture: profilePicture,
        ),
      );
      emit(state.copyWith(
        user: user,
        status: FormzStatus.submissionSuccess,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        error: e.toString(),
      ));
    }
  }
}
