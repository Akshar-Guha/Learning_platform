import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file (if available)
  try {
    await dotenv.load(fileName: ".env");
    debugPrint('✅ .env loaded successfully');
  } catch (e) {
    debugPrint('⚠️ .env load failed (expected in prod if using build args): $e');
  }

  // Debug Config
  debugPrint('--- APP CONFIG ---');
  debugPrint('SUPABASE_URL: ${AppConfig.supabaseUrl.isNotEmpty ? "SET" : "MISSING"}');
  debugPrint('SUPABASE_ANON_KEY: ${AppConfig.supabaseAnonKey.isNotEmpty ? "SET" : "MISSING"}');
  debugPrint('API_BASE_URL: ${AppConfig.apiBaseUrl}');
  debugPrint('------------------');

  // Initialize Supabase
  bool initSuccess = false;
  try {
    if (AppConfig.supabaseUrl.isEmpty || AppConfig.supabaseAnonKey.isEmpty) {
      throw Exception('Missing Supabase Credentials. URL: ${AppConfig.supabaseUrl}, Key: ${AppConfig.supabaseAnonKey.isNotEmpty ? "SET" : "EMPTY"}');
    }

    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    initSuccess = true;
    debugPrint('✅ Supabase initialized');
  } catch (e) {
    debugPrint('❌ Supabase init failed: $e');
  }

  if (initSuccess) {
    runApp(
      const ProviderScope(
        child: ULPApp(),
      ),
    );
  } else {
    runApp(const AppInitErrorScreen());
  }
}

/// Simple Error Screen when Init Fails
class AppInitErrorScreen extends StatelessWidget {
  const AppInitErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF0F0F1A),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 64),
                const SizedBox(height: 24),
                const Text(
                  'Initialization Failed',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Could not connect to Supabase. Please check your configuration.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  'Missing Env Vars?',
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ULPApp extends ConsumerWidget {
  const ULPApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'ULP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark mode for premium feel
      routerConfig: router,
    );
  }
}
