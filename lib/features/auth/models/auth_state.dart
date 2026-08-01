import 'auth_user.dart';

enum AuthStatus { checking, unauthenticated, authenticated }

class AuthState {
  const AuthState._({required this.status, this.user});

  const AuthState.checking() : this._(status: AuthStatus.checking);
  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);
  const AuthState.authenticated(AuthUser user)
    : this._(status: AuthStatus.authenticated, user: user);

  final AuthStatus status;
  final AuthUser? user;

  bool get isAuthenticated => status == AuthStatus.authenticated;
}
