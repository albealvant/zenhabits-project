import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenhabits_app/domain/model/habit.dart';
import 'package:zenhabits_app/presentation/viewmodels/habit_view_model.dart';
import 'package:zenhabits_app/presentation/viewmodels/user_view_model.dart'; // <-- AÑADIDO

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int coins = 200;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      final habitViewModel = Provider.of<HabitViewModel>(context, listen: false);
      final user = userViewModel.currentUser.value;

      if (user != null) {
        habitViewModel.getHabits(user.userId ?? 0);
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      Navigator.pushNamed(context, '/settings');
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  void _navigateToCreateHabit(BuildContext context) {
    Navigator.pushNamed(context, '/create-habit');
  }

  @override
  Widget build(BuildContext context) {
    final habitViewModel = Provider.of<HabitViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context);
    final user = userViewModel.currentUser.value;

    return Scaffold(
      backgroundColor: const Color(0xFFffead2),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage('assets/img/character.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Usuario',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.favorite, size: 16, color: Colors.red),
                          Container(width: 50, height: 5, color: Colors.red),
                          const SizedBox(width: 8),
                          const Icon(Icons.bolt, size: 16, color: Colors.blue),
                          Container(width: 50, height: 5, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Icon(Icons.monetization_on, size: 16, color: Colors.orange),
                          Text('$coins'),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('HÁBITOS', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.brown)),
            ),

            Expanded(
              child: ValueListenableBuilder<List<Habit>>(
                valueListenable: habitViewModel.habitos,
                builder: (context, habitos, _) {
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
                                await habitViewModel.updateHabit(updatedHabit);
                                await habitViewModel.getHabits(habit.userId);

                                setState(() {
                                  if (value == true) {
                                    coins += 10;
                                  } else {
                                    coins -= 10;
                                  }
                                });
                              },
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
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF582105),
        onPressed: () => _navigateToCreateHabit(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFFaa5c21),
        unselectedItemColor: const Color(0xFFebebeb),
        selectedItemColor: const Color(0xFF582105),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}