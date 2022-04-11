import 'package:flutter/material.dart';
import 'package:notepad/crud/database_service.dart';
import '../crud/database_note.dart';

class UpdateNoteView extends StatefulWidget {
  const UpdateNoteView({Key? key}) : super(key: key);

  @override
  State<UpdateNoteView> createState() => UpdateNoteViewState();
}

class UpdateNoteViewState extends State<UpdateNoteView> {
  late final TextEditingController _existingNoteTextController;
  late final DatabaseService _databaseService;
  late final DatabaseNote _existingDatabaseNote;

  @override
  void initState() {
    _existingNoteTextController = TextEditingController();
    _databaseService = DatabaseService();
    super.initState();
  }

  @override
  void dispose() {
    updateNoteWhileDisposing(
        existingDatabaseNote: _existingDatabaseNote,
        text: _existingNoteTextController.text);
    _existingNoteTextController.dispose();
    super.dispose();
  }

  void updateNoteWhileDisposing({
    required DatabaseNote existingDatabaseNote,
    required String text,
  }) async {
    await _databaseService.updateNote(
      toBeUpdatedNote: existingDatabaseNote,
      text: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    _existingDatabaseNote =
        ModalRoute.of(context)!.settings.arguments as DatabaseNote;
    _existingNoteTextController.text = _existingDatabaseNote.text;
    return Scaffold(
      appBar: AppBar(title: const Text("Update Your Note")),
      body: TextField(
        controller: _existingNoteTextController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
