import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/focus/presentation/screens/focus_room_screen.dart';
import '../../features/home/presentation/screens/home_shell.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/landing/presentation/screens/landing_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/squads/presentation/screens/squads_screen.dart';
import '../../features/squads/presentation/screens/create_squad_screen.dart';
import '../../features/squads/presentation/screens/join_squad_screen.dart';
import '../../features/squads/presentation/screens/squad_detail_screen.dart';
import '../../features/streaks/presentation/screens/leaderboard_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';

/// Route paths - centralized for consistency
class AppRoutes {
  static const String landing = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String focus = '/home/focus';
  static const String squads = '/home/squads';
  static const String createSquad = '/home/squads/create';
  static const String joinSquad = '/home/squads/join';
  static String squadDetail(String id) => '/home/squads/$id';
  static const String profile = '/home/profile';
  static const String leaderboard = '/home/leaderboard';
  static const String notifications = '/home/notifications';
}

/// App router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.landing,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLanding = state.matchedLocation == AppRoutes.landing;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;
      final isSigningUp = state.matchedLocation == AppRoutes.signup;
      final isSplash = state.matchedLocation == AppRoutes.splash;

      final isAuthenticated = authState.status == AuthStatus.authenticated;

      // If authenticated and on public pages (landing, login, signup, splash), redirect to home
      if (isAuthenticated && (isLanding || isLoggingIn || isSigningUp || isSplash)) {
        return AppRoutes.home;
      }

      // If not authenticated, allow landing, login, signup pages
      if (!isAuthenticated) {
        if (isLanding || isLoggingIn || isSigningUp || isSplash) {
          return null;
        }
        // Redirect protected pages to landing
        return AppRoutes.landing;
      }

      return null;
    },
    routes: [
      // Landing Screen (Marketing page)
      GoRoute(
        path: AppRoutes.landing,
        name: 'landing',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LandingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Login Screen
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),),
              child: child,
            );
          },
        ),
      ),

      // Sign Up Screen
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignUpScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),),
              child: child,
            );
          },
        ),
      ),

      // Home Shell with nested navigation
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.focus,
            name: 'focus',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FocusRoomScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.squads,
            name: 'squads',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SquadsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // Squad sub-routes (outside shell for full-screen experience)
      GoRoute(
        path: '/home/squads/create',
        name: 'createSquad',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CreateSquadScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/home/squads/join',
        name: 'joinSquad',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const JoinSquadScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/home/squads/:squadId',
        name: 'squadDetail',
        pageBuilder: (context, state) {
          final squadId = state.pathParameters['squadId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: SquadDetailScreen(squadId: squadId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.leaderboard,
        name: 'leaderboard',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LeaderboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const NotificationsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          },
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.error.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
