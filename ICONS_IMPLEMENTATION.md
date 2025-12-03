# 🎨 Implementação de Ícones nos Nós do Mapa Mental

## 📋 Visão Geral

Esta implementação adiciona a funcionalidade de **ícones personalizados** nos nós do mapa mental usando o pacote **Font Awesome Flutter**, que oferece mais de 2.000 ícones vetoriais profissionais, com **busca inteligente em tempo real**.

## ✨ Funcionalidades Adicionadas

### 1. **🔍 Busca Inteligente de Ícones**
- **Campo de busca em tempo real**: Digite palavras-chave em português
- **150+ ícones catalogados** com nomes descritivos
- **Contador de resultados**: Mostra quantos ícones correspondem à busca
- **Limpeza rápida**: Botão X para limpar a busca
- **Estado vazio amigável**: Mensagem quando nenhum ícone é encontrado
- **Tooltip com nome**: Passe o mouse sobre o ícone para ver o nome

#### Exemplos de Busca:
- `estrela` → ⭐ Encontra ícone de estrela
- `casa` → 🏠 Encontra ícone de casa
- `livro` → 📚 Encontra ícones relacionados a livros
- `trabalho` → 💼 Encontra pasta, escritório, etc.
- `coracao` → ❤️ Encontra ícone de coração
- `codigo` → 💻 Encontra ícones de programação

### 2. **Seletor de Ícones**
- Interface visual intuitiva com grade rolável
- Opção "sem ícone" sempre visível no topo
- Destaque visual do ícone selecionado
- **Scroll** para navegar por muitos ícones
- Máximo de 300px de altura com scroll automático

### 3. **Renderização de Ícones nos Nós**
- Ícones aparecem **acima do texto** do nó
- Tamanho otimizado (24px) para boa visualização
- Compatível com todos os formatos de nó (retângulo, círculo, nuvem, losango)
- Persistência automática via serialização JSON

## 🛠️ Mudanças Técnicas

### Arquivos Modificados

#### 1. `pubspec.yaml`
```yaml
dependencies:
  font_awesome_flutter: ^10.7.0  # Pacote de ícones
```

#### 2. `lib/models/mind_map_node_data.dart`
- Adicionado campo `IconData? icon`
- Serialização/deserialização do ícone para JSON
- Armazenamento de `codePoint`, `fontFamily` e `fontPackage`

#### 3. `lib/screens/mind_map_view_screen.dart`
- Importado `font_awesome_flutter`
- Adicionado método `_buildIconSelector()` com 24 ícones
- Atualizado `_showNodeDialog()` para incluir seleção de ícone
- Modificado `_buildNodeWidget()` para renderizar ícone acima do texto

## 🎯 Como Usar

### Para o Usuário Final

1. **Adicionar Ícone ao Criar Nó:**
   - Toque em um nó existente para adicionar um filho
   - No diálogo, role até "Ícone (opcional)"
   - **Digite no campo de busca** (ex: "estrela", "casa", "livro")
   - Selecione o ícone desejado na grade
   - Digite o texto e salve

2. **Buscar Ícones:**
   - Use palavras em português: "estrela", "trabalho", "coracao"
   - A busca filtra em tempo real conforme você digita
   - Veja quantos ícones foram encontrados abaixo do campo
   - Clique no X para limpar a busca

3. **Editar Ícone de Nó Existente:**
   - Toque duas vezes (double tap) no nó
   - Use a busca para encontrar um novo ícone
   - Ou role pela grade de ícones
   - Salve as alterações

4. **Remover Ícone:**
   - Ao editar o nó, clique no botão "Sem ícone" (topo da lista)
   - Isso remove o ícone mantendo o texto

## 📦 Ícones Disponíveis

### 🔍 Sistema de Busca

O sistema possui **150+ ícones catalogados** organizados por categorias. Basta digitar palavras-chave em português:

### Categorias e Palavras-Chave

#### 💡 **Ideias & Criatividade**
- Busque: `lampada`, `cerebro`, `ideia`, `pensamento`, `criatividade`, `paleta`, `pincel`, `lapis`, `caneta`
- Ícones: 💡 🧠 🎨 ✏️ 🖊️

