import 'package:equatable/equatable.dart';
import 'package:shule_direct/features/chat/domain/entities/message_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  final List<MessageEntity> messages;
  final bool hasMore;
  final bool isLoadingMore;
  final MessageEntity? replyingTo;
  const ChatLoaded({
    required this.messages,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.replyingTo,
  });
  ChatLoaded copyWith({
    List<MessageEntity>? messages,
    bool? hasMore,
    bool? isLoadingMore,
    MessageEntity? replyingTo,
    bool clearReply = false,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      replyingTo: clearReply ? null : (replyingTo ?? this.replyingTo),
    );
  }

  @override
  List<Object?> get props => [messages, hasMore, isLoadingMore, replyingTo];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object?> get props => [message];
}
