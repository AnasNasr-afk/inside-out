import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/helpers/check_in_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoodCheckInCard extends StatefulWidget {
  final String childName;

  const MoodCheckInCard({
    super.key,
    required this.childName,
  });

  @override
  State<MoodCheckInCard> createState() =>
      _MoodCheckInCardState();
}

class _MoodCheckInCardState
    extends State<MoodCheckInCard> {
  int? _selectedMoodIndex;

  bool _submitted = false;

  final List<_MoodOption> _moods = const [
    _MoodOption(
      emoji: '😄',
      label: 'Great',
    ),
    _MoodOption(
      emoji: '🙂',
      label: 'Good',
    ),
    _MoodOption(
      emoji: '😐',
      label: 'Okay',
    ),
    _MoodOption(
      emoji: '😔',
      label: 'Low',
    ),
    _MoodOption(
      emoji: '😤',
      label: 'Frustrated',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // ── Restore today's check-in ────────────────────
    _submitted = CheckInHelper.hasCheckedInToday();

    final savedMood =
    CheckInHelper.getTodayMood();

    if (savedMood != null && savedMood > 0) {
      _selectedMoodIndex = savedMood - 1;
    }
  }

  Future<void> _onMoodSelected(int index) async {
    // Prevent multiple submissions per day
    if (_submitted) return;

    // Save locally
    await CheckInHelper.saveCheckIn(index + 1);

    setState(() {
      _selectedMoodIndex = index;
    });

    Future.delayed(
      const Duration(milliseconds: 500),
          () {
        if (mounted) {
          setState(() {
            _submitted = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder:
          (child, animation) =>
          FadeTransition(
            opacity: animation,
            child: child,
          ),
      child: _submitted
          ? _buildConfirmed()
          : _buildCheckIn(),
    );
  }

  // ── Pre-submission ───────────────────────────────
  Widget _buildCheckIn() {
    return Container(
      key: const ValueKey('checkin'),
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 18.h,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6366F1),
            Color(0xFF818CF8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
        BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // ── Top row ─────────────────────────
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'How is ${widget.childName} feeling today?',
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight:
                    FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(width: 8.w),
              Container(
                padding:
                EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                ),
                child: Text(
                  _formattedDate(),
                  style:
                  GoogleFonts.poppins(
                    fontSize: 11.sp,
                    color:
                    Colors.white70,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // ── Emoji row ───────────────────────
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: List.generate(
              _moods.length,
                  (i) {
                final isSelected =
                    _selectedMoodIndex == i;

                return GestureDetector(
                  onTap: () =>
                      _onMoodSelected(i),
                  child: AnimatedContainer(
                    duration:
                    const Duration(
                      milliseconds: 180,
                    ),
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : Colors.white12,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : Colors.white24,
                        width: 1.5.w,
                      ),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: Colors.black
                              .withValues(
                            alpha: 0.12,
                          ),
                          blurRadius: 6.r,
                          offset:
                          const Offset(
                            0,
                            2,
                          ),
                        )
                      ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        _moods[i].emoji,
                        style: TextStyle(
                          fontSize:
                          isSelected
                              ? 24
                              : 22,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Post-submission ──────────────────────────────
  Widget _buildConfirmed() {
    final mood = _moods[_selectedMoodIndex!];

    return Container(
      key: const ValueKey('confirmed'),
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 18.h,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6366F1),
            Color(0xFF818CF8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
        BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          // Emoji circle
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.white12,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white30,
                width: 1.5.w,
              ),
            ),
            child: Center(
              child: Text(
                mood.emoji,
                style: TextStyle(
                  fontSize: 24.sp,
                ),
              ),
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Mood logged ✓',
                  style:
                  GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    Colors.white,
                  ),
                ),

                SizedBox(height: 3.h),

                Text(
                  '${widget.childName} is feeling ${mood.label} today',
                  style:
                  GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color:
                    Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${months[now.month - 1]} ${now.day}';
  }
}

class _MoodOption {
  final String emoji;
  final String label;

  const _MoodOption({
    required this.emoji,
    required this.label,
  });
}