import 'package:flutter/material.dart';

class GoalsScreen extends StatelessWidget {
  // Non-functional prototype of what this screen will be like
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> goals = [
      {
        'title': 'Leer 12 libros',
        'description': 'Completar un libro por mes',
        'completed': false,
      },
      {
        'title': 'Correr 5km',
        'description': 'Alcanzar resistencia cardiovascular',
        'completed': true,
      },
      {
        'title': 'Ahorrar \$1000',
        'description': 'Para fondo de emergencia',
        'completed': false,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFffead2),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Text(
                'METAS',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final String title = goals[index]['title'];
                  final String description = goals[index]['description'];
                  final bool completed = goals[index]['completed'];

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
                          value: completed,
                          onChanged: null,
                        ),
                        title: Opacity(
                          opacity: completed ? 0.5 : 1.0,
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        subtitle: Opacity(
                          opacity: completed ? 0.5 : 1.0,
                          child: Text(description),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.orange),
                          onPressed: () {
                            // delete
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF582105),
        onPressed: () {
          // Navigator.pushNamed(context, '/create-goal');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}