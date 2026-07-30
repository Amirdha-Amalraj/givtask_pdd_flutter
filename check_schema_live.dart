import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  final envFile = File('.env');
  final lines = await envFile.readAsLines();
  String url = '';
  String key = '';
  for (var line in lines) {
    if (line.startsWith('SUPABASE_URL=')) url = line.split('=')[1];
    if (line.startsWith('SUPABASE_ANON_KEY=')) key = line.split('=')[1];
  }

  final apiUrl = '$url/rest/v1/?apikey=$key';
  final response = await http.get(Uri.parse(apiUrl), headers: {
    'Authorization': 'Bearer $key'
  });
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final definitions = data['definitions'];
    
    if (definitions != null && definitions['tasks'] != null) {
      print('Tasks Table Properties:');
      final props = definitions['tasks']['properties'];
      print(JsonEncoder.withIndent('  ').convert(props));
    } else {
      print('Tasks table not found in definitions.');
    }
  } else {
    print('Failed to fetch OpenAPI spec. Status: ${response.statusCode}');
  }
}
