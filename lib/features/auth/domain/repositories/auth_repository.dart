import 'package:firebase_auth/firebase_auth.dart' hide User;

import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signUpWithEmail(String email, String password);
  Future<User> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<User> signInWithGoogle();
  Future<User> signInWithApple();
  Future<void> signInWithPhone({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(FirebaseAuthException e) verificationFailed,
    required void Function(PhoneAuthCredential credential) codeAutoRetrieval,
  });
}
