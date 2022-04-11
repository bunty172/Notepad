import 'package:flutter/material.dart';
import 'package:notepad/constants/routes.dart';
import 'package:notepad/firebase/auth_service.dart';
import 'package:notepad/firebase/firebase_exceptions.dart';
import 'package:notepad/loadingscreens/loadingscreen.dart';
import '../dialogs/autherror_dialog.dart';
import '../dialogs/verificationemail_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text("Register")),
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
                  await AuthService.firebase()
                      .createUser(email: email, password: password);
                  loadingScreen.removeOverlay();
                  await showverificationEmailSent(context,
                      "A verification Email link has been sent your Email,Kindly verify your eamil");
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                } on WeakPasswordExeption {
                  loadingScreen.removeOverlay();
                  await showAuthErrorDialog(context, "Password is too Weak");
                } on InvalidEmailException {
                  loadingScreen.removeOverlay();
                  await showAuthErrorDialog(
                      context, "Email is not Valid,Try with differnet email");
                } on AlreadyRegisteredException {
                  loadingScreen.removeOverlay();
                  await showAuthErrorDialog(context, "User already registered");
                } catch (e) {
                  loadingScreen.removeOverlay();
                  await showAuthErrorDialog(context, "Cannot Register");
                }
              },
              child: const Text(
                "Register",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text(
                "Already Registered? Login now",
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
