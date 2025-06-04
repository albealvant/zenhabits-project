import 'package:zenhabits_app/core/utils/logger.dart';
import 'package:zenhabits_app/data/model/user_model.dart';
import 'package:zenhabits_app/data/repositories/habits_repository.dart';
import 'package:zenhabits_app/data/repositories/users_repository.dart';
import 'package:zenhabits_app/domain/model/user.dart';

class GetUserUsecase {
  final UserRepository repository;
  final HabitRepository habitRepository;

  GetUserUsecase({
    required this.repository,
    required this.habitRepository,
  });

  User _toUser(UserModel user) {
    return User(
      userId: user.userId,
      name: user.name,
      email: user.email,
      password: user.passwordHash
    );
  }

  UserModel _toUserModel(User user) {
    return UserModel(
      userId: user.userId,
      name: user.name,
      email: user.email,
      passwordHash: user.password,
    );
  }

  Future<User> call(String name) async {
    try {
      final result = await repository.getUserByName(name);
      if (result == null) {
        throw Exception('Usuario no encontrado');
      }

      final finalUser = _toUser(result);

      // ✅ Sincronizar hábitos una vez obtenido el usuario
      await habitRepository.syncHabitsFromRemote(_toUserModel(finalUser));
      logger.i("Remote habits synced after fetching user ${finalUser.name}");

      return finalUser;
    } catch (e) {
      logger.e("Error getting user");
      throw Exception('Error al encontrar al usuario: ${e.toString()}');
    }
  }
}