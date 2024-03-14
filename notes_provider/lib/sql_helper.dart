import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class SQLHelper {
  static Database? _database;
  static get getDatabase async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  static Future<Database> initDatabase() async {
    var path = p.join(await getDatabasesPath(), 'notes_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int version) async {
    // can use batch
    // Batch batch = db.batch();

    //     batch.execute('''
    //       CREATE TABLE notes (
    //         id INTEGER PRIMARY KEY,
    //         title TEXT,
    //         content TEXT
    //       )
    // ''');

    //     batch.execute('''
    //       CREATE TABLE notes (
    //         id INTEGER PRIMARY KEY,
    //         title TEXT,
    //         value BOOL
    //       )
    // ''');

    // batch.commit();    // commit changes in one go

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY,
        title TEXT,
        content TEXT
      ) 
''');
    print("Oncreate called");
  }

  // using sql helper
  static Future insertNote(Note note) async {
    Database db = await getDatabase;
    await db.insert("notes", note.toMap());
    print(await db.query("notes"));
  }

  // using raw sql query
  static Future insertNoteRaw(String title, String description) async {
    Database db = await getDatabase;
    db.rawInsert("INSERT INTO notes (title, content) VALUES(?, ?)",
        [title, description]);
    print(await db.rawQuery("SELECT * FROM notes"));
  }

  // using sql helper
  static Future<List<Map>> loadNotes() async {
    Database db = await getDatabase;
    List<Map> maps = await db.query("notes");
    return maps;
  }

  // using sql helper
  static Future updateNote(Note note) async {
    Database db = await getDatabase;
    await db.update("notes", note.toMap(), where: "id=?", whereArgs: [note.id]);
  }

  // using raw sql
  static Future updateNoteRaw(Note note) async {
    Database db = await getDatabase;
    await db.rawUpdate('UPDATE notes SET title = ?, content = ? WHERE id = ?',
        [note.title, note.content, note.id]);
  }

  // using sql helper
  static Future deleteNote(int id) async {
    Database db = await getDatabase;
    await db.delete("notes", where: "id=?", whereArgs: [id]);
  }

  // using raw sql
  static Future deleteNoteRaw(int id) async {
    Database db = await getDatabase;
    await db.rawDelete('DELETE FROM notes WHERE id = ?', [id]);
  }

  // using sql helper
  static Future deleteAllNotes() async {
    Database db = await getDatabase;
    // await db.execute("DELETE FROM notes"); OR
    await db.delete("notes");
  }

  // using sql helper
  static Future deleteAllTodos() async {
    Database db = await getDatabase;
    // await db.execute("DELETE FROM notes"); OR
    await db.delete("todos");
  }

  // using raw sql
  static Future deleteAllNotesRaw() async {
    Database db = await getDatabase;
    await db.rawDelete("DELETE FROM notes");
  }
}

class Note {
  final int id;
  final String title;
  final String content;

  Note({required this.id, required this.title, required this.content});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'content': content};
  }

  @override
  toString() {
    return "{id: $id, title: $title, content: $content}";
  }
}
