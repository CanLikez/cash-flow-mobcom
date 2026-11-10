import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Contoh data awal (dummy/starter data)
  final List<TransactionModel> _transactions = [
    TransactionModel(
      id: '1',
      title: 'Uang Saku Bulanan',
      amount: 1500000,
      type: TransactionType.income,
      date: DateTime.now(),
      category: 'Pemasukan',
    ),
    TransactionModel(
      id: '2',
      title: 'Makan Siang & Kopi',
      amount: 35000,
      type: TransactionType.expense,
      date: DateTime.now(),
      category: 'Makanan',
    ),
  ];

  double get _totalIncome => _transactions
      .where((item) => item.type == TransactionType.income)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get _totalExpense => _transactions
      .where((item) => item.type == TransactionType.expense)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get _balance => _totalIncome - _totalExpense;

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash Flow Harian'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Ringkasan Saldo
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Sisa Saldo Saat Ini',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currencyFormat.format(_balance),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: _balance >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryItem(
                          label: 'Pemasukan',
                          amount: _currencyFormat.format(_totalIncome),
                          icon: Icons.arrow_downward,
                          color: Colors.green,
                        ),
                        Container(height: 36, width: 1, color: Colors.grey.shade300),
                        _buildSummaryItem(
                          label: 'Pengeluaran',
                          amount: _currencyFormat.format(_totalExpense),
                          icon: Icons.arrow_upward,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Header Riwayat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaksi Hari Ini',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_transactions.length} Transaksi',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // List Transaksi
            if (_transactions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Text('Belum ada transaksi hari ini.'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = _transactions[index];
                  final isIncome = item.type == TransactionType.income;
                  return Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      final removedItem = item;
                      setState(() {
                        _transactions.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Transaksi "${removedItem.title}" dihapus'),
                          action: SnackBarAction(
                            label: 'Batal',
                            onPressed: () {
                              setState(() {
                                _transactions.insert(index, removedItem);
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              isIncome ? Colors.green.shade50 : Colors.red.shade50,
                          child: Icon(
                            isIncome ? Icons.attach_money : Icons.shopping_bag_outlined,
                            color: isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          DateFormat('dd MMM yyyy, HH:mm').format(item.date),
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Text(
                          '${isIncome ? '+' : '-'} ${_currencyFormat.format(item.amount)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isIncome ? Colors.green.shade700 : Colors.red.shade700,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newTransaction = await Navigator.push<TransactionModel>(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );

          if (newTransaction != null) {
            setState(() {
              _transactions.insert(0, newTransaction);
            });
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Transaksi "${newTransaction.title}" berhasil ditambahkan!'),
                  backgroundColor: Colors.teal,
                ),
              );
            }
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Transaksi'),
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