#### 🎯 **Objetivos & Conquistas**
- Busque: `foguete`, `estrela`, `trofeu`, `medalha`, `coroa`, `alvo`, `objetivo`, `sucesso`, `vitoria`
- Ícones: 🚀 ⭐ 🏆 🥇 👑 🎯

#### 📚 **Educação & Conhecimento**
- Busque: `livro`, `formatura`, `escola`, `estudo`, `leitura`, `biblioteca`, `certificado`, `diploma`
- Ícones: 📚 🎓 🏫 📖 📜

#### 💼 **Trabalho & Negócios**
- Busque: `pasta`, `trabalho`, `negocio`, `dinheiro`, `moeda`, `grafico`, `relatorio`, `apresentacao`, `escritorio`
- Ícones: 💼 💰 💵 📊 📈 🏢

#### 💻 **Tecnologia & Programação**
- Busque: `codigo`, `programacao`, `computador`, `laptop`, `mobile`, `celular`, `bug`, `servidor`, `database`, `cloudcomputing`, `wifi`, `link`
- Ícones: 💻 🖥️ 📱 🐛 🗄️ ☁️ 📡 🔗

#### 💬 **Comunicação**
- Busque: `comentario`, `mensagem`, `chat`, `email`, `telefone`, `video`, `microfone`
- Ícones: 💬 📧 📞 📹 🎤

#### 👥 **Pessoas & Social**
- Busque: `usuario`, `pessoa`, `usuarios`, `grupo`, `equipe`, `familia`, `coracao`, `amor`
- Ícones: 👤 👥 👨‍👩‍👧‍👦 ❤️

#### 🎨 **Arte & Mídia**
- Busque: `musica`, `som`, `filme`, `camera`, `foto`, `galeria`, `play`, `pause`
- Ícones: 🎵 🔊 🎬 📷 🖼️ ▶️ ⏸️

#### 🎮 **Lazer & Entretenimento**
- Busque: `jogo`, `game`, `esporte`, `bola`, `corrida`, `bicicleta`
- Ícones: 🎮 ⚽ 🏃 🚴

#### 🏠 **Vida & Cotidiano**
- Busque: `casa`, `lar`, `carro`, `veiculo`, `aviao`, `viagem`, `mala`, `compras`, `loja`, `comida`, `restaurante`, `cafe`, `pizza`
- Ícones: 🏠 🚗 ✈️ 🧳 🛒 🍕 ☕

#### 🌿 **Natureza & Clima**
- Busque: `sol`, `lua`, `nuvem`, `chuva`, `tempestade`, `arvore`, `folha`, `flor`
- Ícones: ☀️ 🌙 ☁️ 🌧️ ⛈️ 🌳 🍃 🌱

#### 🛠️ **Ferramentas & Utilitários**
- Busque: `configuracao`, `engrenagem`, `ferramenta`, `chave`, `cadeado`, `desbloqueado`, `busca`, `pesquisa`, `filtro`, `sino`, `notificacao`, `calendario`, `relogio`, `tempo`, `alarme`
- Ícones: ⚙️ 🔧 🔑 🔒 🔓 🔍 🔔 📅 ⏰

#### 🧭 **Navegação & Direção**
- Busque: `seta`, `cima`, `baixo`, `esquerda`, `direita`, `localizacao`, `mapa`, `bussola`
- Ícones: ➡️ ⬆️ ⬇️ ⬅️ 📍 🗺️ 🧭

#### 🏥 **Saúde & Fitness**
- Busque: `saude`, `hospital`, `medico`, `remedio`, `fitness`, `peso`
- Ícones: 🏥 👨‍⚕️ 💊 🏋️ ⚖️

#### 📁 **Documentos & Arquivos**
- Busque: `arquivo`, `documento`, `pdf`, `diretorio`, `download`, `upload`, `salvar`, `imprimir`
- Ícones: 📄 📋 📑 📂 ⬇️ ⬆️ 💾 🖨️

#### ✅ **Ações & Controles**
- Busque: `mais`, `adicionar`, `menos`, `remover`, `deletar`, `editar`, `verificar`, `ok`, `cancelar`, `fechar`, `info`, `ajuda`, `aviso`, `perigo`
- Ícones: ➕ ➖ 🗑️ ✏️ ✅ ❌ ℹ️ ❓ ⚠️

