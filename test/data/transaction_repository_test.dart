import 'package:cash_flow/data/database/app_database.dart';
import 'package:cash_flow/data/repositories/transaction_repository.dart';
import 'package:cash_flow/features/transactions/transaction_provider.dart';
import 'package:cash_flow/models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
  });

  late AppDatabase database;
  late TransactionRepository repository;

  setUp(() {
    database = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    repository = TransactionRepository(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  TransactionModel transaction({
    required String id,
    required double amount,
    TransactionType type = TransactionType.expense,
    DateTime? date,
    String title = 'Test',
    String? category,
    String? note,
    String? icon,
  }) {
    return TransactionModel(
      id: id,
      title: title,
      amount: amount,
      type: type,
      date: date ?? DateTime.utc(2026, 1, 1),
      category: category,
      note: note,
      icon: icon,
    );
  }

  group('TransactionModel', () {
    test('toMap serializes type and date', () {
      final model = transaction(
        id: '1',
        amount: 12500.5,
        type: TransactionType.income,
        date: DateTime.utc(2026, 3, 4, 5, 6, 7, 890),
        category: 'Salary',
        note: 'March',
      );

      final map = model.toMap();

      expect(map['id'], '1');
      expect(map['title'], 'Test');
      expect(map['amount'], 12500.5);
      expect(map['type'], 'income');
      expect(map['date'], DateTime.utc(2026, 3, 4, 5, 6, 7, 890)
          .millisecondsSinceEpoch);
      expect(map['category'], 'Salary');
      expect(map['note'], 'March');
    });

    test('fromMap/toMap roundtrip keeps nullable fields', () {
      final model = transaction(
        id: '1',
        amount: 99.99,
        type: TransactionType.income,
        date: DateTime(2026, 5, 6, 7, 8, 9, 10),
      );

      final copy = TransactionModel.fromMap(model.toMap());

      expect(copy.id, model.id);
      expect(copy.title, model.title);
      expect(copy.amount, model.amount);
      expect(copy.type, model.type);
      expect(copy.date, model.date);
      expect(copy.category, isNull);
      expect(copy.note, isNull);
    });

    test('icon roundtrips through toMap/fromMap', () {
      final withIcon = transaction(id: '1', amount: 10, icon: 'coffee');
      final withoutIcon = transaction(id: '2', amount: 20);

      expect(withIcon.toMap()['icon'], 'coffee');
      expect(withoutIcon.toMap()['icon'], isNull);

      expect(TransactionModel.fromMap(withIcon.toMap()).icon, 'coffee');
      expect(TransactionModel.fromMap(withoutIcon.toMap()).icon, isNull);
    });

    test('copyWith replaces only given fields', () {
      final model = transaction(
        id: '1',
        amount: 10,
        category: 'Food',
        note: 'Lunch',
      );

      final copy = model.copyWith(title: 'Updated', amount: 20.5);

      expect(copy.id, model.id);
      expect(copy.title, 'Updated');
      expect(copy.amount, 20.5);
      expect(copy.type, model.type);
      expect(copy.date, model.date);
      expect(copy.category, 'Food');
      expect(copy.note, 'Lunch');
    });
  });

  group('TransactionRepository', () {
    test('insert then getAll returns newest first', () async {
      final older = transaction(
        id: 'a',
        amount: 10,
        date: DateTime.utc(2026, 1, 1),
      );
      final newer = transaction(
        id: 'b',
        amount: 20,
        date: DateTime.utc(2026, 2, 1),
      );
      final newest = transaction(
        id: 'c',
        amount: 30,
        date: DateTime.utc(2026, 3, 1),
      );

      await repository.insert(older);
      await repository.insert(newest);
      await repository.insert(newer);

      final all = await repository.getAll();

      expect(all.map((item) => item.id), ['c', 'b', 'a']);
    });

    test('getAll breaks date ties by id descending', () async {
      final sameDate = DateTime.utc(2026, 1, 1);
      await repository.insert(transaction(id: 'a', amount: 1, date: sameDate));
      await repository.insert(transaction(id: 'b', amount: 2, date: sameDate));

      final all = await repository.getAll();

      expect(all.map((item) => item.id), ['b', 'a']);
    });

    test('update persists changed fields', () async {
      await repository.insert(
        transaction(id: '1', amount: 10, title: 'Before', category: 'Food'),
      );

      final updated = transaction(
        id: '1',
        amount: 42.75,
        title: 'After',
        type: TransactionType.income,
        date: DateTime(2026, 6, 1),
        category: 'Salary',
        note: 'Updated',
      );
      await repository.update(updated);

      final all = await repository.getAll();

      expect(all, hasLength(1));
      final stored = all.single;
      expect(stored.title, 'After');
      expect(stored.amount, 42.75);
      expect(stored.type, TransactionType.income);
      expect(stored.date, DateTime(2026, 6, 1));
      expect(stored.category, 'Salary');
      expect(stored.note, 'Updated');
    });

    test('icon roundtrips through insert, update and getAll', () async {
      await repository.insert(
        transaction(id: 'with', amount: 10, icon: 'coffee'),
      );
      await repository.insert(transaction(id: 'without', amount: 20));

      var all = await repository.getAll();
      var byId = {for (final item in all) item.id: item};
      expect(byId['with']!.icon, 'coffee');
      expect(byId['without']!.icon, isNull);

      await repository.update(
        transaction(id: 'with', amount: 10, icon: 'food'),
      );
      await repository.update(
        transaction(id: 'without', amount: 20, icon: 'salary'),
      );

      all = await repository.getAll();
      byId = {for (final item in all) item.id: item};
      expect(byId['with']!.icon, 'food');
      expect(byId['without']!.icon, 'salary');
    });

    test('delete removes only the matching transaction', () async {
      await repository.insert(transaction(id: '1', amount: 10));
      await repository.insert(transaction(id: '2', amount: 20));

      await repository.delete('1');

      final all = await repository.getAll();

      expect(all.map((item) => item.id), ['2']);
    });
  });

  group('TransactionProvider', () {
    test('loads, adds, removes and restores with totals', () async {
      final provider = TransactionProvider(repository);

      await provider.load();

      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
      expect(provider.transactions, isEmpty);
      expect(provider.totalIncome, 0.0);
      expect(provider.totalExpense, 0.0);
      expect(provider.balance, 0.0);

      final income = transaction(
        id: 'income',
        amount: 1000,
        type: TransactionType.income,
        date: DateTime.utc(2026, 1, 1),
      );
      final expense = transaction(
        id: 'expense',
        amount: 250.5,
        type: TransactionType.expense,
        date: DateTime.utc(2026, 1, 2),
      );

      await provider.add(income);
      await provider.add(expense);

      expect(provider.transactions.map((item) => item.id), ['expense', 'income']);
      expect(provider.totalIncome, 1000.0);
      expect(provider.totalExpense, 250.5);
      expect(provider.balance, 749.5);

      await provider.remove(expense.id);

      expect(provider.transactions.map((item) => item.id), ['income']);
      expect(provider.totalExpense, 0.0);
      expect(provider.balance, 1000.0);
      expect(await repository.getAll(), hasLength(1));

      await provider.restore(expense);

      expect(provider.transactions.map((item) => item.id), ['expense', 'income']);
      expect(provider.totalExpense, 250.5);
      expect(provider.balance, 749.5);
      expect(await repository.getAll(), hasLength(2));
    });

    test('updateTransaction replaces the item and sorts', () async {
      final provider = TransactionProvider(repository);
      final original = transaction(
        id: '1',
        amount: 10,
        date: DateTime.utc(2026, 1, 1),
      );
      final other = transaction(
        id: '2',
        amount: 20,
        date: DateTime.utc(2026, 1, 2),
      );
      await provider.add(original);
      await provider.add(other);

      final updated = original.copyWith(
        amount: 99,
        date: DateTime.utc(2026, 3, 1),
      );
      await provider.updateTransaction(updated);

      expect(provider.transactions.map((item) => item.id), ['1', '2']);
      expect(provider.transactions.first.amount, 99.0);
      expect(provider.totalExpense, 119.0);
    });
  });
}
