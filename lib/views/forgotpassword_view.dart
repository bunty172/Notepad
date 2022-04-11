import 'package:flutter/material.dart';
import 'package:notepad/dialogs/autherror_dialog.dart';
import 'package:notepad/dialogs/showinfo_dialog.dart';
import 'package:notepad/firebase/auth_service.dart';
import 'package:notepad/firebase/firebase_exceptions.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const Text(
            "Please Enter Your email:",
            style: TextStyle(fontSize: 20),
          ),
          TextField(
            decoration: const InputDecoration(hintText: "Enter your email"),
            controller: _controller,
          ),
          TextButton(
              onPressed: () async {
                final email = _controller.text;
                try {
                  await AuthService.firebase()
                      .sendpasswordResetLink(email: email);
                  await showInfoDialog(context,
                      "Password Reset link has been sent to your email");
                } on InvalidEmailException {
                  await showAuthErrorDialog(
                      context, "Please enter a valid email");
                } on UserNotFoundException {
                  await showAuthErrorDialog(context, "User Not found");
                } on GenericException {
                  await showAuthErrorDialog(context, "Something Went Wrong ");
                }
              },
              child: const Text(
                "Send reset link",
                style: TextStyle(fontSize: 20),
              ))
        ]),
      ),
    );
  }
}
