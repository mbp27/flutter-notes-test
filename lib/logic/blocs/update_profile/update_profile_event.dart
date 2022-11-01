part of 'update_profile_bloc.dart';

abstract class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileInitial extends UpdateProfileEvent {
  final User user;

  const UpdateProfileInitial({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

class UpdateProfilePhotoChanged extends UpdateProfileEvent {
  final String? value;

  const UpdateProfilePhotoChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateProfileFirstNameChanged extends UpdateProfileEvent {
  final String? value;

  const UpdateProfileFirstNameChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateProfileLastNameChanged extends UpdateProfileEvent {
  final String? value;

  const UpdateProfileLastNameChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateProfileGenderChanged extends UpdateProfileEvent {
  final Gender? value;

  const UpdateProfileGenderChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateProfileDateOfBirthChanged extends UpdateProfileEvent {
  final DateTime? value;

  const UpdateProfileDateOfBirthChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateProfileValidateForm extends UpdateProfileEvent {}

class UpdateProfileFormSubmitted extends UpdateProfileEvent {
  final User user;

  const UpdateProfileFormSubmitted({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}
