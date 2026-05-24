import 'package:shule_direct/core/constants/import_files.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object?> get props => [];
}

class ConversationInitial extends ConversationState {
  const ConversationInitial();
}

class ConversationLoading extends ConversationState {
  const ConversationLoading();
}

class ConversationLoaded extends ConversationState {
  final List<ConversationEntity> conversations;
  const ConversationLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class ConversationEmpty extends ConversationState {
  const ConversationEmpty();
}

class ConversationError extends ConversationState {
  final String message;
  const ConversationError(this.message);

  @override
  List<Object?> get props => [message];
}