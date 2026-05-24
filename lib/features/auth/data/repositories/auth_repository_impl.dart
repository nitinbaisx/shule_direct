import 'package:shule_direct/core/constants/import_files.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorage secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<ApiResponse<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await remoteDataSource.login(
        email: email,
        password: password,
      );
      if (res.success && res.data != null) {
        await secureStorage.saveToken(res.data!.accessToken);
        final emailToSave =
            res.data!.email.isNotEmpty ? res.data!.email : email.trim();
        if (emailToSave.isNotEmpty) {
          await secureStorage.saveEmail(emailToSave);
        }
      }
      return res;
    } catch (e) {
      return ApiResponse.failure(
        message: 'Something went wrong. Please try again.',
      );
    }
  }
}
