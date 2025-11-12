import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/errors/exception.dart';
import '../model/user_model.dart';

/// Data source for handling remote authentication operations with Firebase Auth.
/// Provides methods for email/password, Google, Apple, and phone sign-in/sign-up.
class AuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  bool _isGoogleSignInInitialized = false;

  AuthDataSource({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn.instance {
    _initializeGoogleSignIn();
  }

  /// Initializes the Google Sign-In instance asynchronously.
  /// Required in google_sign_in v7 before performing authentication.
  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
    } catch (e) {
      log(e.toString());
      throw FirebaseAuthExceptionWrapper(e.toString());
    }
  }

  /// Ensures Google Sign-In is initialized before use.
  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

  /// Signs in a user with email and password using Firebase Auth.
  /// Returns a UserModel on success, throws FirebaseAuthExceptionWrapper on failure.
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionWrapper(e.toString());
    }
  }

  /// Signs up a new user with email and password using Firebase Auth.
  /// Returns a UserModel on success, throws FirebaseAuthExceptionWrapper on failure.
  Future<UserModel> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(userCredential.user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionWrapper(e.toString());
    }
  }

  /// Signs out the current user from both Google Sign-In and Firebase Auth.
  /// Returns a UserModel (likely null or guest), throws FirebaseAuthExceptionWrapper on failure.
  Future<UserModel> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return UserModel.fromFirebaseUser(_firebaseAuth.currentUser!);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionWrapper(e.toString());
    }
  }

  /// Signs in a user with Google account using Firebase Auth.
  /// Initializes Google Sign-In if needed, authenticates, and creates Firebase credential.
  /// Returns a UserModel on success, throws FirebaseAuthExceptionWrapper on failure.
  Future<UserModel> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      final googleSignInAccount = await _googleSignIn.authenticate();
      final googleAuth = googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionWrapper(e.toString());
    }
  }

  /// Signs in a user with Apple ID using Firebase Auth.
  /// Requests Apple credentials with email and full name scopes, creates OAuth credential.
  /// Returns a UserModel on success, throws FirebaseAuthExceptionWrapper on failure.
  Future<UserModel> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthProvider = OAuthProvider("apple.com");
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      throw FirebaseAuthExceptionWrapper(e.toString());
    }
  }

  /// Initiates phone number verification for sign-in using Firebase Auth.
  /// Sends OTP to the phone number and provides callbacks for code sent, verification failed, etc.
  /// Does not return a UserModel; use the callbacks to complete sign-in.
  Future<void> signInWithPhone({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(FirebaseAuthException e) verificationFailed,
    required void Function(PhoneAuthCredential credential) codeAutoRetrieval,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) {
        codeAutoRetrieval(credential);
      },
      verificationFailed: (e) {
        verificationFailed(e);
      },
      codeSent: (verificationId, resendToken) {
        codeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }
}
