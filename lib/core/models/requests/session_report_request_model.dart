class SessionReportRequestModel {
  final int childId;
  final int taskId;
  final String taskTitle;
  final String report;

  SessionReportRequestModel({
    required this.childId,
    required this.taskId,
    required this.taskTitle,
    required this.report,
  });

  Map<String, dynamic> toJson() => {
    'childId': childId,
    'taskId': taskId,
    'taskTitle': taskTitle,
    'report': report,
  };
}
