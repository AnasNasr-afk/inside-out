import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:patient/core/networking/repositories/assessment_repo.dart';
import 'package:patient/core/theme/theme.dart';
import 'game_haptics.dart';
import 'game_records.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key, this.taskId});

  final int? taskId;

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  static const _gameKey = 'memory_cards';

  late List<int> _cards;
  late List<int> _state; // 0 = hidden, 1 = flipped, 2 = matched
  int _matches = 0;
  int _moves = 0;
  bool _isProcessing = false;

  Timer? _timer;
  int _elapsedSeconds = 0;

  int? _prevBestMoves;
  int? _prevBestTime;

  bool _resultSaved = false;
  bool _isSavingResult = false;
  String? _saveError;

  bool get _isComplete => _matches == 6;

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
    _initializeGame();
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
            'Completed Memory Cards: $_moves moves in $_timeLabel, matched all 6 pairs.',
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

  void _initializeGame() {
    final indices = [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6]..shuffle(Random());
    _cards = indices;
    _state = List.filled(12, 0);
    _matches = 0;
    _moves = 0;
    _isProcessing = false;
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

  void _flipCard(int index) {
    if (_state[index] != 0 || _isProcessing) return;

    setState(() => _state[index] = 1);

    final flipped = [
      for (int i = 0; i < _state.length; i++)
        if (_state[i] == 1) i,
    ];

    if (flipped.length == 2) {
      _moves++;
      _isProcessing = true;
      final first = flipped[0];
      final second = flipped[1];

      if (_cards[first] == _cards[second]) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            bool didComplete = false;
            setState(() {
              _state[first] = 2;
              _state[second] = 2;
              _matches++;
              _isProcessing = false;
              if (_matches == 6) {
                _timer?.cancel();
                GameHaptics.onComplete();
                GameRecords.save(_gameKey, _moves, _elapsedSeconds);
                didComplete = true;
              } else {
                GameHaptics.onCorrect();
              }
            });
            if (didComplete) _saveTaskResult();
          }
        });
      } else {
        GameHaptics.onWrong();
        Future.delayed(const Duration(milliseconds: 900), () {
          if (mounted) {
            setState(() {
              _state[first] = 0;
              _state[second] = 0;
              _isProcessing = false;
            });
          }
        });
      }
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
        title: const Text('Memory Cards'),
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildStatCard('Moves', _moves.toString())),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Score', '$_matches/6')),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Time', _timeLabel)),
              ],
            ),
            const SizedBox(height: 20),

            if (_isComplete) ...[
              _CompletionBanner(
                moves: _moves,
                timeLabel: _timeLabel,
                bestLabel: _bestLabel,
              ),
              const SizedBox(height: 20),
            ],

            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final isFlipped = _state[index] == 1;
                  final isMatched = _state[index] == 2;

                  return GestureDetector(
                    onTap: () => _flipCard(index),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0.0,
                        end: (isFlipped || isMatched) ? 1.0 : 0.0,
                      ),
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      builder: (context, value, _) {
                        final showFront = value >= 0.5;
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(
                              showFront ? (1 - value) * pi : value * pi,
                            ),
                          child: showFront
                              ? _buildCardFront(index, isMatched)
                              : _buildCardBack(),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            if (_saveError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _saveError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
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
                        setState(_initializeGame);
                        _startTimer();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isComplete ? Colors.green : AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSavingResult
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Saving result…',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        widget.taskId != null && _isComplete
                            ? (_saveError != null ? 'Retry Save' : 'Back to Task')
                            : (_isComplete ? 'Play Again' : 'Reset Game'),
                        style: const TextStyle(
                          fontSize: 15,
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

  Widget _buildCardFront(int index, bool isMatched) {
    return Card(
      color: isMatched
          ? Colors.green.withValues(alpha: 0.25)
          : AppTheme.primaryColor.withValues(alpha: 0.3),
      child: Center(
        child: Text(
          _cards[index].toString(),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isMatched ? Colors.green : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Card(
      color: Colors.grey.shade300,
      child: const Center(child: Icon(Icons.help_outline, size: 40)),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Card(
      color: AppTheme.primaryColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.celebration_rounded, color: Colors.green, size: 44),
          const SizedBox(height: 8),
          const Text(
            'You did it!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$moves moves · $timeLabel',
            style: TextStyle(
              fontSize: 14,
              color: Colors.green.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (bestLabel.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    bestLabel.startsWith('New')
                        ? Icons.star_rounded
                        : Icons.emoji_events_rounded,
                    size: 16,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    bestLabel,
                    style: TextStyle(
                      fontSize: 13,
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
