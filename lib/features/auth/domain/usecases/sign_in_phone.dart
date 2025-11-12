import 'package:firebase_auth/firebase_auth.dart';

import '../repositories/auth_repository.dart';

class SignInWithPhone {
  final AuthRepository repository;

  SignInWithPhone(this.repository);

  Future<void> call({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(FirebaseAuthException e) verificationFailed,
    required void Function(PhoneAuthCredential credential) codeAutoRetrieval,
  }) async {
    await repository.signInWithPhone(
      phoneNumber: phoneNumber,
      codeSent: codeSent,
      verificationFailed: verificationFailed,
      codeAutoRetrieval: codeAutoRetrieval,
    );
  }
}
