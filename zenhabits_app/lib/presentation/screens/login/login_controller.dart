import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenhabits_app/presentation/viewmodels/user_view_model.dart';
import 'login_state.dart';

class LoginController {
  final LoginState state;
  final BuildContext context;

  LoginController(this.state, this.context);

  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error de autenticación'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  Future<void> login() async {
    final userVM = context.read<UserViewModel>();
    final username = state.usernameController.text.trim();
    final password = state.passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showError('Por favor completa todos los campos');
      return;
    }

    final success = await userVM.authenticate(username, password);

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      final error = userVM.error.value ?? 'Usuario o contraseña incorrectos';
      showError(error);
    }
  }
}