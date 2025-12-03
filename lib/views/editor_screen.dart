import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redstone_notes_app/models/ideia_model.dart';

class EditorScreen extends StatefulWidget {
  final Ideia? ideiaExistente;
  const EditorScreen({super.key, this.ideiaExistente});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final _tituloController = TextEditingController();
  final _textoController = TextEditingController();

  DateTime? _dataAtividadeSelecionada;

  @override
  void initState() {
    super.initState();

    if (widget.ideiaExistente != null) {
      _tituloController.text = widget.ideiaExistente!.titulo;
      _textoController.text = widget.ideiaExistente!.texto;
      _dataAtividadeSelecionada = widget.ideiaExistente!.dataAtividade;
    }
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: _dataAtividadeSelecionada ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );

    if (dataEscolhida != null) {
      setState(() {
        _dataAtividadeSelecionada = dataEscolhida;
      });
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _textoController.dispose();
    super.dispose();
  }

  void _salvarAtividade() {
    final titulo = _tituloController.text;
    final texto = _textoController.text;

    if (titulo.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O título não pode estar em branco.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (widget.ideiaExistente == null) {
      final ideia = Ideia(
        titulo: titulo,
        texto: texto,
        dataAtividade: _dataAtividadeSelecionada,
      );
      Navigator.pop(context, ideia);
    } else {
      final ideiaAtualizada = widget.ideiaExistente!.copyWith(
        titulo: titulo,
        texto: texto,
        dataAtividade: _dataAtividadeSelecionada,
      );
      Navigator.pop(context, ideiaAtualizada);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.ideiaExistente == null ? 'Nova Atividade' : 'Editar Atividade')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Text(
                    _dataAtividadeSelecionada == null
                        ? 'Nenhuma data selecionada'
                        : 'Data: ${DateFormat('dd/MM/yyyy').format(_dataAtividadeSelecionada!)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selecionarData(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: TextField(
                controller: _textoController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  labelText: 'Texto',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _salvarAtividade,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
