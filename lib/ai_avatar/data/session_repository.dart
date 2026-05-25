import 'package:patient/core/networking/api_client.dart';
import 'package:patient/core/models/requests/session_report_request_model.dart';

class SessionRepository {
  final _client = ApiClient.instance;

  Future<void> submitReport(SessionReportRequestModel model) async {
    await _client.post('Session/report', body: model.toJson());
  }
}
