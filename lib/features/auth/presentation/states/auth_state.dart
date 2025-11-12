import '../../domain/entities/user.dart';

enum AuthStateStatus { initial, loading, success, error }

class AuthState {
  final AuthStateStatus status;
  final User? user;
  final String? error;

  AuthState({
    required this.status,
    this.user,
    this.error,
  });

  AuthState copyWith({
    AuthStateStatus? status,
    User? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}