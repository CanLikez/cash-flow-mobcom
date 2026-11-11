import '../../models/transaction_model.dart';
import '../database/app_database.dart';

class TransactionRepository {
  TransactionRepository({AppDatabase? database})
      : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<List<TransactionModel>> getAll() async {
    final db = await _database.database;
    final rows = await db.query(
      AppDatabase.table,
      orderBy: 'date DESC, id DESC',
    );
    return rows.map(TransactionModel.fromMap).toList();
  }

  Future<void> insert(TransactionModel transaction) async {
    final db = await _database.database;
    await db.insert(AppDatabase.table, transaction.toMap());
  }

  Future<void> update(TransactionModel transaction) async {
    final db = await _database.database;
    await db.update(
      AppDatabase.table,
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _database.database;
    await db.delete(
      AppDatabase.table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
