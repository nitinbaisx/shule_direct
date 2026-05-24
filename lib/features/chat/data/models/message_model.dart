import 'package:shule_direct/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.conversationId,
    required super.content,
    required super.type,
    required super.senderName,
    super.senderAvatar,
    required super.isMe,
    required super.createdAt,
    super.replyTo,
  });

  static Map<String, dynamic>? unwrapPayload(Map<String, dynamic> data) {
    final eventType = data['event']?.toString() ?? data['action']?.toString();
    if (eventType == 'typing' ||
        eventType == 'ping' ||
        eventType == 'pong' ||
        eventType == 'connection') {
      return null;
    }

    final nested = data['message'];
    if (nested is Map) {
      return Map<String, dynamic>.from(nested);
    }

    final inner = data['data'];
    if (inner is Map) {
      final map = Map<String, dynamic>.from(inner);
      if (map['message'] is Map) {
        return Map<String, dynamic>.from(map['message'] as Map);
      }
      if (map['id'] != null || map['content'] != null) {
        return map;
      }
    }

    if (data['id'] != null || data['content'] != null) {
      return data;
    }

    return null;
  }

  factory MessageModel.fromJson(
    Map<String, dynamic> json,
    String currentUserEmail,
  ) {
    MessageEntity? replyMsg;
    final replyDetail = json['reply_to_detail'];
    final replyRaw = replyDetail is Map ? replyDetail : null;
    if (replyRaw != null) {
      replyMsg = MessageModel.fromJson(
        Map<String, dynamic>.from(replyRaw),
        currentUserEmail,
      );
    }

    final sender = json['sender'];
    final senderEmail = _senderEmail(sender);
    final senderName = _senderName(sender);
    final senderAvatar = sender is Map
        ? (sender['profile_pic'] ??
                sender['avatar'] ??
                sender['profile_picture'])
            ?.toString()
        : null;

    final timeStr =
        json['timestamp'] ?? json['created_at'] ?? json['createdAt'] ?? '';

    final content = json['content']?.toString() ??
        json['message']?.toString() ??
        json['text']?.toString() ??
        json['body']?.toString() ??
        '';

    return MessageModel(
      id: _parseInt(json['id']) ?? 0,
      conversationId: _parseInt(json['conversation']) ??
          _parseInt(json['conversation_id']) ??
          0,
      content: content,
      type: json['type']?.toString() ?? 'text',
      senderName: senderName,
      senderAvatar: senderAvatar,
      isMe: _resolveIsMe(json, senderEmail, currentUserEmail),
      createdAt: DateTime.tryParse(timeStr.toString()) ?? DateTime.now(),
      replyTo: replyMsg,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static String _senderEmail(dynamic sender) {
    if (sender is Map) {
      return (sender['email'] ?? sender['username'])?.toString() ?? '';
    }
    return '';
  }

  static String _senderName(dynamic sender) {
    if (sender is Map) {
      return (sender['name'] ??
              sender['display_name'] ??
              sender['username'] ??
              'Unknown')
          .toString();
    }
    return 'Unknown';
  }

  static bool _resolveIsMe(
    Map<String, dynamic> json,
    String senderEmail,
    String currentUserEmail,
  ) {
    if (json['is_me'] == true ||
        json['is_mine'] == true ||
        json['is_sender'] == true) {
      return true;
    }
    if (currentUserEmail.isNotEmpty && senderEmail.isNotEmpty) {
      return senderEmail.toLowerCase().trim() ==
          currentUserEmail.toLowerCase().trim();
    }
    final senderJson = json['sender'];
    final senderUsername = senderJson is Map
        ? (senderJson['username'] ?? senderJson['display_name'])?.toString() ??
            ''
        : '';
    if (currentUserEmail.isNotEmpty && senderUsername.isNotEmpty) {
      return senderUsername.toLowerCase().trim() ==
          currentUserEmail.toLowerCase().trim();
    }
    return false;
  }

  MessageModel copyWith({
    int? id,
    String? content,
    bool? isMe,
    String? senderName,
    MessageEntity? replyTo,
    bool clearReplyTo = false,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId,
      content: content ?? this.content,
      type: type,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar,
      isMe: isMe ?? this.isMe,
      createdAt: createdAt,
      replyTo: clearReplyTo ? null : (replyTo ?? this.replyTo),
    );
  }
}
