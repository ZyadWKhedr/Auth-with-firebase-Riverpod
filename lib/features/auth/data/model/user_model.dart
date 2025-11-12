class UserModel {
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? displayName;

  UserModel({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.displayName,
  });

  factory UserModel.fromFirebaseUser(dynamic user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      phoneNumber: user.phoneNumber,
      displayName: user.displayName,
    );
  }
}
