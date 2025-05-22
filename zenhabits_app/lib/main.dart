import 'package:flutter/material.dart';
import 'package:zenhabits_app/data/local/zenhabits_database.dart';
import 'package:zenhabits_app/presentation/screens/create_habit_screen.dart';
import 'package:zenhabits_app/presentation/screens/home_screen.dart';
import 'package:zenhabits_app/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorZenhabitsDatabase
      .databaseBuilder('zenhabits.db')
      .build();

  runApp(ZenHabitsApp(database: database));
}

class ZenHabitsApp extends StatelessWidget {
  final ZenhabitsDatabase database;

  const ZenHabitsApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZenHabits',
      theme: ThemeData(fontFamily: 'Sans', primarySwatch: Colors.orange),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/create-habit': (context) => const CreateHabitScreen(),
      },
    );
  }
}
