import 'package:shule_direct/core/constants/import_files.dart';
import 'package:shule_direct/features/chat/data/models/message_model.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMessagesUsecase getMessagesUsecase;
  final SendMessageUsecase sendMessageUsecase;
  final DeleteMessageUsecase deleteMessageUsecase;
  final ChatWebSocketDataSource webSocketDataSource;
  final SecureStorage secureStorage;
  StreamSubscription? _wsSubscription;
  static const int _initialLimit = 50;
  static const int _pageLimit = 20;
  int _conversationId = 0;
  int _totalCount = 0;
  int _windowStartOffset = 0;
  String _currentUserEmail = '';
  String? _activeOrdering;
  final Set<int> _deletedMessageIds = {};
  int _pendingTempId = -1;
  bool _isLoadingMore = false;

  ChatCubit({
    required this.getMessagesUsecase,
    required this.sendMessageUsecase,
    required this.deleteMessageUsecase,
    required this.webSocketDataSource,
    required this.secureStorage,
  }) : super(const ChatInitial());
  Future<void> init(int conversationId) async {
    _conversationId = conversationId;
    _totalCount = 0;
    _windowStartOffset = 0;
    _activeOrdering = null;
    _isLoadingMore = false;
    _deletedMessageIds
      ..clear()
      ..addAll(await secureStorage.getDeletedMessageIds(conversationId));
    _currentUserEmail = (await secureStorage.getEmail())?.trim() ?? '';
    emit(const ChatLoading());
    await _loadLatestMessages();
    await _connectWebSocket();
  }

  Future<void> _loadLatestMessages() async {
    try {
      final probe = await _fetchMessages(limit: 1, offset: 0);
      if (!probe.success) {
        emit(ChatError(probe.message ?? 'Failed to load messages'));
        return;
      }
      _totalCount = probe.totalCount ?? probe.data?.length ?? 0;
      if (_totalCount == 0) {
        emit(const ChatLoaded(messages: [], hasMore: false));
        return;
      }
      final limit = _totalCount > _initialLimit ? _initialLimit : _totalCount;
      _windowStartOffset = _totalCount > limit ? _totalCount - limit : 0;
      await _loadMessages(
        limit: limit,
        offset: _windowStartOffset,
        replace: true,
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  List<MessageModel> _withoutDeleted(List<MessageModel> messages) {
    return messages
        .where((m) => m.id <= 0 || !_deletedMessageIds.contains(m.id))
        .toList();
  }

  Future<ApiResponse<List<MessageEntity>>> _fetchMessages({
    required int limit,
    required int offset,
  }) async {
    final orderings = <String?>[
      _activeOrdering,
      '-created_at',
      '-timestamp',
      null,
    ];
    for (final ordering in orderings) {
      if (ordering != null && ordering.isEmpty) continue;
      if (_activeOrdering != null &&
          ordering != _activeOrdering &&
          ordering != null) {
        continue;
      }
      final res = await getMessagesUsecase(
        conversationId: _conversationId,
        limit: limit,
        offset: offset,
        ordering: ordering,
      );
      if (res.success) {
        _activeOrdering = ordering;
        return res;
      }
    }
    return ApiResponse.failure(message: 'Failed to load messages');
  }

  List<MessageModel> _sortOldestFirst(List<MessageEntity> messages) {
    final list = messages.whereType<MessageModel>().toList();
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  List<MessageModel> _mergeUnique(List<MessageEntity> messages) {
    final sorted = _sortOldestFirst(messages);
    final seenIds = <int>{};
    final result = <MessageModel>[];
    for (final m in sorted) {
      if (m.id > 0) {
        if (seenIds.contains(m.id)) continue;
        seenIds.add(m.id);
        result.add(m);
        continue;
      }
      final isDup = result.any(
        (r) =>
            r.id <= 0 &&
            r.content == m.content &&
            r.isMe == m.isMe &&
            r.createdAt.difference(m.createdAt).inSeconds.abs() < 30,
      );
      if (!isDup) result.add(m);
    }
    return result;
  }

  Future<void> _loadMessages({
    required int limit,
    required int offset,
    bool replace = false,
    bool appendOlder = false,
  }) async {
    try {
      final res = await _fetchMessages(limit: limit, offset: offset);
      if (res.success) {
        final batch = _withoutDeleted(_sortOldestFirst(res.data ?? []));
        if (res.totalCount != null) {
          _totalCount = res.totalCount!;
        }
        final current = state;
        final hasMoreOlder = _windowStartOffset > 0;
        if (appendOlder && current is ChatLoaded) {
          emit(current.copyWith(
            messages: _mergeUnique([...batch, ...current.messages]),
            hasMore: hasMoreOlder,
            isLoadingMore: false,
          ));
        } else if (replace || current is! ChatLoaded) {
          emit(ChatLoaded(
            messages: batch,
            hasMore: hasMoreOlder,
          ));
        }
      } else if (!appendOlder) {
        emit(ChatError(res.message ?? 'Failed to load messages'));
      } else {
        final current = state;
        if (current is ChatLoaded) {
          emit(current.copyWith(isLoadingMore: false));
        }
      }
    } catch (e) {
      if (!appendOlder) {
        emit(ChatError(e.toString()));
      } else {
        final current = state;
        if (current is ChatLoaded) {
          emit(current.copyWith(isLoadingMore: false));
        }
      }
    }
  }

  Future<void> loadMoreMessages() async {
    if (_isLoadingMore || _windowStartOffset <= 0) return;
    final current = state;
    if (current is! ChatLoaded || !current.hasMore) return;
    _isLoadingMore = true;
    emit(current.copyWith(isLoadingMore: true));
    final nextOffset =
        (_windowStartOffset - _pageLimit).clamp(0, _windowStartOffset);
    final fetchLimit = _windowStartOffset - nextOffset;
    if (fetchLimit <= 0) {
      _isLoadingMore = false;
      emit(current.copyWith(isLoadingMore: false, hasMore: false));
      return;
    }
    _windowStartOffset = nextOffset;
    await _loadMessages(
      limit: fetchLimit,
      offset: nextOffset,
      appendOlder: true,
    );
    _isLoadingMore = false;
  }

  Future<void> _connectWebSocket() async {
    await _wsSubscription?.cancel();
    _wsSubscription = null;
    final token = await secureStorage.getToken() ?? '';
    final stream = webSocketDataSource.connect(
      conversationId: _conversationId,
      token: token,
    );
    _wsSubscription = stream.listen(_handleWebSocketMessage);
  }

  void _handleWebSocketMessage(Map<String, dynamic> data) {
    final current = state;
    if (current is! ChatLoaded) return;
    try {
      final raw = MessageModel.unwrapPayload(data);
      if (raw == null) return;
      var message = MessageModel.fromJson(raw, _currentUserEmail);
      if (_deletedMessageIds.contains(message.id)) return;
      if (_shouldSkipMessage(message)) return;
      if (!message.isMe) {
        final minePending = current.messages.any(
          (m) =>
              m.isMe &&
              m.content.trim() == message.content.trim() &&
              m.createdAt.difference(message.createdAt).inSeconds.abs() < 120,
        );
        if (minePending) message = message.copyWith(isMe: true);
      }
      final latest = state;
      if (latest is ChatLoaded) {
        _addOrUpdateMessage(latest, message);
      }
    } catch (_) {}
  }

  bool _shouldSkipMessage(MessageModel message) {
    if (message.type == 'system') return false;
    return message.content.trim().isEmpty;
  }

  void _addOrUpdateMessage(
    ChatLoaded current,
    MessageModel message, {
    int? removePendingId,
  }) {
    if (message.id > 0 && _deletedMessageIds.contains(message.id)) return;
    var messages = List<MessageModel>.from(
      current.messages.whereType<MessageModel>(),
    );
    final pendingId = removePendingId ?? _pendingTempId;
    if (pendingId != 0) {
      messages.removeWhere((m) => m.id == pendingId);
    }
    final byId = messages.indexWhere((m) => m.id > 0 && m.id == message.id);
    if (byId >= 0) {
      messages[byId] = message.isMe || !messages[byId].isMe
          ? message
          : message.copyWith(isMe: messages[byId].isMe);
      final latest = state;
      if (latest is ChatLoaded) {
        emit(latest.copyWith(messages: _mergeUnique(messages)));
      }
      return;
    }
    final dupIndex = messages.indexWhere(
      (m) =>
          m.content.trim() == message.content.trim() &&
          m.isMe == message.isMe &&
          (m.id <= 0 ||
              message.id <= 0 ||
              m.createdAt.difference(message.createdAt).inSeconds.abs() < 60),
    );
    if (dupIndex >= 0) {
      messages[dupIndex] = message.id > 0
          ? message
          : messages[dupIndex].copyWith(
              content: message.content,
              isMe: message.isMe || messages[dupIndex].isMe,
            );
      final latest = state;
      if (latest is ChatLoaded) {
        emit(latest.copyWith(messages: _mergeUnique(messages)));
      }
      return;
    }
    messages.add(message);
    final latest = state;
    if (latest is ChatLoaded) {
      emit(latest.copyWith(messages: _mergeUnique(messages)));
    }
  }

  Future<String?> sendMessage({
    required String content,
    int? replyTo,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return 'Message cannot be empty.';
    final current = state;
    if (current is! ChatLoaded) {
      return 'Chat is not ready. Please wait and try again.';
    }
    if (_conversationId <= 0) {
      return 'Invalid conversation. Go back and open the chat again.';
    }
    MessageEntity? replyTarget = current.replyingTo;
    var targetId = replyTo ?? current.replyingTo?.id;
    if (targetId != null && targetId > 0) {
      for (final m in current.messages) {
        if (m.id == targetId) {
          replyTarget = m;
          break;
        }
      }
    } else if (targetId != null && targetId <= 0) {
      targetId = null;
      replyTarget = null;
    }
    final replyId = targetId;
    final pending = MessageModel(
      id: _pendingTempId - 1,
      conversationId: _conversationId,
      content: trimmed,
      type: 'text',
      senderName: 'You',
      isMe: true,
      createdAt: DateTime.now(),
      replyTo: replyTarget,
    );
    final pendingId = pending.id;
    _pendingTempId = pendingId;
    emit(current.copyWith(
      messages: _mergeUnique([...current.messages, pending]),
      clearReply: true,
    ));
    try {
      final res = await sendMessageUsecase(
        conversationId: _conversationId,
        content: trimmed,
        type: 'text',
        replyTo: replyId,
      );
      final loaded = state;
      if (loaded is! ChatLoaded) {
        return 'Chat is not ready. Please try again.';
      }
      if (res.success && res.data != null) {
        var data = res.data!;
        if (data is MessageModel && !data.isMe) {
          data = data.copyWith(isMe: true);
        }
        final afterSend = state;
        if (afterSend is ChatLoaded) {
          _addOrUpdateMessage(
            afterSend,
            data as MessageModel,
            removePendingId: pendingId,
          );
        }
        return null;
      }
      final withoutPending =
          loaded.messages.where((m) => m.id != pendingId).toList();
      emit(loaded.copyWith(messages: withoutPending));
      return res.message ?? 'Failed to send message.';
    } catch (_) {
      final loaded = state;
      if (loaded is ChatLoaded) {
        final withoutPending =
            loaded.messages.where((m) => m.id != pendingId).toList();
        emit(loaded.copyWith(messages: withoutPending));
      }
      return 'Failed to send message. Please try again.';
    }
  }

  Future<void> deleteMessage(int messageId) async {
    if (messageId <= 0) return;
    final current = state;
    if (current is! ChatLoaded) return;
    final previous = List<MessageEntity>.from(current.messages);
    final updated =
        previous.where((m) => m.id != messageId).toList(growable: false);
    _deletedMessageIds.add(messageId);
    emit(current.copyWith(messages: updated));
    try {
      final res = await deleteMessageUsecase(messageId);
      if (res.success) {
        await secureStorage.addDeletedMessageId(_conversationId, messageId);
      } else {
        _deletedMessageIds.remove(messageId);
        emit(current.copyWith(messages: previous));
      }
    } catch (_) {
      _deletedMessageIds.remove(messageId);
      emit(current.copyWith(messages: previous));
    }
  }

  void setReplyingTo(MessageEntity message) {
    if (message.id <= 0 || message.type == 'system') return;
    final current = state;
    if (current is ChatLoaded) {
      emit(current.copyWith(replyingTo: message));
    }
  }

  void clearReply() {
    final current = state;
    if (current is ChatLoaded) {
      emit(current.copyWith(clearReply: true));
    }
  }

  @override
  Future<void> close() async {
    await _wsSubscription?.cancel();
    _wsSubscription = null;
    webSocketDataSource.dispose();
    return super.close();
  }
}
