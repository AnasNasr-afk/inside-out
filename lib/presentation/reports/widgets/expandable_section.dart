import 'package:flutter/material.dart';

class ExpandableSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ExpandableSection({
    required this.title,
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        tilePadding: EdgeInsets.zero, // Remove default padding
        childrenPadding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
        iconColor: Colors.grey,
        collapsedIconColor: Colors.grey,
        children: children,
      ),
    );
  }
}
