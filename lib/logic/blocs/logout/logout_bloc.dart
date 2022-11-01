import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/data/repositories/auth_repository.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRepository _authRepository;

  LogoutBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LogoutInitial()) {
    on<LogoutStarted>(_onLogoutStarted);
  }

  FutureOr<void> _onLogoutStarted(
      LogoutStarted event, Emitter<LogoutState> emit) async {
    try {
      emit(LogoutStartedInProgress());
      await _authRepository.logout();
      emit(LogoutStartedSuccess());
    } catch (e) {
      emit(LogoutStartedFailure(error: e));
    }
  }
}
