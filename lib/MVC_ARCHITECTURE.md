# 🏗️ Arquitetura MVC - Redstone Notes App

## 📋 Visão Geral

O projeto foi reestruturado seguindo o padrão **MVC (Model-View-Controller)** para melhor organização, manutenibilidade e escalabilidade do código.

## 🗂️ Estrutura de Diretórios

```
lib/
├── main.dart                      # Ponto de entrada da aplicação
│
├── models/                        # 📦 MODEL - Camada de Dados
│   ├── ideia_model.dart          # Modelo de Ideia/Atividade
│   ├── mind_map_node_data.dart   # Modelo de Nó do Mapa Mental
│   └── user_model.dart           # Modelo de Usuário
│
├── views/                         # 🎨 VIEW - Camada de Interface
│   ├── auth_gate_screen.dart     # Tela de controle de autenticação
│   ├── login_screen.dart         # Tela de login
│   ├── register_screen.dart      # Tela de registro
│   ├── home_screen.dart          # Tela principal
│   ├── editor_screen.dart        # Editor de atividades
│   ├── mind_map_view_screen.dart # Visualização do mapa mental
│   ├── mind_map_selection_screen.dart # Seleção de mapas
│   ├── profile_screen.dart       # Perfil do usuário
│   ├── settings_screen.dart      # Configurações
│   ├── menu_screen.dart          # Menu lateral
│   └── widgets/                  # Widgets reutilizáveis
│       └── activity_list_page.dart # Lista de atividades
│
├── controllers/                   # 🎮 CONTROLLER - Camada de Lógica
│   ├── auth_provider.dart        # Controlador de autenticação
│   └── theme_provider.dart       # Controlador de tema
│
├── services/                      # 🔧 Camada de Serviços
│   └── auth_repository.dart      # Repositório de autenticação
│
├── database/                      # 💾 Camada de Persistência
│   └── database_helper.dart      # Helper do SQLite
│
└── utils/                         # 🛠️ Utilitários
    (vazio - preparado para helpers futuros)
```

## 🎯 Responsabilidades de Cada Camada

### 📦 **Models** (Modelos)

**Responsabilidade**: Representar a estrutura de dados da aplicação.

**O que contém:**
- Classes de dados (POJOs/DTOs)
- Serialização/Deserialização (toJson/fromJson)
- Validações de dados básicas
- Lógica de negócio relacionada aos dados

**Arquivos:**
- `ideia_model.dart` - Representa uma ideia/atividade com título, texto, data e mapa mental
- `mind_map_node_data.dart` - Representa um nó do mapa mental (texto, cor, forma, ícone)
- `user_model.dart` - Representa um usuário (nome, email, idade, senha)

**Exemplo:**
```dart
class Ideia {
  final String id;
  final String titulo;
  final String texto;
  final DateTime? dataAtividade;
  final String? mindMapJson;
  
  Ideia({required this.id, required this.titulo, ...});
  
  Map<String, dynamic> toJson() => {...};
  factory Ideia.fromJson(Map<String, dynamic> json) => {...};
}
```

---

### 🎨 **Views** (Visualizações)

**Responsabilidade**: Apresentar a interface ao usuário e capturar interações.

**O que contém:**
- Widgets do Flutter (Stateless/Stateful)
- Layout e estrutura da UI
- Navegação entre telas
- Bindings com Controllers (Provider/Consumer)

**NÃO deve conter:**
- Lógica de negócio
- Acesso direto ao banco de dados
- Chamadas HTTP diretas

**Organização:**
- **Telas principais** na raiz de `views/`
- **Widgets reutilizáveis** em `views/widgets/`

**Exemplo:**
```dart
class HomeScreen extends StatefulWidget {
  // UI apenas, delega lógica para Controllers
  
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Renderiza baseado no estado do controller
      },
    );
  }
}
```

---

### 🎮 **Controllers** (Controladores)

**Responsabilidade**: Gerenciar o estado e a lógica de apresentação.

**O que contém:**
- ChangeNotifiers (Provider pattern)
- Gerenciamento de estado
- Lógica de apresentação
- Comunicação entre View e Model
- Orquestração de serviços

**Arquivos:**
- `auth_provider.dart` - Gerencia autenticação, login, logout, sessão
- `theme_provider.dart` - Gerencia tema claro/escuro

**Exemplo:**
```dart
class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  AuthStatus _status = AuthStatus.unknown;
  
  Future<void> login(String email, String password) async {
    // Lógica de login
    _currentUser = await _authRepository.login(email, password);
    _status = AuthStatus.authenticated;
    notifyListeners(); // Notifica Views
  }
}
```

---

### 🔧 **Services** (Serviços)

**Responsabilidade**: Implementar lógica de negócio e comunicação externa.

**O que contém:**
- Repositórios
- Chamadas de API
- Lógica de negócio complexa
- Validações avançadas

**Arquivos:**
- `auth_repository.dart` - Serviço de autenticação (comunicação com DB)

