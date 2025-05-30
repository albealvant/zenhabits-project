import 'package:zenhabits_app/data/local/model/user_model.dart';
import 'package:zenhabits_app/data/local/repositories/users_repository.dart';
import 'package:zenhabits_app/domain/model/user.dart';

class GetUserUsecase {
  final UserRepository repository;

  GetUserUsecase ({required this.repository});

  User _toUser(UserModel user) {
    return User(
      userId: user.userId,
      name: user.name,
      email: user.email,
      password: user.passwordHash
    );
  }

Future<User> call(String name) async {
    try {
      final result = await repository.getUserByName(name);
      if (result == null) {
        throw Exception('Usuario no encontrado');
      }
      final finalUser = _toUser(result);
      return finalUser;
    } catch (e) {
      throw Exception('Error al encontrar al usuario: ${e.toString()}');
    }
  }
}