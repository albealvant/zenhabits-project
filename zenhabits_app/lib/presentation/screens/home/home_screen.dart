import 'package:flutter/material.dart';
import 'package:zenhabits_app/presentation/widgets/user_header.dart';
import 'package:zenhabits_app/presentation/widgets/habit_list.dart';
import 'package:zenhabits_app/presentation/screens/goals/goals_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int coins = 200;

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.pushNamed(context, '/settings');
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  void _navigateToCreateHabit() {
    Navigator.pushNamed(context, '/create-habit');
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _buildHomeContent(),
      const GoalsScreen(),
      Container(), // Placeholder para settings
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFffead2),
      body: SafeArea(child: _screens[_selectedIndex]),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF582105),
              onPressed: _navigateToCreateHabit,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
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

  Widget _buildHomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserHeader(coins: coins),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'HÁBITOS',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
        ),
        Expanded(
          child: HabitList(
            onCoinsChanged: (value) {
              setState(() {
                coins += value;
              });
            },
          ),
        ),
      ],
    );
  }
}