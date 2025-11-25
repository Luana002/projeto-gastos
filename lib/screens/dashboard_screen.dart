import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

// Dashboard mostra o resumo do dia a partir do provider
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txProvider = Provider.of<TransactionProvider>(context);

    if (txProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final transacoes = txProvider.items;
    final hoje = DateTime.now();
    bool mesmaData(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

    DateTime? _parseData(dynamic data) {
      if (data is DateTime) return data;
      if (data is String) {
        try {
          return DateFormat('dd/MM/yyyy').parse(data);
        } catch (_) {
          try {
            return DateTime.parse(data);
          } catch (_) {
            return null;
          }
        }
      }
      return null;
    }

    double _parseValor(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v.replaceAll(',', '.')) ?? 0.0;
      return 0.0;
    }

    final despesasHoje = transacoes.where((t) {
      final d = _parseData(t['data']);
      if (d == null) return false;
      return (t['tipo'] == 'despesa') && mesmaData(d, hoje);
    }).toList();

    final totalDespesasHoje = despesasHoje.fold<double>(0.0, (s, t) => s + _parseValor(t['valor']));

    final Map<String, double> categorias = {}; // soma por categoria
    for (var t in despesasHoje) {
      final cat = (t['categoria'] as String?) ?? 'Outros';
      categorias[cat] = (categorias[cat] ?? 0) + _parseValor(t['valor']);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('App de gastos'),
        actions: [
          IconButton(icon: const Icon(Icons.category), onPressed: () => Navigator.pushNamed(context, '/categories')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Resumo do dia', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Total gasto hoje'),
                subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR').format(totalDespesasHoje), style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Gastos por categoria (hoje)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (categorias.isEmpty)
              const Text('Nenhuma despesa registrada hoje.')
            else
              ...categorias.entries.map((e) => Card(
                child: ListTile(
                  title: Text(e.key),
                  trailing: Text(NumberFormat.simpleCurrency(locale: 'pt_BR').format(e.value)),
                ),
              )),
            const SizedBox(height: 20),
            ElevatedButton.icon(icon: const Icon(Icons.list), label: const Text('Ver transações'), onPressed: () => Navigator.pushNamed(context, '/transactions')),
            const SizedBox(height: 8),
            ElevatedButton.icon(icon: const Icon(Icons.add), label: const Text('Nova transação'), onPressed: () => Navigator.pushNamed(context, '/transaction_form')),
          ],
        ),
      ),
    );
  }
}