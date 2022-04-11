import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notepad/dialogs/autherror_dialog.dart';
import 'package:notepad/firebase/auth_provider.dart';
import 'package:notepad/firebase/auth_user.dart';
import 'package:notepad/firebase/firebase_exceptions.dart';
import 'package:notepad/firebase_options.dart';

class FirebaseAuthProvider extends AuthProvider {
  @override
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw AuthenticationErrorException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailException();
        case 'email-already-in-use':
          throw AlreadyRegisteredException();
        case 'weak-password':
          throw WeakPasswordExeption();
        default:
          throw GenericException();
      }
    }
  }

  @override
  Future<AuthUser?> login(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw AuthenticationErrorException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          throw WrongPasswordException();
        case "user-not-found":
          throw UserNotFoundException();
        case "invalid-email":
          throw InvalidEmailException();
        default:
          throw AuthenticationErrorException();
      }
    } catch (_) {
      throw GenericException();
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.sendEmailVerification();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> sendpasswordResetLink({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        throw InvalidEmailException();
      } else if (e.code == "user-not-found") {
        throw UserNotFoundException();
      } else {
        throw GenericException();
      }
    }
  }
}