## 🔧 Extensibilidade

### Adicionar Mais Ícones ao Catálogo

Para adicionar novos ícones pesquisáveis, edite o mapa `_allIcons` na classe `IconSearchWidget` em `mind_map_view_screen.dart`:

```dart
static final Map<String, IconData> _allIcons = {
  // ... ícones existentes ...
  
  // ADICIONAR NOVOS AQUI:
  'palavrachave': FontAwesomeIcons.seuNovoIcone,
  'sinonimo': FontAwesomeIcons.seuNovoIcone,  // Mesmo ícone, palavra diferente
};
```

**Exemplo prático:**
```dart
// Adicionar ícone de diamante
'diamante': FontAwesomeIcons.gem,
'joia': FontAwesomeIcons.gem,
'precioso': FontAwesomeIcons.gem,
```

### Consultar Ícones Font Awesome Disponíveis

1. Visite: https://fontawesome.com/icons
2. Escolha ícones da versão **FREE** (Solid)
3. No Flutter use: `FontAwesomeIcons.nomeDoIcone` (camelCase)

**Exemplos de conversão:**
- `arrow-right` → `FontAwesomeIcons.arrowRight`
- `user-circle` → `FontAwesomeIcons.userCircle`
- `heart` → `FontAwesomeIcons.heart`

## 🎨 Personalização Visual

### Ajustar Tamanho do Ícone

Em `_buildNodeWidget()`:
```dart
FaIcon(nodeData.icon, size: 24, color: Colors.black87),  // Altere 'size'
```

### Ajustar Espaçamento

```dart
if (nodeData.icon != null) ...[
  FaIcon(nodeData.icon, size: 24, color: Colors.black87),
  const SizedBox(height: 8),  // Altere o espaçamento
],
```

### Cor do Ícone

Pode herdar a cor do nó ou definir uma fixa:
```dart
// Cor fixa
FaIcon(nodeData.icon, size: 24, color: Colors.black87),

// Ou cor baseada no fundo do nó (contraste)
FaIcon(nodeData.icon, size: 24, 
  color: nodeData.color.computeLuminance() > 0.5 
    ? Colors.black87 
    : Colors.white),
```

## 💾 Persistência de Dados

Os ícones são salvos automaticamente como parte do JSON do mapa mental:

```json
{
  "nodes": [
    {
      "id": "uuid-123",
      "text": "Minha Ideia",
      "color": 4294198070,
      "shape": "rectangle",
      "icon": {
        "codePoint": 61675,
        "fontFamily": "FontAwesomeSolid",
        "fontPackage": "font_awesome_flutter"
      }
    }
  ],
  "edges": [...]
}
```

## 🚀 Melhorias Futuras Sugeridas

1. ✅ **Busca de Ícones** - ✨ IMPLEMENTADO!
2. **Categorias com Abas**: Organizar por tipo (negócios, educação, etc) em tabs
3. **Ícones Favoritos**: Salvar ícones mais usados pelo usuário
4. **Histórico de Uso**: Mostrar últimos ícones utilizados
5. **Upload de Imagens**: Permitir imagens personalizadas do dispositivo
6. **Tamanho Ajustável**: Slider para ajustar tamanho do ícone por nó
7. **Cor do Ícone**: Seletor de cor independente para o ícone
8. **Busca em Inglês**: Suportar palavras-chave em inglês também
9. **Ícones Customizados**: Importar ícones de outras fontes
10. **Atalhos de Teclado**: Ctrl+F para focar no campo de busca

## 📝 Notas Técnicas

- **Performance**: Ícones são vetoriais, não afetam performance
- **Compatibilidade**: Funciona em Android, iOS, Web, Desktop
- **Fallback**: Se ícone não existir, não quebra a renderização
- **Serialização**: `IconData` completo é preservado (fontFamily, package)

## 🐛 Troubleshooting

### Ícone não aparece
- Verifique se `flutter pub get` foi executado
- Confirme que o import está correto
- Teste com ícone simples como `FontAwesomeIcons.star`

### Erro de serialização
- Certifique-se que `icon` aceita `null`
- Valide o JSON antes de salvar

### Layout quebrado
- Ajuste padding do Container do nó
- Verifique constraints de tamanho mínimo
