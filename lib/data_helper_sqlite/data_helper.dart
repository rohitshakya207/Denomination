
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/data_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('denomination.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE denomination (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        remark TEXT,
        recordtime TEXT,
        categery TEXT,
        wordtotal TEXT,
        finalalltotal INTEGER,
        amount2000 INTEGER,
        multi2000 INTEGER,
        amount500 INTEGER,
        multi500 INTEGER,
        amount200 INTEGER,
        multi200 INTEGER,
        amount100 INTEGER,
        multi100 INTEGER,
        amount50 INTEGER,
        multi50 INTEGER,
        amount20 INTEGER,
        multi20 INTEGER,
        amount10 INTEGER,
        multi10 INTEGER,
        amount5 INTEGER,
        multi5 INTEGER,
        amount2 INTEGER,
        multi2 INTEGER,
        amount1 INTEGER,
        multi1 INTEGER
      )
    ''');
  }

  // Insert a transaction
  Future<int> insertData(CalCulateDataModel calCulateDataModel) async {
    final db = await instance.database;
    return await db.insert('denomination', calCulateDataModel.toMap());
  }

  // Fetch all transactions
  Future<List<CalCulateDataModel>> fetchAllData() async {
    final db = await instance.database;
    final result = await db.query('denomination');
    return result.map((map) => CalCulateDataModel.fromMap(map)).toList();
  }

  // Fetch a specific transaction by ID
  Future<CalCulateDataModel?> fetchDataById(int id) async {
    final db = await instance.database;
    final result = await db.query('denomination', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return CalCulateDataModel.fromMap(result.first);
    }
    return null;
  }

  // Update a transaction
  Future<int> updateData(CalCulateDataModel calCulateDataModel) async {
    final db = await instance.database;
    if (calCulateDataModel.id == null) {
      throw ArgumentError('denomination ID must not be null');
    }
    return await db.update(
      'denomination',
      calCulateDataModel.toMap(),
      where: 'id = ?',
      whereArgs: [calCulateDataModel.id],
    );
  }

  // Delete a transaction
  Future<int> deleteData(int id) async {
    final db = await instance.database;
    return await db.delete('denomination', where: 'id = ?', whereArgs: [id]);
  }
}
