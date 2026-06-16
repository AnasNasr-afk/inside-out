import 'package:firebase_messaging/firebase_messaging.dart';

/// Category of an incoming notification — drives the icon and colour shown in
/// the notification list. Derived from the FCM `data['type']` field.
enum AppNotificationType { taskAssigned, taskCompleted, note, general }

AppNotificationType _typeFromKey(String? key) {
  switch (key?.toLowerCase().replaceAll('_', '')) {
    case 'taskassigned':
    case 'assigned':
    case 'newtask':
      return AppNotificationType.taskAssigned;
    case 'taskcompleted':
    case 'completed':
      return AppNotificationType.taskCompleted;
    case 'note':
    case 'parentnote':
      return AppNotificationType.note;
    default:
      return AppNotificationType.general;
  }
}

String _typeKey(AppNotificationType type) => switch (type) {
      AppNotificationType.taskAssigned => 'task_assigned',
      AppNotificationType.taskCompleted => 'task_completed',
      AppNotificationType.note => 'note',
      AppNotificationType.general => 'general',
    };

/// A single notification shown in the in-app notification list. Built from an
/// FCM [RemoteMessage] (push) or created locally (e.g. completion confirmation),
/// and persisted to local storage so the list survives restarts.
class AppNotification {
  final String id;
  final String title;
  final String body;
  final AppNotificationType type;
  final DateTime receivedAt;
  final bool read;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.receivedAt,
    this.read = false,
  });

  factory AppNotification.fromRemoteMessage(RemoteMessage message) {
    final data = message.data;
    final notification = message.notification;
    return AppNotification(
      id: message.messageId ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: notification?.title ?? data['title']?.toString() ?? 'Notification',
      body: notification?.body ?? data['body']?.toString() ?? '',
      type: _typeFromKey(data['type']?.toString()),
      receivedAt: message.sentTime ?? DateTime.now(),
      read: false,
    );
  }

  factory AppNotification.local({
    required String title,
    required String body,
    AppNotificationType type = AppNotificationType.general,
  }) {
    return AppNotification(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      receivedAt: DateTime.now(),
      read: false,
    );
  }

  AppNotification copyWith({bool? read}) => AppNotification(
        id: id,
        title: title,
        body: body,
        type: type,
        receivedAt: receivedAt,
        read: read ?? this.read,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': _typeKey(type),
        'receivedAt': receivedAt.toIso8601String(),
        'read': read,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        body: json['body']?.toString() ?? '',
        type: _typeFromKey(json['type']?.toString()),
        receivedAt: DateTime.tryParse(json['receivedAt']?.toString() ?? '') ??
            DateTime.now(),
        read: json['read'] == true,
      );
}
