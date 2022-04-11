import 'package:notepad/firebase/auth_provider.dart';
import 'package:notepad/firebase/auth_user.dart';
import 'package:notepad/firebase/firebaseauth_provider.dart';

class AuthService extends AuthProvider {
  final FirebaseAuthProvider firebaseAuthProvider;
  AuthService(this.firebaseAuthProvider);
  factory AuthService.firebase() {
    return AuthService(FirebaseAuthProvider());
  }

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) {
    return firebaseAuthProvider.createUser(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => firebaseAuthProvider.currentUser;

  @override
  Future<void> initializeFirebase() {
    return firebaseAuthProvider.initializeFirebase();
  }

  @override
  Future<AuthUser?> login({required String email, required String password}) {
    return firebaseAuthProvider.login(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return firebaseAuthProvider.logout();
  }

  @override
  Future<void> sendVerificationEmail() {
    return firebaseAuthProvider.sendVerificationEmail();
  }

  @override
  Future<void> sendpasswordResetLink({required String email}) {
    return firebaseAuthProvider.sendpasswordResetLink(email: email);
  }
}
