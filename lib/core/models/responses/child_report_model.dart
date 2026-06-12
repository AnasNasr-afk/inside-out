class ChildReportEntry {
  final int id;
  final String content;
  final DateTime assignedDate;
  final String studentName;

  const ChildReportEntry({
    required this.id,
    required this.content,
    required this.assignedDate,
    required this.studentName,
  });

  factory ChildReportEntry.fromJson(Map<String, dynamic> json) {
    return ChildReportEntry(
      id: (json['id'] as num?)?.toInt() ?? 0,
      content: json['content']?.toString() ?? '',
      assignedDate: DateTime.tryParse(json['assignedDate']?.toString() ?? '') ?? DateTime.now(),
      studentName: (json['specialistName'] ?? json['studentName'])?.toString() ?? '',
    );
  }

  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[assignedDate.month - 1]} ${assignedDate.day}';
  }

  static List<ChildReportEntry> fallback() => [
        ChildReportEntry(
          id: 1,
          content:
              'Lilly completed the breathing exercise task independently. '
              'She took 3 seconds to complete the task, making 10 moves over 30 rounds. '
              'Her mother noted that Lilly faces some difficulties with pacing her breath, '
              'but was able to complete each round with encouragement. '
              'There are no previous performance records to compare this session against.',
          assignedDate: DateTime.now(),
          studentName: 'Dr. Sarah',
        ),
      ];
}
