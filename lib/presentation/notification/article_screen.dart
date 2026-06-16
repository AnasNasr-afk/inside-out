import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticleScreen extends StatelessWidget {
  final String articleTitle;

  const ArticleScreen({super.key, required this.articleTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Artical", // Changed to match the image
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'League Spartan',
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.all(10.0.r),
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 240, 237, 237),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new,
                  color: Colors.black, size: 20.sp),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Title
            Text(
              "Learn About Heartbeat.", // Use bold title
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'League Spartan',
              ),
            ),
            SizedBox(height: 10.h),

            // Article Content
            Text(
              "A heartbeat is a two-part pumping action that takes about a second. "
              "As blood collects in the upper chambers (the right and left atria), "
              "the heart’s natural pacemaker (the SA node) sends out an electrical signal "
              "that causes the atria to contract.",
              style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),
            SizedBox(height: 20.h),

            // Card-like Playable Section

            Container(
              padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 30.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE4E7F9), // Light grey background
                borderRadius: BorderRadius.circular(12.r), // Rounded corners
              ),
              child: Row(
                children: [
                  // Left side: Text + Play Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Learn About Heartbeat.",
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            // Play Icon
                            SizedBox(width: 2.w),
                            Icon(Icons.play_circle_outline,
                                color: Color.fromRGBO(122, 134, 248, 1),
                                size: 30.sp),

                            SizedBox(width: 6.w),

                            // "Check Now" Text
                            Text(
                              "Check Now",
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Color.fromRGBO(122, 134, 248, 1)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Right side: Illustration Image
                  Assets.illustrations.i9nHeartbeat.svg(
                    width: 90.w, // Adjusted size to match design
                    height: 90.h,
                    fit: BoxFit.contain,
                  )
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Additional Content
            Text(
              "Your pulse is measured by counting the number of times your heart beats in one minute. "
              "For example, if your heart contracts 72 times in one minute, your pulse would be 72 beats per minute (BPM). "
              "This is also called your heart rate. A normal pulse beats in a steady, regular rhythm.",
              style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),
            SizedBox(height: 10.h),

            Text(
              "This is also called your heart rate. A normal pulse beats in a steady, regular rhythm.",
              style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
