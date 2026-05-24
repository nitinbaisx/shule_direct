import 'package:shule_direct/features/conversation/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.id,
    required super.name,
    required super.lastMessage,
    required super.lastMessageTime,
    super.avatarUrl,
    super.isOnline,
    super.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final lastMsg = json['last_message'];
    String lastMsgText = '';
    String lastMsgTime = json['last_message_time']?.toString() ?? '';

    if (lastMsg != null && lastMsg is Map) {
      lastMsgText = lastMsg['content']?.toString() ?? '';
      lastMsgTime = lastMsg['created_at']?.toString() ?? lastMsgTime;
    }

    return ConversationModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      lastMessage: lastMsgText,
      lastMessageTime: lastMsgTime,
      avatarUrl: json['avatar_url']?.toString() ??
          json['avatar']?.toString() ??
          json['image']?.toString(),
      isOnline: json['is_online'] == true,
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
    );
  }
}
