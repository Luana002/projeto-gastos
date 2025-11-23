import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String nome;
  final Color cor;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.nome,
    this.cor = Colors.indigo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(nome),
        backgroundColor: cor.withOpacity(0.2),
        labelStyle: TextStyle(color: cor, fontWeight: FontWeight.w500),
      ),
    );
  }
}
