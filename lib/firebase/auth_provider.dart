import 'auth_user.dart';

abstract class AuthProvider {
  Future<void> initializeFirebase();

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<AuthUser?> login({
    required String email,
    required String password,
  });

  AuthUser? get currentUser;

  Future<void> logout();

  Future<void> sendVerificationEmail();

  Future<void> sendpasswordResetLink({required String email});
}
