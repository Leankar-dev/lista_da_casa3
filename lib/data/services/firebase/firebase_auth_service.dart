import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// Firebase Authentication Service
class FirebaseAuthService {
  FirebaseAuth? _auth;
  bool _isInitialized = false;

  /// Initialize Firebase Auth (call after Firebase.initializeApp)
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

  /// Check if Firebase is available
  bool get isFirebaseAvailable {
    _ensureInitialized();
    return _isInitialized && _auth != null;
  }

  /// Get current user
  User? get currentUser {
    _ensureInitialized();
    return _auth?.currentUser;
  }

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges {
    _ensureInitialized();
    if (_auth == null) {
      return Stream.value(null);
    }
    return _auth!.authStateChanges();
  }

  /// Sign in with email and password
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _ensureInitialized();
    if (_auth == null) return null;
    try {
      return await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Register with email and password
  Future<UserCredential?> registerWithEmail({
    required String email,
    required String password,
  }) async {
    _ensureInitialized();
    if (_auth == null) return null;
    try {
      return await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _ensureInitialized();
    await _auth?.signOut();
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    _ensureInitialized();
    if (_auth == null) return;
    try {
      await _auth!.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Utilizador não encontrado';
      case 'wrong-password':
        return 'Palavra-passe incorreta';
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
      default:
        return 'Erro de autenticação: ${e.message}';
    }
  }
}
