part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginEvent {}

class LoginEmailChanged extends LoginEvent {
  final String? value;

  const LoginEmailChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class LoginPasswordChanged extends LoginEvent {
  final String? value;

  const LoginPasswordChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class LoginValidateForm extends LoginEvent {}

class LoginFormSubmitted extends LoginEvent {}
