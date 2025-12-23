import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/providers/auth_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../squads/presentation/providers/squad_providers.dart';
import '../../domain/models/focus_session.dart';
import '../../domain/services/focus_visibility_service.dart';
import '../../domain/services/wake_lock_service.dart';
import '../providers/focus_providers.dart';
import '../widgets/breathing_animation.dart';
import '../widgets/focus_widgets.dart';

/// Focus Room Screen - Main presence dashboard
class FocusRoomScreen extends ConsumerStatefulWidget {
  const FocusRoomScreen({super.key});

  @override
  ConsumerState<FocusRoomScreen> createState() => _FocusRoomScreenState();
}

class _FocusRoomScreenState extends ConsumerState<FocusRoomScreen>
    with WidgetsBindingObserver {
  String? _selectedSquadId;
  final WakeLockService _wakeLock = WakeLockService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Mark focus page as active for visibility tracking
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(focusVisibilityServiceProvider).enterFocusPage();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ref.read(focusVisibilityServiceProvider).leaveFocusPage();
    _wakeLock.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app going to background/foreground
    if (state == AppLifecycleState.paused) {
      // App went to background - could pause focus here
    } else if (state == AppLifecycleState.resumed) {
      // App came to foreground
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentSession = ref.watch(currentFocusSessionProvider);
    final squadsAsync = ref.watch(userSquadsProvider);
    final currentUserId = ref.watch(currentUserProvider)?.id ?? '';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0F1A), AppTheme.darkBg],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header - simplified since HomeShell provides app bar
              Padding(
                padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Text(
                        'Focus Room',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimaryDark,
                        ),
                      ),
                      const Spacer(),
                      _buildStatusIndicator(currentSession),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current session card or squad selector
                      currentSession.when(
                        data: (session) => session != null && session.isActive
                            ? _buildActiveSessionCard(session)
                            : _buildSquadSelector(squadsAsync),
                        loading: () => _buildLoadingCard(),
                        error: (e, _) => _buildErrorCard(e.toString()),
                      ),
                      const SizedBox(height: 24),

                      // Squad presence section
                      if (_selectedSquadId != null || 
                          currentSession.valueOrNull?.squadId != null)
                        _buildPresenceSection(
                          currentSession.valueOrNull?.squadId ?? _selectedSquadId!,
                          currentUserId,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(AsyncValue<FocusSession?> sessionAsync) {
    final session = sessionAsync.valueOrNull;
    final isFocusing = session?.isActive ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isFocusing 
            ? AppTheme.success.withOpacity(0.2) 
            : AppTheme.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFocusing 
              ? AppTheme.success.withOpacity(0.5) 
              : AppTheme.darkBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFocusing ? AppTheme.success : AppTheme.textSecondaryDark,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isFocusing ? 'Focusing' : 'Idle',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isFocusing ? AppTheme.success : AppTheme.textSecondaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSessionCard(FocusSession session) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.success.withOpacity(0.1),
            AppTheme.success.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.success.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Pulsing focus icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.success.withOpacity(0.2),
              border: Border.all(color: AppTheme.success, width: 3),
            ),
            child: const Icon(
              Iconsax.activity,
              size: 36,
              color: AppTheme.success,
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1000.ms),
          
          const SizedBox(height: 20),

          // Timer
          FocusTimer(
            startedAt: session.startedAt,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppTheme.success,
              letterSpacing: 2,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Stay focused! Your squad sees you.',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryDark.withOpacity(0.8),
            ),
          ),
          
          const SizedBox(height: 24),

          // Stop button
          FocusButton(
            isFocusing: true,
            isLoading: false,
            onPressed: () => _stopFocus(),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildSquadSelector(AsyncValue<List<dynamic>> squadsAsync) {
    return squadsAsync.when(
      data: (squads) {
        if (squads.isEmpty) {
          return _buildNoSquadsCard();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a squad to focus with',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryDark,
              ),
            ),
            const SizedBox(height: 16),
            
            // Squad cards
            ...squads.map((squad) => _buildSquadCard(squad)),
            
            const SizedBox(height: 20),

            // Start button (only if a squad is selected)
            if (_selectedSquadId != null)
              FocusButton(
                isFocusing: false,
                isLoading: ref.watch(currentFocusSessionProvider).isLoading,
                onPressed: () => _startFocus(_selectedSquadId!),
              ).animate().fadeIn().slideY(begin: 0.2, end: 0),
          ],
        );
      },
      loading: () => _buildLoadingCard(),
      error: (e, _) => _buildErrorCard(e.toString()),
    );
  }

  Widget _buildSquadCard(dynamic squad) {
    final isSelected = _selectedSquadId == squad.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedSquadId = squad.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryPurple.withOpacity(0.15) 
              : AppTheme.darkCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected 
                ? AppTheme.primaryPurple 
                : AppTheme.darkBorder.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  squad.name.isNotEmpty ? squad.name[0].toUpperCase() : 'S',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                squad.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryDark,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Iconsax.tick_circle5,
                color: AppTheme.primaryPurple,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSquadsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.darkBorder.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(
            Iconsax.people,
            size: 48,
            color: AppTheme.textSecondaryDark.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Join a squad first',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondaryDark.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You need to be in a squad to start focusing',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondaryDark.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.push(AppRoutes.squads),
            icon: const Icon(Iconsax.add, size: 18),
            label: const Text('Join or Create Squad'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresenceSection(String squadId, String currentUserId) {
    final activeSessionsAsync = ref.watch(squadActiveSessionsProvider(squadId));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Squad Activity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryDark,
          ),
        ),
        const SizedBox(height: 12),
        
        activeSessionsAsync.when(
          data: (sessions) {
            // Convert to presence items
            final presenceItems = sessions.map((s) => PresenceItem(
              userId: s.userId,
              displayName: 'Member', // Would need to join with profiles
              isFocusing: s.isActive,
              durationMinutes: DateTime.now().difference(s.startedAt).inMinutes,
            ),).toList();
            
            if (presenceItems.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'No one is focusing right now',
                  style: TextStyle(
                    color: AppTheme.textSecondaryDark.withOpacity(0.7),
                  ),
                ),
              );
            }
            
            return SquadPresenceList(
              members: presenceItems,
              currentUserId: currentUserId,
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryPurple),
          ),
          error: (e, _) => Text('Error: $e'),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildLoadingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryPurple),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.error.withOpacity(0.3)),
      ),
      child: Text('Error: $error', style: const TextStyle(color: AppTheme.error)),
    );
  }

  Future<void> _startFocus(String squadId) async {
    try {
      await ref.read(currentFocusSessionProvider.notifier).startFocus(squadId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Focus session started!'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  Future<void> _stopFocus() async {
    try {
      await ref.read(currentFocusSessionProvider.notifier).stopFocus();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Great job! Focus session ended.'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }
}
