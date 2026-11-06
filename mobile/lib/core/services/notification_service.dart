import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Top-level background handler — must be a top-level function.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase is already initialized by the time this runs (Flutter calls
  // ensureInitialized internally for background isolates).
  debugPrint('[FCM] Background message: ${message.messageId}');
}

/// Singleton notification service that wraps FCM + local notifications.
class AppNotificationService {
  AppNotificationService._internal();
  static final AppNotificationService _instance =
      AppNotificationService._internal();
  factory AppNotificationService() => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // ── Notification channels ────────────────────────────────────────
  static const _channelId = 'peso_plan_alerts';
  static const _channelName = 'Peso Plan Alerts';
  static const _channelDesc = 'Budget, bill, and household reminders';

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Callback invoked when the user taps a notification while the app is open.
  void Function(String? route)? onNotificationTap;

  // ── Init ─────────────────────────────────────────────────────────

  Future<void> initialize() async {
    if (_isInitialized || Firebase.apps.isEmpty) return;

    // 1. Local notifications plugin
    final androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // We ask explicitly via requestPermission()
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    // 2. Android high-importance channel
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _channelId,
              _channelName,
              description: _channelDesc,
              importance: Importance.max,
              playSound: true,
              enableVibration: true,
            ),
          );
    }

    // 3. FCM handlers
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // 4. Handle notification that launched the app from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _routeFromMessage(initialMessage);
    }

    // 5. iOS foreground presentation options
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _isInitialized = true;
  }

  // ── Permission ───────────────────────────────────────────────────

  Future<bool> requestPermission() async {
    if (Firebase.apps.isEmpty) return false;

    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  // ── Token ────────────────────────────────────────────────────────

  Future<String?> getDeviceToken() async {
    if (Firebase.apps.isEmpty) return null;
    return _messaging.getToken();
  }

  /// Listens for token refreshes and calls [onRefresh] with the new token.
  void onTokenRefresh(void Function(String token) onRefresh) {
    _messaging.onTokenRefresh.listen(onRefresh);
  }

  // ── Private handlers ─────────────────────────────────────────────

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    debugPrint('[FCM] Foreground: ${message.notification?.title}');
    final title = message.notification?.title ?? 'Peso Plan';
    final body = message.notification?.body ?? 'You have a new update.';
    await _showLocalNotification(
      title: title,
      body: body,
      payload: message.data['route'] as String?,
    );
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('[FCM] Opened from background: ${message.notification?.title}');
    _routeFromMessage(message);
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    final route = response.payload;
    if (route != null && onNotificationTap != null) {
      onNotificationTap!(route);
    }
  }

  void _routeFromMessage(RemoteMessage message) {
    final route = message.data['route'] as String?;
    if (route != null && onNotificationTap != null) {
      onNotificationTap!(route);
    }
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }
}
