import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  try {
    await dotenv.load(fileName: ".env");
    debugPrint('✅ .env loaded successfully');
    debugPrint('SUPABASE_URL: ${AppConfig.supabaseUrl}');
    debugPrint('SUPABASE_ANON_KEY: ${AppConfig.supabaseAnonKey.isNotEmpty ? "SET (${AppConfig.supabaseAnonKey.length} chars)" : "EMPTY!"}');
  } catch (e) {
    debugPrint('⚠️ .env load failed: $e - using defaults');
  }

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    debugPrint('✅ Supabase initialized');
  } catch (e) {
    debugPrint('❌ Supabase init failed: $e');
  }

  runApp(
    const ProviderScope(
      child: ULPApp(),
    ),
  );
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
