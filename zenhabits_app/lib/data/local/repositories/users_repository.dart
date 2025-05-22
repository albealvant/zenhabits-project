import 'package:zenhabits_app/data/local/database/dao/user_dao.dart';
import 'package:zenhabits_app/data/local/database/entities/user_entity.dart';
import 'package:zenhabits_app/data/local/model/user_model.dart';

class UserRepository {
  final UserDao userDao;

  UserRepository({required this.userDao});

  Future<void> insertUser(UserModel user) async {
    final userEntity = User(
      user.idUsuario ?? 0,
      user.nombre,
      user.email,
      user.passwordHash,
    );
    await userDao.insertUser(userEntity);
  }

  Future<void> updateUser(UserModel user) async {
    final userEntity = User(
      user.idUsuario ?? 0,  
      user.nombre,
      user.email,
      user.passwordHash,
    );
    await userDao.updateUsuario(userEntity);
  }

  Future<UserModel?> getUserById(int id) async {
    final user = await userDao.findUserById(id);
    if (user != null) {
      return UserModel(
        idUsuario: user.userId,
        nombre: user.name,
        email: user.email,
        passwordHash: user.passwordHash,
      );
    }
    return null;
  }

  Future<List<UserModel>> getAllUsers() async {
    final users = await userDao.findAllUsers();
    return users.map((user) => UserModel(
      idUsuario: user.userId,
      nombre: user.name,
      email: user.email,
      passwordHash: user.passwordHash,
    )).toList();
  }

  Future<void> deleteUser(UserModel usuario) async {
    final userEntity = User(
      usuario.idUsuario ?? 0,
      usuario.nombre,
      usuario.email,
      usuario.passwordHash,
    );
    await userDao.deleteUser(userEntity);
  }
}
