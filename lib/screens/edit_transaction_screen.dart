import 'package:flutter/material.dart';

// Modelo simples de transação
class Transaction {
  String id;
  String title;
  double amount;
  DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });
}

// Tela de edição
class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction; // transação que será editada
  final Function(Transaction) onUpdate; // função para atualizar
  final Function(String) onDelete; // função para deletar

  const EditTransactionScreen({
    Key? key,
    required this.transaction,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _amount;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _title = widget.transaction.title;
    _amount = widget.transaction.amount;
    _date = widget.transaction.date;
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updated = Transaction(
        id: widget.transaction.id,
        title: _title,
        amount: _amount,
        date: _date,
      );
      widget.onUpdate(updated); // atualiza a lista em memória
      Navigator.of(context).pop(); // volta para a tela anterior
    }
  }

  void _delete() {
    widget.onDelete(widget.transaction.id);
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Transação'),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: _delete),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o título' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _amount.toString(),
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o valor';
                  if (double.tryParse(value) == null) return 'Valor inválido';
                  return null;
                },
                onSaved: (value) => _amount = double.parse(value!),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Data: ${_date.toLocal().toString().split(' ')[0]}'),
                  const SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: _pickDate, child: const Text('Selecionar Data')),
                ],
              ),
              const Spacer(),
              ElevatedButton(onPressed: _save, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}