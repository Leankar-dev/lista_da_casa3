import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../secure_storage_service.dart';

class FirebaseAuthService {
  FirebaseAuth? _auth;
  bool _isInitialized = false;

  void _ensureInitialized() {
    if (!_isInitialized) {
      try {
        if (Firebase.apps.isNotEmpty) {
          _auth = FirebaseAuth.instance;
          _isInitialized = true;
        }
      } catch (e) {
        _isInitialized = false;
      }
    }
  }

  bool get isFirebaseAvailable {
    _ensureInitialized();
    return _isInitialized && _auth != null;
  }

  User? get currentUser {
    _ensureInitialized();
    return _auth?.currentUser;
  }

  bool get isAuthenticated => currentUser != null;

  Stream<User?> get authStateChanges {
    _ensureInitialized();
    if (_auth == null) {
      return Stream.value(null);
    }
    return _auth!.authStateChanges();
  }

  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _ensureInitialized();
    if (_auth == null) return null;
    try {
      final credential = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await SecureStorageService.saveUserId(credential.user!.uid);
        if (credential.user!.email != null) {
          await SecureStorageService.saveUserEmail(credential.user!.email!);
        }
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> registerWithEmail({
    required String email,
    required String password,
  }) async {
    _ensureInitialized();
    if (_auth == null) return null;
    try {
      final credential = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await SecureStorageService.saveUserId(credential.user!.uid);
        if (credential.user!.email != null) {
          await SecureStorageService.saveUserEmail(credential.user!.email!);
        }
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    _ensureInitialized();
    await SecureStorageService.clearUserData();
    await _auth?.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _ensureInitialized();
    if (_auth == null) return;
    try {
      await _auth!.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Utilizador não encontrado';
      case 'wrong-password':
        return 'Palavra-passe incorreta';
      case 'invalid-credential':
        return 'Email ou palavra-passe incorretos';
      case 'email-already-in-use':
        return 'Este email já está em uso';
      case 'invalid-email':
        return 'Email inválido';
      case 'weak-password':
        return 'Palavra-passe fraca';
      case 'user-disabled':
        return 'Utilizador desativado';
      case 'too-many-requests':
        return 'Demasiadas tentativas. Tente mais tarde.';
      case 'network-request-failed':
        return 'Erro de ligação à internet';
      default:
        return 'Erro de autenticação: ${e.message}';
    }
  }
}
