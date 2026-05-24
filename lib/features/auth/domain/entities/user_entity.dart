import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String email;

  const UserEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.email,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, email];
}