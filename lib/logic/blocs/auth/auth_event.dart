part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthUserChanges extends AuthEvent {
  final User user;

  AuthUserChanges({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

class AuthStatusChanged extends AuthEvent {
  final AuthStatus status;

  AuthStatusChanged(this.status);

  @override
  List<Object?> get props => [status];
}

class AuthRefresh extends AuthEvent {}
