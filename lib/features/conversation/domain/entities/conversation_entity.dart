import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final int id;
  final String name;
  final String lastMessage;
  final String lastMessageTime;
  final String? avatarUrl;
  final bool isOnline;
  final int unreadCount;

  const ConversationEntity({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    this.avatarUrl,
    this.isOnline = false,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [id, name, lastMessage];
}