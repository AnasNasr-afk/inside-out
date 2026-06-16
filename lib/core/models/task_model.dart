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
  // null = regular task; 'memory_cards' | 'color_match' | 'emotion_match' = game task
  final String? gameType;

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
    this.gameType,
  });

  bool get isGameTask => gameType != null && gameType!.isNotEmpty;

  String get gameDisplayName => switch (gameType) {
        'memory_cards' => 'Memory Cards',
        'color_match' => 'Color Match',
        'emotion_match' => 'Emotion Match',
        _ => '',
      };

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
      gameType: (json['gameType'] as String?) ?? _inferGameType(json['title'] as String? ?? ''),
    );
  }

  // TODO: remove once backend sends gameType in task response
  static String? _inferGameType(String title) {
    final t = title.toLowerCase();
    if (t.contains('memory')) return 'memory_cards';
    if (t.contains('color')) return 'color_match';
    if (t.contains('emotion')) return 'emotion_match';
    return null;
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

  bool get isOverdue => !isCompleted && DateTime.now().isAfter(dueDate);

  bool get isHidden {
    if (!isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due  = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return !due.isAfter(today);
  }

  String get timeLabel {
    if (isCompleted) {
      return completedAt != null
          ? 'Completed ${_fmt(completedAt!)}'
          : 'Completed';
    }
    if (isOverdue) return 'Overdue since ${_fmt(dueDate)}';
    return 'Due ${_fmt(dueDate)}';
  }

  static String _fmt(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }
}