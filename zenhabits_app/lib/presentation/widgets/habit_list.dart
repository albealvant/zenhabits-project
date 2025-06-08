import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenhabits_app/domain/model/habit.dart';
import 'package:zenhabits_app/presentation/viewmodels/habit_view_model.dart';
import 'package:zenhabits_app/presentation/viewmodels/user_view_model.dart';

class HabitList extends StatefulWidget {
  final void Function(int coinsDelta) onCoinsChanged;

  const HabitList({super.key, required this.onCoinsChanged});

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<UserViewModel>().currentUser.value;
      if (user != null) {
        context.read<HabitViewModel>().getHabits(user.userId ?? 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitViewModel = context.watch<HabitViewModel>();
    final user = context.read<UserViewModel>().currentUser.value;

    return ValueListenableBuilder<List<Habit>>(
      valueListenable: habitViewModel.habitos,
      builder: (_, habitos, __) {
        if (habitos.isEmpty) {
          return const Center(child: Text('No tienes hábitos aún.'));
        }

        return ListView.builder(
          itemCount: habitos.length,
          itemBuilder: (context, index) {
            final habit = habitos[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: ListTile(
                  leading: Checkbox(
                    value: habit.completed,
                    onChanged: (bool? value) async {
                      final updatedHabit = Habit(
                        habitId: habit.habitId,
                        name: habit.name,
                        description: habit.description,
                        frequency: habit.frequency,
                        completed: value ?? false,
                        startDate: habit.startDate,
                        endDate: habit.endDate,
                        userId: habit.userId,
                      );
                      await habitViewModel.updateHabit(updatedHabit, user!);
                      await habitViewModel.getHabits(user.userId!);

                      widget.onCoinsChanged(value == true ? 10 : -10);
                    },
                    activeColor: Colors.orange,
                    checkColor: Color.fromARGB(255, 81, 40, 19),
                  ),
                  title: Opacity(
                    opacity: habit.completed ? 0.5 : 1.0,
                    child: Text(
                      habit.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  subtitle: Opacity(
                    opacity: habit.completed ? 0.5 : 1.0,
                    child: Text(habit.description ?? ''),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.orange),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('¿Eliminar hábito?'),
                          content: const Text('Esta acción no se puede deshacer.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(ctx).pop();
                                await habitViewModel.deleteHabit(habit);
                                await habitViewModel.getHabits(habit.userId);
                              },
                              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}