import 'package:zenhabits_app/core/constants/local_errors.dart';
import 'package:zenhabits_app/core/constants/local_messages.dart';
import 'package:zenhabits_app/core/utils/logger.dart';
import 'package:zenhabits_app/data/model/user_model.dart';
import 'package:zenhabits_app/data/repositories/users_repository.dart';
import 'package:zenhabits_app/domain/model/user.dart';

class InsertUserUseCase {
  final UserRepository repository;

  InsertUserUseCase({required this.repository});

  UserModel _toUserModel(User user) {
    return UserModel(
      name: user.name,
      email: user.email,
      passwordHash: user.password,
    );
  }

  Future<void> call(User user) async {
    try {
      final userModel = _toUserModel(user);
      await repository.insertUser(userModel);
      logger.i(LocalLogMessages.userInserted(user.name));
    } catch (e) {
      logger.e(LocalErrors.insertUser(user.name, e.toString()));
      throw Exception('Error al crear la cuenta de usuario: ${e.toString()}');
    }
  }
}