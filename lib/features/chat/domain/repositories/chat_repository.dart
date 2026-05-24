import 'package:shule_direct/core/constants/import_files.dart';

abstract class ChatRepository {
  Future<ApiResponse<List<MessageEntity>>> getMessages({
    required int conversationId,
    required int limit,
    required int offset,
    String? ordering,
  });

  Future<ApiResponse<MessageEntity>> sendMessage({
    required int conversationId,
    required String content,
    required String type,
    int? replyTo,
  });

  Future<ApiResponse<void>> deleteMessage(int messageId);
}
