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
      logger.i("User inserted: ${user.name}");
    } catch (e) {
      logger.e("Error inserting user ${user.name}: $e");
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
      logger.i("User updated: ${user.name}");
    } catch (e) {
      logger.e("Error updating user ${user.name}: $e");
    }
  }

  Future<UserModel?> getUserByName(String name) async {
    try {
      final userEntity = await userDao.findUserByName(name);
      if (userEntity != null) {
        logger.i("User found: $name");
        return UserModel(
          userId: userEntity.userId,
          name: userEntity.name,
          email: userEntity.email,
          passwordHash: userEntity.passwordHash,
        );
      } else {
        logger.w("User not found: $name");
        return null;
      }
    } catch (e) {
      logger.e("Error fetching user $name: $e");
      rethrow;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final users = await userDao.findAllUsers();
      logger.i("Fetched ${users.length} users");
      return users.map((user) => UserModel(
        userId: user.userId,
        name: user.name,
        email: user.email,
        passwordHash: user.passwordHash,
      )).toList();
    } catch (e) {
      logger.e("Error fetching all users: $e");
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
      logger.i("User deleted: ${user.name}");
    } catch (e) {
      logger.e("Error deleting user ${user.name}: $e");
    }
  }
}
