import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/core/businessLogic/task_cubit/task_cubit.dart';
import 'package:patient/presentation/reports/report_screen.dart';
import 'package:patient/presentation/splash_screen.dart';
import 'package:patient/presentation/tasks%20/task_details_screen.dart';
import 'package:patient/routing/routes.dart';

import '../core/businessLogic/auth_cubit/auth_cubit.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/onBoarding/onboarding_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.onboardingScreen:
        return MaterialPageRoute(builder: (_) => BlocProvider(
          create: (context) => AuthCubit(),
            child: const OnBoardingScreen()));
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => BlocProvider(
            create: (BuildContext context) => TaskCubit(),
            child: const HomeScreen()));
      case Routes.reportScreen:
        return MaterialPageRoute(builder: (_) => const ReportScreen());
      case Routes.taskDetailsScreen:
        return MaterialPageRoute(builder: (_) => const TaskDetailsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
