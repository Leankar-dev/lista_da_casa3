import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Serviço para armazenamento seguro de dados sensíveis.
///
/// Utiliza flutter_secure_storage para criptografar dados no dispositivo:
/// - Android: Usa EncryptedSharedPreferences (API 23+) com AES-256
/// - iOS: Usa Keychain Services com proteção first_unlock_this_device
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Chaves para armazenamento
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const String _apiTokenKey = 'api_token';
  static const String _refreshTokenKey = 'refresh_token';

  /// Salva o ID do usuário de forma segura
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Obtém o ID do usuário armazenado
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Salva o email do usuário de forma segura
  static Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }

  /// Obtém o email do usuário armazenado
  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  /// Salva o token de API de forma segura
  static Future<void> saveApiToken(String token) async {
    await _storage.write(key: _apiTokenKey, value: token);
  }

  /// Obtém o token de API armazenado
  static Future<String?> getApiToken() async {
    return await _storage.read(key: _apiTokenKey);
  }

  /// Salva o refresh token de forma segura
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Obtém o refresh token armazenado
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Salva o timestamp da última sincronização
  static Future<void> saveLastSyncTimestamp(DateTime timestamp) async {
    await _storage.write(key: _lastSyncKey, value: timestamp.toIso8601String());
  }

  /// Obtém o timestamp da última sincronização
  static Future<DateTime?> getLastSyncTimestamp() async {
    final value = await _storage.read(key: _lastSyncKey);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  /// Salva um valor genérico de forma segura
  static Future<void> write({
    required String key,
    required String value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  /// Lê um valor genérico
  static Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  /// Remove um valor específico
  static Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Remove todos os dados sensíveis do usuário (logout)
  static Future<void> clearUserData() async {
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _userEmailKey);
    await _storage.delete(key: _apiTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  /// Remove todos os dados armazenados
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Verifica se existe um token de autenticação armazenado
  static Future<bool> hasAuthToken() async {
    final token = await getApiToken();
    return token != null && token.isNotEmpty;
  }

  /// Verifica se existe um usuário logado (por ID)
  static Future<bool> hasLoggedUser() async {
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }
}
