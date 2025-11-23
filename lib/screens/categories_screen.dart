import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categorias = [
      {'nome': 'Alimentação', 'descricao': 'Gastos com comida'},
      {'nome': 'Transporte', 'descricao': 'Uber, ônibus, combustível'},
      {'nome': 'Lazer', 'descricao': 'Cinema, passeios, festas'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      body: ListView.builder(
        itemCount: categorias.length,
        itemBuilder: (context, i) {
          final c = categorias[i];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(c['nome']!),
              subtitle: Text(c['descricao']!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nova categoria (mock)!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
