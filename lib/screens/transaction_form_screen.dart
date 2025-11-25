import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

// Formulário de transação — agora usa provider para salvar/atualizar
class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valorCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String? _categoria;
  bool _isDespesa = true;
  DateTime _data = DateTime.now();

  Map<String, dynamic>? _edit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)!.settings.arguments;
    if (arg != null && arg is Map<String, dynamic> && _edit == null) {
      _edit = arg;

      _valorCtrl.text = (_edit!['valor'] ?? '').toString();
      _descCtrl.text = (_edit!['descricao'] ?? '').toString();
      _categoria = _edit!['categoria'] as String?;
      _isDespesa = (_edit!['tipo'] ?? 'despesa') == 'despesa';
      final maybeDate = _edit!['data'];
      if (maybeDate is DateTime) {
        _data = maybeDate;
      } else if (maybeDate is String) {
        try {
          _data = DateFormat('dd/MM/yyyy').parse(maybeDate);
        } catch (_) {
          try {
            _data = DateTime.parse(maybeDate);
          } catch (_) {}
        }
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _valorCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _data = picked);
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final valor = double.tryParse(_valorCtrl.text.replaceAll(',', '.')) ?? 0.0;
    final descricao = _descCtrl.text.trim();
    final categoria = _categoria ?? 'Sem categoria';
    final tipo = _isDespesa ? 'despesa' : 'receita';

    final transacao = <String, dynamic>{
      if (_edit != null && _edit!['id'] != null) 'id': _edit!['id'],
      'valor': valor,
      'descricao': descricao,
      'categoria': categoria,
      'tipo': tipo,
      'data': _data,
    };

    final provider = Provider.of<TransactionProvider>(context, listen: false);
    if (transacao.containsKey('id')) {
      await provider.update(transacao);
    } else {
      await provider.add(transacao);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transação salva')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriasFixas = ['Alimentação', 'Transporte', 'Lazer', 'Salário'];

    return Scaffold(
      appBar: AppBar(
        title: Text(_edit == null ? 'Nova Transação' : 'Editar Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // VALOR
              TextFormField(
                controller: _valorCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe o valor';
                  if (double.tryParse(v.replaceAll(',', '.')) == null) return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // DATA
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data'),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(_data)),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: _pickDate,
                ),
              ),
              const SizedBox(height: 8),

              // CATEGORIA
              DropdownButtonFormField<String>(
                value: _categoria,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: categoriasFixas.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _categoria = v),
                validator: (v) => v == null ? 'Escolha uma categoria' : null,
              ),

              const SizedBox(height: 8),

              // TIPO
              SwitchListTile(
                title: const Text('É despesa?'),
                value: _isDespesa,
                onChanged: (v) => setState(() => _isDespesa = v),
              ),

              const SizedBox(height: 8),

              // DESCRIÇÃO
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Descrição (opcional)'),
                maxLines: 2,
              ),

              const SizedBox(height: 20),

              // SALVAR
              ElevatedButton.icon(
                onPressed: _onSave,
                icon: const Icon(Icons.save),
                label: Text(_edit == null ? 'Salvar transação' : 'Salvar alterações'),
              ),

              // MOVER PARA LIXEIRA 
              if (_edit != null) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final id = _edit!['id'];
                    if (id != null) {
                      final provider = Provider.of<TransactionProvider>(context, listen: false);
                      await provider.delete(id as int);
                      if (mounted) Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Mover para lixeira'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}