/// Validadores para formulários
class Validators {
  /// Valida email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email é obrigatório';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email inválido';
    }
    
    return null;
  }
  
  /// Valida senha
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    if (value.length < minLength) {
      return 'Senha deve ter no mínimo $minLength caracteres';
    }
    
    return null;
  }
  
  /// Valida confirmação de senha
  static String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    
    if (value != password) {
      return 'As senhas não coincidem';
    }
    
    return null;
  }
  
  /// Valida nome
  static String? validateName(String? value, {int minLength = 2}) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    
    if (value.trim().length < minLength) {
      return 'Nome deve ter no mínimo $minLength caracteres';
    }
    
    return null;
  }
  
  /// Valida idade
  static String? validateAge(String? value, {int min = 1, int max = 150}) {
    if (value == null || value.trim().isEmpty) {
      return 'Idade é obrigatória';
    }
    
    final age = int.tryParse(value.trim());
    
    if (age == null) {
      return 'Idade inválida';
    }
    
    if (age < min || age > max) {
      return 'Idade deve estar entre $min e $max';
    }
    
    return null;
  }
  
  /// Valida campo obrigatório genérico
  static String? validateRequired(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    
    return null;
  }
  
  /// Valida comprimento mínimo
  static String? validateMinLength(String? value, int minLength, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    
    if (value.trim().length < minLength) {
      return '$fieldName deve ter no mínimo $minLength caracteres';
    }
    
    return null;
  }
  
  /// Valida comprimento máximo
  static String? validateMaxLength(String? value, int maxLength, {String fieldName = 'Campo'}) {
    if (value != null && value.length > maxLength) {
      return '$fieldName deve ter no máximo $maxLength caracteres';
    }
    
    return null;
  }
  
  /// Valida número
  static String? validateNumber(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    
    if (double.tryParse(value.trim()) == null) {
      return '$fieldName deve ser um número válido';
    }
    
    return null;
  }
  
  /// Valida URL
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL é obrigatória';
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value.trim())) {
      return 'URL inválida';
    }
    
    return null;
  }
}
