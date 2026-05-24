import 'package:shule_direct/core/constants/import_files.dart';

class GetConversationsUsecase {
  final ConversationRepository repository;

  GetConversationsUsecase(this.repository);

  Future<ApiResponse<List<ConversationEntity>>> call() {
    return repository.getConversations();
  }
}
