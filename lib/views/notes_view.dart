import 'package:flutter/material.dart';
import 'package:notepad/constants/popupmenu_constants.dart';
import 'package:notepad/constants/routes.dart';
import 'package:notepad/crud/database_service.dart';
import 'package:notepad/dialogs/logout_dialog.dart';
import 'package:notepad/firebase/auth_service.dart';
import 'package:notepad/views/noteslist_view.dart';
import '../crud/database_note.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => NotesViewState();
}

class NotesViewState extends State<NotesView> {
  late final DatabaseService _databaseService;
  final String email = AuthService.firebase().currentUser!.email;
  @override
  void initState() {
    openDatabaseService();
    super.initState();
  }

  void openDatabaseService() async {
    _databaseService = DatabaseService();
    await _databaseService.open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(takenoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuItem>(
            onSelected: ((value) async {
              switch (value) {
                case MenuItem.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  break;
              }
            }),
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuItem>(
                  value: MenuItem.logout,
                  child: Text("Logout"),
                )
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _databaseService.getOrcreateUser(email: email),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _databaseService.getStreamOfNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final notesFromStream =
                              snapshot.data as List<DatabaseNote>;
                          return NotesListView(notesList: notesFromStream);
                        } else {
                          return const CircularProgressIndicator();
                        }
                      default:
                        return const CircularProgressIndicator();
                    }
                  });
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
