import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:testproject/main.dart';

void main() {
  // Initialize SQLite for the test environment
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  testWidgets('Inventory App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const InventoryApp());

    // Verify that we start on the Login screen.
    expect(find.text('Login'), findsAtLeastNWidgets(1));
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
