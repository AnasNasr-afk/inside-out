import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:rive/rive.dart';

import 'package:patient/core/routing/app_router.dart';
import 'package:patient/core/routing/routes.dart';

import 'core/helpers/shared_pref.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RiveFile.initialize();
  await dotenv.load(fileName: '.env');
  await SharedPrefHelper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    ProviderScope(
        child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Patient App',
      theme: AppTheme.lightTheme(),
      onGenerateRoute: AppRouter().onGenerateRoute,
      initialRoute: Routes.splashScreen,
    );
  }
}
