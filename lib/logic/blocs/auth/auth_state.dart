part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final User user;
  final DateTime? refreshTime;
  final String? error;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user = User.empty,
    this.refreshTime,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    DateTime? refreshTime,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      refreshTime: refreshTime ?? this.refreshTime,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props {
    return [
      status,
      user,
      refreshTime,
      error,
    ];
  }
}
