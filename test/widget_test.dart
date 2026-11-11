import 'package:cash_flow/data/database/app_database.dart';
import 'package:cash_flow/data/repositories/transaction_repository.dart';
import 'package:cash_flow/features/transactions/transaction_provider.dart';
import 'package:cash_flow/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late AppDatabase database;
  late TransactionProvider provider;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    database = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    provider = TransactionProvider(TransactionRepository(database: database));
    await provider.load();
  });

  tearDown(() async {
    provider.dispose();
    await database.close();
  });

  testWidgets('CashFlowApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(CashFlowApp(provider: provider));
    await tester.pumpAndSettle();

    expect(find.text('Cash Flow Harian'), findsOneWidget);
  });
}
