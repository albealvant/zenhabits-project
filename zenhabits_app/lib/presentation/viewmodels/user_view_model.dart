import 'package:flutter/material.dart';
import 'package:zenhabits_app/domain/model/user.dart';
import 'package:zenhabits_app/domain/usecases/insert_user_usecase.dart';
import 'package:zenhabits_app/domain/usecases/get_user_usecase.dart';

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

  Future<void> getUser(User user) async {
    isLoading.value = true;
    error.value = null;

    try {
      final result = await getUserUsecase(user);
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
      await insertUserUseCase(user);
    } catch (e) {
      error.value = 'Error al crear el usuario: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}