import 'package:flutter/material.dart';
import 'package:notepad/constants/routes.dart';
import 'package:notepad/crud/database_service.dart';
import 'package:notepad/dialogs/delete_dialog.dart';
import '../crud/database_note.dart';

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notesList;
  const NotesListView({Key? key, required this.notesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseService _databaseService;
    _databaseService = DatabaseService();
    return ListView.builder(
      itemBuilder: ((context, index) {
        final note = notesList[index];
        return ListTile(
          title: Text(
            note.text,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                await _databaseService.deleteNote(
                    noteToBeDeletedId: note.noteId);
              }
            },
          ),
          onTap: () {
            Navigator.of(context).pushNamed(updatenoteRoute, arguments: note);
          },
        );
      }),
      itemCount: notesList.length,
    );
  }
}
