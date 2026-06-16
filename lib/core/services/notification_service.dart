import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';
import '../models/app_notification.dart';
import 'notification_store.dart';

/// FCM background handler. Must be a top-level function annotated with
/// `@pragma('vm:entry-point')` because it runs in a separate isolate. It
/// initialises Firebase and persists the incoming message so the in-app list
/// can show it the next time the app is in the foreground.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationStore.instance.add(
    AppNotification.fromRemoteMessage(message),
  );
}

/// Wraps Firebase Cloud Messaging: permissions, token handling, and the
/// foreground/opened message handlers. Foreground pushes are mirrored to a
/// local notification (heads-up) and stored in [NotificationStore].
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Notifications',
    description: 'Task assignments and updates from your specialist.',
    importance: Importance.high,
  );

  bool _initialised = false;

  /// One-time setup: permissions, local-notification plugin, channel, and FCM
  /// message listeners. Safe to call more than once.
  Future<void> init() async {
    if (_initialised) return;
    _initialised = true;

    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Show heads-up banners while the app is in the foreground (iOS).
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _initLocalNotifications();

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _local.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = AppNotification.fromRemoteMessage(message);
    await NotificationStore.instance.add(notification);
    if (notification.title.isNotEmpty || notification.body.isNotEmpty) {
      await _showLocal(notification.title, notification.body);
    }
  }

  void _onMessageOpened(RemoteMessage message) {
    // Stored on receipt; opening just surfaces the list. Mark read on open.
    NotificationStore.instance.add(AppNotification.fromRemoteMessage(message));
  }

  /// Displays a heads-up local notification (used for foreground pushes and
  /// the local "task sent" confirmation). Never throws.
  Future<void> _showLocal(String title, String body) async {
    try {
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      );
      await _local.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
      );
    } catch (e) {
      debugPrint('⚠️ Failed to show local notification: $e');
    }
  }

  /// Returns the current FCM registration token (null if unavailable).
  Future<String?> getToken() async {
    try {
      return await _fcm.getToken();
    } catch (e) {
      debugPrint('⚠️ Failed to get FCM token: $e');
      return null;
    }
  }

  /// Notifies the caller whenever the token rotates so it can re-register.
  Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;

  /// Records a locally-generated notification and shows it as a heads-up
  /// banner — e.g. confirming the parent's completed task was sent.
  Future<void> pushLocalConfirmation({
    required String title,
    required String body,
    AppNotificationType type = AppNotificationType.general,
  }) async {
    await NotificationStore.instance.add(
      AppNotification.local(title: title, body: body, type: type),
    );
    await _showLocal(title, body);
  }
}
