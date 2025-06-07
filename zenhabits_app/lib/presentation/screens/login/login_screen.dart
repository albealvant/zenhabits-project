import 'package:flutter/material.dart';
import 'package:zenhabits_app/presentation/screens/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFffead2),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Image(
                image: AssetImage('assets/img/logoZenhabits.png'),
                height: 120,
              ),
              SizedBox(height: 30),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}