import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:notepad/constants/routes.dart';
import 'package:notepad/firebase/auth_service.dart';
import 'package:notepad/views/forgotpassword_view.dart';
import 'package:notepad/views/login_view.dart';
import 'package:notepad/views/notes_view.dart';
import 'package:notepad/views/register_view.dart';
import 'package:notepad/views/takenote_view.dart';
import 'package:notepad/views/updatenote_view.dart';

void main() {
  runApp(MaterialApp(
    title: "Notepad",
    home: AnimatedSplashScreen(
      duration: 3000,
      splash: Icons.note,
      backgroundColor: Colors.lightBlueAccent,
      nextScreen: const Homepage(),
    ),
    debugShowCheckedModeBanner: false,
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      takenoteRoute: (context) => const TakeNote(),
      updatenoteRoute: (context) => const UpdateNoteView(),
      forgotPasswordRoute: (context) => const ForgotPasswordView(),
    },
  ));
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initializeFirebase(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const NotesView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
