import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patient/ai_avatar/providers/animation_state_controller.dart';

class FlagSwitch extends ConsumerWidget {
  const FlagSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(animationStateControllerProvider).language;

    final flagCode = switch (lang) {
      'ar' => FlagsCode.EG,
      'jp' => FlagsCode.JP,
      _ => FlagsCode.US,
    };

    final label = switch (lang) {
      'ar' => 'AR',
      'jp' => 'JP',
      _ => 'EN',
    };

    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () =>
            ref.read(animationStateControllerProvider.notifier).toggleLanguage(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flag.fromCode(flagCode, height: 20, width: 28, fit: BoxFit.fill),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
