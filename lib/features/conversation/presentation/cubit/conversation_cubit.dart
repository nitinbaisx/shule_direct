import 'package:shule_direct/core/constants/import_files.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final GetConversationsUsecase getConversationsUsecase;

  ConversationCubit(this.getConversationsUsecase)
      : super(const ConversationInitial());

  List<ConversationEntity> _allConversations = [];

  Future<void> loadConversations() async {
    try {
      emit(const ConversationLoading());
      final res = await getConversationsUsecase();

      if (res.success) {
        final list = res.data ?? [];
        _allConversations = list;
        if (list.isEmpty) {
          emit(const ConversationEmpty());
        } else {
          emit(ConversationLoaded(list));
        }
      } else {
        emit(ConversationError(
          res.message ?? 'Failed to load conversations',
        ));
      }
    } catch (e) {
      emit(ConversationError(e.toString()));
    }
  }

  void searchConversation(String query) {
    if (query.trim().isEmpty) {
      emit(ConversationLoaded(_allConversations));
      return;
    }
    final filteredList = _allConversations.where((conversation) {
      return conversation.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (filteredList.isEmpty) {
      emit(const ConversationEmpty());
    } else {
      emit(ConversationLoaded(filteredList));
    }
  }
}
