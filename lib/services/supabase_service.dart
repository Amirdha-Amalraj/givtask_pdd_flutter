import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (url == null || anonKey == null) {
      debugPrint('WARNING: Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env file');
      return;
    }

    if (url == 'YOUR_SUPABASE_URL_HERE') {
      debugPrint('WARNING: Supabase is not configured properly. Using placeholder keys.');
      return;
    }

    try {
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
      );
      _initialized = true;
    } catch (e) {
      debugPrint('Supabase initialization error: $e');
    }
  }

  static bool get isInitialized => _initialized;

  static SupabaseClient get client => Supabase.instance.client;
}
