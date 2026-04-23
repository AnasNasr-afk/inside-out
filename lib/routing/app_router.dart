import 'package:flutter/material.dart';
import 'package:patient/presentation/reports/report_screen.dart';
import 'package:patient/presentation/splash_screen.dart';
import 'package:patient/presentation/tasks%20/task_details_screen.dart';
import 'package:patient/routing/routes.dart';

import '../presentation/home/home_screen.dart';
import '../presentation/onBoarding/onboarding_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.onboardingScreen:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
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
