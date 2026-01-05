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

class LogEntry {
  final int? id;
  final String action;
  final String user;
  final String timestamp;

  LogEntry({this.id, required this.action, required this.user, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'action': action,
      'user': user,
      'timestamp': timestamp,
    };
  }

  factory LogEntry.fromMap(Map<String, dynamic> map) {
    return LogEntry(
      id: map['id'],
      action: map['action'],
      user: map['user'],
      timestamp: map['timestamp'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static String? currentUser;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

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
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE logs (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              action TEXT NOT NULL,
              user TEXT NOT NULL,
              timestamp TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE inventory (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
)
''');
    await db.execute('''
CREATE TABLE logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  action TEXT NOT NULL,
  user TEXT NOT NULL,
  timestamp TEXT NOT NULL
)
''');
  }

  Future<void> addLog(String action) async {
    final db = await database;
    await db.insert('logs', {
      'action': action,
      'user': currentUser ?? 'Unknown',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<LogEntry>> readAllLogs() async {
    final db = await database;
    final result = await db.query('logs', orderBy: 'timestamp DESC');
    return result.map((json) => LogEntry.fromMap(json)).toList();
  }

  Future<int> create(InventoryItem item) async {
    final db = await database;
    final id = await db.insert('inventory', item.toMap());
    await addLog('Added item: ${item.name}');
    return id;
  }

  Future<List<InventoryItem>> readAllItems() async {
    final db = await database;
    final result = await db.query('inventory');
    return result.map((json) => InventoryItem.fromMap(json)).toList();
  }

  Future<int> update(InventoryItem item) async {
    final db = await database;
    final count = await db.update(
      'inventory',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
    await addLog('Updated item to: ${item.name}');
    return count;
  }

  Future<int> delete(int id, String itemName) async {
    final db = await database;
    final count = await db.delete(
      'inventory',
      where: 'id = ?',
      whereArgs: [id],
    );
    await addLog('Deleted item: $itemName');
    return count;
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
