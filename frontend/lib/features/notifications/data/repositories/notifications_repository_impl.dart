import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/models/notification_model.dart';
import '../../domain/repositories/notifications_repository.dart';

/// Implementation of NotificationsRepository using Supabase Realtime + REST API
class NotificationsRepositoryImpl implements NotificationsRepository {
  final SupabaseClient _supabase;
  final http.Client _httpClient;
  final String _baseUrl = AppConfig.apiBaseUrl;

  NotificationsRepositoryImpl({
    SupabaseClient? supabase,
    http.Client? httpClient,
  })  : _supabase = supabase ?? Supabase.instance.client,
        _httpClient = httpClient ?? http.Client();

  Future<Map<String, String>> get _headers async {
    final session = _supabase.auth.currentSession;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session?.accessToken ?? ''}',
    };
  }

  @override
  Stream<List<AppNotification>> watchNotifications() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return Stream.value([]);

    return _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((e) => AppNotification.fromJson(e)).toList());
  }

  @override
  Future<List<AppNotification>> getNotifications() async {
    final headers = await _headers;
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/notifications'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final list = data['notifications'] as List<dynamic>? ?? [];
      return list.map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to fetch notifications: ${response.statusCode}');
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final headers = await _headers;
    final response = await _httpClient.patch(
      Uri.parse('$_baseUrl/notifications/$notificationId/read'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read: ${response.statusCode}');
    }
  }

  @override
  Future<void> markAllAsRead() async {
    final headers = await _headers;
    final response = await _httpClient.patch(
      Uri.parse('$_baseUrl/notifications/read-all'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark all as read: ${response.statusCode}');
    }
  }
}
