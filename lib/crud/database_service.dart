import 'dart:async';
import 'package:notepad/crud/database_constants.dart';
import 'package:notepad/crud/database_exeptions.dart';
import 'package:notepad/firebase/auth_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:notepad/crud/database_user.dart';
import 'database_note.dart';

extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}

class DatabaseService {
  Database? _db;
  final String email = AuthService.firebase().currentUser!.email;
  DatabaseUser? _user;
  List<DatabaseNote> _databaseNotesList = <DatabaseNote>[];
  late final StreamController<List<DatabaseNote>>
      _databaseNotesStreamController;

  factory DatabaseService() => _shared;
  static final _shared = DatabaseService._sharedInstance();
  DatabaseService._sharedInstance() {
    _databaseNotesStreamController =
        StreamController<List<DatabaseNote>>.broadcast(onListen: () {
      _databaseNotesStreamController.sink.add(_databaseNotesList);
    });
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseIsAlreadyExistsException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createUserTable);
      await db.execute(createNoteTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw NoPlatformDirectoryFoundException();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw NoDatabaseFoundException();
    } else {
      await db.close();
    }
  }

  Database getDatabase() {
    final db = _db;
    if (db == null) {
      throw Exception();
    } else {
      return db;
    }
  }

  Future<void> _ensureDbisOpen() async {
    try {
      await open();
    } catch (e) {
      // Do nothing
    }
  }

  Future<DatabaseUser> getOrcreateUser({required String email}) async {
    try {
      final user = await getDatabaseUser(email: email);
      _user = user;
      return user;
    } catch (e) {
      final createduser = await createDatabaseUser(email: email);
      _user = createduser;
      return createduser;
    }
  }

  Future<DatabaseUser> getDatabaseUser({required String email}) async {
    await _ensureDbisOpen();
    final db = getDatabase();
    final listmap = await db
        .query(userTable, where: "email=?", whereArgs: [email.toLowerCase()]);
    if (listmap.isEmpty) {
      throw DatabaseUserNotFoundException();
    } else {
      return DatabaseUser.fromRowInDatabase(listmap.first);
    }
  }

  Future<DatabaseUser> createDatabaseUser({required String email}) async {
    await _ensureDbisOpen();
    final db = getDatabase();
    final userId =
        await db.insert(userTable, {emailColumn: email.toLowerCase()});
    return DatabaseUser(userId: userId, email: email);
  }

  Future<DatabaseNote> createNote(
      {required DatabaseUser dbUser, required String text}) async {
    final db = getDatabase();
    final createdNoteId = await db.insert(notesTable, {
      fUserIdColumn: dbUser.userId,
      textColumn: text,
    });
    final createdNote = DatabaseNote(createdNoteId, text, dbUser.userId);
    _databaseNotesList.add(createdNote);
    _databaseNotesStreamController.sink.add(_databaseNotesList);
    return createdNote;
  }

  Future<DatabaseNote> updateNote(
      {required DatabaseNote toBeUpdatedNote, required String text}) async {
    final db = getDatabase();
    final int updateCount = await db.update(
        notesTable,
        {
          textColumn: text,
        },
        where: "id=?",
        whereArgs: [toBeUpdatedNote.noteId]);
    if (updateCount == 0) {
      throw DatabaseNoteCouldNotUpdateException();
    } else {
      _databaseNotesList
          .removeWhere((note) => toBeUpdatedNote.noteId == note.noteId);
      final updatedNote = await getNote(noteid: toBeUpdatedNote.noteId);
      _databaseNotesList.add(updatedNote);
      _databaseNotesStreamController.sink.add(_databaseNotesList);
      return updatedNote;
    }
  }

  Future<DatabaseNote> getNote({required int noteid}) async {
    final db = getDatabase();
    final note = await db.query(notesTable, where: "id=?", whereArgs: [noteid]);
    return DatabaseNote.fromRowInDatabase(note.first);
  }

  Future<void> deleteNote({required int noteToBeDeletedId}) async {
    final db = getDatabase();
    final int deleteCount = await db
        .delete(notesTable, where: "id=?", whereArgs: [noteToBeDeletedId]);
    _databaseNotesList.removeWhere((note) => noteToBeDeletedId == note.noteId);
    _databaseNotesStreamController.add(_databaseNotesList);
    if (deleteCount == 0) {
      throw DatabaseNoteCouldNotDeleteException();
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = getDatabase();
    final databaseNotesList = await db.query(notesTable);
    final databaseNotesIterable = databaseNotesList
        .map((mapNote) => DatabaseNote.fromRowInDatabase(mapNote));
    return databaseNotesIterable;
  }

  Future<void> _cacheNotes() async {
    final databaseNotesIterable = await getAllNotes();
    _databaseNotesList = databaseNotesIterable.toList();
    _databaseNotesStreamController.add(_databaseNotesList);
  }

  Stream<List<DatabaseNote>> get getStreamOfNotes {
    return _databaseNotesStreamController.stream
        .filter((note) => note.userId == _user!.userId);
  }
}
