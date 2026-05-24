import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final int id;
  final int conversationId;
  final String content;
  final String type;
  final String senderName;
  final String? senderAvatar;
  final bool isMe;
  final DateTime createdAt;
  final MessageEntity? replyTo;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.type,
    required this.senderName,
    this.senderAvatar,
    required this.isMe,
    required this.createdAt,
    this.replyTo,
  });

  @override
  List<Object?> get props => [id, content, createdAt];
}