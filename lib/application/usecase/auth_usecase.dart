import '../../domain/repository/auth_repository.dart';

class AuthUsecase {
  AuthUsecase(this._authRepository);
  final AuthRepository _authRepository;

  Future<void> signIn(String email, String password) => _authRepository
      .signInWithEmailAndPassword(email: email, password: password);

  Future<void> signUp(String email, String password) => _authRepository
      .signUpWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() => _authRepository.signOut();
}
