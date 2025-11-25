import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _formatDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);
  String _formatCurrency(double v) => NumberFormat.simpleCurrency(locale: 'pt_BR').format(v);

  Future<void> _editar(BuildContext context, Map<String, dynamic> t) async {
    final result = await Navigator.pushNamed(context, '/transaction_form', arguments: t);
    if (result != null && result is Map<String, dynamic>) {
      final provider = Provider.of<TransactionProvider>(context, listen: false);

      if (result['deleted'] == true && result['id'] != null) {
        final id = result['id'] as int;
        await provider.delete(id);
        return;
      }

      if (result['id'] != null) {
        await provider.update(result);
      } else {
        await provider.add(result);
      }
    }
  }

  Future<void> _criar(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/transaction_form');
    if (result != null && result is Map<String, dynamic>) {
      final provider = Provider.of<TransactionProvider>(context, listen: false);
      await provider.add(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    if (provider.isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final _lista = provider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _criar(context)),
        ],
      ),
      body: ListView.builder(
        itemCount: _lista.length,
        itemBuilder: (context, i) {
          final t = _lista[i];
          final tipo = t['tipo'] as String? ?? 'despesa';
          final color = tipo == 'despesa' ? Colors.red : Colors.green;
          final data = t['data'] is DateTime ? t['data'] as DateTime : DateTime.now();
          final descricao = (t['descricao'] as String?) ?? '';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(tipo == 'despesa' ? Icons.arrow_upward : Icons.arrow_downward, color: color),
              title: Text(_formatCurrency((t['valor'] is num) ? (t['valor'] as num).toDouble() : double.tryParse((t['valor'] ?? '0').toString()) ?? 0.0), style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${t['categoria']} • ${_formatDate(data)}'),
                  if (descricao.isNotEmpty) Text(descricao, style: const TextStyle(fontSize: 12)),
                ],
              ),
              isThreeLine: descricao.isNotEmpty,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editar(context, t)),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async {
                    final provider = Provider.of<TransactionProvider>(context, listen: false);
                    final id = t['id'] as int?;
                    if (id != null) {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Confirmar exclusão'),
                          content: const Text('Deseja excluir esta transação?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      );
                      if (ok == true) await provider.delete(id);
                    }
                  }),
                ],
              ),
              onTap: () => Navigator.pushNamed(context, '/transaction_detail', arguments: t),
            ),
          );
        },
      ),
    );
  }
}