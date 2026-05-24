import 'package:shule_direct/core/constants/import_files.dart';

abstract class ConversationRepository {
  Future<ApiResponse<List<ConversationEntity>>> getConversations();
}
