import 'dart:async';

import 'package:flutternotestest/data/models/user.dart';
import 'package:flutternotestest/data/providers/auth_provider.dart';

enum AuthStatus { unknown, error, authenticated, unauthenticated }

class AuthRepository {
  final _controller = StreamController<AuthStatus>();
  final _authProvider = AuthProvider();

  Stream<AuthStatus> get status async* {
    bool isLoggedIn = await _authProvider.isLoggedIn();
    if (isLoggedIn) {
      yield AuthStatus.authenticated;
    } else {
      yield AuthStatus.unauthenticated;
    }
    yield* _controller.stream;
  }

  void dispose() => _controller.close();

  /// Login with email
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authProvider.login(email: email, password: password);
      if (user == null) return null;
      _controller.add(AuthStatus.authenticated);
      return User.fromMap(user);
    } catch (e) {
      rethrow;
    }
  }

  /// Update user
  Future<User> update({required int id, required User user}) async {
    try {
      final userUpdated = await _authProvider.update(id: id, user: user);
      return User.fromMap(userUpdated);
    } catch (e) {
      rethrow;
    }
  }

  /// For logout current user
  Future<void> logout() async {
    try {
      await _authProvider.logout();
      _controller.add(AuthStatus.unauthenticated);
    } catch (e) {
      rethrow;
    }
  }

  /// For check if user is logged in or not
  Future<bool> isLoggedIn() => _authProvider.isLoggedIn();

  /// For get user data loggedin
  Future<User> user() async {
    try {
      final user = await _authProvider.user();
      if (user != null) {
        return User.fromMap(user);
      }
      return User.empty;
    } catch (e) {
      rethrow;
    }
  }
}
