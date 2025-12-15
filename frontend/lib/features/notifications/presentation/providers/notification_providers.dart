import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/notifications_repository_impl.dart';
import '../../domain/models/notification_model.dart';
import '../../domain/repositories/notifications_repository.dart';

/// Repository provider
final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepositoryImpl();
});

/// Stream provider for realtime notifications
final notificationsStreamProvider = StreamProvider<List<AppNotification>>((ref) {
  final repo = ref.watch(notificationsRepositoryProvider);
  return repo.watchNotifications();
});

/// Derived provider for unread count
final unreadCountProvider = Provider<int>((ref) {
  final notificationsAsync = ref.watch(notificationsStreamProvider);
  return notificationsAsync.maybeWhen(
    data: (notifications) => notifications.where((n) => !n.isRead).length,
    orElse: () => 0,
  );
});

/// State notifier for marking notifications as read
class MarkReadNotifier extends StateNotifier<AsyncValue<void>> {
  final NotificationsRepository _repo;

  MarkReadNotifier(this._repo) : super(const AsyncData(null));

  Future<void> markAsRead(String id) async {
    state = const AsyncLoading();
    try {
      await _repo.markAsRead(id);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> markAllAsRead() async {
    state = const AsyncLoading();
    try {
      await _repo.markAllAsRead();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final markReadNotifierProvider = StateNotifierProvider<MarkReadNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(notificationsRepositoryProvider);
  return MarkReadNotifier(repo);
});

/// Provider for showing realtime toast notifications
final latestNotificationProvider = Provider<AppNotification?>((ref) {
  final notificationsAsync = ref.watch(notificationsStreamProvider);
  return notificationsAsync.maybeWhen(
    data: (list) => list.isNotEmpty ? list.first : null,
    orElse: () => null,
  );
});
