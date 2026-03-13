import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:patient/core/core.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/presentation/splash_screen.dart';
import 'package:patient/presentation/widgets/snackbar_service.dart';
import 'package:patient/provider/appointments_provider.dart';
import 'package:patient/provider/assessment_provider.dart';
import 'package:patient/provider/auth_provider.dart';
import 'package:patient/repository/supabase_auth_repository.dart';

import 'package:patient/provider/reports_provider.dart';
import 'package:patient/repository/supabase_patient_repository.dart';

import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import 'provider/task_provider.dart';
import 'provider/therapy_goals_provider.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  Gemini.init(apiKey: dotenv.env['GEMINI_API_KEY']!); // Add your Gemini API key here
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  setupDependencyInjection();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssessmentProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authRepository: SupabaseAuthRepository(
              supabaseClient: Supabase.instance.client,
            ),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ReportsProvider(
          patientRepository: SupabasePatientRepository(supabaseClient: Supabase.instance.client),
        )),
        ChangeNotifierProvider(create: (_) => TaskProvider(
          patientRepository: SupabasePatientRepository(supabaseClient: Supabase.instance.client),
        )),
        ChangeNotifierProvider(create: (_) => TherapyGoalsProvider(
          patientRepository: SupabasePatientRepository(supabaseClient: Supabase.instance.client),
        )),
        ChangeNotifierProvider(create: (_) => AppointmentsProvider(
          authRepository: SupabaseAuthRepository(supabaseClient: Supabase.instance.client),
          patientRepository: SupabasePatientRepository(supabaseClient: Supabase.instance.client)
        ))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Patient App',
        theme: AppTheme.lightTheme(),
        home: const SplashScreen());
  }
}
