import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication error occurred']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error occurred']);
}
