import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenhabits_app/presentation/screens/create/habit/create_habit_controller.dart';
import 'package:zenhabits_app/presentation/viewmodels/habit_view_model.dart';
import 'package:zenhabits_app/presentation/viewmodels/user_view_model.dart';

class CreateHabitForm extends StatefulWidget {
  const CreateHabitForm({super.key});

  @override
  State<CreateHabitForm> createState() => _CreateHabitFormState();
}

class _CreateHabitFormState extends State<CreateHabitForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedFrequency;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habitViewModel = context.read<HabitViewModel>();
    final userViewModel = context.read<UserViewModel>();

    final controller = CreateHabitController(
      habitViewModel: habitViewModel,
      userViewModel: userViewModel,
      context: context,
    );

    return Column(
      children: [
        Image.asset(
          'assets/img/monkey.png',
          width: 160,
          fit: BoxFit.contain,
        ),
        Container(
          width: double.infinity,
          color: const Color(0xFFF7B972),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: const Center(
            child: Text(
              'CREAR NUEVO HÁBITO',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D2600),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              children: [
                _buildTextField(hintText: 'Nombre', controller: nameController),
                const SizedBox(height: 16),
                _buildTextField(hintText: 'Descripción', controller: descriptionController),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Frecuencia'),
                  items: const [
                    DropdownMenuItem(value: 'diario', child: Text('Diario')),
                    DropdownMenuItem(value: 'semanal', child: Text('Semanal')),
                    DropdownMenuItem(value: 'mensual', child: Text('Mensual')),
                  ],
                  value: selectedFrequency,
                  onChanged: (value) {
                    setState(() {
                      selectedFrequency = value;
                    });
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(
                      text: 'AÑADIR',
                      color: Colors.orange,
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (selectedFrequency != null) {
                                setState(() => isLoading = true);

                                await controller.createHabit(
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  frequency: selectedFrequency!,
                                );

                                if (mounted) setState(() => isLoading = false);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Selecciona una frecuencia')),
                                );
                              }
                            },
                    ),
                    _buildButton(
                      text: 'CANCELAR',
                      color: const Color(0xFFFFC66B),
                      onPressed: isLoading ? null : () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      decoration: _inputDecoration(hintText),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: isLoading && text == 'AÑADIR'
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
    );
  }
}