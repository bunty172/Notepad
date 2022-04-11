import 'package:notepad/crud/database_constants.dart';

class DatabaseUser {
  final String email;
  final int userId;

  DatabaseUser({required this.email, required this.userId});

  DatabaseUser.fromRowInDatabase(Map<String, Object?> map)
      : email = map[emailColumn] as String,
        userId = map[userIdColumn] as int;
}
