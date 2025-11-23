import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> transacoes;
  final Function(Map<String, dynamic>)? onAtualizar;
  final Function(int)? onRemover;

  const TransactionsScreen({
    super.key,
    required this.transacoes,
    this.onAtualizar,
    this.onRemover,
  });

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Map<String, dynamic>> get _lista => widget.transacoes;

  String _formatDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);
  String _formatCurrency(double v) => NumberFormat.simpleCurrency(locale: 'pt_BR').format(v);

  
  Future<void> _editar(Map<String, dynamic> t) async {
    final result = await Navigator.pushNamed(context, '/transaction_form', arguments: t);
    if (result != null && result is Map<String, dynamic>) {
      
      if (result['deleted'] == true && result['id'] != null) {
        final id = result['id'] as int;
        widget.onRemover?.call(id);
        return;
      }

      
      if (widget.onAtualizar != null) {
        widget.onAtualizar!(result);
      } else {
        
        setState(() {
          final id = result['id'];
          if (id != null) {
            final idx = _lista.indexWhere((x) => x['id'] == id);
            if (idx != -1) _lista[idx] = result;
            else _lista.add(result);
          } else {
            final newId = (_lista.isNotEmpty ? _lista.map((e) => e['id'] as int).reduce((a,b)=>a>b?a:b) : 0) + 1;
            _lista.add({...result, 'id': newId});
          }
        });
      }
    }
  }

  
  Future<void> _criar() async {
    final result = await Navigator.pushNamed(context, '/transaction_form');
    if (result != null && result is Map<String, dynamic>) {
      if (widget.onAtualizar != null) {
        widget.onAtualizar!(result);
      } else {
        setState(() {
          final newId = (_lista.isNotEmpty ? _lista.map((e) => e['id'] as int).reduce((a,b)=>a>b?a:b) : 0) + 1;
          _lista.add({...result, 'id': newId});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _criar),
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
              title: Text(_formatCurrency(t['valor'] as double), style: TextStyle(color: color, fontWeight: FontWeight.bold)),
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
                  IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editar(t)),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {
                    
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Confirmar exclusão'),
                        content: const Text('Deseja excluir esta transação? (mock)'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                          TextButton(
                            onPressed: () {
                              widget.onRemover?.call(t['id'] as int);
                              Navigator.pop(context);
                            },
                            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
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
