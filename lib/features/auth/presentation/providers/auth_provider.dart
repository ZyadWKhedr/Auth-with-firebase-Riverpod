import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/remote_auth_datasource.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_apple.dart';
import '../../domain/usecases/sign_in_email.dart';
import '../../domain/usecases/sign_in_google.dart';
import '../../domain/usecases/sign_in_phone.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up_email.dart';
import '../states/auth_state.dart';
import 'auth_notifier.dart';

// Data layer providers
/// Provider for the remote authentication data source.
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return AuthDataSource();
});

// Domain layer providers
/// Provider for the authentication repository.
/// TODO: Replace with AuthRepositoryImpl once implemented.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError('AuthRepositoryImpl not implemented');
});

/// Provider for the SignInWithEmail use case.
final signInWithEmailProvider = Provider<SignInWithEmail>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInWithEmail(repository);
});

/// Provider for the SignUpWithEmail use case.
final signUpWithEmailProvider = Provider<SignUpWithEmail>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpWithEmail(repository);
});

/// Provider for the SignOut use case.
final signOutProvider = Provider<SignOut>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOut(repository);
});

/// Provider for the SignInWithGoogle use case.
final signInWithGoogleProvider = Provider<SignInWithGoogle>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInWithGoogle(repository);
});

/// Provider for the SignInWithApple use case.
final signInWithAppleProvider = Provider<SignInWithApple>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInWithApple(repository);
});

/// Provider for the SignInWithPhone use case.
final signInWithPhoneProvider = Provider<SignInWithPhone>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInWithPhone(repository);
});

// Presentation layer provider
/// NotifierProvider for managing authentication state.
/// Provides methods to perform auth operations and updates the AuthState.
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});