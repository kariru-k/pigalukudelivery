import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigalukudelivery/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String id = "home-screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: (){
              FirebaseAuth.instance.signOut().then((value){
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              });
            },
            child: const Text("Home Screen")
        ),
      ),
    );
  }
}
