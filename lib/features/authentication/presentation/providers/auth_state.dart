import 'package:equatable/equatable.dart';
import 'package:venture_link/features/authentication/domain/entities/user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  emailNotVerified,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  const AuthState.initial() : this();

  const AuthState.loading()
      : this(status: AuthStatus.loading);

  const AuthState.authenticated(UserEntity user)
      : this(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this(status: AuthStatus.unauthenticated);

  const AuthState.emailNotVerified(UserEntity user)
      : this(status: AuthStatus.emailNotVerified, user: user);

  const AuthState.error(String message)
      : this(status: AuthStatus.unauthenticated, errorMessage: message);

  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  bool get isEmailNotVerified =>
      status == AuthStatus.emailNotVerified && user != null;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
