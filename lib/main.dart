import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/transaction_form_screen.dart';
import 'screens/transaction_detail_screen.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(const FinancasApp());
}

class FinancasApp extends StatefulWidget {
  const FinancasApp({super.key});

  @override
  State<FinancasApp> createState() => _FinancasAppState();
}

class _FinancasAppState extends State<FinancasApp> {
  
  List<Map<String, dynamic>> transacoes = [];

  void _adicionarOuAtualizar(Map<String, dynamic> nova) {
    setState(() {
      final id = nova['id'];
      final idx = transacoes.indexWhere((t) => t['id'] == id);
      if (idx >= 0) {
        transacoes[idx] = nova;
      } else {
        final novoId = transacoes.isEmpty
            ? 1
            : transacoes.map((t) => t['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
        transacoes.add({...nova, 'id': novoId});
      }
    });
  }

  void _remover(int id) {
    setState(() => transacoes.removeWhere((t) => t['id'] == id));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finanças Universitárias',
      theme: AppTheme.light,
      routes: {
        '/': (context) => DashboardScreen(transacoes: transacoes),
        '/transactions': (context) => TransactionsScreen(
              transacoes: transacoes,
              onAtualizar: _adicionarOuAtualizar,
              onRemover: _remover,
            ),
        '/transaction_form': (context) => TransactionFormScreen(
              onSalvar: _adicionarOuAtualizar,
              transacoes: transacoes,
            ),
        '/transaction_detail': (context) => const TransactionDetailScreen(),
        '/categories': (context) => const CategoriesScreen(),
      },
    );
  }
}