import 'package:flutter/material.dart';
import 'package:patient/core/theme/app_tokens.dart';

class TaskHeader extends StatelessWidget {
  const TaskHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Text('Tasks', style: T.screenTitle()),
    );
  }
}
