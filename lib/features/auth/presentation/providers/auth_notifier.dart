import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/sign_in_apple.dart';
import '../../domain/usecases/sign_in_email.dart';
import '../../domain/usecases/sign_in_google.dart';
import '../../domain/usecases/sign_in_phone.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up_email.dart';
import '../states/auth_state.dart';

/// Notifier for managing authentication state in Riverpod.
/// Handles authentication operations and updates the AuthState accordingly.
class AuthNotifier extends Notifier<AuthState> {
  late final SignInWithEmail _signInWithEmailUC;
  late final SignUpWithEmail _signUpWithEmailUC;
  late final SignOut _signOutUC;
  late final SignInWithGoogle _signInWithGoogleUC;
  late final SignInWithApple _signInWithAppleUC;
  late final SignInWithPhone _signInWithPhoneUC;

  @override
  AuthState build() {
    _signInWithEmailUC = ref.watch(signInWithEmailProvider);
    _signUpWithEmailUC = ref.watch(signUpWithEmailProvider);
    _signOutUC = ref.watch(signOutProvider);
    _signInWithGoogleUC = ref.watch(signInWithGoogleProvider);
    _signInWithAppleUC = ref.watch(signInWithAppleProvider);
    _signInWithPhoneUC = ref.watch(signInWithPhoneProvider);
    return AuthState(status: AuthStateStatus.initial);
  }

  /// Attempts to sign in with email and password.
  /// Updates state to loading, then success or error.
  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(status: AuthStateStatus.loading);
    try {
      final user = await _signInWithEmailUC(email, password);
      state = state.copyWith(status: AuthStateStatus.success, user: user);
    } catch (e) {
      state = state.copyWith(
        status: AuthStateStatus.error,
        error: e.toString(),
      );
    }
  }

  /// Attempts to sign up with email and password.
  /// Updates state to loading, then success or error.
  Future<void> signUpWithEmail(String email, String password) async {
    state = state.copyWith(status: AuthStateStatus.loading);
    try {
      final user = await _signUpWithEmailUC(email, password);
      state = state.copyWith(status: AuthStateStatus.success, user: user);
    } catch (e) {
      state = state.copyWith(
        status: AuthStateStatus.error,
        error: e.toString(),
      );
    }
  }

  /// Signs out the current user.
  /// Updates state to loading, then success or error.
  Future<void> signOut() async {
    state = state.copyWith(status: AuthStateStatus.loading);
    try {
      await _signOutUC();
      state = state.copyWith(status: AuthStateStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: AuthStateStatus.error,
        error: e.toString(),
      );
    }
  }

  /// Attempts to sign in with Google.
  /// Updates state to loading, then success or error.
  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStateStatus.loading);
    try {
      final user = await _signInWithGoogleUC();
      state = state.copyWith(status: AuthStateStatus.success, user: user);
    } catch (e) {
      state = state.copyWith(
        status: AuthStateStatus.error,
        error: e.toString(),
      );
    }
  }

  /// Attempts to sign in with Apple.
  /// Updates state to loading, then success or error.
  Future<void> signInWithApple() async {
    state = state.copyWith(status: AuthStateStatus.loading);
    try {
      final user = await _signInWithAppleUC();
      state = state.copyWith(status: AuthStateStatus.success, user: user);
    } catch (e) {
      state = state.copyWith(
        status: AuthStateStatus.error,
        error: e.toString(),
      );
    }
  }
}
