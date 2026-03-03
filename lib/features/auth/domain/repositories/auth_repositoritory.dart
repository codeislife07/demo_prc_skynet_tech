import 'package:demo_prc_skynet_tech/features/auth/entity/user.dart';

abstract class AuthRepositoritory {
  Future<User?> login(String email, String password);
  Future<User?> register(String email, String password);
}
