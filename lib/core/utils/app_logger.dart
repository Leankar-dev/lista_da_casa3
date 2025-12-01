import 'package:flutter/foundation.dart';

/// Serviço de logging centralizado com controle de ambiente.
///
/// Este logger garante que informações sensíveis nunca sejam
/// expostas em builds de produção.
class AppLogger {
  // Impede instanciação
  AppLogger._();

  /// Indica se os logs estão habilitados (apenas em debug mode)
  static bool get isEnabled => kDebugMode;

  /// Log de informação geral
  static void info(String message, {String? tag}) {
    if (!isEnabled) return;
    final prefix = tag != null ? '[$tag]' : '[INFO]';
    debugPrint('ℹ️ $prefix $message');
  }

  /// Log de debug/desenvolvimento
  static void debug(String message, {String? tag}) {
    if (!isEnabled) return;
    final prefix = tag != null ? '[$tag]' : '[DEBUG]';
    debugPrint('🔍 $prefix $message');
  }

  /// Log de aviso
  static void warning(String message, {String? tag}) {
    if (!isEnabled) return;
    final prefix = tag != null ? '[$tag]' : '[WARNING]';
    debugPrint('⚠️ $prefix $message');
  }

  /// Log de erro
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!isEnabled) return;
    final prefix = tag != null ? '[$tag]' : '[ERROR]';
    debugPrint('❌ $prefix $message');
    if (error != null) {
      debugPrint('   Error: $error');
    }
    if (stackTrace != null) {
      debugPrint('   StackTrace: $stackTrace');
    }
  }

  /// Log de sucesso
  static void success(String message, {String? tag}) {
    if (!isEnabled) return;
    final prefix = tag != null ? '[$tag]' : '[SUCCESS]';
    debugPrint('✅ $prefix $message');
  }

  /// Log para operações de banco de dados
  static void database(String message) {
    if (!isEnabled) return;
    debugPrint('🗄️ [Database] $message');
  }

  /// Log para operações de rede/API
  static void network(String message) {
    if (!isEnabled) return;
    debugPrint('🌐 [Network] $message');
  }

  /// Log para operações de autenticação
  /// IMPORTANTE: Nunca logar tokens, senhas ou dados sensíveis
  static void auth(String message) {
    if (!isEnabled) return;
    debugPrint('🔐 [Auth] $message');
  }

  /// Log para operações de sincronização
  static void sync(String message) {
    if (!isEnabled) return;
    debugPrint('🔄 [Sync] $message');
  }

  /// Log para repositórios
  static void repository(String repoName, String message) {
    if (!isEnabled) return;
    debugPrint('📦 [$repoName] $message');
  }

  /// Log para listas de compras
  static void shoppingList(String message) {
    if (!isEnabled) return;
    debugPrint('📋 [ShoppingList] $message');
  }

  /// Log para itens de compras
  static void shoppingItem(String message) {
    if (!isEnabled) return;
    debugPrint('🛒 [ShoppingItem] $message');
  }

  /// Sanitiza dados sensíveis para log seguro
  /// Use para mascarar emails, IDs parciais, etc.
  static String sanitize(String value, {int visibleChars = 4}) {
    if (value.length <= visibleChars * 2) {
      return '*' * value.length;
    }
    final start = value.substring(0, visibleChars);
    final end = value.substring(value.length - visibleChars);
    final middle = '*' * (value.length - visibleChars * 2);
    return '$start$middle$end';
  }

  /// Sanitiza email para log seguro
  /// Exemplo: "usuario@email.com" -> "usu***@***.com"
  static String sanitizeEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return sanitize(email);

    final user = parts[0];
    final domain = parts[1];

    final sanitizedUser = user.length > 3
        ? '${user.substring(0, 3)}***'
        : '***';

    final domainParts = domain.split('.');
    final sanitizedDomain = domainParts.length > 1
        ? '***${domainParts.last}'
        : '***';

    return '$sanitizedUser@$sanitizedDomain';
  }
}
