import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, failure }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());
  final AuthRepository _repository;

  Future<void> login(String username, String password) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      final user = await _repository.login(username: username, password: password);
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } catch (_) {
      emit(const AuthState(
        status: AuthStatus.failure,
        errorMessage: 'Login failed. Check your username and password.',
      ));
    }
  }

  void logout() => emit(const AuthState());
}
