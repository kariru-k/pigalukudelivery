import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pigalukudelivery/screens/home_screen.dart';
import 'package:pigalukudelivery/screens/login_screen.dart';
import 'package:pigalukudelivery/screens/reset_password_screen.dart';
import 'package:pigalukudelivery/screens/splash_screen.dart';

import 'firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Piga Luku Delivery App',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: "Lato"
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context) =>const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ResetPassword.id: (context) => const ResetPassword(),
      },
    );
  }
}



