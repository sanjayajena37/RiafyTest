import 'dart:io';

import 'package:path/path.dart';
import 'package:riafy_test/models/DemoModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static final _databaseName = "Riafy.db";
  static final _databaseVersion = 1;

  static final BOOKMARK = 'bookmarks';

  static final columnId = 'id';

  // static final columnName = 'name';
  // static final columnAge = 'age';

  // make this a singleton class
  DbHelper._privateConstructor();

  static final DbHelper instance = DbHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print("Create path is:\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" + path);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $BOOKMARK (
            dbid INTEGER PRIMARY KEY AUTOINCREMENT,
            id TEXT,
            channelname TEXT ,
            title TEXT ,
            high_thumbnail TEXT ,
            low_thumbnail TEXT ,
            medium_thumbnail TEXT
          )
          ''');

  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id, String table) async {
    Database db = await instance.database;
    int i= await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
    print("\n\n\n\n\n\n\nVALUE IS:\n\n\n\n\n\n\n\n\n"+i.toString());
    return i;
  }

  Future<List<DemoModel>> getRegData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(BOOKMARK);
    List<DemoModel> list = [];
    maps.forEach((map) {
      list.add(new DemoModel.fromJson1(map));
    });
    return list;
  }


}
