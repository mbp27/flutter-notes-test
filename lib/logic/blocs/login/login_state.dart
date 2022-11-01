part of 'login_bloc.dart';

class LoginState extends Equatable {
  final EmailField emailField;
  final TextField passwordField;
  final FormzStatus status;
  final String? error;

  const LoginState({
    this.emailField = const EmailField.pure(),
    this.passwordField = const TextField.pure(),
    this.status = FormzStatus.pure,
    this.error,
  });

  bool get saveButtonActive =>
      status.isValid ||
      status.isSubmissionFailure ||
      status.isSubmissionSuccess;

  LoginState copyWith({
    EmailField? emailField,
    TextField? passwordField,
    FormzStatus? status,
    String? error,
  }) {
    return LoginState(
      emailField: emailField ?? this.emailField,
      passwordField: passwordField ?? this.passwordField,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props {
    return [
      emailField,
      passwordField,
      status,
      error,
    ];
  }
}
