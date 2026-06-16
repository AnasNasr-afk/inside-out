import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_item.dart';
import 'onboarding_indicator.dart';
import 'onboarding_content.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingCarousel extends StatefulWidget {
  const OnboardingCarousel({super.key});

  @override
  State<OnboardingCarousel> createState() => _OnboardingCarouselState();
}

class _OnboardingCarouselState extends State<OnboardingCarousel> {
  final PageController _controller = PageController();
  int currentPage = 0;
  late Timer timer;

  final contents = onboardingContents;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      currentPage = (currentPage + 1) % contents.length;
      _controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: contents.length,
          onPageChanged: (index) {
            setState(() => currentPage = index);
          },
          itemBuilder: (_, index) {
            return OnboardingItem(content: contents[index]);
          },
        ),

        Positioned(
          bottom: 140.h,
          left: 0.w,
          right: 0.w,
          child: OnboardingIndicator(
            count: contents.length,
            currentIndex: currentPage,
          ),
        ),
      ],
    );
  }
}