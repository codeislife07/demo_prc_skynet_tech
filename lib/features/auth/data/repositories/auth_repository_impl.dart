import 'package:demo_prc_skynet_tech/core/database/user_table.dart';
import 'package:demo_prc_skynet_tech/features/auth/domain/repositories/auth_repositoritory.dart';
import 'package:demo_prc_skynet_tech/features/auth/entity/user.dart';

class AuthRepositoryImpl implements AuthRepositoritory {
  @override
  Future<User?> login(String email, String password) async {
    var user = await UserTable().loginUser(email, password);
    return user;
  }

  @override
  Future<User?> register(String email, String password) async {
    var user = await UserTable().registerUser(email, password);
    return user;
  }
}
