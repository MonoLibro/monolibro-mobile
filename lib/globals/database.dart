import 'package:sqflite/sqflite.dart';

class DatabaseWrapper {
  Database? db;
  bool active = false;

  DatabaseWrapper() {
    initialize();
  }

  Future<void> initialize() async {
    db = await openDatabase("db.sql",
    version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE LocalUser (userID char(32), firstName char(256), lastName char(256), email char(256), publicKey text, privateKey text, frozen int(1))');
        // await db.execute('CREATE TABLE Users ()')
    });
    active = true;
  }

  Future<void> close() async {
    await db!.close();
  }

  Future<void> fullReset() async {
    active = false;
    if (active) {
      await close();
    }
    await deleteDatabase("db.sql");
    await initialize();
  }

  Future<void> execute(String sql) async {
    if (!active) {
      throw Exception("DB not active yet");
    }
    await db!.execute(sql);
  }

  Future<List<Map>> executeWithResult(String sql) async {
    if (!active) {
      throw Exception("DB not active yet");
    }
    return db!.rawQuery(sql);
  }
}

DatabaseWrapper dbWrapper = DatabaseWrapper();