import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenhabits_app/presentation/viewmodels/user_view_model.dart';

class UserHeader extends StatelessWidget {
  final int coins;

  const UserHeader({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserViewModel>().currentUser.value;

    return Padding(
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
              ),
            ],
          )
        ],
      ),
    );
  }
}