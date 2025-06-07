import 'package:flutter/material.dart';
import 'package:zenhabits_app/presentation/screens/create/habit/create_habit_form.dart';

class CreateHabitScreen extends StatelessWidget {
  const CreateHabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFEEEDB),
      body: SafeArea(
        child: CreateHabitForm(),
      ),
    );
  }
}