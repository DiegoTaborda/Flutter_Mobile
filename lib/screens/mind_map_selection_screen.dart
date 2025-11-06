import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../ideia_model.dart';
import 'mind_map_view_screen.dart';

class MindMapSelectionScreen extends StatelessWidget {
  final List<Ideia> ideias;
  final Function(Ideia) onIdeiaUpdated; 

  const MindMapSelectionScreen({
    super.key, 
    required this.ideias,
    required this.onIdeiaUpdated,
  });

  @override
  Widget build(BuildContext context) {
    ideias.sort((a, b) {
      return a.dataAtividade!.compareTo(b.dataAtividade!);
    });

    return Scaffold(
      body: ListView.builder(
        itemCount: ideias.length,
        itemBuilder: (context, index) {
          final ideia = ideias[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(ideia.titulo),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ideia.dataAtividade != null)
                    Text(
                      'Data: ${DateFormat('dd/MM/yyyy').format(ideia.dataAtividade!)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  Text(
                    ideia.texto,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              onTap: () async {
                final ideiaAtualizada = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MindMapViewScreen(ideia: ideia),
                  ),
                );

                if (ideiaAtualizada != null && ideiaAtualizada is Ideia) {
                  print('--- CHECKPOINT 2: Ideia recebida de volta ---');
                  print('JSON Recebido: ${ideiaAtualizada.mindMapJson}');
                  onIdeiaUpdated(ideiaAtualizada);
                }
              },
            ),
          );
        },
      ),
    );
  }
}