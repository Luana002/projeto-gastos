import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/transaction_form_screen.dart';
import 'screens/transaction_detail_screen.dart';
import 'screens/categories_screen.dart';
import 'repositories/transaction_repository.dart';
import 'providers/transaction_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TransactionProvider>(
          create: (_) {
            final provider = TransactionProvider(repo: TransactionRepository());
            provider.init();
            return provider;
          },
        ),
      ],
      child: const FinancasApp(),
    ),
  );
}

class FinancasApp extends StatelessWidget {
  const FinancasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finanças Universitárias',
      theme: AppTheme.light,
      routes: {
        '/': (context) => const DashboardScreen(),
        '/transactions': (context) => const TransactionsScreen(),
        '/transaction_form': (context) => const TransactionFormScreen(),
        '/transaction_detail': (context) => const TransactionDetailScreen(),
        '/categories': (context) => const CategoriesScreen(),
      },
    );
  }
}