import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigalukudelivery/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3), () {
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
            if(user==null){
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            }
            else{
              Navigator.pushReplacementNamed(context, HomeScreen.id);
            }
          });
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authData = Provider.of<AuthProvider>(context);

    authData.getCurrentAddress();


    return Scaffold(
      body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/pigaluku_logo.png'),
              const SizedBox(height: 20,),
              const Text(
                'Piga Luku Delivery Application',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          )
      ),
    );
  }
}
