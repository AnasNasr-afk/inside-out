import 'package:patient/core/networking/api_client.dart';

class SessionRepository {
  final _client = ApiClient.instance;

  Future<void> saveAvatarReport({
    required int childId,
    required String avatarReport,
  }) async {
    await _client.post('Assessment/save-avatar-report', body: {
      'childId': childId,
      'avatarReport': avatarReport,
    });
  }
}
