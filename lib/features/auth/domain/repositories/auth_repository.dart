import 'package:shule_direct/core/constants/import_files.dart';

abstract class AuthRepository {
  Future<ApiResponse<UserEntity>> login({
    required String email,
    required String password,
  });
}
