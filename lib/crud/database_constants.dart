const dbName = "notes.db";
const userTable = "user";
const userIdColumn = 'user_id';
const emailColumn = 'email';
const notesTable = "notes";
const noteIdColumn = 'id';
const fUserIdColumn = 'f_id';
const textColumn = 'text';
const createUserTable =
    '''CREATE TABLE IF NOT EXISTS 'user'('user_id' INTEGER NOT NULL,
	                        'email'	TEXT NOT NULL UNIQUE,
	                         PRIMARY KEY('user_id' AUTOINCREMENT));''';

const createNoteTable =
    '''CREATE TABLE IF NOT EXISTS "notes"("id" INTEGER NOT NULL,
	                          "f_id"	INTEGER NOT NULL,
	                          "text" TEXT,
	                           PRIMARY KEY("id"),
	                           FOREIGN KEY("f_id") REFERENCES "user"("user_id"));''';





