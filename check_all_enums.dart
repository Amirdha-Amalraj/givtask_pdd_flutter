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

  // We need the postgres connection to query pg_enum, but we don't have the connection string.
  // We can just use the rest API via rpc if there's a function, but there likely isn't.
  // Instead, let's just do exhaustive testing of the most common enum values.
  
  final client = SupabaseClient(url, key);

  final statusesToTest = [
    'Open', 'Closed', 'Active', 'Inactive', 'Published', 'Draft', 'Archived', 'Completed', 'Pending', 'In Progress',
    'open', 'closed', 'active', 'inactive', 'published', 'draft', 'archived', 'completed', 'pending', 'in_progress',
    'OPEN', 'CLOSED', 'ACTIVE', 'INACTIVE', 'PUBLISHED', 'DRAFT', 'ARCHIVED', 'COMPLETED', 'PENDING', 'IN_PROGRESS'
  ];

  for (var status in statusesToTest) {
    try {
      await client.from('tasks').insert({
        'title': 'Test Enum',
        'status': status,
        'ngo_id': '00000000-0000-0000-0000-000000000000'
      });
      print('Valid Enum: $status');
    } catch (e) {
      if (!e.toString().contains('invalid input value for enum task_status')) {
        print('Valid Enum (Failed RLS/Constraints): $status -> ${e.toString()}');
      }
    }
  }
}
