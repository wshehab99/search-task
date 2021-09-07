import 'package:dummer_iti_5/constants/constants.dart';
import 'package:dummer_iti_5/model/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  //singletone
  static DbHelper? _helper;

  DbHelper._getInstance();

  factory DbHelper() {
    if (_helper == null) {
      _helper = DbHelper._getInstance();
    }
    return _helper!;
  }

  Future<String> _getDbPath() async {
    String path = await getDatabasesPath();
    String noteDbPath = join(path, Constants.DB_NAME);
    return noteDbPath;
  }

  Future<Database> getDbInstance() async {
    String dbPath = await _getDbPath();
    return openDatabase(
      dbPath,
      version: Constants.DB_VERSION,
      onCreate: (db, version) => _createTable(db),
      onUpgrade: (db, oldVersion, newVersion) => _upGrade(db),
    );
  }

  _createTable(Database db) {
    try {
      String sql =
          'create table ${Constants.TABLE_NAME} (${Constants.COL_ID} integer primary key autoincrement, ${Constants.COL_NOTE} text, ${Constants.COL_DATE} text )';
      print(sql);
      db.execute(sql);
    } catch (e) {
      print(e.toString());
    }
  }

  _upGrade(Database db) {
    _createTable(db);
  }

  Future<int> insertNote(Note note) async {
    Database db = await getDbInstance();
    return db.insert(Constants.TABLE_NAME, note.toMap());
  }

  Future<List<Note>> getAllNotes() async {
    // List<Note> noteList = [];
    Database db = await getDbInstance();
    List<Map<String, dynamic>> mapList = await db.query(Constants.TABLE_NAME);
    // mapList.forEach((element) => noteList.add(Note.fromMap(element)));
    // return noteList;
    return mapList.map((e) => Note.fromMap(e)).toList();
  }

  Future<int> deleteNote(Note note) async {
    Database db = await getDbInstance();
    return db.delete(Constants.TABLE_NAME,
        where: '${Constants.COL_ID}=?', whereArgs: [note.noteId]);
  }

  Future<int> updateNote(Note note) async {
    Database db = await getDbInstance();
    return db.update(Constants.TABLE_NAME, note.toMap(),
        where: '${Constants.COL_ID}=?', whereArgs: [note.noteId]);
    // return db.update(Constants.TABLE_NAME, note.toMap(), where: '${Constants.COL_ID}=${note.noteId}');
  }

  Future<List<Note>> getNote(String text) async {
    Database db = await getDbInstance();
    List<Map<String, dynamic>> mapList = await db.query(Constants.TABLE_NAME,
        where: '${Constants.COL_NOTE} like $text %');
    return mapList.map((e) => Note.fromMap(e)).toList();
  }
}
