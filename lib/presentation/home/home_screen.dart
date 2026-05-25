import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/core/cubits/auth_cubit/auth_cubit.dart';
import 'package:patient/core/cubits/task_cubit/task_cubit.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/presentation/home/widgets/bottom_nav_bar.dart';
import 'package:patient/presentation/home/widgets/home_content.dart';
import 'package:patient/presentation/notification/updates_screen.dart';
import 'package:patient/presentation/profile/profile_screen.dart';

import '../../core/helpers/shared_pref_keys.dart';
import '../tasks /tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final childId =
    await SharedPrefHelper.getInt(SharedPrefKeys.childId);

    final cubit = TaskCubit.get(context);

    await cubit.getTasks(childId);

    await cubit.getParentChildData(childId);
  }

  void _goToTasks() {
    setState(() => _selectedIndex = 1);
  }

  late final List<Widget> _screens = [
    HomeContent(
      onSeeAllTasks: _goToTasks,
    ),

    const TasksScreen(),

    UpdatesScreen(),

    BlocProvider(
      create: (context) => AuthCubit(),
      child: const ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _screens[_selectedIndex],
            ),

            BottomNavBar(
              selectedIndex: _selectedIndex,
              onTap: (i) {
                setState(() {
                  _selectedIndex = i;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}