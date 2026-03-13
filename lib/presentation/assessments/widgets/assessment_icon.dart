import 'package:flutter/material.dart';

class AssessmentIcon extends StatelessWidget {
  final String icon;

  const AssessmentIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      icon,
      width: 80,
      height: 80,
      fit: BoxFit.contain,
    );
  }
}
