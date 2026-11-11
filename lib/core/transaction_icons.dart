import 'package:flutter/material.dart';

class TransactionIconOption {
  final String key;
  final String label;
  final IconData icon;

  const TransactionIconOption({
    required this.key,
    required this.label,
    required this.icon,
  });
}

const List<TransactionIconOption> transactionIcons = [
  TransactionIconOption(key: 'food', label: 'Makanan', icon: Icons.restaurant),
  TransactionIconOption(key: 'coffee', label: 'Kopi', icon: Icons.local_cafe),
  TransactionIconOption(
    key: 'transport',
    label: 'Transport',
    icon: Icons.directions_car,
  ),
  TransactionIconOption(
    key: 'shopping',
    label: 'Belanja',
    icon: Icons.shopping_bag_outlined,
  ),
  TransactionIconOption(key: 'bills', label: 'Tagihan', icon: Icons.receipt_long),
  TransactionIconOption(
    key: 'health',
    label: 'Kesehatan',
    icon: Icons.medical_services_outlined,
  ),
  TransactionIconOption(
    key: 'education',
    label: 'Kuliah',
    icon: Icons.school_outlined,
  ),
  TransactionIconOption(
    key: 'entertainment',
    label: 'Hiburan',
    icon: Icons.movie_outlined,
  ),
  TransactionIconOption(
    key: 'salary',
    label: 'Gaji',
    icon: Icons.payments_outlined,
  ),
  TransactionIconOption(key: 'gift', label: 'Hadiah', icon: Icons.card_giftcard),
  TransactionIconOption(
    key: 'savings',
    label: 'Tabungan',
    icon: Icons.savings_outlined,
  ),
  TransactionIconOption(
    key: 'other',
    label: 'Lainnya',
    icon: Icons.category_outlined,
  ),
];

IconData? resolveTransactionIcon(String? key) {
  if (key == null) return null;
  for (final option in transactionIcons) {
    if (option.key == key) return option.icon;
  }
  return null;
}
