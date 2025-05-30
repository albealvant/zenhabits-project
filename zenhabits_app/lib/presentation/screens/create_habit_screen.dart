import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenhabits_app/domain/model/habit.dart';
import 'package:zenhabits_app/presentation/viewmodels/habit_view_model.dart';

class CreateHabitScreen extends StatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  State<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedFrequency;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _createHabit(BuildContext context) async {
    final viewModel = Provider.of<HabitViewModel>(context, listen: false);

    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final frequency = selectedFrequency;

    if (name.isEmpty || frequency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nombre y frecuencia son obligatorios')),
      );
      return;
    }

    final newHabit = Habit(
      name: name,
      description: description.isEmpty ? null : description,
      frequency: frequency.toLowerCase(),
      completed: false,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      userId: 0, // Cambia esto según el usuario actual
    );

    try {
      await viewModel.createHabit(newHabit);
      await viewModel.getHabits(0); // Refrescar la lista de hábitos

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hábito creado con éxito 🎉'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear hábito: $e')),
      );
    }
  }

  Widget _buildTextField({required String hintText, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
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
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEEEDB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFaa5c21),
                  radius: 22,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                    iconSize: 20,
                  ),
                ),
              ),
            ),

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
                      decoration: InputDecoration(
                        hintText: 'Frecuencia',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
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
                          onPressed: () => _createHabit(context),
                        ),
                        _buildButton(
                          text: 'CANCELAR',
                          color: const Color(0xFFFFC66B),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}