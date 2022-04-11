import 'package:flutter/material.dart';
import 'package:notepad/constants/routes.dart';
import 'package:notepad/dialogs/autherror_dialog.dart';
import 'package:notepad/firebase/firebase_exceptions.dart';
import 'package:notepad/loadingscreens/loadingscreen.dart';
import '../firebase/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final LoadingScreen loadingScreen;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    loadingScreen = LoadingScreen(context: context);
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter Your Email",
              ),
              controller: _email,
              autofocus: true,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter Your Password",
              ),
              controller: _password,
              obscureText: true,
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  loadingScreen.showOverlay();
                  await AuthService.firebase().login(
                    email: email,
                    password: password,
                  );
                  final user = AuthService.firebase().currentUser;
                  if (user != null) {
                    loadingScreen.removeOverlay();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  } else {
                    loadingScreen.removeOverlay();
                    throw UserNotLoggedInException();
                  }
                } on UserNotFoundException {
                  loadingScreen.removeOverlay();
                  await showAuthErrorDialog(context, "UserNotFound");
                } on WrongPasswordException {
                  loadingScreen.removeOverlay();
                  await showAuthErrorDialog(context, "WrongPassword");
                } on InvalidEmailException {
                  loadingScreen.removeOverlay();
                  await showAuthErrorDialog(
                      context, "Please enter valid email");
                } catch (_) {
                  loadingScreen.removeOverlay();
                  await showAuthErrorDialog(context, "Authentication Error");
                }
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text(
                "Haven't Registered Yet?",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(forgotPasswordRoute);
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
