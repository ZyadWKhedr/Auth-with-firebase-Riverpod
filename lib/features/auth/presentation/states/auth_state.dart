import '../../domain/entities/user.dart';

/// Enum representing the possible statuses of the authentication state.
enum AuthStateStatus { initial, loading, success, error }

/// Immutable state class for managing authentication UI state.
/// Used in Riverpod providers to handle loading, success, and error states.
class AuthState {
  /// The current status of the authentication process.
  final AuthStateStatus status;
  /// The authenticated user, null if not authenticated or on error.
  final User? user;
  /// Error message if status is error, null otherwise.
  final String? error;

  /// Constructor for AuthState.
  AuthState({
    required this.status,
    this.user,
    this.error,
  });

  /// Creates a copy of this AuthState with optionally updated fields.
  /// Useful for immutable state updates in Riverpod.
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