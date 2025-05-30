import 'package:flutter/material.dart';
import 'package:zenhabits_app/domain/model/user.dart';
import 'package:zenhabits_app/domain/usecases/insert_user_usecase.dart';
import 'package:zenhabits_app/domain/usecases/get_user_usecase.dart';
import 'package:bcrypt/bcrypt.dart';

class UserViewModel extends ChangeNotifier {
  final InsertUserUseCase insertUserUseCase;
  final GetUserUsecase getUserUsecase;

  final ValueNotifier<User?> currentUser = ValueNotifier<User?>(null);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> error = ValueNotifier(null);

  UserViewModel({
    required this.insertUserUseCase,
    required this.getUserUsecase,
  });

  Future<void> getUser(String name) async {
    isLoading.value = true;
    error.value = null;

    try {
      final result = await getUserUsecase(name);
      currentUser.value = result;
    } catch (e) {
      error.value = 'Error al obtener usuario: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUser(User user) async {
    isLoading.value = true;
    error.value = null;

    try {
      final hashedPassword = BCrypt.hashpw(user.password, BCrypt.gensalt());
      final userWithHash = User(
        name: user.name,
        email: user.email,
        password: hashedPassword,
      );

      await insertUserUseCase(userWithHash);
    } catch (e) {
      error.value = 'Error al crear el usuario: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> authenticate(String name, String password) async {
    isLoading.value = true;
    error.value = null;

    try {
      final result = await getUserUsecase(name);

      if (BCrypt.checkpw(password, result.password)) {
        currentUser.value = result;
        return true;
      } else {
        error.value = 'Contraseña incorrecta';
        return false;
      }
    } catch (e) {
      error.value = 'Usuario no encontrado: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}