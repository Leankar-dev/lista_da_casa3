import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/di/injection.dart';

/// Auth State
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isFirebaseAvailable;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isFirebaseAvailable = false,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isFirebaseAvailable,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isFirebaseAvailable: isFirebaseAvailable ?? this.isFirebaseAvailable,
    );
  }
}

/// Auth ViewModel
class AuthViewModel extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthViewModel(this._ref) : super(const AuthState()) {
    _init();
  }

  void _init() {
    final authService = _ref.read(firebaseAuthServiceProvider);
    final isAvailable = authService.isFirebaseAvailable;
    state = state.copyWith(isFirebaseAvailable: isAvailable);

    if (isAvailable) {
      authService.authStateChanges.listen((user) {
        state = state.copyWith(user: user);
      });
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (!state.isFirebaseAvailable) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authService = _ref.read(firebaseAuthServiceProvider);
      await authService.signInWithEmail(email: email, password: password);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) async {
    if (!state.isFirebaseAvailable) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authService = _ref.read(firebaseAuthServiceProvider);
      await authService.registerWithEmail(email: email, password: password);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    if (!state.isFirebaseAvailable) return;
    try {
      final authService = _ref.read(firebaseAuthServiceProvider);
      await authService.signOut();
      state = state.copyWith(user: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (!state.isFirebaseAvailable) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authService = _ref.read(firebaseAuthServiceProvider);
      await authService.sendPasswordResetEmail(email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Auth Provider
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  return AuthViewModel(ref);
});
