import 'package:flutter/material.dart';
import 'package:redstone_notes_app/database/database_helper.dart';
import 'package:redstone_notes_app/ideia_model.dart';
import 'package:redstone_notes_app/screens/editor_screen.dart';
import 'package:redstone_notes_app/screens/menu_screen.dart';
import 'package:redstone_notes_app/screens/mind_map_selection_screen.dart';
import '../activity_list_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Ideia> _ideias = [];
  final PageController _pageController = PageController();
  final DatabaseHelper _db = DatabaseHelper.instance;
  int _paginaAtual = 0;

  @override
  void initState() {
    super.initState();
    _carregarIdeias();
  }

  Future<void> _carregarIdeias() async {
    final ideias = await _db.getAllIdeias();
    setState(() {
      _ideias.clear();
      _ideias.addAll(ideias);
    });
  }

  Future<void> _adicionarOuAtualizarIdeia(Ideia ideia) async {
    final index = _ideias.indexWhere((i) => i.id == ideia.id);
    if (index != -1) {
      await _db.updateIdeia(ideia);
    } else {
      await _db.insertIdeia(ideia);
    }
    await _carregarIdeias();
  }

  Future<void> _removerIdeia(Ideia ideia) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja excluir a atividade "${ideia.titulo}"?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _db.deleteIdeia(ideia.id);
      await _carregarIdeias();
    }
  }

  void _abrirEditor([Ideia? ideiaExistente]) async {
    final ideiaRetornada = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorScreen(ideiaExistente: ideiaExistente),
      ),
    );

    if (ideiaRetornada != null && ideiaRetornada is Ideia) {
      _adicionarOuAtualizarIdeia(ideiaRetornada);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 2:
        _abrirEditor();
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Botão temporário!'), duration: Duration(seconds: 1)));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuScreen()));
        break;
      default:
        _pageController.animateToPage(index,
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    const List<String> titulos = ['Minhas Atividades', 'Mapas Mentais'];

    return Scaffold(
      appBar: AppBar(title: Text(titulos[_paginaAtual])),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _paginaAtual = index),
        children: [
          ActivityListPage(
            ideias: _ideias,
            onEdit: (ideia) => _abrirEditor(ideia),
            onDelete: (ideia) => _removerIdeia(ideia),
            onToggleComplete: (ideia) => _adicionarOuAtualizarIdeia(ideia),
          ),
          // ATUALIZE ESTA LINHA:
          MindMapSelectionScreen(
            ideias: _ideias,
            // Passamos a nossa função de atualizar para a tela de seleção
            onIdeiaUpdated: (ideia) => _adicionarOuAtualizarIdeia(ideia),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined), label: 'Atividades'),
          BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined), label: 'Mapa Mental'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box), label: 'Adicionar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.hourglass_empty), label: 'Temp'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
    );
  }
}