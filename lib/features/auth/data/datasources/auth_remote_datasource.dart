import 'package:shule_direct/core/constants/import_files.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl(this.apiService);

  @override
  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  }) {
    return apiService.login(email: email, password: password);
  }
}
