import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/core/cubits/auth_cubit/auth_cubit.dart';
import 'package:patient/core/cubits/task_cubit/task_cubit.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/presentation/child_mood/child_mode_sounds.dart';
import 'package:patient/presentation/home/widgets/bottom_nav_bar.dart';
import 'package:patient/presentation/home/widgets/home_content.dart';
import 'package:patient/presentation/chat/chat_screen.dart';
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
    // Pre-warm sounds so they're ready before the child mode button is tapped.
    ChildModeSounds.instance.init();
  }

  Future<void> _loadInitialData() async {
    final childId = SharedPrefHelper.getInt(SharedPrefKeys.childId);
    final cubit = TaskCubit.get(context);

    await cubit.getTasks(childId);
    if (!mounted) return;
    await cubit.getParentChildData(childId);
  }

  void _goToTasks() {
    setState(() => _selectedIndex = 1);
  }

  void _goToProfile() => setState(() => _selectedIndex = 3);
  void _openChat() => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatScreen()),
      );

  late final List<Widget> _screens = [
    HomeContent(
        onSeeAllTasks: _goToTasks,
        onAvatarTap: _goToProfile,
        onChatTap: _openChat),
    const TasksScreen(),
    UpdatesScreen(),
    BlocProvider(
      create: (context) => AuthCubit(),
      child: const ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFFFBFAFF),
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: bottomInset + 12,
            child: BottomNavBar(
              selectedIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
            ),
          ),
        ],
      ),
    );
  }
}
