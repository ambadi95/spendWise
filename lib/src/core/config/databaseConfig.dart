

import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseConfig {
  static const String supabaseUrl = "https://oeyopvahcjzemfowxdfs.supabase.co";
  static const String supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9leW9wdmFoY2p6ZW1mb3d4ZGZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY0NjYxODUsImV4cCI6MjA3MjA0MjE4NX0.FG5xFxTdxbuvLNCfkmjhQX72u_Ifd5oICWzWUxFIaZo";

  static Future<void> init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}