import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const expensesTable = "expenses";
const markersTable = "markers";

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await createDatabase();
      return _database;
    }
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "biobuluyo.db");
    var database = await openDatabase(path, version: 6, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  void onUpgrade(Database db, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database db, int version) async {
    await db.execute("CREATE TABLE $expensesTable ("
        "id INTEGER PRIMARY KEY, "
        "description TEXT, "
        "price TEXT, "
        "date INTEGER, "
        "category INTEGER,"
        "map TEXT "           //TO SAVE MARKER ID
        ")");

    await db.execute("CREATE TABLE $markersTable ("
        "id INTEGER PRIMARY KEY, "
        "name TEXT, "
        "markerId TEXT, "
        "lat INTEGER, "
        "lng REAL"
        ")");
  }

  deleteDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "biobuluyo.db");
    return databaseFactory.deleteDatabase(path);
  }

}
