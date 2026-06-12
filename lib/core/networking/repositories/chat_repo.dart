import '../api_client.dart';
import '../../helpers/shared_pref.dart';
import '../../helpers/shared_pref_keys.dart';

class ChatRepository {
  final _client = ApiClient.instance;

  Future<({String channelUrl, String sendbirdUserId})> createChat(
      int specialistId) async {
    final parentId = SharedPrefHelper.getInt(SharedPrefKeys.frontendId);
    final response = await _client.post(
      'Chat/create-chat?parentId=$parentId&specialistId=$specialistId',
    );
    return (
      channelUrl: response['channelUrl'] as String,
      sendbirdUserId: 'parent_$parentId',
    );
  }
}
