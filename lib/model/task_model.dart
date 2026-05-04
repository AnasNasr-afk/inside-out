class TaskModel {
  final int taskId;
  final String title;
  final DateTime assignedDate;
  final DateTime dueDate;
  final DateTime? completedAt;
  final String description;
  final double plannedDays;
  final double actualDays;
  final bool isCompleted;
  final String punctualityStatus;

  const TaskModel({
    required this.taskId,
    required this.title,
    required this.assignedDate,
    required this.dueDate,
    this.completedAt,
    required this.description,
    required this.plannedDays,
    required this.actualDays,
    required this.isCompleted,
    required this.punctualityStatus,
  });

  // factory TaskModel.fromJson(Map<String, dynamic> json) {
  //   final status = json['taskStatus'] ?? 'Pending';
  //
  //   return TaskModel(
  //     // ✅ map id correctly
  //     taskId: json['id'] ?? 0,
  //
  //     title: json['title'] ?? '',
  //     description: json['description'] ?? '',
  //
  //     assignedDate: DateTime.tryParse(json['assignedDate'] ?? '') ?? DateTime.now(),
  //     dueDate: DateTime.tryParse(json['dueDate'] ?? '') ?? DateTime.now(),
  //
  //     // ❌ not موجود في API → null
  //     completedAt: null,
  //
  //     // ❌ not موجود → default values
  //     plannedDays: 0,
  //     actualDays: 0,
  //
  //     // ✅ derive from taskStatus
  //     isCompleted: status.toString().toLowerCase() == 'completed',
  //
  //     // ❌ not موجود → infer simple logic
  //     punctualityStatus: 'On Time',
  //   );
  // }
  // ── Helpers used by the UI ──────────────────────────────

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['taskId'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      assignedDate: DateTime.tryParse(json['assignedDate'] ?? '') ?? DateTime.now(),
      dueDate: DateTime.tryParse(json['dueDate'] ?? '') ?? DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'])
          : null,
      plannedDays: (json['plannedDays'] as num?)?.toDouble() ?? 0,
      actualDays: (json['actualDays'] as num?)?.toDouble() ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      punctualityStatus: json['punctualityStatus'] ?? 'On Time',
    );
  }

  /// "Jun 3" format for the task card
  String get formattedDueDate {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[dueDate.month - 1]} ${dueDate.day}';
  }

  /// "Jun 3" format for assigned date
  String get formattedAssignedDate {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[assignedDate.month - 1]} ${assignedDate.day}';
  }

  /// "${plannedDays.round()} days" for the detail screen
  String get plannedDaysLabel => '${plannedDays.round()} days';

  /// Status pill color logic
  bool get isLate => punctualityStatus == 'Late';
  bool get isOnTime => punctualityStatus == 'On Time';
  bool get isEarly => punctualityStatus == 'Early';
}