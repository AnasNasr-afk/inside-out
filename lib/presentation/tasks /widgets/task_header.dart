import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskHeader extends StatelessWidget {
  const TaskHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tasks",
                style: theme.textTheme.displayMedium,
              ),

            ],
          ),
          // Container(
          //   width: 44.w,
          //   height: 44.h,
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     shape: BoxShape.circle,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withValues(alpha: 0.06),
          //         blurRadius: 12.r,
          //         offset: const Offset(0, 4),
          //       ),
          //     ],
          //   ),
          //   child: const Icon(Icons.tune_rounded,
          //       size: 20.sp, color: Color(0xFF1F2937)),
          // ),
        ],
      ),
    );
  }
}
