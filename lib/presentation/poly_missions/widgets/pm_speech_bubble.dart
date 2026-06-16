import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:patient/core/theme/app_tokens.dart';

class PmSpeechBubble extends StatelessWidget {
  final String text;

  const PmSpeechBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Bubble body
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x5914120C),
                    blurRadius: 28,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: T.cardTitle().copyWith(
                  color: const Color(0xFF2B2360),
                  height: 1.32,
                ),
              ),
            ),

            // Downward tail
            Positioned(
              bottom: -7,
              child: Transform.rotate(
                angle: math.pi / 4,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
