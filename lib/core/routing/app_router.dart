import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patient/ai_avatar/presentation/avatar_screen.dart';
import 'package:patient/core/cubits/task_cubit/task_cubit.dart';
import 'package:patient/presentation/auth/login_screen.dart';
import 'package:patient/presentation/auth/signup_screen.dart';
import 'package:patient/presentation/avatar/avatar_screen.dart';
import 'package:patient/presentation/chat/chat_screen.dart';
import 'package:patient/presentation/reports/report_screen.dart';
import 'package:patient/presentation/splash_screen.dart';
import 'package:patient/core/models/task_model.dart';
import 'package:patient/presentation/tasks%20/task_details_screen.dart';
import 'package:patient/core/routing/routes.dart';

import '../cubits/auth_cubit/auth_cubit.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/on_boarding/onboarding_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.onboardingScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => AuthCubit(),
                child: const OnBoardingScreen()));
      case Routes.signupScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => AuthCubit(), child: const SignupScreen()));
      case Routes.loginScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => AuthCubit(), child: const LoginScreen()));
      case Routes.homeScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (BuildContext context) => TaskCubit(),
                child: const HomeScreen()));
      case Routes.reportScreen:
        return MaterialPageRoute(builder: (_) => const ReportScreen());
      case Routes.chatScreen:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      case Routes.taskDetailsScreen:
        final task = settings.arguments;
        if (task is! TaskModel) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('No task to display.')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => TaskDetailsScreen(task: task),
        );
      case Routes.avatarScreen:
        return MaterialPageRoute(builder: (_) => const AvatarTestScreen());
      case Routes.aiBearScreen:
        return MaterialPageRoute(
          builder: (_) => const ProviderScope(child: AiBearScreen()),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
