import 'package:flutter/material.dart';
import '../widgets/image_picker.dart';
import '../widgets/register_form.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String id = "register-screen";


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const ShopPicCard(),
              const RegisterForm(),
              SizedBox(
                child: TextButton(
                  child: const Text("Login Instead"),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
