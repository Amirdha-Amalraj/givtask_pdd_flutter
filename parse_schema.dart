import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('openapi.json');
  if (!file.existsSync()) {
    print('openapi.json not found');
    return;
  }
  
  final jsonStr = file.readAsStringSync();
  final data = jsonDecode(jsonStr);
  final definitions = data['definitions'] as Map<String, dynamic>;
  
  final targetTables = ['profiles', 'tasks', 'applications', 'notifications', 'saved_tasks', 'certificates'];
  
  for (var table in targetTables) {
    if (definitions.containsKey(table)) {
      print('--- Table: $table ---');
      final properties = definitions[table]['properties'] as Map<String, dynamic>;
      properties.forEach((key, value) {
        print('  $key: ${value['type']} (${value['format'] ?? ''})');
      });
      print('');
    } else {
      print('--- Table: $table (MISSING) ---');
    }
  }
}
