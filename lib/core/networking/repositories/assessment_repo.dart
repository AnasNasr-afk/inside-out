import '../api_client.dart';

class AssessmentRepository {
  final _client = ApiClient.instance;

  Future<void> saveTaskResult({
    required int specialistTaskId,
    required int totalMoves,
    required int timeTaken,
    required int roundsCount,
    required String motherNote,
  }) async {
    await _client.post('Assessment/save-task-result', body: {
      'specialistTaskId': specialistTaskId,
      'totalMoves': totalMoves,
      'timeTaken': timeTaken,
      'roundsCount': roundsCount,
      'motherNote': motherNote,
    });
  }
}
