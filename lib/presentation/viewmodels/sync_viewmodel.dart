import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection.dart';

class SyncState {
  final bool isSyncing;
  final String? error;
  final DateTime? lastSyncAt;

  const SyncState({this.isSyncing = false, this.error, this.lastSyncAt});

  SyncState copyWith({bool? isSyncing, String? error, DateTime? lastSyncAt}) {
    return SyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      error: error,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }
}

class SyncViewModel extends StateNotifier<SyncState> {
  final Ref _ref;

  SyncViewModel(this._ref) : super(const SyncState());

  Future<bool> syncToCloud() async {
    state = state.copyWith(isSyncing: true, error: null);
    try {
      final syncService = _ref.read(syncServiceProvider);

      if (!syncService.isAuthenticated) {
        state = state.copyWith(
          isSyncing: false,
          error: 'Utilizador não autenticado',
        );
        return false;
      }

      await syncService.syncAllToCloud();
      state = state.copyWith(isSyncing: false, lastSyncAt: DateTime.now());
      return true;
    } catch (e) {
      state = state.copyWith(isSyncing: false, error: e.toString());
      return false;
    }
  }

  Future<bool> syncHistoryOnly() async {
    state = state.copyWith(isSyncing: true, error: null);
    try {
      final syncService = _ref.read(syncServiceProvider);

      if (!syncService.isAuthenticated) {
        state = state.copyWith(
          isSyncing: false,
          error: 'Utilizador não autenticado',
        );
        return false;
      }

      await syncService.syncHistoryToCloud();
      state = state.copyWith(isSyncing: false, lastSyncAt: DateTime.now());
      return true;
    } catch (e) {
      state = state.copyWith(isSyncing: false, error: e.toString());
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final syncViewModelProvider = StateNotifierProvider<SyncViewModel, SyncState>((
  ref,
) {
  return SyncViewModel(ref);
});
