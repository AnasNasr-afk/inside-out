import '../../models/responses/child_report_model.dart';
import '../api_client.dart';

class AssessmentRepository {
  final _client = ApiClient.instance;

  Future<({List<ChildReportEntry> reports, bool isFallback})> getChildReports(int childId) async {
    try {
      final response = await _client.get('Assessment/child-reports/$childId');
      final list = response as List<dynamic>;
      final reports = list
          .map((e) => ChildReportEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      return (reports: reports, isFallback: false);
    } catch (_) {
      return (reports: ChildReportEntry.fallback(), isFallback: true);
    }
  }

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
