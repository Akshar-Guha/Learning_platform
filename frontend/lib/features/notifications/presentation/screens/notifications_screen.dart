import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/notification_providers.dart';
import '../widgets/notification_widgets.dart';

/// Notifications Screen - List all user notifications
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsStreamProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              ref.read(markReadNotifierProvider.notifier).markAllAsRead();
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0F1A), AppTheme.darkBg],
            stops: [0.0, 0.3],
          ),
        ),
        child: notificationsAsync.when(
          data: (notifications) {
            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.notification_bing,
                      size: 64,
                      color: AppTheme.textSecondaryDark.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondaryDark.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You\'ll see nudges and alerts here',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondaryDark.withOpacity(0.5),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: AppTheme.darkBorder.withOpacity(0.5),
              ),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationTile(
                  notification: notification,
                  onTap: () {
                    if (!notification.isRead) {
                      ref.read(markReadNotifierProvider.notifier).markAsRead(notification.id);
                    }
                    // TODO: Navigate based on notification type/metadata
                  },
                  onDismiss: () {
                    // Mark as read on dismiss for now
                    ref.read(markReadNotifierProvider.notifier).markAsRead(notification.id);
                  },
                ).animate().fadeIn(delay: (50 * index).ms, duration: 300.ms);
              },
            );
          },
          loading: () => Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: theme.colorScheme.primary,
              size: 40,
            ),
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
                const SizedBox(height: 16),
                Text('Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(notificationsStreamProvider),
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
