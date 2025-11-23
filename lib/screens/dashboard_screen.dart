import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transacoes;
  const DashboardScreen({super.key, required this.transacoes});

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();
    bool mesmaData(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

    final despesasHoje = transacoes.where((t) {
      final data = t['data'];
      DateTime d;
      if (data is DateTime) d = data;
      else if (data is String) {
        try {
          d = DateFormat('dd/MM/yyyy').parse(data);
        } catch (_) {
          return false;
        }
      } else {
        return false;
      }
      return (t['tipo'] == 'despesa') && mesmaData(d, hoje);
    }).toList();

    final totalDespesasHoje = despesasHoje.fold<double>(0.0, (s, t) => s + (t['valor'] as double));

    final Map<String, double> categorias = {};
    for (var t in despesasHoje) {
      final cat = (t['categoria'] as String?) ?? 'Outros';
      categorias[cat] = (categorias[cat] ?? 0) + (t['valor'] as double);
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