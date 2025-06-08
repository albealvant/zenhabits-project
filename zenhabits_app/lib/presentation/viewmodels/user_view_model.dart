import 'package:flutter/material.dart';
import 'package:zenhabits_app/core/utils/logger.dart';
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

  Future<User?> getUser(String name) async {
    isLoading.value = true;
    error.value = null;
    logger.i("Fetching user: $name");

    try {
      final result = await getUserUsecase(name);
      currentUser.value = result;
      logger.i("User fetched: ${result.name}");
      return result;
    } catch (e) {
      logger.e("Error fetching user: $e");
      error.value = 'Error al obtener usuario: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> createUser(User user) async {
    isLoading.value = true;
    error.value = null;
    logger.i("Creating user: ${user.name}");

    try {
      final hashedPassword = BCrypt.hashpw(user.password, BCrypt.gensalt());
      final userWithHash = User(
        name: user.name,
        email: user.email,
        password: hashedPassword,
      );

      await insertUserUseCase(userWithHash);
      logger.i("User created: ${user.name}");
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('unique') || errorMessage.contains('duplicate')) {
        error.value = 'El nombre de usuario ya está en uso.';
        logger.w("Duplicate username: ${user.name}");
      } else {
        error.value = 'Error al crear el usuario: ${e.toString()}';
        logger.e("Error creating user: $e");
      }
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