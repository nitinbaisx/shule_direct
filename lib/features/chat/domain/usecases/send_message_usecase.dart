import 'package:shule_direct/core/constants/import_files.dart';

class SendMessageUsecase {
  final ChatRepository repository;
  SendMessageUsecase(this.repository);

  Future<ApiResponse<MessageEntity>> call({
    required int conversationId,
    required String content,
    required String type,
    int? replyTo,
  }) {
    return repository.sendMessage(
      conversationId: conversationId,
      content: content,
      type: type,
      replyTo: replyTo,
    );
  }
}
