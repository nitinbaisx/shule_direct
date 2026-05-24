import 'package:shule_direct/core/constants/import_files.dart';
import 'package:shule_direct/features/chat/data/models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ApiResponse<List<MessageModel>>> getMessages({
    required int conversationId,
    required int limit,
    required int offset,
    required String currentUserEmail,
    String? ordering,
  });

  Future<ApiResponse<MessageModel>> sendMessage({
    required int conversationId,
    required String content,
    required String type,
    required String currentUserEmail,
    int? replyTo,
  });

  Future<ApiResponse<void>> deleteMessage(int messageId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiService apiService;

  ChatRemoteDataSourceImpl(this.apiService);

  @override
  Future<ApiResponse<List<MessageModel>>> getMessages({
    required int conversationId,
    required int limit,
    required int offset,
    required String currentUserEmail,
    String? ordering,
  }) {
    return apiService.getMessages(
      conversationId: conversationId,
      limit: limit,
      offset: offset,
      currentUserEmail: currentUserEmail,
      ordering: ordering,
    );
  }

  @override
  Future<ApiResponse<MessageModel>> sendMessage({
    required int conversationId,
    required String content,
    required String type,
    required String currentUserEmail,
    int? replyTo,
  }) {
    return apiService.sendMessage(
      conversationId: conversationId,
      content: content,
      type: type,
      currentUserEmail: currentUserEmail,
      replyTo: replyTo,
    );
  }

  @override
  Future<ApiResponse<void>> deleteMessage(int messageId) {
    return apiService.deleteMessage(messageId);
  }
}
