import '../models/notification_model.dart';

/// Repository interface for notifications
abstract class NotificationsRepository {
  /// Stream of user's notifications (realtime)
  Stream<List<AppNotification>> watchNotifications();
  
  /// Fetch notifications from API
  Future<List<AppNotification>> getNotifications();
  
  /// Mark a notification as read
  Future<void> markAsRead(String notificationId);
  
  /// Mark all notifications as read
  Future<void> markAllAsRead();
}
