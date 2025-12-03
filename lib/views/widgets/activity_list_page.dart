import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redstone_notes_app/models/ideia_model.dart';

class ActivityListPage extends StatelessWidget {
  final List<Ideia> ideias;
  final Function(Ideia) onToggleComplete;
  final Function(Ideia) onDelete;
  final Function(Ideia) onEdit;

  const ActivityListPage({
    super.key,
    required this.ideias,
    required this.onToggleComplete,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    ideias.sort((a, b) {
      if (a.dataAtividade == null && b.dataAtividade != null) return 1;
      if (a.dataAtividade != null && b.dataAtividade == null) return -1;
      if (a.dataAtividade == null && b.dataAtividade == null) return 0;
      return a.dataAtividade!.compareTo(b.dataAtividade!);
    });

    final List<Ideia> ideiasPendentes =
        ideias.where((ideia) => !ideia.isCompleta).toList();
    final List<Ideia> ideiasConcluidas =
        ideias.where((ideia) => ideia.isCompleta).toList();

    if (ideias.isEmpty) {
      return const Center(
        child: Text('Nenhuma atividade criada.\nUse o botão "+" para criar'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        if (ideiasPendentes.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Text('Pendentes', style: Theme.of(context).textTheme.titleLarge),
          ),
          ...ideiasPendentes.map((ideia) => _buildIdeiaTile(context, ideia)),
        ],
        if (ideiasConcluidas.isNotEmpty) ...[
          const Divider(height: 32, thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Text('Concluídas', style: Theme.of(context).textTheme.titleLarge),
          ),
          ...ideiasConcluidas.map((ideia) => _buildIdeiaTile(context, ideia)),
        ]
      ],
    );
  }

  Widget _buildIdeiaTile(BuildContext context, Ideia ideia) {
    return Card(
      color: ideia.isCompleta ? Colors.grey.shade200 : null,
      child: ListTile(
        onTap: () => onEdit(ideia),
        leading: Checkbox(
          value: ideia.isCompleta,
          onChanged: (bool? novoValor) {
            onToggleComplete(ideia.copyWith(isCompleta: novoValor ?? false));
          },
        ),
        title: Text(
          ideia.titulo,
          style: TextStyle(
            decoration: ideia.isCompleta ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ideia.dataAtividade != null)
              Text(
                'Data: ${DateFormat('dd/MM/yyyy').format(ideia.dataAtividade!)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ideia.isCompleta ? Colors.grey : Colors.blue,
                  decoration: ideia.isCompleta ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            Text(
              ideia.texto, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(
                decoration: ideia.isCompleta ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => onDelete(ideia),
        ),
      ),
    );
  }
}
