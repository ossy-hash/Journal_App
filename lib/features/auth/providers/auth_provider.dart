import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Auth state
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });
  
  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final SupabaseClient _supabase;
  
  AuthNotifier(this._supabase) : super(const AuthState()) {
    _initializeAuth();
  }
  
  void _initializeAuth() {
    final currentUser = _supabase.auth.currentUser;
    state = state.copyWith(user: currentUser);
    
    _supabase.auth.onAuthStateChange.listen((data) {
      state = state.copyWith(user: data.session?.user);
    });
  }
  
  // Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  // Register
  Future<void> register(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  // Forgot password
  Future<void> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  // Logout
  Future<void> logout() async {
    await _supabase.auth.signOut();
    state = const AuthState();
  }
}

// Providers
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(Supabase.instance.client);
});
final currentUserProvider = Provider((ref) {
  return ref.watch(authProvider).user;
});