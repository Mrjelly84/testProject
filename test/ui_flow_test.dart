import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:testproject/inventory_screen.dart';

void main() {
  // Initialize SQLite for the test environment
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  testWidgets('Add item in inventory screen', (WidgetTester tester) async {
    // Load InventoryScreen directly to avoid login flow timing
    await tester.pumpWidget(const MaterialApp(home: InventoryScreen()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Ensure Inventory screen is present
    expect(find.text('Inventory'), findsOneWidget);

    // Tap FAB to add item
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Dialog should appear; enter item name
    expect(find.text('Add Item'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Test Item');
    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify new item in list
    expect(find.text('Test Item'), findsOneWidget);
  });
}
