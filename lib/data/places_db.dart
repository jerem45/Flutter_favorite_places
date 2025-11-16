// data/place_db.dart
// lib/data/places_db.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class PlaceDb {
  PlaceDb._();
  static final PlaceDb instance = PlaceDb._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      p.join(dbPath, 'places.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE places(
            id TEXT PRIMARY KEY,
            placesText TEXT NOT NULL,
            imagePath TEXT NOT NULL,
            userAdress TEXT NOT NULL
          );
        ''');
      },
    );
    return _db!;
  }

  Future<int> insertPlace(Map<String, Object?> data) async {
    final db = await database;
    return db.insert('places', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, Object?>>> getAll() async {
    final db = await database;
    return db.query('places', orderBy: 'ROWID DESC');
  }

  Future<int> deleteById(String id) async {
    final db = await database;
    return db.delete('places', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updatePlace(Map<String, Object?> data) async {
    final db = await database;
    return db.update('places', data, where: 'id = ?', whereArgs: [data['id']]);
  }
}
