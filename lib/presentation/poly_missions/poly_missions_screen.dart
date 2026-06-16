import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient/core/theme/app_tokens.dart';
import 'package:patient/presentation/poly_missions/cubit/poly_missions_cubit.dart';
import 'package:patient/presentation/poly_missions/widgets/pm_all_done.dart';
import 'package:patient/presentation/poly_missions/widgets/pm_background.dart';
import 'package:patient/presentation/poly_missions/widgets/pm_control_area.dart';
import 'package:patient/presentation/poly_missions/widgets/pm_focused_pill.dart';
import 'package:patient/presentation/poly_missions/widgets/pm_mission.dart';
import 'package:patient/presentation/poly_missions/widgets/pm_mission_card.dart';
import 'package:patient/presentation/poly_missions/widgets/pm_other_chip.dart';
import 'package:patient/presentation/poly_missions/widgets/pm_poly_area.dart';
import 'package:patient/presentation/poly_missions/widgets/pm_speech_bubble.dart';
import 'package:patient/presentation/poly_missions/widgets/pm_top_bar.dart';

class PolyMissionsScreen extends StatefulWidget {
  const PolyMissionsScreen({super.key});

  @override
  State<PolyMissionsScreen> createState() => _PolyMissionsScreenState();
}

class _PolyMissionsScreenState extends State<PolyMissionsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bobCtrl;

  @override
  void initState() {
    super.initState();
    _bobCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _bobCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PolyMissionsCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFF2B2360),
        body: BlocBuilder<PolyMissionsCubit, PolyMissionsState>(
          builder: (ctx, state) {
            final cubit = ctx.read<PolyMissionsCubit>();
            // Only show the focused mission view when a mission is actually
            // selected. On celebration the index is cleared, so we fall back to
            // the pick cards (hidden under the celebration overlay) instead of
            // dereferencing a null currentIndex.
            final showFocus = state.currentIndex != null &&
                state.phase != PmPhase.pick &&
                state.phase != PmPhase.celebration;

            return Stack(
              children: [
                // Background
                const Positioned.fill(child: PmBackground()),

                // Top bar
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: PmTopBar(
                    coins: state.totalCoins,
                    doneCount: state.done.length,
                    totalCount: state.tasks.length,
                  ),
                ),

                // Cards / focus / loading / empty area
                Positioned(
                  top: 118.h, left: 0, right: 0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: ScaleTransition(
                        scale: Tween(begin: 0.94, end: 1.0).animate(anim),
                        child: child,
                      ),
                    ),
                    child: state.isLoadingTasks
                        ? _buildLoading()
                        : state.tasks.isEmpty
                            ? _buildEmpty()
                            : showFocus
                                ? _buildFocusGroup(state)
                                : _buildPickCards(state, cubit),
                  ),
                ),

                // Poly avatar
                Positioned(
                  bottom: 180.h, left: 0, right: 0,
                  child: Center(
                    child: PmPolyArea(
                      isHearing: state.phase == PmPhase.recording,
                    ),
                  ),
                ),

                // Dynamic guidance bubble floating above Poly's head.
                if (!state.isLoadingTasks &&
                    state.tasks.isNotEmpty &&
                    state.phase != PmPhase.celebration)
                  Positioned(
                    bottom: 470.h, left: 24.w, right: 24.w,
                    child: PmSpeechBubble(
                      phase: state.phase,
                      polyIsTalking: state.polyIsTalking,
                      allDone: state.allDone,
                      allTasksDone: state.tasks.isNotEmpty &&
                          state.done.length >= state.tasks.length,
                    ),
                  ),

                // All-done celebration overlay
                if (state.phase == PmPhase.celebration)
                  PmAllDone(
                    coinsEarned: state.done.length * 10,
                    totalCoins: state.totalCoins,
                    onContinue: cubit.advanceBatch,
                  ),

                // Control area
                Positioned(
                  bottom: 20.h, left: 0, right: 0,
                  child: Center(
                    child: PmControlArea(
                      phase: state.phase,
                      polyIsTalking: state.polyIsTalking,
                      allDone: state.allDone,
                      recSeconds: state.recSeconds,
                      onStartRec: cubit.startRecording,
                      onStopRec: cubit.stopRecording,
                      onNext: cubit.nextMission,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      key: const ValueKey('loading'),
      height: 180.h,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.5.w,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return SizedBox(
      key: const ValueKey('empty'),
      height: 180.h,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white54,
                size: 42.sp,
              ),
              SizedBox(height: 14.h),
              Text(
                'No missions yet',
                style: T.sectionHeader().copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Your specialist will assign tasks soon.',
                style: T.navLabel().copyWith(
                  color: Colors.white60,
                  fontSize: 13.5.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickCards(PolyMissionsState state, PolyMissionsCubit cubit) {
    return Padding(
      key: const ValueKey('pick'),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AnimatedBuilder(
        animation: _bobCtrl,
        builder: (_, __) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < state.tasks.length; i++) ...[
              Expanded(
                child: Transform.translate(
                  offset: Offset(
                    0,
                    state.done.contains(state.tasks[i].taskId.toString())
                        ? 0
                        : -9.0.h *
                            math.sin(
                              _bobCtrl.value * 2 * math.pi +
                                  i * 1.3 * math.pi / 3,
                            ),
                  ),
                  child: PmMissionCard(
                    mission: PolyMission.fromTask(state.tasks[i], i),
                    isDone: state.done
                        .contains(state.tasks[i].taskId.toString()),
                    onTap: () => cubit.pickMission(i),
                  ),
                ),
              ),
              if (i < state.tasks.length - 1) SizedBox(width: 13.w),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFocusGroup(PolyMissionsState state) {
    final idx = state.currentIndex!;
    final cur = PolyMission.fromTask(state.tasks[idx], idx);
    final others = [
      for (int i = 0; i < state.tasks.length; i++)
        if (i != idx) PolyMission.fromTask(state.tasks[i], i),
    ];

    return Padding(
      key: const ValueKey('focus'),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PmFocusedPill(
            mission: cur,
            showDone: state.phase == PmPhase.response,
          ),
          SizedBox(height: 14.h),
          if (others.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < others.length; i++) ...[
                  PmOtherChip(mission: others[i]),
                  if (i < others.length - 1) SizedBox(width: 8.w),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
