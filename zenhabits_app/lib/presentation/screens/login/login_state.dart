import 'package:flutter/material.dart';

class LoginState {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }
}