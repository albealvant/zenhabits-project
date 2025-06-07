import 'package:flutter/material.dart';
import 'signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEAD2),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: SignUpForm(),
      ),
    );
  }
}