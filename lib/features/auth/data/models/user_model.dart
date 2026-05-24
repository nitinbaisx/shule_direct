import 'package:shule_direct/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.accessToken,
    required super.refreshToken,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      accessToken: json['access'] ?? json['access_token'] ?? '',
      refreshToken: json['refresh'] ?? json['refresh_token'] ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  factory UserModel.fromLoginResponse({
    required Map<String, dynamic>? body,
    String? authorizationHeader,
    String? refreshTokenHeader,
  }) {
    final accessToken = _tokenFromHeader(authorizationHeader) ??
        (body != null ? UserModel.fromJson(body).accessToken : '');
    final refreshToken = refreshTokenHeader?.trim() ?? '';
    final user = _userMapFromBody(body);
    return UserModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      email: user?['email']?.toString() ?? '',
    );
  }

  static String? _tokenFromHeader(String? header) {
    if (header == null || header.isEmpty) return null;
    const prefix = 'Bearer ';
    if (header.startsWith(prefix)) {
      return header.substring(prefix.length).trim();
    }
    return header.trim();
  }

  static Map<String, dynamic>? _userMapFromBody(Map<String, dynamic>? body) {
    if (body == null) return null;
    final data = body['data'];
    if (data is Map<String, dynamic>) {
      final user = data['user'];
      if (user is Map<String, dynamic>) return user;
    }
    return body;
  }
}
