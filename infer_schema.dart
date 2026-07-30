import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://cxwoqmmarfxylpfircti.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN4d29xbW1hcmZ4eWxwZmlyY3RpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUwNTg4NDcsImV4cCI6MjEwMDYzNDg0N30.Vt0VOYvA_4BBEVtPIZbc7oV6W_2dNqTpJyUp0xDQWrM',
  );
  
  final client = Supabase.instance.client;
  
  final tables = ['profiles', 'tasks', 'applications', 'notifications', 'ngo_profiles'];
  for (var table in tables) {
    print('Fetching $table...');
    try {
      final res = await client.from(table).select().limit(1);
      if (res.isNotEmpty) {
        print('  Schema for $table: ${res.first.keys.join(', ')}');
      } else {
        print('  $table is empty, cannot infer schema natively.');
      }
    } catch (e) {
      print('  Error reading $table: $e');
    }
  }
}
