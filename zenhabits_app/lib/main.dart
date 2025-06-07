import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenhabits_app/data/database/zenhabits_database.dart';
import 'package:zenhabits_app/data/repositories/habits_repository.dart';
import 'package:zenhabits_app/data/api/remote_habit_datasource.dart';
import 'package:zenhabits_app/domain/usecases/insert_habit_usecase.dart';
import 'package:zenhabits_app/domain/usecases/delete_habit_usecase.dart';
import 'package:zenhabits_app/domain/usecases/get_habits_usecase.dart';
import 'package:zenhabits_app/domain/usecases/update_habit_usecase.dart';
import 'package:zenhabits_app/presentation/screens/create/habit/create_habit_screen.dart';
import 'package:zenhabits_app/presentation/screens/home/home_screen.dart';
import 'package:zenhabits_app/presentation/screens/login/login_screen.dart';
import 'package:zenhabits_app/presentation/viewmodels/habit_view_model.dart';
import 'package:zenhabits_app/presentation/screens/signup/signup_screen.dart';
import 'package:zenhabits_app/data/repositories/users_repository.dart';
import 'package:zenhabits_app/domain/usecases/insert_user_usecase.dart';
import 'package:zenhabits_app/domain/usecases/get_user_usecase.dart';
import 'package:zenhabits_app/presentation/viewmodels/user_view_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorZenhabitsDatabase
      .databaseBuilder('ZenHabits.db')
      .build();
  final remoteDataSource = RemoteHabitsDataSource(baseUrl: 'http://localhost:3000');

  final habitRepository = HabitRepository(habitDao: database.habitDao,remoteDataSource: remoteDataSource);
  final userRepository = UserRepository(userDao: database.userDao);
  final insertHabitUseCase = InsertHabitUseCase(repository: habitRepository);
  final updateHabitUseCase = UpdateHabitUseCase(repository: habitRepository);
  final deleteHabitUseCase = DeleteHabitUsecase(repository: habitRepository);
  final getHabitsUseCase = GetHabitsUseCase(repository: habitRepository);
  final insertUserUseCase = InsertUserUseCase(repository: userRepository);
  final getUserUseCase = GetUserUsecase(repository: userRepository, habitRepository: habitRepository);


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HabitViewModel(
            insertHabitUsecase: insertHabitUseCase,
            updateHabitUseCase: updateHabitUseCase,
            deleteHabitUsecase: deleteHabitUseCase,
            getHabitsUsecase: getHabitsUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => UserViewModel(
            insertUserUseCase: insertUserUseCase,
            getUserUsecase: getUserUseCase,
          ),
        ),
      ],
      child: const ZenHabitsApp(),
    )
  );
}

class ZenHabitsApp extends StatelessWidget {
  const ZenHabitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZenHabits',
      theme: ThemeData(
        fontFamily: 'Sans',
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/create-habit': (context) => const CreateHabitScreen(),
        '/signup': (context) => const SignUpScreen(),
      },
    );
  }
}