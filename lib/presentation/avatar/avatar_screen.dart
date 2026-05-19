import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/presentation/avatar/widgets/avatar_controls.dart';
import 'package:patient/presentation/avatar/widgets/avatar_view.dart';

import '../../core/businessLogic/avatar_cubit/avatar_cubit.dart';

class AvatarTestScreen extends StatelessWidget {
  const AvatarTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvatarCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Avatar Test")),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarView(),
            SizedBox(height: 20),
            AvatarControls(),
          ],
        ),
      ),
    );
  }
}