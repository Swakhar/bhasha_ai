import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService(this._client);

  final SupabaseClient _client;

  Session? get session => _client.auth.currentSession;
  User? get user => _client.auth.currentUser;

  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;

  Future<void> sendEmailOtp({
    required String email,
    String? emailRedirectTo,
  }) async {
    await _client.auth.signInWithOtp(
      email: email,
      emailRedirectTo: emailRedirectTo,
    );
  }

  Future<void> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    await _client.auth.verifyOTP(
      type: OtpType.email,
      email: email,
      token: token,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}

