import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'data/repositories/transaction_repository.dart';
import 'features/transactions/transaction_provider.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const CashFlowApp());
}

class CashFlowApp extends StatelessWidget {
  const CashFlowApp({super.key, this.provider});

  /// Optional provider for tests. When null, the app creates and owns the
  /// default provider backed by the local database.
  final TransactionProvider? provider;

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: 'Cash Flow Harian',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: const HomeScreen(),
    );

    final injectedProvider = provider;
    if (injectedProvider != null) {
      // Do not dispose a provider owned by the caller (e.g. widget tests).
      return ChangeNotifierProvider<TransactionProvider>.value(
        value: injectedProvider,
        child: app,
      );
    }

    return ChangeNotifierProvider<TransactionProvider>(
      create: (_) => TransactionProvider(TransactionRepository())..load(),
      child: app,
    );
  }
}
