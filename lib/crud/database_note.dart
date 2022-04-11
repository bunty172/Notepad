import 'package:notepad/crud/database_constants.dart';

class DatabaseNote {
  final int noteId;
  final int userId;
  final String text;

  DatabaseNote(this.noteId, this.text, this.userId);

  DatabaseNote.fromRowInDatabase(Map<String, Object?> map)
      : noteId = map[noteIdColumn] as int,
        userId = map[fUserIdColumn] as int,
        text = map[textColumn] as String;
}
