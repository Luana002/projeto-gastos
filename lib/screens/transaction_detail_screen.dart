import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados simulados
    final transacao = {
      'valor': 120.0,
      'categoria': 'Lazer',
      'data': DateTime.now(),
      'descricao': 'Cinema e pipoca',
      'tipo': 'despesa',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe da Transação')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              NumberFormat.simpleCurrency(locale: 'pt_BR')
                  .format(transacao['valor']),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Categoria: ${transacao['categoria']}'),
            Text('Tipo: ${transacao['tipo']}'),
            Text(
                'Data: ${DateFormat('dd/MM/yyyy').format(transacao['data'] as DateTime)}'),
            const SizedBox(height: 8),
            Text('Descrição: ${transacao['descricao']}'),
          ],
        ),
      ),
    );
  }
}
