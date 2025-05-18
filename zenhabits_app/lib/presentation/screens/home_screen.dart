import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/monkey_avatar.png'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
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
                          const Text('253'),
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
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.check_box_outline_blank, color: Colors.brown),
                      title: const Text('Hábito', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      subtitle: const Text('Descripción'),
                      trailing: const Icon(Icons.delete, color: Colors.orange),
                    ),
                  ),
                ),
              ),
            )
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