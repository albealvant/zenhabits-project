import 'package:flutter/material.dart';
import 'package:zenhabits_app/domain/model/user.dart';
import 'package:zenhabits_app/presentation/viewmodels/user_view_model.dart';

class SignUpController {
  final UserViewModel userViewModel;
  final BuildContext context;

  SignUpController({
    required this.userViewModel,
    required this.context,
  });

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final newUser = User(
      userId: null,
      name: username,
      email: email,
      password: password,
    );

    await userViewModel.createUser(newUser);
    final error = userViewModel.error.value;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Cuenta creada con éxito'),
        backgroundColor: error == null ? Colors.green : null,
      ),
    );

    if (error == null) {
      Navigator.pop(context);
    }
  }
}