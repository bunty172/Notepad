import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String email;
  final bool isEmailVerified;

  AuthUser({
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(
      email: user.email!,
      isEmailVerified: user.emailVerified,
    );
  }
}
