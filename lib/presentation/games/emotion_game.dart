import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:patient/core/networking/repositories/assessment_repo.dart';
import 'package:patient/core/theme/theme.dart';
import 'game_haptics.dart';
import 'game_records.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmotionGame extends StatefulWidget {
  const EmotionGame({super.key, this.taskId});

  final int? taskId;

  @override
  State<EmotionGame> createState() => _EmotionGameState();
}

class _EmotionGameState extends State<EmotionGame> {
  static const _gameKey = 'emotion_match';

  final List<EmotionData> _emotions = [
    EmotionData('Happy', Icons.sentiment_very_satisfied_rounded, Colors.yellow.shade700),
    EmotionData('Good', Icons.sentiment_satisfied_rounded, Colors.green),
    EmotionData('Okay', Icons.sentiment_neutral_rounded, Colors.teal),
    EmotionData('Unhappy', Icons.sentiment_dissatisfied_rounded, Colors.orange),
    EmotionData('Sad', Icons.sentiment_very_dissatisfied_rounded, Colors.blue),
    EmotionData('Angry', Icons.mood_bad_rounded, Colors.red),
  ];

  late List<EmotionData> _queue;
  int _queueIndex = 0;
  int _score = 0;
  int _moves = 0;
  bool _isLocked = false;
  String _message = '';
  String? _targetEmotion;

  String? _lastTappedEmotion;
  bool _lastTapCorrect = false;
  bool _isWrongTap = false;

  Timer? _timer;
  int _elapsedSeconds = 0;

  int? _prevBestMoves;
  int? _prevBestTime;

  bool _resultSaved = false;
  bool _isSavingResult = false;
  String? _saveError;

  bool get _isComplete => _score == 6;

  String get _timeLabel => GameRecords.formatTime(_elapsedSeconds);

  String get _bestLabel {
    if (_prevBestMoves == null) return '';
    if (_moves < _prevBestMoves! ||
        _elapsedSeconds < (_prevBestTime ?? 999999)) {
      return 'New personal best!';
    }
    return 'Best: $_prevBestMoves moves · ${GameRecords.formatTime(_prevBestTime!)}';
  }

