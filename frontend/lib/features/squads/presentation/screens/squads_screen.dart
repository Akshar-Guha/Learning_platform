import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/squad_providers.dart';
import '../widgets/squad_card.dart';

/// Squads List Screen - Shows user's squads with create/join buttons
class SquadsScreen extends ConsumerWidget {
  const SquadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final squadsAsync = ref.watch(userSquadsProvider);

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
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Text(
                      'Squads',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimaryDark,
                      ),
                    ),
                    const Spacer(),
                    // Join button
                    _HeaderButton(
                      icon: Iconsax.login,
                      onTap: () => context.push('/home/squads/join'),
                      tooltip: 'Join Squad',
                    ),
                    const SizedBox(width: 8),
                    // Create button
                    _HeaderButton(
                      icon: Iconsax.add,
                      onTap: () => context.push('/home/squads/create'),
                      tooltip: 'Create Squad',
                      isPrimary: true,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              // Squad list
              Expanded(
                child: squadsAsync.when(
                  data: (squads) => squads.isEmpty
                      ? _buildEmptyState(context)
                      : _buildSquadsList(context, squads),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppTheme.primaryPurple),
                  ),
                  error: (e, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
                        const SizedBox(height: 16),
                        Text('Error: $e', style: const TextStyle(color: AppTheme.textSecondaryDark)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.invalidate(userSquadsProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withOpacity(0.3),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: const Icon(Iconsax.people, size: 48, color: Colors.white),
            ).animate().scale(curve: Curves.elasticOut),
            const SizedBox(height: 24),
            const Text(
              'No Squads Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryDark,
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 8),
            Text(
              'Create a squad or join one with an\ninvite code to start your journey',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryDark.withOpacity(0.8),
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(
                  label: 'Join Squad',
                  icon: Iconsax.login,
                  onTap: () => context.push('/home/squads/join'),
                  isOutlined: true,
                ),
                const SizedBox(width: 12),
                _ActionButton(
                  label: 'Create Squad',
                  icon: Iconsax.add,
                  onTap: () => context.push('/home/squads/create'),
                ),
              ],
            ).animate().fadeIn(delay: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildSquadsList(BuildContext context, List squads) {
    return RefreshIndicator(
      onRefresh: () async {
        // Trigger refresh
      },
      color: AppTheme.primaryPurple,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: squads.length,
        itemBuilder: (context, index) {
          final squad = squads[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SquadCard(
              squad: squad,
              onTap: () => context.push('/home/squads/${squad.id}'),
            ),
          );
        },
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool isPrimary;

  const _HeaderButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: isPrimary ? AppTheme.primaryGradient : null,
            color: isPrimary ? null : AppTheme.darkCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isPrimary ? Colors.transparent : AppTheme.darkBorder,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isPrimary ? Colors.white : AppTheme.textSecondaryDark,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isOutlined;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isOutlined ? null : AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(12),
          border: isOutlined
              ? Border.all(color: AppTheme.primaryPurple.withOpacity(0.5))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isOutlined ? AppTheme.primaryPurple : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isOutlined ? AppTheme.primaryPurple : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
