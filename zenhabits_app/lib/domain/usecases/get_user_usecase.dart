import 'package:zenhabits_app/data/local/model/user_model.dart';
import 'package:zenhabits_app/data/local/repositories/users_repository.dart';
import 'package:zenhabits_app/domain/model/user.dart';

class GetUserUsecase {
  final UserRepository repository;

  GetUserUsecase ({required this.repository});

  UserModel _toUserModel(User user) {
    return UserModel(
      name: user.name,
      email: user.email,
      passwordHash: user.password
    );
  }

  User _toUser(UserModel user) {
    return User(
      name: user.name,
      email: user.email,
      password: user.passwordHash
    );
  }

  Future<User> call(User user) async {
    try {
      final userModel = _toUserModel(user);
      final result = await repository.getUserById(userModel);
      final finalUser = _toUser(result!);
      return finalUser;
    } catch (e) {
      throw Exception('Error al encontrar al usuario: ${e.toString()}');
    }
  }
}