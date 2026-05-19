import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/helpers/check_in_helper.dart';

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
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
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
        BorderRadius.circular(22),
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
              Text(
                'How is ${widget.childName} feeling today?',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight:
                  FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
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
                    fontSize: 11,
                    color:
                    Colors.white70,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : Colors.white12,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : Colors.white24,
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: Colors.black
                              .withValues(
                            alpha: 0.12,
                          ),
                          blurRadius: 6,
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
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
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
        BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          // Emoji circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white12,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white30,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                mood.emoji,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Mood logged ✓',
                  style:
                  GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    Colors.white,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '${widget.childName} is feeling ${mood.label} today',
                  style:
                  GoogleFonts.poppins(
                    fontSize: 12,
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