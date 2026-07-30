import 'package:supabase/supabase.dart';
import 'dart:io';

void main() async {
  final envFile = File('.env');
  final lines = await envFile.readAsLines();
  String url = '';
  String key = '';
  for (var line in lines) {
    if (line.startsWith('SUPABASE_URL=')) url = line.split('=')[1];
    if (line.startsWith('SUPABASE_ANON_KEY=')) key = line.split('=')[1];
  }

  final client = SupabaseClient(url, key);

  try {
    final response = await client
        .from('tasks')
        .select('*, profiles(ngo_profiles(org_name))')
        .limit(1);
    print(response);
  } catch (e) {
    print('Error: $e');
  }
}
