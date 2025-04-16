import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatabaseConfig {
  // Supabase Configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseKey => dotenv.env['SUPABASE_KEY'] ?? '';
  
  // Table name
  static const String tableName = 'nutrition_data';
}