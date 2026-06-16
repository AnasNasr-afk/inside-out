import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../gen/assets.gen.dart'; // IMPORTANT
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icons = [
      Assets.icons.icHome,
      Assets.icons.icTasks,
      Assets.icons.icNotifications,
      Assets.icons.icProfile,
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: icons
            .asMap()
            .entries
            .map(
              (entry) => _buildItem(
            icon: entry.value,
            index: entry.key,
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildItem({
    required SvgGenImage icon,
    required int index,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: icon.svg(
        width: 24.w,
        height: 24.h,
        color: isSelected ? AppTheme.primaryColor : Colors.grey,
      ),
    );
  }
}