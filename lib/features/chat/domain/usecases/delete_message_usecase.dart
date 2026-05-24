import 'package:shule_direct/core/constants/import_files.dart';

class DeleteMessageUsecase {
  final ChatRepository repository;
  DeleteMessageUsecase(this.repository);

  Future<ApiResponse<void>> call(int messageId) {
    return repository.deleteMessage(messageId);
  }
}
