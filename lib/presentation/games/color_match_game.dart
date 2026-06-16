import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:patient/core/networking/repositories/assessment_repo.dart';
import 'package:patient/core/theme/theme.dart';
import 'game_haptics.dart';
import 'game_records.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorMatchGame extends StatefulWidget {
  const ColorMatchGame({super.key, this.taskId});

  final int? taskId;

  @override
  State<ColorMatchGame> createState() => _ColorMatchGameState();
}

class _ColorMatchGameState extends State<ColorMatchGame> {
  static const _gameKey = 'color_match';

  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  late List<Color> _queue;
  int _queueIndex = 0;
  Color? _targetColor;
  int _score = 0;
  int _moves = 0;
  bool _isLocked = false;
  String _message = 'Match this color!';

  Color? _lastTappedColor;
  bool _lastTapCorrect = false;

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
            'Completed Color Match: $_moves moves in $_timeLabel, matched all 6 colors.',
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
    _queue = List.from(_colors)..shuffle(Random());
    _queueIndex = 0;
    _score = 0;
    _moves = 0;
    _isLocked = false;
    _lastTappedColor = null;
    _lastTapCorrect = false;
    _targetColor = _queue[0];
    _message = 'Match this color!';
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

  void _selectColor(Color color) {
    if (_isLocked || _isComplete) return;

    bool didComplete = false;
    setState(() {
      _moves++;
      _lastTappedColor = color;

      if (color == _targetColor) {
        _lastTapCorrect = true;
        _score++;
        _isLocked = true;
        if (_score == 6) {
          _timer?.cancel();
          _message = 'Amazing! You matched all colors!';
          GameHaptics.onComplete();
          GameRecords.save(_gameKey, _moves, _elapsedSeconds);
          didComplete = true;
        } else {
          _message = 'Great match!';
          GameHaptics.onCorrect();
        }
      } else {
        _lastTapCorrect = false;
        _message = 'Try again!';
        GameHaptics.onWrong();
      }
    });
    if (didComplete) _saveTaskResult();

    if (color != _targetColor) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _lastTappedColor = null);
      });
    }

    if (color == _targetColor && _score < 6) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _queueIndex++;
            _targetColor = _queue[_queueIndex];
            _lastTappedColor = null;
            _isLocked = false;
            _message = 'Match this color!';
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
        title: const Text('Color Match'),
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
            Row(
              children: [
                Expanded(child: _buildStatCard('Moves', _moves.toString())),
                SizedBox(width: 12.w),
                Expanded(child: _buildStatCard('Score', '$_score/6')),
                SizedBox(width: 12.w),
                Expanded(child: _buildStatCard('Time', _timeLabel)),
              ],
            ),
            SizedBox(height: 30.h),

            if (_isComplete)
              _CompletionBanner(
                moves: _moves,
                timeLabel: _timeLabel,
                bestLabel: _bestLabel,
              )
            else ...[
              Text(
                _message,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              // Target circle with checkmark overlay when locked
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150.w,
                    height: 150.h,
                    decoration: BoxDecoration(
                      color: _targetColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 3.w),
                    ),
                  ),
                  if (_isLocked)
                    Container(
                      width: 150.w,
                      height: 150.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 72.sp,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ],

            SizedBox(height: 40.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  final color = _colors[index];
                  final isTapped = _lastTappedColor == color;
                  final borderColor = isTapped
                      ? (_lastTapCorrect ? Colors.green : Colors.red)
                      : Colors.black;

                  return AnimatedScale(
                    scale: (isTapped && _lastTapCorrect) ? 1.18 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    child: GestureDetector(
                      onTap: () => _selectColor(color),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: borderColor,
                            width: isTapped ? 4.0 : 2.0,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Column(
                children: [
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
                                  ? (_saveError != null
                                      ? 'Retry Save'
                                      : 'Back to Task')
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
                style:
                    TextStyle(fontSize: 12.sp, color: Colors.black87)),
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
              padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
