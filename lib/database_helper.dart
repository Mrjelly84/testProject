import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class InventoryItem {
  final int? id;
  final String name;

  InventoryItem({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'],
      name: map['name'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize SQLite FFI for Desktop or Tests
    if (kIsWeb) {
      throw UnsupportedError('SQLite is not supported on Web');
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS || Platform.environment.containsKey('FLUTTER_TEST')) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _database = await _initDB('inventory.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE inventory (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
)
''');
  }

  Future<int> create(InventoryItem item) async {
    final db = await database;
    return await db.insert('inventory', item.toMap());
  }

  Future<List<InventoryItem>> readAllItems() async {
    final db = await database;
    final result = await db.query('inventory');
    return result.map((json) => InventoryItem.fromMap(json)).toList();
  }

  Future<int> update(InventoryItem item) async {
    final db = await database;
    return db.update(
      'inventory',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'inventory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
