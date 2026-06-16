import 'package:flutter/material.dart';
import '../../gen/assets.gen.dart';
import 'article_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdatesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> latestVideos = [
    {
      'title': 'How to run reports',
      'views': '2.1k views · 5 days ago',
      'thumbnail': Assets.placeholders.thumbnail1,
    },
    {
      'title': 'How to run reports',
      'views': '2.1k views · 5 days ago',
      'thumbnail': Assets.placeholders.thumbnail1,
    }
  ];

  final List<Map<String, dynamic>> latestArticles = [
    {
      'title': 'New feature: Google Meet now has a custom background tool',
      'date': 'Jan 14, 2022',
      'thumbnail': Assets.placeholders.thumbnail1,
    },
    {
      'title': 'New feature: Google Meet now has a custom background tool',
      'date': 'Jan 14, 2022',
      'thumbnail': Assets.placeholders.thumbnail1,
    },
    {
      'title': 'New feature: Google Meet now has a custom background tool',
      'date': 'Jan 14, 2022',
      'thumbnail': Assets.placeholders.thumbnail1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Updates",
                style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'League Spartan'),
              ),
              SizedBox(height: 24.h),
              Text(
                "Latest Videos",
                style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'League Spartan'),
              ),
              SizedBox(height: 14.h),
              SizedBox(
                height: 190.h, // Adjust height based on design
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: latestVideos.length,
                  itemBuilder: (context, index) {
                    final video = latestVideos[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Assets.placeholders.thumbnail1.image(
                              width: 200.w,
                              height: 130.h,
                            ),  
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            video['title']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            video['views']!,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 40.h),
              Text(
                "Latest Articles",
                style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'League Spartan'),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: ListView.builder(
                  itemCount: latestArticles.length,
                  itemBuilder: (context, index) {
                    final article = latestArticles[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ArticleScreen(articleTitle: article['title']!),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15.h),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Assets.placeholders.thumbnail1.image(
                              width: 200.w,
                              height: 130.h,
                            ),  
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article['title']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    article['date']!,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
