import 'package:shule_direct/core/constants/import_files.dart';
import 'package:shule_direct/features/conversation/data/models/conversation_model.dart';

abstract class ConversationRemoteDataSource {
  Future<ApiResponse<List<ConversationModel>>> getConversations();
}

class ConversationRemoteDataSourceImpl implements ConversationRemoteDataSource {
  final ApiService apiService;

  ConversationRemoteDataSourceImpl(this.apiService);

  @override
  Future<ApiResponse<List<ConversationModel>>> getConversations() {
    return apiService.getConversations();
  }
}
