import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LevelIndicator extends StatelessWidget {
  final double currentLevel; // Dynamic value from backend
  final int maxLevel; // Maximum level for slider

  const LevelIndicator({
    super.key,
    required this.currentLevel,
    required this.maxLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFCB6CE6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Autism Level',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 25.h),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Slider track
                      Container(
                        height: 40.h, // Increased height for better visibility
                        decoration: BoxDecoration(
                          color: const Color(0xFFCB6CE6),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      // Tick marks
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          maxLevel, // Number of divisions based on max level
                          (index) => Container(
                            height: index % 2 == 0
                                ? 20
                                : 15, // Alternating heights for ticks
                            width: 2.w,
                            color: Colors.white.withValues(alpha:0.7),
                          ),
                        ),
                      ),
                      // Current level indicator (triangle)
                      // Current level indicator (triangle with text above)
                      Positioned(
                        left: (currentLevel / (maxLevel)) *
                            (MediaQuery.of(context).size.width * 0.8 -
                                25), // Adjust for better alignment
                        child: Column(
                          children: [
                            Text(
                              currentLevel.toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            CustomPaint(
                              size: const Size(20, 20),
                              painter: TrianglePainter(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for triangle thumb indicator
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white;
    Path path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
