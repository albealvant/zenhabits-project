import 'package:flutter/material.dart';
import 'package:zenhabits_app/domain/model/habit.dart';
import 'package:zenhabits_app/presentation/viewmodels/habit_view_model.dart';
import 'package:zenhabits_app/presentation/viewmodels/user_view_model.dart';

class CreateHabitController {
  final HabitViewModel habitViewModel;
  final UserViewModel userViewModel;
  final BuildContext context;

  bool _isSubmitting = false;

  static const String _noUserMessage = 'No hay usuario autenticado';
  static const String _requiredFieldsMessage = 'Nombre y frecuencia son obligatorios';
  static const String _habitSuccessMessage = 'Hábito creado con éxito';
  static const String _habitErrorMessage = 'Error al crear hábito';

  CreateHabitController({
    required this.habitViewModel,
    required this.userViewModel,
    required this.context,
  });

  Future<void> createHabit({
    required String name,
    String? description,
    required String frequency,
  }) async {
    if (_isSubmitting) return;

    final user = userViewModel.currentUser.value;
    final userId = user?.userId ?? 0;

    if (userId == 0) {
      _showSnack(_noUserMessage);
      return;
    }

    if (name.trim().isEmpty || frequency.trim().isEmpty) {
      _showSnack(_requiredFieldsMessage);
      return;
    }

    _isSubmitting = true;

    final newHabit = Habit(
      name: name.trim(),
      description: (description?.trim().isEmpty ?? true) ? null : description!.trim(),
      frequency: frequency.toLowerCase(),
      completed: false,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      userId: userId,
    );

    try {
      await habitViewModel.createHabit(newHabit, user!);
      await habitViewModel.getHabits(userId);

      _showSnack(_habitSuccessMessage, isSuccess: true);
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
    } catch (e) {
      _showSnack('$_habitErrorMessage: $e');
    } finally {
      _isSubmitting = false;
    }
  }

  void _showSnack(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : null,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
