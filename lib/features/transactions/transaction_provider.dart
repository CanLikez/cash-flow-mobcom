import 'package:flutter/foundation.dart';

import '../../data/repositories/transaction_repository.dart';
import '../../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  TransactionProvider(this._repository);

  final TransactionRepository _repository;

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TransactionModel> get transactions =>
      List<TransactionModel>.unmodifiable(_transactions);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get totalIncome => _transactions
      .where((transaction) => transaction.type == TransactionType.income)
      .fold(0.0, (sum, transaction) => sum + transaction.amount);

  double get totalExpense => _transactions
      .where((transaction) => transaction.type == TransactionType.expense)
      .fold(0.0, (sum, transaction) => sum + transaction.amount);

  double get balance => totalIncome - totalExpense;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _repository.getAll();
      _sort();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(TransactionModel transaction) async {
    await _repository.insert(transaction);
    _transactions.add(transaction);
    _sort();
    notifyListeners();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _repository.update(transaction);
    final index =
        _transactions.indexWhere((item) => item.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
    } else {
      _transactions.add(transaction);
    }
    _sort();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _repository.delete(id);
    _transactions.removeWhere((transaction) => transaction.id == id);
    notifyListeners();
  }

  Future<void> restore(TransactionModel transaction) async {
    await _repository.insert(transaction);
    _transactions.removeWhere((item) => item.id == transaction.id);
    _transactions.add(transaction);
    _sort();
    notifyListeners();
  }

  void _sort() {
    _transactions.sort((a, b) {
      final byDate = b.date.compareTo(a.date);
      if (byDate != 0) return byDate;
      return b.id.compareTo(a.id);
    });
  }
}
