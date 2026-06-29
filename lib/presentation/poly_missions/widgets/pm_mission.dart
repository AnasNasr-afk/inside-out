import 'package:flutter/material.dart';
import 'package:patient/core/models/task_model.dart';

class PolyMission {
  final String key;
  final String label;
  final Color color;
  final Color deepColor;
  final IconData icon;
  final String question;

  const PolyMission({
    required this.key,
    required this.label,
    required this.color,
    required this.deepColor,
    required this.icon,
    required this.question,
  });

  // 3-slot rotating colour + icon palette for batch cards.
  static const _palette = [
    (Color(0xFF1ED8C4), Color(0xFF0E8F82), Icons.task_alt_rounded),
    (Color(0xFFFFC93C), Color(0xFFA9750E), Icons.auto_awesome_rounded),
    (Color(0xFF8A6BFF), Color(0xFF5A3DD6), Icons.psychology_rounded),
  ];

  factory PolyMission.fromTask(TaskModel task, int slot) {
    final p = _palette[slot % 3];
    return PolyMission(
      key: task.taskId.toString(),
      label: task.title,
      color: p.$1,
      deepColor: p.$2,
      icon: p.$3,
      question: task.description.trim().isNotEmpty
          ? task.description
          : task.title,
    );
  }
}
