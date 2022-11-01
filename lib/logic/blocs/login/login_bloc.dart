import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/data/repositories/auth_repository.dart';
import 'package:flutternotestest/fields/fields.dart';
import 'package:formz/formz.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onLoginEmailChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginValidateForm>(_onLoginValidateForm);
    on<LoginFormSubmitted>(_onLoginFormSubmitted);
  }

  FutureOr<void> _onLoginEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) async {
    final emailField = EmailField.dirty(
      isRequired: true,
      value: event.value?.trim(),
    );
    emit(state.copyWith(emailField: emailField));
    add(LoginValidateForm());
  }

  FutureOr<void> _onLoginPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    final passwordField = TextField.dirty(
      isRequired: true,
      value: event.value?.trim(),
    );
    emit(state.copyWith(passwordField: passwordField));
    add(LoginValidateForm());
  }

  FutureOr<void> _onLoginValidateForm(
    LoginValidateForm event,
    Emitter<LoginState> emit,
  ) {
    final fields = <FormzInput>[
      state.emailField,
      state.passwordField,
    ];
    emit(state.copyWith(status: Formz.validate(fields)));
  }

  FutureOr<void> _onLoginFormSubmitted(
    LoginFormSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status.isSubmissionInProgress) return;
    if (!state.status.isValidated) {
      return add(LoginValidateForm());
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final email = state.emailField.value;
      final password = state.passwordField.value;
      if (email == null || password == null) throw 'An error occured';
      await _authRepository.login(
        email: email,
        password: password,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        error: e.toString(),
      ));
    }
  }
}
