import '../../../model/task_model.dart';
import '../api_client.dart';

class TaskRepository {
  final _client = ApiClient.instance;

  Future<List<TaskModel>> getTasks(int childId) async {
    final response = await _client.get('Task/child/$childId/details'); // ✅ FIXED

    final list = response as List<dynamic>;

    return list
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}