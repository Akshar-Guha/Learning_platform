// Build timestamp: 2025-12-21 21:59:50
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration loaded from environment variables.
/// RULE: No magic strings - all configs from .env
class AppConfig {
  // Supabase Configuration
  static String get supabaseUrl {
    const fromEnv = String.fromEnvironment('SUPABASE_URL');
    if (fromEnv.isNotEmpty) return fromEnv;
    return dotenv.env['SUPABASE_URL'] ?? '';
  }

  static String get supabaseAnonKey {
    const fromEnv = String.fromEnvironment('SUPABASE_ANON_KEY');
    if (fromEnv.isNotEmpty) return fromEnv;
    return dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  }

  // Backend API Configuration
  static String get apiBaseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    if (fromEnv.isNotEmpty) return fromEnv;
    return dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api/v1';
  }

  // App Constants
  static const String appName = 'ULP';
  static const String appVersion = '1.0.0';

  // Feature Flags
  static const bool enableEduVerification = true;
  static const int maxSquadSize = 4;
}