**Exemplo:**
```dart
class AuthRepository {
  final DatabaseHelper _db;
  
  Future<User> login(String email, String password) async {
    // Lógica de validação e busca no banco
    final user = await _db.getUserByEmail(email);
    if (user == null || !_verifyPassword(password, user)) {
      throw AuthException('Credenciais inválidas');
    }
    return user;
  }
}
```

---

### 💾 **Database** (Banco de Dados)

**Responsabilidade**: Gerenciar a persistência de dados.

**O que contém:**
- Conexão com SQLite
- Queries SQL
- Migrations
- CRUD operations

**Arquivos:**
- `database_helper.dart` - Helper do SQLite (singleton)

---

### 🛠️ **Utils** (Utilitários)

**Responsabilidade**: Funções auxiliares reutilizáveis.

**O que pode conter:**
- Validadores (email, senha, etc)
- Formatadores (data, moeda, etc)
- Constantes
- Helpers diversos

---

## 🔄 Fluxo de Dados (Data Flow)

```
┌──────────┐
│   View   │ ◄─── Exibe dados e captura eventos do usuário
└────┬─────┘
     │ Evento (tap, input, etc)
     ▼
┌──────────────┐
│  Controller  │ ◄─── Processa evento, atualiza estado
└────┬─────────┘
     │ Chama serviço
     ▼
┌──────────────┐
│   Service    │ ◄─── Executa lógica de negócio
└────┬─────────┘
     │ Acessa dados
     ▼
┌──────────────┐
│   Database   │ ◄─── Persiste/Busca dados
└────┬─────────┘
     │ Retorna Model
     ▼
┌──────────────┐
│    Model     │ ◄─── Estrutura de dados
└────┬─────────┘
     │ notifyListeners()
     ▼
┌──────────────┐
│     View     │ ◄─── Atualiza UI (rebuild)
└──────────────┘
```

## 🎯 Exemplo Prático: Login de Usuário

### 1️⃣ **View** captura o evento
```dart
// views/login_screen.dart
ElevatedButton(
  onPressed: () {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.login(email, password); // Delega para Controller
  },
  child: Text('Entrar'),
)
```

### 2️⃣ **Controller** processa
```dart
// controllers/auth_provider.dart
Future<void> login(String email, String password) async {
  _status = AuthStatus.loading;
  notifyListeners(); // Atualiza View (loading)
  
  _currentUser = await _authRepository.login(email, password); // Chama Service
  _status = AuthStatus.authenticated;
  notifyListeners(); // Atualiza View (sucesso)
}
```

### 3️⃣ **Service** executa lógica
```dart
// services/auth_repository.dart
Future<User> login(String email, String password) async {
  final user = await _db.getUserByEmail(email); // Acessa Database
  
  if (!_verifyPassword(password, user.passwordHash)) {
    throw AuthException('Senha incorreta');
  }
  
  return user; // Retorna Model
}
```

### 4️⃣ **Database** busca dados
```dart
// database/database_helper.dart
Future<User?> getUserByEmail(String email) async {
  final db = await database;
  final maps = await db.query('users', where: 'email = ?', whereArgs: [email]);
  
  if (maps.isEmpty) return null;
  return User.fromJson(maps.first); // Retorna Model
}
```

### 5️⃣ **View** reage ao estado
```dart
// views/login_screen.dart
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.status == AuthStatus.loading) {
      return CircularProgressIndicator();
    }
    if (authProvider.status == AuthStatus.authenticated) {
      return HomeScreen(); // Navega
    }
    return LoginForm(); // Permanece
  },
)
```

## ✅ Vantagens da Arquitetura MVC

### 1. **Separação de Responsabilidades**
- Cada camada tem uma função bem definida
- Facilita manutenção e evolução do código

### 2. **Testabilidade**
- Controllers podem ser testados independentemente
- Services podem ser mockados
- Models são simples de testar

### 3. **Reutilização**
- Widgets podem ser reutilizados
- Controllers podem gerenciar múltiplas Views
- Services são compartilhados

### 4. **Escalabilidade**
- Fácil adicionar novas features
- Estrutura clara para novos desenvolvedores
- Manutenção simplificada

### 5. **Manutenibilidade**
- Bugs são mais fáceis de localizar
- Mudanças impactam apenas uma camada
- Código mais limpo e organizado

## 🚀 Próximos Passos

### Melhorias Sugeridas:

1. **Criar Controllers adicionais:**
   - `ideia_controller.dart` - Gerenciar atividades
   - `mind_map_controller.dart` - Gerenciar mapas mentais

2. **Adicionar Utils:**
   - `validators.dart` - Validações (email, senha)
   - `constants.dart` - Constantes da aplicação
   - `formatters.dart` - Formatadores de data, texto

3. **Organizar Services:**
   - `ideia_service.dart` - Lógica de negócio de ideias
   - `mind_map_service.dart` - Lógica de mapas

4. **Implementar Testes:**
   - Unit tests para Models
   - Widget tests para Views
   - Integration tests para fluxos completos

## 📚 Referências

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Provider Package](https://pub.dev/packages/provider)
- [MVC Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)
