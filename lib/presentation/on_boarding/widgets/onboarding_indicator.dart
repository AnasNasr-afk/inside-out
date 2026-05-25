import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: 5),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? Colors.blueAccent
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}