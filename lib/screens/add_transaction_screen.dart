import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  TransactionType _selectedType = TransactionType.expense;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          DateTime.now().hour,
          DateTime.now().minute,
        );
      });
    }
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
      final newTransaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        amount: amount,
        type: _selectedType,
        date: _selectedDate,
        category: _categoryController.text.trim().isEmpty
            ? (_selectedType == TransactionType.income ? 'Pemasukan' : 'Pengeluaran')
            : _categoryController.text.trim(),
      );

      // Mengembalikan data transaksi baru ke halaman sebelumnya
      Navigator.pop(context, newTransaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Segmented Button untuk Jenis Transaksi
              SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment<TransactionType>(
                    value: TransactionType.expense,
                    label: Text('Pengeluaran'),
                    icon: Icon(Icons.arrow_upward, color: Colors.red),
                  ),
                  ButtonSegment<TransactionType>(
                    value: TransactionType.income,
                    label: Text('Pemasukan'),
                    icon: Icon(Icons.arrow_downward, color: Colors.green),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _selectedType = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Input Judul Transaksi
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul / Keterangan',
                  hintText: 'Misal: Sarapan Pagi / Gaji Bulanan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul transaksi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Input Jumlah Nominal
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nominal (Rp)',
                  hintText: 'Contoh: 25000',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nominal tidak boleh kosong';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Masukkan angka nominal yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pemilih Tanggal
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(4),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Transaksi',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    dateFormat.format(_selectedDate),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Input Kategori (Opsional)
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Kategori (Opsional)',
                  hintText: 'Misal: Makan, Transport, Kuliah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              ElevatedButton.icon(
                onPressed: _saveTransaction,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Transaksi'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

