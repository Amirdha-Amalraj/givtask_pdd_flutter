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

  final statusesToTest = [
    'published', 'draft', 'archived', 'completed',
    'open', 'closed', 'active', 'inactive', 'in_progress',
    'Pending', 'Open', 'Active'
  ];

  for (var status in statusesToTest) {
    try {
      await client.from('tasks').insert({
        'title': 'Test Task',
        'status': status,
        'ngo_id': '00000000-0000-0000-0000-000000000000' // dummy UUID
      });
      print('SUCCESS with status: $status');
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('invalid input value for enum task_status')) {
        // Expected if status is wrong
      } else {
        // Might be a different error (like foreign key constraint on ngo_id), 
        // which means the enum was actually ACCEPTED!
        print('ENUM ACCEPTED for status: $status (Error: $msg)');
      }
    }
  }
}
