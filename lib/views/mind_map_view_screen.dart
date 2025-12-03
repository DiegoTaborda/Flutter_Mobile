import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphview/GraphView.dart';
import 'package:redstone_notes_app/models/ideia_model.dart';
import 'package:redstone_notes_app/models/mind_map_node_data.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class MindMapViewScreen extends StatefulWidget {
  final Ideia ideia;
  const MindMapViewScreen({super.key, required this.ideia});

  @override
  State<MindMapViewScreen> createState() => _MindMapViewScreenState();
}

class _MindMapViewScreenState extends State<MindMapViewScreen> {
  final Graph graph = Graph();
  late BuchheimWalkerConfiguration builder;
  Node? nodeCentral;
  
  final Map<Node, MindMapNodeData> nodeDataMap = {};
  final TransformationController transformationController = TransformationController();

  void _saveAndExit() {
    final List<Map<String, dynamic>> nodesJson =
        nodeDataMap.values.map((data) => data.toJson()).toList();

    final List<Map<String, String>> edgesJson = graph.edges
        .map((edge) => {
              'from': nodeDataMap[edge.source]!.id,
              'to': nodeDataMap[edge.destination]!.id,
            })
        .toList();

    final mindMapData = {
      'nodes': nodesJson,
      'edges': edgesJson,
    };

    final jsonString = jsonEncode(mindMapData);
    print('--- CHECKPOINT 1: Salvando o Mapa ---');
    print(jsonString);
    final ideiaAtualizada = widget.ideia.copyWith(mindMapJson: jsonString);
    Navigator.pop(context, ideiaAtualizada);
  }

  @override
  void initState() {
    super.initState();

    print('--- CHECKPOINT 3: Abrindo a tela do mapa ---');
    print('JSON da Ideia na entrada: ${widget.ideia.mindMapJson}');

    builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = (60)
      ..levelSeparation = (100)
      ..subtreeSeparation = (100)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);

