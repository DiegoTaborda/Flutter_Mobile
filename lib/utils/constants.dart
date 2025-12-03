/// Constantes da aplicação
class AppConstants {
  // Nome da aplicação
  static const String appName = 'Redstone Notes';
  
  // Versão
  static const String appVersion = '1.0.0';
  
  // Database
  static const String databaseName = 'redstone_notes.db';
  static const int databaseVersion = 1;
  
  // Tabelas
  static const String tableUsers = 'users';
  static const String tableIdeias = 'ideias';
  
  // SharedPreferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyUserSession = 'user_session';
  
  // Validações
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minAge = 1;
  static const int maxAge = 150;
  
  // UI
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const int maxTextLength = 1000;
  
  // Animações
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
  
  // Mensagens de erro
  static const String errorGeneric = 'Ocorreu um erro inesperado.';
  static const String errorNoInternet = 'Sem conexão com a internet.';
  static const String errorInvalidEmail = 'Email inválido.';
  static const String errorPasswordTooShort = 'Senha deve ter no mínimo $minPasswordLength caracteres.';
  static const String errorEmptyField = 'Este campo não pode estar vazio.';
  
  // Mensagens de sucesso
  static const String successLogin = 'Login realizado com sucesso!';
  static const String successRegister = 'Cadastro realizado com sucesso!';
  static const String successSave = 'Salvo com sucesso!';
  static const String successDelete = 'Excluído com sucesso!';
}
