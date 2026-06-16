import 'package:flutter/material.dart';
import 'package:patient/presentation/games/color_match_game.dart';
import 'package:patient/presentation/games/memory_game.dart';
import 'package:patient/presentation/games/emotion_game.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a game!',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24.h),
            _ChildGameCard(
              title: 'Color Match',
              icon: Icons.palette_rounded,
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ColorMatchGame()),
              ),
            ),
            SizedBox(height: 16.h),
            _ChildGameCard(
              title: 'Memory Cards',
              icon: Icons.grid_view_rounded,
              color: Colors.purple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MemoryGame()),
              ),
            ),
            SizedBox(height: 16.h),
            _ChildGameCard(
              title: 'Emotion Match',
              icon: Icons.sentiment_very_satisfied_rounded,
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmotionGame()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChildGameCard extends StatelessWidget {
  const _ChildGameCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5.w,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 72.w,
              height: 72.h,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, size: 40.sp, color: Colors.white),
            ),
            SizedBox(width: 20.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
