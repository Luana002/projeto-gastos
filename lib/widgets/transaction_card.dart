import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final double valor;
  final String categoria;
  final String data;
  final String tipo;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.valor,
    required this.categoria,
    required this.data,
    required this.tipo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = tipo == 'despesa' ? Colors.red : Colors.green;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          tipo == 'despesa' ? Icons.arrow_upward : Icons.arrow_downward,
          color: color,
        ),
        title: Text(
          NumberFormat.simpleCurrency(locale: 'pt_BR').format(valor),
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$categoria • $data'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}