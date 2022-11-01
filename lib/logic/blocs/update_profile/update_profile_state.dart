part of 'update_profile_bloc.dart';

enum UpdateProfileLoadState { initial, inProgress, success, failure }

class UpdateProfileState extends Equatable {
  final User user;
  final String? photo;
  final TextField firstNameField;
  final TextField lastNameField;
  final DropdownField<Gender> genderField;
  final DateTimeField dateOfBirthField;
  final FormzStatus status;
  final UpdateProfileLoadState loadState;
  final String? error;

  const UpdateProfileState({
    this.user = User.empty,
    this.photo,
    this.firstNameField = const TextField.pure(),
    this.lastNameField = const TextField.pure(),
    this.genderField = const DropdownField<Gender>.pure(),
    this.dateOfBirthField = const DateTimeField.pure(),
    this.status = FormzStatus.pure,
    this.loadState = UpdateProfileLoadState.initial,
    this.error,
  });

  bool get saveButtonActive =>
      status.isValid ||
      status.isSubmissionFailure ||
      status.isSubmissionSuccess;

  UpdateProfileState copyWith({
    User? user,
    String? photo,
    TextField? firstNameField,
    TextField? lastNameField,
    DropdownField<Gender>? genderField,
    DateTimeField? dateOfBirthField,
    FormzStatus? status,
    UpdateProfileLoadState? loadState,
    String? error,
  }) {
    return UpdateProfileState(
      user: user ?? this.user,
      photo: photo ?? this.photo,
      firstNameField: firstNameField ?? this.firstNameField,
      lastNameField: lastNameField ?? this.lastNameField,
      genderField: genderField ?? this.genderField,
      dateOfBirthField: dateOfBirthField ?? this.dateOfBirthField,
      status: status ?? this.status,
      loadState: loadState ?? this.loadState,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props {
    return [
      user,
      photo,
      firstNameField,
      lastNameField,
      genderField,
      dateOfBirthField,
      status,
      loadState,
      error,
    ];
  }
}
