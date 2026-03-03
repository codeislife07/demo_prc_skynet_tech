import 'dart:async';

import 'package:demo_prc_skynet_tech/features/auth/domain/repositories/auth_repositoritory.dart';
import 'package:demo_prc_skynet_tech/features/auth/presentation/bloc/auth_event.dart';
import 'package:demo_prc_skynet_tech/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoritory repositoritory;
  AuthBloc(this.repositoritory) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<RegisterEvent>(_onRegisterEvent);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await repositoritory.login(event.email, event.password);
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        throw Exception('InValid Login');
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegisterEvent(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await repositoritory.register(event.email, event.password);
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        throw Exception('Unable to register. Email may already be in use.');
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
