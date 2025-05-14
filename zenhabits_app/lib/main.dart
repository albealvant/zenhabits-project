import 'package:flutter/material.dart';
import 'package:zenhabits_app/data/local/zenhabits_database.dart';
import 'package:zenhabits_app/data/local/database/entities/user_entity.dart';

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
      home: MyHomePage(title: 'ZenHabits', database: database),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final ZenhabitsDatabase database;

  const MyHomePage({super.key, required this.title, required this.database});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _statusMessage = 'Insertando usuario...';

  @override
  void initState() {
    super.initState();
    _insertInitialUser();
  }

  Future<void> _insertInitialUser() async {
    final userDao = widget.database.userDao;
    final newUser = User(1, 'albeal', 'albeal@gmail.com', '1234');
    try {
      await userDao.insertUser(newUser);
      setState(() {
        _statusMessage = 'Usuario insertado correctamente.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'ERROR al insertar el usuario: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          _statusMessage,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}