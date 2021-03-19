import 'dart:io';

import 'package:simplenoteapp/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider{
  static const dbFileName = 'simplenoteapp.db';
  static const dbTableName = "notes_table";
  static const recycleTableName = "recycle_table";
  static Database _db;
  static int get _version =>1;

  initDb() async {
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, dbFileName);
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE $dbTableName(
          id INTEGER PRIMARY KEY, 
          title TEXT,
          description TEXT,
          createdDate TEXT)
        ''');
        await db.execute('''
        CREATE TABLE $recycleTableName(
          id INTEGER PRIMARY KEY, 
          title TEXT,
          description TEXT,
          createdDate TEXT)
        ''');
      },
    );
  }

  getNotes() async{
    final List<Map<String, dynamic>> jsons = await _db.rawQuery("SELECT * FROM $dbTableName");
    print('${jsons.length} rows retrieved from db!');
    return jsons.map((json) => NoteModel.fromJsonMap(json)).toList();
  }
  getRecycleNotes() async{
    final List<Map<String, dynamic>> jsons = await _db.rawQuery("SELECT * FROM $recycleTableName");
    print('${jsons.length} rows retrieved from db!');
    return jsons.map((json) => NoteModel.fromJsonMap(json)).toList();
  }

  Future<void> addNote(NoteModel note) async {
    await _db.transaction(
          (Transaction txn) async {
        final int id = await txn.rawInsert('''
          INSERT INTO $dbTableName
            (title, description,createdDate)
          VALUES
            (
              "${note.title}",
              "${note.description}",
              "${note.createdDate}"
            )''');
        print('Inserted note item with id=$id.');
      },
    );
  }
  Future<void> addNoteToRecycleBin(id,title,description,createdDate) async {
    await _db.transaction(
          (Transaction txn) async {
        final int id = await txn.rawInsert('''
          INSERT INTO $recycleTableName
            (title, description,createdDate)
          VALUES
            (
              "${title}",
              "${description}",
              "${createdDate}"
            )''');
        print('Inserted note item with id=$id.');
      },
    );
  }
  Future<void> restoreDeletedNote(id,title,description,createdDate) async {
    await _db.transaction(
          (Transaction txn) async {
        final int id = await txn.rawInsert('''
          INSERT INTO $dbTableName
            (title, description,createdDate)
          VALUES
            (
              "${title}",
              "${description}",
              "${createdDate}"
            )''');
        print('Inserted note item with id=$id.');
      },
    );
  }

  Future<void> updateNote({id,title,description,date}) async {
    final count = await _db.rawUpdate('''
        UPDATE $dbTableName
        SET title = ?, description = ?,createdDate = ?
        WHERE id = ?
      ''',[title,description,date,id]);
    print('Updated $count records in db.');
  }


  Future<void> deleteNote(id,title,description,createdDate) async {

    addNoteToRecycleBin(id, title, description, createdDate);
    final count = await _db.rawDelete('''
        DELETE FROM $dbTableName
        WHERE id = ${id}
      ''');
    print('Updated $count records in db.');
  }

  Future<void> deleteFromRecycleBin(id) async {
    final count = await _db.rawDelete('''
        DELETE FROM $recycleTableName
        WHERE id = ${id}
      ''');
    print('Updated $count records in db.');
  }
}