import 'package:shule_direct/core/constants/import_files.dart';

class GetMessagesUsecase {
  final ChatRepository repository;
  GetMessagesUsecase(this.repository);

  Future<ApiResponse<List<MessageEntity>>> call({
    required int conversationId,
    required int limit,
    required int offset,
    String? ordering,
  }) {
    return repository.getMessages(
      conversationId: conversationId,
      limit: limit,
      offset: offset,
      ordering: ordering,
    );
  }
}
