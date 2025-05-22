import 'package:zenhabits_app/data/local/model/user_model.dart';
import 'package:zenhabits_app/data/local/repositories/users_repository.dart';
import 'package:zenhabits_app/domain/model/user.dart';

class InsertUserUseCase {
  final UserRepository repository;

  InsertUserUseCase({required this.repository});

  Future<void> call(User user) async {
    try {
      await repository.insertUser(user as UserModel);
    } catch (e) {
      throw Exception('Error al crear la cuenta de usuario: ${e.toString()}');
    }
  }
}