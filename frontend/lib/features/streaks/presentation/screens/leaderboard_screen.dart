import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../providers/streak_providers.dart';
import '../widgets/streak_widgets.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(streakLeaderboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consistency Leaderboard'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(streakLeaderboardProvider);
        },
        child: leaderboardAsync.when(
          data: (entries) {
            if (entries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No streaks yet!'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                         // Maybe navigate to check-in or home?
                      },
                      child: const Text('Start Your Streak'),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                // Assuming we can identify current user by ID from auth provider if needed
                // For now, isCurrentUser is false or we inject auth provider too (optional)
                return LeaderboardTile(
                  entry: entry,
                  // isCurrentUser: entry.userId == currentUser?.id, // Logic if needed
                );
              },
            );
          },
          loading: () => Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: theme.colorScheme.primary,
              size: 40,
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error loading leaderboard: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(streakLeaderboardProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
