import '../api_client.dart';

class NotificationRepository {
  final _client = ApiClient.instance;

  /// Registers this device's FCM token with the backend so the server can
  /// route push notifications to the parent. The backend's accepted role value
  /// for this app is 'Parent' (it rejects 'P'). [platform] is required by the
  /// backend (e.g. 'Android', 'iOS').
  Future<void> registerDeviceToken({
    required int userId,
    required String token,
    required String platform,
    String role = 'Parent',
  }) async {
    await _client.post(
      'Notification/device-token',
      body: {
        'userId': userId,
        'role': role,
        'token': token,
        'platform': platform,
      },
    );
  }
}
