import 'package:shule_direct/core/constants/import_files.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSource remoteDataSource;

  ConversationRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResponse<List<ConversationEntity>>> getConversations() async {
    try {
      return await remoteDataSource.getConversations();
    } catch (e) {
      return ApiResponse.failure(message: 'Something went wrong.');
    }
  }
}
