import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (!SupabaseService.isInitialized) {
    throw Exception('Supabase is not initialized');
  }
  return AuthRepository(SupabaseService.client.auth);
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  if (!SupabaseService.isInitialized) {
    return const Stream.empty();
  }
  return SupabaseService.client.auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  if (!SupabaseService.isInitialized) return null;
  return ref.watch(authStateProvider).value?.session?.user;
});

class AuthRepository {
  final GoTrueClient _auth;

  AuthRepository(this._auth);

  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  User? get currentUser => _auth.currentUser;

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String role,
    required String name,
  }) async {
    return await _auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: 'http://localhost:8080/',
      data: {
        'role': role,
        'full_name': name,
      },
    );
  }

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.resetPasswordForEmail(
      email,
      redirectTo: 'http://localhost:8080/',
    );
  }
  
  Future<UserResponse> updatePassword(String newPassword) async {
    return await _auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }
}
