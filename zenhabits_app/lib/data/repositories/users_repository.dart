import 'package:zenhabits_app/data/database/dao/user_dao.dart';
import 'package:zenhabits_app/data/database/entities/user_entity.dart';
import 'package:zenhabits_app/data/model/user_model.dart';

class UserRepository {
  final UserDao userDao;

  UserRepository({required this.userDao});

  Future<void> insertUser(UserModel user) async {
    final userEntity = User(
      null,
      user.name,
      user.email,
      user.passwordHash,
    );
    await userDao.insertUser(userEntity);
  }

  Future<void> updateUser(UserModel user) async {
    final userEntity = User(
      user.userId ?? 0,  
      user.name,
      user.email,
      user.passwordHash,
    );
    await userDao.updateUsuario(userEntity);
  }

  Future<UserModel?> getUserByName(String name) async {
    final userEntity = await userDao.findUserByName(name);
    
    if (userEntity != null) {
      return UserModel(
        userId: userEntity.userId,
        name: userEntity.name,
        email: userEntity.email,
        passwordHash: userEntity.passwordHash,
      );
    } else {
      return null;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    final users = await userDao.findAllUsers();
    return users.map((user) => UserModel(
      userId: user.userId,
      name: user.name,
      email: user.email,
      passwordHash: user.passwordHash,
    )).toList();
  }

  Future<void> deleteUser(UserModel usuario) async {
    final userEntity = User(
      usuario.userId ?? 0,
      usuario.name,
      usuario.email,
      usuario.passwordHash,
    );
    await userDao.deleteUser(userEntity);
  }
}
