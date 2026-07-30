import 'package:supabase/supabase.dart';

void main() async {
  final supabaseUrl = 'https://cxwoqmmarfxylpfircti.supabase.co';
  final supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN4d29xbW1hcmZ4eWxwZmlyY3RpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUwNTg4NDcsImV4cCI6MjEwMDYzNDg0N30.Vt0VOYvA_4BBEVtPIZbc7oV6W_2dNqTpJyUp0xDQWrM';
  
  final client = SupabaseClient(supabaseUrl, supabaseKey);
  
  try {
    final response = await client.auth.signUp(
      email: 'test_verify_check_${DateTime.now().millisecondsSinceEpoch}@example.com',
      password: 'SecurePassword123!',
    );
    
    if (response.session == null && response.user != null) {
      print('EMAIL_CONFIRMATION_ENABLED: TRUE');
    } else if (response.session != null) {
      print('EMAIL_CONFIRMATION_ENABLED: FALSE');
    } else {
      print('UNKNOWN_STATE');
    }
  } catch (e) {
    print('ERROR: $e');
  }
}
