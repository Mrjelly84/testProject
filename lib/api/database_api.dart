import 'package:flutter/foundation.dart';
import '../database_helper.dart';

class DatabaseApi {
  static final DatabaseApi instance = DatabaseApi._init();
  DatabaseApi._init();

  /// Ensures the database is opened and ready.
  Future<void> connect() async {
    try {
      await DatabaseHelper.instance.database;
      debugPrint('Database connected');
    } catch (e) {
      debugPrint('Database connect error: $e');
      rethrow;
    }
  }

  /// Closes the open database.
  Future<void> disconnect() async {
    try {
      await DatabaseHelper.instance.close();
      debugPrint('Database closed');
    } catch (e) {
      debugPrint('Database close error: $e');
      rethrow;
    }
  }

  /// Set the current user used for log entries.
  void setCurrentUser(String user) {
    DatabaseHelper.currentUser = user;
  }

  /// Add an action to the logs.
  Future<void> addLog(String action) async {
    return await DatabaseHelper.instance.addLog(action);
  }

  Future<List<InventoryItem>> getItems() async {
    return await DatabaseHelper.instance.readAllItems();
  }

  Future<int> addItem(String name) async {
    final item = InventoryItem(name: name);
    return await DatabaseHelper.instance.create(item);
  }

  Future<int> updateItem(InventoryItem item) async {
    return await DatabaseHelper.instance.update(item);
  }

  Future<int> deleteItem(int id, String name) async {
    return await DatabaseHelper.instance.delete(id, name);
  }

  Future<List<LogEntry>> getLogs() async {
    return await DatabaseHelper.instance.readAllLogs();
  }
}