  @override
  void initState() {
    super.initState();
    _initGame();
    _startTimer();
    _loadBestRecord();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _saveTaskResult() async {
    if (widget.taskId == null) return;
    setState(() {
      _isSavingResult = true;
      _saveError = null;
    });
    try {
      await AssessmentRepository().saveTaskResult(
        specialistTaskId: widget.taskId!,
        totalMoves: _moves,
        timeTaken: _elapsedSeconds,
        roundsCount: 6,
        motherNote:
            'Completed Emotion Recognition: $_moves moves in $_timeLabel, identified all 6 emotions.',
      ).timeout(const Duration(seconds: 15));
      if (mounted) setState(() { _resultSaved = true; _isSavingResult = false; });
    } catch (e) {
      if (mounted) {
        setState(() { _saveError = 'Could not save result. Tap to retry.'; _isSavingResult = false; });
      }
    }
  }

  Future<void> _loadBestRecord() async {
    final record = await GameRecords.load(_gameKey);
    if (mounted) {
      setState(() {
        _prevBestMoves = record.moves;
        _prevBestTime = record.seconds;
      });
    }
  }

  void _initGame() {
    _queue = List.from(_emotions)..shuffle(Random());
    _queueIndex = 0;
    _score = 0;
    _moves = 0;
    _isLocked = false;
    _lastTappedEmotion = null;
    _lastTapCorrect = false;
    _isWrongTap = false;
    _targetEmotion = _queue[0].name;
    _message = 'Find ${_queue[0].name}!';
    _elapsedSeconds = 0;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _elapsedSeconds++);
        if (_elapsedSeconds >= 300) _timer?.cancel();
      }
    });
  }

  void _selectEmotion(String emotionName) {
    if (_isLocked || _isComplete) return;

    bool didComplete = false;
    setState(() {
      _moves++;
      _lastTappedEmotion = emotionName;

      if (emotionName == _targetEmotion) {
        _lastTapCorrect = true;
        _score++;
        _isLocked = true;
        if (_score == 6) {
          _timer?.cancel();
          _message = 'You did it!';
          GameHaptics.onComplete();
          GameRecords.save(_gameKey, _moves, _elapsedSeconds);
          didComplete = true;
        } else {
          _message = 'Correct!';
          GameHaptics.onCorrect();
        }
      } else {
        _lastTapCorrect = false;
        _isWrongTap = true;
        _message = 'Try again!';
        GameHaptics.onWrong();
      }
    });
    if (didComplete) _saveTaskResult();

    // Clear only the red border highlight after 600ms — banner stays
    if (emotionName != _targetEmotion) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _lastTappedEmotion = null);
      });
    }

    // Advance to next round on correct
    if (emotionName == _targetEmotion && _score < 6) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _queueIndex++;
            _targetEmotion = _queue[_queueIndex].name;
            _isLocked = false;
            _lastTappedEmotion = null;
            _isWrongTap = false;
            _message = 'Find ${_queue[_queueIndex].name}!';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSavingResult,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saving result, please wait…'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Recognition'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (_isSavingResult) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Saving result, please wait…'),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }
            Navigator.pop(context, _resultSaved);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0.r),
        child: Column(
          children: [
            // ── Stat row ──────────────────────────────────────
            Row(
              children: [
                Expanded(child: _buildStatCard('Moves', _moves.toString())),
                SizedBox(width: 12.w),
                Expanded(child: _buildStatCard('Score', '$_score/6')),
                SizedBox(width: 12.w),
                Expanded(child: _buildStatCard('Time', _timeLabel)),
              ],
            ),
            SizedBox(height: 20.h),

            // ── Instruction / completion banner ───────────────
            if (_isComplete)
              _CompletionBanner(
                moves: _moves,
                timeLabel: _timeLabel,
                bestLabel: _bestLabel,
              )
            else
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _message,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_isWrongTap && _targetEmotion != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        _targetEmotion!,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor.withValues(alpha: 0.65),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),

            SizedBox(height: 20.h),

            // ── Emotion grid — 3 columns, no scroll ───────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: _emotions.length,
              itemBuilder: (context, index) {
                final emotion = _emotions[index];
                final isLastTapped = _lastTappedEmotion == emotion.name;
                final borderColor = isLastTapped
                    ? (_lastTapCorrect ? Colors.green : Colors.red)
                    : Colors.transparent;
                final opacity = (_isLocked && !_isComplete && !isLastTapped)
                    ? 0.35
                    : 1.0;

                return AnimatedScale(
                  scale: (isLastTapped && _lastTapCorrect) ? 1.18 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  child: AnimatedOpacity(
                    opacity: opacity,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: () => _selectEmotion(emotion.name),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: emotion.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: borderColor, width: 3.w),
                        ),
                        child: Center(
                          child: Icon(
                            emotion.icon,
                            size: 64.sp,
                            color: emotion.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20.h),

            // ── Button ────────────────────────────────────────
            if (_saveError != null)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  _saveError!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 13.sp),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.taskId != null && _isComplete
                    ? (_isSavingResult
                        ? null
                        : _saveError != null
                            ? _saveTaskResult
                            : () => Navigator.pop(context, _resultSaved))
                    : () {
                        setState(_initGame);
                        _startTimer();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isComplete ? Colors.green : AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: _isSavingResult
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18.w,
                            height: 18.h,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5.w,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Saving result…',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        widget.taskId != null && _isComplete
                            ? (_saveError != null ? 'Retry Save' : 'Back to Task')
                            : (_isComplete ? 'Play Again' : 'Reset Game'),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Card(
      color: AppTheme.primaryColor.withValues(alpha: 0.1),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletionBanner extends StatelessWidget {
  const _CompletionBanner({
    required this.moves,
    required this.timeLabel,
    required this.bestLabel,
  });

  final int moves;
  final String timeLabel;
  final String bestLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.35),
          width: 1.5.w,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.celebration_rounded, color: Colors.green, size: 44.sp),
          SizedBox(height: 8.h),
          Text(
            'You did it!',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '$moves moves · $timeLabel',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.green.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (bestLabel.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    bestLabel.startsWith('New')
                        ? Icons.star_rounded
                        : Icons.emoji_events_rounded,
                    size: 16.sp,
                    color: Colors.green.shade700,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    bestLabel,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class EmotionData {
  final String name;
  final IconData icon;
  final Color color;

  EmotionData(this.name, this.icon, this.color);
}
