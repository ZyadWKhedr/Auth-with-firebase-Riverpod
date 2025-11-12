import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmail {
  final AuthRepository repository;

  SignUpWithEmail(this.repository);

  Future<User> call(String email, String password) async {
    return await repository.signUpWithEmail(email, password);
  }
}
