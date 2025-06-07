import 'package:zenhabits_app/core/constants/local_errors.dart';
import 'package:zenhabits_app/core/constants/local_messages.dart';
import 'package:zenhabits_app/core/utils/logger.dart';
import 'package:zenhabits_app/data/database/dao/user_dao.dart';
import 'package:zenhabits_app/data/database/entities/user_entity.dart';
import 'package:zenhabits_app/data/model/user_model.dart';

class UserRepository {
  final UserDao userDao;

  UserRepository({required this.userDao});

  Future<void> insertUser(UserModel user) async {
    try {
      final userEntity = User(
        null,
        user.name,
        user.email,
        user.passwordHash,
      );
      await userDao.insertUser(userEntity);
      logger.i(LocalLogMessages.userInserted(user.name));
    } catch (e) {
      logger.e(LocalErrors.insertUser(user.name, e.toString()));
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      final userEntity = User(
        user.userId ?? 0,
        user.name,
        user.email,
        user.passwordHash,
      );
      await userDao.updateUsuario(userEntity);
      logger.i(LocalLogMessages.userUpdated(user.name));
    } catch (e) {
      logger.e(LocalErrors.updateUser);
    }
  }

  Future<UserModel?> getUserByName(String name) async {
    try {
      final userEntity = await userDao.findUserByName(name);
      if (userEntity != null) {
        logger.i(LocalLogMessages.userFound(name));
        return UserModel(
          userId: userEntity.userId,
          name: userEntity.name,
          email: userEntity.email,
          passwordHash: userEntity.passwordHash,
        );
      } else {
        logger.w(LocalLogMessages.userNotFound(name));
        return null;
      }
    } catch (e) {
      logger.e(LocalErrors.fetchUser);
      rethrow;
    }
  }

  Future<void> deleteUser(UserModel user) async {
    try {
      final userEntity = User(
        user.userId ?? 0,
        user.name,
        user.email,
        user.passwordHash,
      );
      await userDao.deleteUser(userEntity);
      logger.i(LocalLogMessages.userDeleted(user.name));
    } catch (e) {
      logger.e(LocalErrors.deleteUser);
    }
  }
}
