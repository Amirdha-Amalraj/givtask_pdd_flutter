import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('openapi.json');
  final jsonString = await file.readAsString();
  final data = jsonDecode(jsonString);
  
  final definitions = data['definitions'];
  if (definitions != null) {
    if (definitions['tasks'] != null) {
      print('Tasks Table Properties:');
      print(definitions['tasks']['properties']);
    }
    
    // Attempt to find any enum definitions related to status
    definitions.forEach((key, value) {
      if (key.toString().toLowerCase().contains('status')) {
        print('Found definition for $key: $value');
      }
    });
  } else {
    print('No definitions found.');
  }
}
