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
    final completedAt = json['completedAt'] != null
        ? DateTime.tryParse(json['completedAt'].toString())
        : null;
    final dueDate = DateTime.tryParse(json['dueDate']?.toString() ?? '') ??
        DateTime.now();
    final isCompleted = _deriveIsCompleted(json, completedAt);

    return TaskModel(
      taskId: json['taskId'] ?? json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      assignedDate: DateTime.tryParse(json['assignedDate']?.toString() ?? '') ??
          DateTime.now(),
      dueDate: dueDate,
      completedAt: completedAt,
      plannedDays: (json['plannedDays'] as num?)?.toDouble() ?? 0,
      actualDays: (json['actualDays'] as num?)?.toDouble() ?? 0,
      isCompleted: isCompleted,
      punctualityStatus: _derivePunctuality(
        isCompleted: isCompleted,
        completedAt: completedAt,
        dueDate: dueDate,
      ),
    );
  }

  static String _derivePunctuality({
    required bool isCompleted,
    required DateTime? completedAt,
    required DateTime dueDate,
  }) {
    if (!isCompleted) return 'Pending';
    if (completedAt == null) return 'On Time';

    final completedDay =
        DateTime(completedAt.year, completedAt.month, completedAt.day);
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (completedDay.isAfter(dueDay)) return 'Late';
    if (completedDay.isBefore(dueDay)) return 'Early';
    return 'On Time';
  }

  static bool _deriveIsCompleted(Map<String, dynamic> json, DateTime? completedAt) {
    final status = json['status'] ?? json['taskStatus'] ?? json['TaskStatus'];
    if (status is String) {
      return status.toLowerCase() == 'completed';
    }
    if (status is num) return status.toInt() == 1;

    if (json['isCompleted'] == true) return true;

    return completedAt != null;
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

  /// "${plannedDays.round()} days" for the detail screen, or "—" if invalid
  String get plannedDaysLabel {
    final n = plannedDays.round();
    if (n <= 0) return '—';
    return '$n ${n == 1 ? 'day' : 'days'}';
  }

  /// Status pill color logic
  bool get isLate => punctualityStatus == 'Late';
  bool get isOnTime => punctualityStatus == 'On Time';
  bool get isEarly => punctualityStatus == 'Early';
}