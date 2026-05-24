import 'package:shule_direct/core/constants/import_files.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final SecureStorage secureStorage;
  String _currentUserEmail = '';

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  Future<String> _getEmail() async {
    if (_currentUserEmail.isEmpty) {
      _currentUserEmail = await secureStorage.getEmail() ?? '';
    }
    return _currentUserEmail;
  }

  @override
  Future<ApiResponse<List<MessageEntity>>> getMessages({
    required int conversationId,
    required int limit,
    required int offset,
    String? ordering,
  }) async {
    try {
      final email = await _getEmail();
      return await remoteDataSource.getMessages(
        conversationId: conversationId,
        limit: limit,
        offset: offset,
        currentUserEmail: email,
        ordering: ordering,
      );
    } catch (e) {
      return ApiResponse.failure(message: 'Something went wrong.');
    }
  }

  @override
  Future<ApiResponse<MessageEntity>> sendMessage({
    required int conversationId,
    required String content,
    required String type,
    int? replyTo,
  }) async {
    try {
      final email = await _getEmail();
      return await remoteDataSource.sendMessage(
        conversationId: conversationId,
        content: content,
        type: type,
        currentUserEmail: email,
        replyTo: replyTo,
      );
    } catch (e) {
      return ApiResponse.failure(message: 'Failed to send message.');
    }
  }

  @override
  Future<ApiResponse<void>> deleteMessage(int messageId) async {
    try {
      return await remoteDataSource.deleteMessage(messageId);
    } catch (e) {
      return ApiResponse.failure(message: 'Failed to delete message.');
    }
  }
}
