import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cubits/avatar_cubit/avatar_cubit.dart';

class AvatarControls extends StatelessWidget {
  const AvatarControls({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AvatarCubit>();

    return Column(
      children: [
        ElevatedButton(
          onPressed: () => cubit.setEmotion('idle'),
          child: const Text('Idle'),
        ),
        ElevatedButton(
          onPressed: () => cubit.setEmotion('happy'),
          child: const Text('Happy'),
        ),
        ElevatedButton(
          onPressed: () => cubit.setEmotion('thinking'),
          child: const Text('Thinking'),
        ),
        ElevatedButton(
          onPressed: () => cubit.setEmotion('talking'),
          child: const Text('Talking'),
        ),
      ],
    );
  }
}