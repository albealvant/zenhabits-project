import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenhabits_app/presentation/viewmodels/user_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error de autenticación'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showDialog('Por favor completa todos los campos');
      return;
    }

    final success = await userViewModel.authenticate(username, password);

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      final errorMessage = userViewModel.error.value ?? 'Usuario o contraseña incorrectos';
      _showDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFffead2),
      body: Center(
        child: ValueListenableBuilder<bool>(
          valueListenable: userViewModel.isLoading,
          builder: (_, isLoading, __) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/img/logoZenhabits.png',
                        height: 120,
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE3C1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.brown.shade200, width: 2),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'nombre de usuario',
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'contraseña',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Checkbox(value: true, onChanged: (_) {}),
                                const Text('Recuérdame', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : () => _login(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : () {
                                  Navigator.pushNamed(context, '/signup');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFC66B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: const Text(
                                  'Crear cuenta',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: isLoading ? null : () {},
                              child: const Text('¿Olvidaste la contraseña?', style: TextStyle(color: Color.fromARGB(255, 100, 57, 31))),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if (isLoading)
                  const CircularProgressIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}