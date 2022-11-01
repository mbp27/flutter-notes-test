part of 'logout_bloc.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];
}

class LogoutInitial extends LogoutState {}

class LogoutStartedInProgress extends LogoutState {}

class LogoutStartedSuccess extends LogoutState {}

class LogoutStartedFailure extends LogoutState {
  final Object error;

  const LogoutStartedFailure({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