    if (widget.ideia.mindMapJson != null && widget.ideia.mindMapJson!.isNotEmpty) {
      final mindMapData = jsonDecode(widget.ideia.mindMapJson!);
      final nodesJson = mindMapData['nodes'] as List;
      final edgesJson = mindMapData['edges'] as List;
      Map<String, Node> idToNodeMap = {};

      for (var nodeJson in nodesJson) {
        final nodeData = MindMapNodeData.fromJson(nodeJson);
        final node = Node.Id(nodeData.id);
        nodeDataMap[node] = nodeData;
        graph.addNode(node);
        idToNodeMap[nodeData.id] = node;
        
        if (nodeCentral == null) {
          nodeCentral = node;
        }
      }

      for (var edgeJson in edgesJson) {
        final fromNode = idToNodeMap[edgeJson['from']];
        final toNode = idToNodeMap[edgeJson['to']];
        if (fromNode != null && toNode != null) {
          graph.addEdge(fromNode, toNode);
        }
      }
    } else {
      final id = uuid.v4();
      nodeCentral = Node.Id(id); 
      final nodeCentralData = MindMapNodeData(
        id: id,
        text: widget.ideia.titulo,
        color: Colors.red.shade200,
        shape: NodeShape.rectangle,
      );
      nodeDataMap[nodeCentral!] = nodeCentralData;
      graph.addNode(nodeCentral!);
    }
  }

  @override
  void dispose() {
    transformationController.dispose();
    super.dispose();
  }

  Future<void> _showNodeDialog({Node? parentNode, Node? existingNode}) async {
    bool isEditing = existingNode != null;
    MindMapNodeData? existingData = isEditing ? nodeDataMap[existingNode] : null;

    final TextEditingController textController = TextEditingController(text: existingData?.text ?? '');
    Color selectedColor = existingData?.color ?? Colors.blue.shade200;
    NodeShape selectedShape = existingData?.shape ?? NodeShape.rectangle;
    IconData? selectedIcon = existingData?.icon;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Editar Tópico' : 'Adicionar Novo Tópico'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(controller: textController, autofocus: true, decoration: const InputDecoration(hintText: 'Digite o texto aqui')),
                    const SizedBox(height: 20),
                    const Text('Cor do Nó:'),
                    _buildColorSelector(selectedColor, (color) => setDialogState(() => selectedColor = color)),
                    const SizedBox(height: 20),
                    const Text('Formato do Nó:'),
                    _buildShapeSelector(selectedShape, (shape) => setDialogState(() => selectedShape = shape)),
                    const SizedBox(height: 20),
                    const Text('Ícone (opcional):'),
                    const SizedBox(height: 8),
                    _buildIconSelector(selectedIcon, (icon) => setDialogState(() => selectedIcon = icon)),
                  ],
                ),
              ),
              actions: [
                TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(context).pop()),
                TextButton(
                  child: const Text('Salvar'),
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      setState(() {
                        if (isEditing) {
                          nodeDataMap[existingNode]!.text = textController.text;
                          nodeDataMap[existingNode]!.color = selectedColor;
                          nodeDataMap[existingNode]!.shape = selectedShape;
                          nodeDataMap[existingNode]!.icon = selectedIcon;
                        } else {
                          final id = uuid.v4();
                          final newNode = Node.Id(id);
                          nodeDataMap[newNode] = MindMapNodeData(
                            id: id,
                            text: textController.text, 
                            color: selectedColor, 
                            shape: selectedShape,
                            icon: selectedIcon,
                          );
                          graph.addEdge(parentNode!, newNode);
                        }
                      });
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  Widget _buildColorSelector(Color currentColor, ValueChanged<Color> onColorSelected) {
    final List<Color> colors = [
      Colors.blue.shade200, Colors.green.shade200, Colors.red.shade200, 
      Colors.purple.shade200, Colors.orange.shade200, Colors.grey.shade400,
      Colors.yellow.shade200, Colors.pink.shade200,
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              color: color, shape: BoxShape.circle,
              border: currentColor == color ? Border.all(color: Colors.black, width: 3) : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildShapeSelector(NodeShape currentShape, ValueChanged<NodeShape> onShapeSelected) {
    final Map<NodeShape, IconData> shapes = {
      NodeShape.rectangle: Icons.check_box_outline_blank,
      NodeShape.circle: Icons.radio_button_unchecked,
      NodeShape.cloud: Icons.cloud_outlined,
      NodeShape.diamond: Icons.diamond_outlined,
    };
    return Wrap(
      spacing: 16,
      children: shapes.entries.map((entry) {
        return IconButton(
          icon: Icon(entry.value, size: 30),
          color: currentShape == entry.key ? Theme.of(context).primaryColor : Colors.grey,
          onPressed: () => onShapeSelected(entry.key),
        );
      }).toList(),
    );
  }

  Widget _buildIconSelector(IconData? currentIcon, ValueChanged<IconData?> onIconSelected) {
    return IconSearchWidget(
      currentIcon: currentIcon,
      onIconSelected: onIconSelected,
    );
  }

  Future<void> _showDeleteNodeConfirmationDialog(BuildContext context, Node nodeToDelete) async {
    if (nodeToDelete == nodeCentral) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não é possível excluir o tópico principal.')));
      return;
    }
    return showDialog<void>(
      context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Deseja excluir este tópico e todos os seus sub-tópicos?'),
          actions: <Widget>[
            TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(context).pop()),
            TextButton(
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
              onPressed: () {
                graph.removeNode(nodeToDelete);
                nodeDataMap.remove(nodeToDelete);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _zoomIn() {
    transformationController.value.scale(1.2);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    transformationController.notifyListeners();
  }

  void _zoomOut() {
    transformationController.value.scale(1 / 1.2);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    transformationController.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa Mental: ${nodeCentral != null ? nodeDataMap[nodeCentral]!.text : ""}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveAndExit,
            tooltip: 'Salvar e Sair',
          ),
        ],
      ),
      body: Stack(
        children: [
          InteractiveViewer(
            transformationController: transformationController, // Conecta o controller
            constrained: false,
            boundaryMargin: const EdgeInsets.all(200),
            minScale: 0.1,
            maxScale: 4.0,
            child: GraphView(
              graph: graph,
              algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
              paint: Paint()..color = Colors.grey..strokeWidth = 1..style = PaintingStyle.stroke,
              builder: (Node node) => _buildNodeWidget(node),
            ),
          ),
          // NOVO: Botões de Zoom
          Positioned(
            bottom: 16, right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(heroTag: 'zoomIn', onPressed: _zoomIn, child: const Icon(Icons.add)),
                const SizedBox(height: 8),
                FloatingActionButton.small(heroTag: 'zoomOut', onPressed: _zoomOut, child: const Icon(Icons.remove)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MODIFICADO: Widget agora renderiza cor, formato e ícone dinamicamente
  Widget _buildNodeWidget(Node node) {
    final nodeData = nodeDataMap[node]!;

    Widget child = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: nodeData.color,
        borderRadius: nodeData.shape == NodeShape.rectangle ? BorderRadius.circular(8) : null,
        shape: nodeData.shape == NodeShape.circle ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (nodeData.icon != null) ...[
            FaIcon(nodeData.icon, size: 24, color: Colors.black87),
            const SizedBox(height: 8),
          ],
          Text(
            nodeData.text, 
            style: const TextStyle(fontSize: 12), 
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    // Aplica o formato customizado
    switch (nodeData.shape) {
      case NodeShape.cloud:
        child = ClipPath(clipper: CloudClipper(), child: child);
        break;
      case NodeShape.diamond:
        child = Transform.rotate(angle: math.pi / 4, child: ClipPath(clipper: DiamondClipper(), child: child));
        break;
      default: // Rectangle e Circle já são tratados na decoração
        break;
    }

    return GestureDetector(
      onTap: () => _showNodeDialog(parentNode: node),
      onDoubleTap: () => _showNodeDialog(existingNode: node),
      onLongPress: () => _showDeleteNodeConfirmationDialog(context, node),
      child: child,
    );
  }
}

// NOVO: Clipper customizado para o formato de nuvem
class CloudClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width * 0.4, size.height * 0.9);
    path.cubicTo(size.width * 0.1, size.height * 0.9, 0, size.height * 0.7, size.width * 0.2, size.height * 0.4);
    path.cubicTo(size.width * 0.2, 0, size.width * 0.8, 0, size.width * 0.8, size.height * 0.4);
    path.cubicTo(size.width, size.height * 0.7, size.width * 0.9, size.height * 0.9, size.width * 0.6, size.height * 0.9);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// NOVO: Clipper customizado para o formato de losango
class DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height / 2)
      ..close();
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Widget de busca e seleção de ícones
class IconSearchWidget extends StatefulWidget {
  final IconData? currentIcon;
  final ValueChanged<IconData?> onIconSelected;

  const IconSearchWidget({
    super.key,
    required this.currentIcon,
    required this.onIconSelected,
  });

  @override
  State<IconSearchWidget> createState() => _IconSearchWidgetState();
}

class _IconSearchWidgetState extends State<IconSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<MapEntry<String, IconData>> _filteredIcons = [];
  
  // Mapa completo de ícones disponíveis com nomes descritivos
  static final Map<String, IconData> _allIcons = {
    // Ideias & Criatividade
    'lampada': FontAwesomeIcons.lightbulb,
    'cerebro': FontAwesomeIcons.brain,
    'ideia': FontAwesomeIcons.lightbulb,
    'pensamento': FontAwesomeIcons.brain,
    'criatividade': FontAwesomeIcons.palette,
    'paleta': FontAwesomeIcons.palette,
    'pincel': FontAwesomeIcons.paintbrush,
    'lapis': FontAwesomeIcons.pencil,
    'caneta': FontAwesomeIcons.pen,
    
    // Objetivos & Conquistas
    'foguete': FontAwesomeIcons.rocket,
    'estrela': FontAwesomeIcons.star,
    'trofeu': FontAwesomeIcons.trophy,
    'medalha': FontAwesomeIcons.medal,
    'coroa': FontAwesomeIcons.crown,
    'alvo': FontAwesomeIcons.bullseye,
    'objetivo': FontAwesomeIcons.bullseye,
    'sucesso': FontAwesomeIcons.trophy,
    'vitoria': FontAwesomeIcons.trophy,
    
    // Educação & Conhecimento
    'livro': FontAwesomeIcons.book,
    'formatura': FontAwesomeIcons.graduationCap,
    'escola': FontAwesomeIcons.school,
    'estudo': FontAwesomeIcons.bookOpen,
    'leitura': FontAwesomeIcons.bookOpenReader,
    'biblioteca': FontAwesomeIcons.bookBookmark,
    'certificado': FontAwesomeIcons.certificate,
    'diploma': FontAwesomeIcons.scroll,
    
    // Trabalho & Negócios
    'pasta': FontAwesomeIcons.briefcase,
    'trabalho': FontAwesomeIcons.briefcase,
    'negocio': FontAwesomeIcons.businessTime,
    'dinheiro': FontAwesomeIcons.moneyBill,
    'moeda': FontAwesomeIcons.coins,
    'grafico': FontAwesomeIcons.chartLine,
    'relatorio': FontAwesomeIcons.chartBar,
    'apresentacao': FontAwesomeIcons.chalkboardUser,
    'escritorio': FontAwesomeIcons.building,
    
    // Tecnologia & Programação
    'codigo': FontAwesomeIcons.code,
    'programacao': FontAwesomeIcons.laptop,
    'computador': FontAwesomeIcons.desktop,
    'laptop': FontAwesomeIcons.laptopCode,
    'mobile': FontAwesomeIcons.mobile,
    'celular': FontAwesomeIcons.mobileScreen,
    'bug': FontAwesomeIcons.bug,
    'servidor': FontAwesomeIcons.server,
    'database': FontAwesomeIcons.database,
    'cloudcomputing': FontAwesomeIcons.cloud,
    'wifi': FontAwesomeIcons.wifi,
    'link': FontAwesomeIcons.link,
    
    // Comunicação
    'comentario': FontAwesomeIcons.comment,
    'mensagem': FontAwesomeIcons.message,
    'chat': FontAwesomeIcons.comments,
    'email': FontAwesomeIcons.envelope,
    'telefone': FontAwesomeIcons.phone,
    'video': FontAwesomeIcons.video,
    'microfone': FontAwesomeIcons.microphone,
    
    // Pessoas & Social
    'usuario': FontAwesomeIcons.user,
    'pessoa': FontAwesomeIcons.person,
    'usuarios': FontAwesomeIcons.users,
    'grupo': FontAwesomeIcons.userGroup,
    'equipe': FontAwesomeIcons.peopleGroup,
    'familia': FontAwesomeIcons.peopleRoof,
    'coracao': FontAwesomeIcons.heart,
    'amor': FontAwesomeIcons.heart,
    
    // Arte & Mídia
    'musica': FontAwesomeIcons.music,
    'som': FontAwesomeIcons.volumeHigh,
    'filme': FontAwesomeIcons.film,
    'camera': FontAwesomeIcons.camera,
    'foto': FontAwesomeIcons.image,
    'galeria': FontAwesomeIcons.images,
    'play': FontAwesomeIcons.play,
    'pause': FontAwesomeIcons.pause,
    
    // Lazer & Entretenimento
    'jogo': FontAwesomeIcons.gamepad,
    'game': FontAwesomeIcons.gamepad,
    'esporte': FontAwesomeIcons.futbol,
    'bola': FontAwesomeIcons.baseball,
    'corrida': FontAwesomeIcons.personRunning,
    'bicicleta': FontAwesomeIcons.personBiking,
    
    // Vida & Cotidiano
    'casa': FontAwesomeIcons.house,
    'lar': FontAwesomeIcons.house,
    'carro': FontAwesomeIcons.car,
    'veiculo': FontAwesomeIcons.carSide,
    'aviao': FontAwesomeIcons.plane,
    'viagem': FontAwesomeIcons.suitcase,
    'mala': FontAwesomeIcons.suitcaseRolling,
    'compras': FontAwesomeIcons.cartShopping,
    'loja': FontAwesomeIcons.store,
    'comida': FontAwesomeIcons.utensils,
    'restaurante': FontAwesomeIcons.bowlFood,
    'cafe': FontAwesomeIcons.mugHot,
    'pizza': FontAwesomeIcons.pizzaSlice,
    
    // Natureza & Clima
    'sol': FontAwesomeIcons.sun,
    'lua': FontAwesomeIcons.moon,
    'nuvem': FontAwesomeIcons.cloud,
    'chuva': FontAwesomeIcons.cloudRain,
    'tempestade': FontAwesomeIcons.cloudBolt,
    'arvore': FontAwesomeIcons.tree,
    'folha': FontAwesomeIcons.leaf,
    'flor': FontAwesomeIcons.seedling,
    
    // Ferramentas & Utilitários
    'configuracao': FontAwesomeIcons.gear,
    'engrenagem': FontAwesomeIcons.gears,
    'ferramenta': FontAwesomeIcons.wrench,
    'chave': FontAwesomeIcons.key,
    'cadeado': FontAwesomeIcons.lock,
    'desbloqueado': FontAwesomeIcons.lockOpen,
    'busca': FontAwesomeIcons.magnifyingGlass,
    'pesquisa': FontAwesomeIcons.magnifyingGlass,
    'filtro': FontAwesomeIcons.filter,
    'sino': FontAwesomeIcons.bell,
    'notificacao': FontAwesomeIcons.bellSlash,
    'calendario': FontAwesomeIcons.calendar,
    'relogio': FontAwesomeIcons.clock,
    'tempo': FontAwesomeIcons.hourglass,
    'alarme': FontAwesomeIcons.bellConcierge,
    
    // Navegação & Direção
    'seta': FontAwesomeIcons.arrowRight,
    'cima': FontAwesomeIcons.arrowUp,
    'baixo': FontAwesomeIcons.arrowDown,
    'esquerda': FontAwesomeIcons.arrowLeft,
    'direita': FontAwesomeIcons.arrowRight,
    'localizacao': FontAwesomeIcons.locationDot,
    'mapa': FontAwesomeIcons.map,
    'bussola': FontAwesomeIcons.compass,
    
    // Saúde & Fitness
    'saude': FontAwesomeIcons.heartPulse,
    'hospital': FontAwesomeIcons.hospital,
    'medico': FontAwesomeIcons.userDoctor,
    'remedio': FontAwesomeIcons.pills,
    'fitness': FontAwesomeIcons.dumbbell,
    'peso': FontAwesomeIcons.weightScale,
    
    // Documentos & Arquivos
    'arquivo': FontAwesomeIcons.file,
    'documento': FontAwesomeIcons.fileLines,
    'pdf': FontAwesomeIcons.filePdf,
    'diretorio': FontAwesomeIcons.folder,
    'download': FontAwesomeIcons.download,
    'upload': FontAwesomeIcons.upload,
    'salvar': FontAwesomeIcons.floppyDisk,
    'imprimir': FontAwesomeIcons.print,
    
    // Ações & Controles
    'mais': FontAwesomeIcons.plus,
    'adicionar': FontAwesomeIcons.circlePlus,
    'menos': FontAwesomeIcons.minus,
    'remover': FontAwesomeIcons.trash,
    'deletar': FontAwesomeIcons.trashCan,
    'editar': FontAwesomeIcons.penToSquare,
    'verificar': FontAwesomeIcons.check,
    'ok': FontAwesomeIcons.circleCheck,
    'cancelar': FontAwesomeIcons.xmark,
    'fechar': FontAwesomeIcons.circleXmark,
    'info': FontAwesomeIcons.circleInfo,
    'ajuda': FontAwesomeIcons.circleQuestion,
    'aviso': FontAwesomeIcons.triangleExclamation,
    'perigo': FontAwesomeIcons.circleExclamation,
  };

  @override
  void initState() {
    super.initState();
    _filteredIcons = _allIcons.entries.toList();
    _searchController.addListener(_filterIcons);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterIcons);
    _searchController.dispose();
    super.dispose();
  }

  void _filterIcons() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredIcons = _allIcons.entries.toList();
      } else {
        _filteredIcons = _allIcons.entries
            .where((entry) => entry.key.contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campo de busca
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar ícone... (ex: estrela, casa, livro)',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          
          // Contador de resultados
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${_filteredIcons.length} ícone(s) encontrado(s)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          
          // Botão "Sem ícone"
          InkWell(
            onTap: () => widget.onIconSelected(null),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: widget.currentIcon == null 
                    ? Theme.of(context).primaryColor.withOpacity(0.2) 
                    : Colors.grey.shade100,
                border: Border.all(
                  color: widget.currentIcon == null 
                      ? Theme.of(context).primaryColor 
                      : Colors.grey.shade300,
                  width: widget.currentIcon == null ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(Icons.block, size: 20, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    'Sem ícone',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: widget.currentIcon == null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Grade de ícones com scroll
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: _filteredIcons.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          Text(
                            'Nenhum ícone encontrado',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tente: estrela, casa, livro...',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _filteredIcons.map((entry) {
                        final icon = entry.value;
                        final name = entry.key;
                        final isSelected = widget.currentIcon?.codePoint == icon.codePoint;
                        
                        return Tooltip(
                          message: name,
                          child: InkWell(
                            onTap: () => widget.onIconSelected(icon),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? Theme.of(context).primaryColor.withOpacity(0.2) 
                                    : Colors.grey.shade50,
                                border: Border.all(
                                  color: isSelected 
                                      ? Theme.of(context).primaryColor 
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: FaIcon(
                                  icon, 
                                  size: 20,
                                  color: isSelected 
                                      ? Theme.of(context).primaryColor 
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
