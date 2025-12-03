import 'package:intl/intl.dart';

/// Formatadores para exibição de dados
class Formatters {
  /// Formata data para padrão brasileiro (dd/MM/yyyy)
  static String formatDate(DateTime? date) {
    if (date == null) return 'Sem data';
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  /// Formata data e hora para padrão brasileiro (dd/MM/yyyy HH:mm)
  static String formatDateTime(DateTime? date) {
    if (date == null) return 'Sem data';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
  
  /// Formata data para formato resumido (dd/MM)
  static String formatDateShort(DateTime? date) {
    if (date == null) return '--/--';
    return DateFormat('dd/MM').format(date);
  }
  
  /// Formata hora (HH:mm)
  static String formatTime(DateTime? date) {
    if (date == null) return '--:--';
    return DateFormat('HH:mm').format(date);
  }
  
  /// Retorna data relativa (Hoje, Ontem, etc)
  static String formatRelativeDate(DateTime? date) {
    if (date == null) return 'Sem data';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateDay = DateTime(date.year, date.month, date.day);
    
    if (dateDay == today) {
      return 'Hoje';
    } else if (dateDay == yesterday) {
      return 'Ontem';
    } else if (dateDay.isAfter(today)) {
      final diff = dateDay.difference(today).inDays;
      if (diff == 1) return 'Amanhã';
      if (diff < 7) return 'Em $diff dias';
    }
    
    return formatDate(date);
  }
  
  /// Formata nome (primeira letra maiúscula)
  static String formatName(String? name) {
    if (name == null || name.trim().isEmpty) return '';
    
    return name.trim().split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
  
  /// Trunca texto com reticências
  static String truncateText(String? text, int maxLength) {
    if (text == null || text.isEmpty) return '';
    if (text.length <= maxLength) return text;
    
    return '${text.substring(0, maxLength)}...';
  }
  
  /// Remove espaços extras
  static String cleanText(String? text) {
    if (text == null) return '';
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
  
  /// Formata número de telefone (XX) XXXXX-XXXX
  static String formatPhone(String? phone) {
    if (phone == null || phone.isEmpty) return '';
    
    final numbers = phone.replaceAll(RegExp(r'\D'), '');
    
    if (numbers.length == 11) {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7)}';
    } else if (numbers.length == 10) {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 6)}-${numbers.substring(6)}';
    }
    
    return phone;
  }
  
  /// Formata CPF XXX.XXX.XXX-XX
  static String formatCPF(String? cpf) {
    if (cpf == null || cpf.isEmpty) return '';
    
    final numbers = cpf.replaceAll(RegExp(r'\D'), '');
    
    if (numbers.length == 11) {
      return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9)}';
    }
    
    return cpf;
  }
  
  /// Formata moeda (R$ 1.234,56)
  static String formatCurrency(double? value) {
    if (value == null) return 'R\$ 0,00';
    
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    
    return formatter.format(value);
  }
  
  /// Formata número com separador de milhares
  static String formatNumber(num? value) {
    if (value == null) return '0';
    
    final formatter = NumberFormat('#,##0', 'pt_BR');
    return formatter.format(value);
  }
  
  /// Formata percentual (12,34%)
  static String formatPercentage(double? value, {int decimals = 2}) {
    if (value == null) return '0%';
    
    return '${value.toStringAsFixed(decimals)}%';
  }
  
  /// Obtém iniciais do nome (máximo 2 letras)
  static String getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    
    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    
    return (words[0][0] + words[words.length - 1][0]).toUpperCase();
  }
}
