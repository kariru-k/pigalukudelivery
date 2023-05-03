import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String id = "home-screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
            },
            child: const Text("Home Screen")
        ),
      ),
    );
  }
}
