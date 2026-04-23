

import 'package:flutter/material.dart';
import 'package:patient/presentation/home/widgets/bottom_nav_bar.dart';
import 'package:patient/presentation/home/widgets/home_content.dart';
import 'package:patient/presentation/notification/updates_screen.dart';
import 'package:patient/presentation/profile/profile_screen.dart';

import '../tasks /tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> get _screens => [
    const HomeContent(),
    const TasksScreen(),
    UpdatesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _screens[_selectedIndex]),
            BottomNavBar(
              selectedIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
            ),
          ],
        ),
      ),
    );
  }
}

