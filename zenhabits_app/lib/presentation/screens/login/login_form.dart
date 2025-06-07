import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenhabits_app/presentation/viewmodels/user_view_model.dart';
import 'login_controller.dart';
import 'login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final LoginState _state;
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _state = LoginState();
    _controller = LoginController(_state, context);
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UserViewModel>().isLoading.value;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE3C1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.brown.shade200, width: 2),
      ),
      child: Column(
        children: [
          _buildTextField(controller: _state.usernameController, hint: 'nombre de usuario'),
          const SizedBox(height: 16),
          _buildTextField(controller: _state.passwordController, hint: 'contraseña', obscureText: true),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(value: true, onChanged: (_) {}),
              const Text('Recuérdame', style: TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _controller.login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Iniciar sesión',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      Navigator.pushNamed(context, '/signup');
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC66B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Crear cuenta',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: isLoading ? null : () {},
            child: const Text('¿Olvidaste la contraseña?',
                style: TextStyle(color: Color.fromARGB(255, 100, 57, 31))),
          ),
          if (isLoading) const Padding(padding: EdgeInsets.only(top: 16), child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        hintText: hint,
      ),
    );
  }
}