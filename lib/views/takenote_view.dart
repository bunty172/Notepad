import 'package:flutter/material.dart';
import 'package:notepad/crud/database_service.dart';
import 'package:notepad/firebase/auth_service.dart';

class TakeNote extends StatefulWidget {
  const TakeNote({Key? key}) : super(key: key);

  @override
  State<TakeNote> createState() => _TakeNoteState();
}

class _TakeNoteState extends State<TakeNote> {
  late final TextEditingController _noteTextController;
  late final DatabaseService _databaseService;
  final String email = AuthService.firebase().currentUser!.email;
  @override
  void initState() {
    _databaseService = DatabaseService();
    _noteTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    saveNoteIfTextNotEmpty();
    _noteTextController.dispose();
    super.dispose();
  }

  void saveNoteIfTextNotEmpty() async {
    if(_noteTextController.text.isNotEmpty){
       final dbUser = await _databaseService.getDatabaseUser(email: email);
    await _databaseService.createNote(
        dbUser: dbUser, text: _noteTextController.text);
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Take Your Note"),
        ),
        body: TextField(
          decoration: const InputDecoration(hintText: "Take Your Note here"),
          controller: _noteTextController,
        ));
  }
}
