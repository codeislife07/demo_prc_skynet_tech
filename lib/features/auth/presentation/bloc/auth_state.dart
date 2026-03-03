import 'package:demo_prc_skynet_tech/features/auth/entity/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess({required this.user});
}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}
