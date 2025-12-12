import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration loaded from environment variables.
/// RULE: No magic strings - all configs from .env
class AppConfig {
  // Supabase Configuration
  static String get supabaseUrl =>
      dotenv.env['SUPABASE_URL'] ?? ''; // Must be set in .env file

  static String get supabaseAnonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Backend API Configuration
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api/v1';

  // App Constants
  static const String appName = 'Antigravity';
  static const String appVersion = '1.0.0';

  // Feature Flags
  static const bool enableEduVerification = true;
  static const int maxSquadSize = 4;
}
