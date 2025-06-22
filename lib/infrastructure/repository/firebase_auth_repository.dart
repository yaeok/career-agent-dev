import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/model/app_user.dart';
import '../../domain/repository/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._firebaseAuth);
  final FirebaseAuth _firebaseAuth;

  AppUser? _convertAppUser(User? firebaseUser) {
    if (firebaseUser == null) return null;
    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email);
  }

  @override
  Stream<AppUser?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map(_convertAppUser);

  @override
  Future<AppUser?> getCurrentUser() async =>
      _convertAppUser(_firebaseAuth.currentUser);

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async => await _firebaseAuth.signOut();
}
