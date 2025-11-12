class User {
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? displayName;

  User({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.displayName,
  });
}