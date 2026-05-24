import 'package:shule_direct/core/constants/import_files.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase loginUsecase;

  AuthCubit(this.loginUsecase) : super(const AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      emit(const AuthError('Email and password are required.'));
      return;
    }

    try {
      emit(const AuthLoading());
      final res = await loginUsecase(email: email, password: password);

      if (res.success) {
        emit(const AuthSuccess());
      } else {
        emit(AuthError(res.message ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void reset() => emit(const AuthInitial());
}
