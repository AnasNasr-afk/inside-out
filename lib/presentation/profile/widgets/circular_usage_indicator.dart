import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CircularUsageIndicator extends StatelessWidget {
  final double percentage;

  const CircularUsageIndicator({super.key,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(
              value: percentage,
              strokeWidth: 5,
              backgroundColor:
              Colors.white.withValues(alpha: 0.35),
              valueColor:
              const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
              strokeCap: StrokeCap.round,
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                      '${(percentage * 100).toInt()}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    TextSpan(
                      text: '%',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                'Used',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
