import '../../models/responses/parent_child_response_model.dart';
import '../api_client.dart';

class HomeRepository {
  final _client = ApiClient.instance;

  Future<ParentChildResponseModel> getParentChildData(
      int childId,
      ) async {
    final response = await _client.get(
      'Child/track/$childId',
    );

    return ParentChildResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }
}