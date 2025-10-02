import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../ideia_model.dart';
import 'mind_map_view_screen.dart';

class MindMapSelectionScreen extends StatelessWidget {
  final List<Ideia> ideias;
  // NOVO: Uma função que será chamada quando uma ideia for atualizada
  final Function(Ideia) onIdeiaUpdated; 

  const MindMapSelectionScreen({
    super.key, 
    required this.ideias,
    required this.onIdeiaUpdated, // NOVO: Adiciona a função ao construtor
  });

  @override
  Widget build(BuildContext context) {
    // A lógica de ordenação continua a mesma
    ideias.sort((a, b) {
      // ...
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

                // Se a tela do mapa retornou uma ideia atualizada...
                if (ideiaAtualizada != null && ideiaAtualizada is Ideia) {
                  print('--- CHECKPOINT 2: Ideia recebida de volta ---');
                  print('JSON Recebido: ${ideiaAtualizada.mindMapJson}');
                  // ...nós usamos nossa nova função de callback para enviá-la
                  // para a HomeScreen, que sabe o que fazer com ela.
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