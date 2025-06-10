import '../../../domain/model/chat_message.dart';

class ChatState {
  final List<ChatMessage> messages;
  // final Resource<String>? sendMessageStatus;
  final bool isAIThinking;
  final bool isAIWriting;

  const ChatState({
    this.messages = const [],
    this.isAIThinking = false,
    this.isAIWriting = false,
    // this.sendMessageStatus,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isAIThinking,
    bool? isAIWriting,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
        isAIThinking: isAIThinking ?? this.isAIThinking,
        isAIWriting: isAIWriting ?? this.isAIWriting
      // sendMessageStatus: sendMessageStatus ?? this.sendMessageStatus,
    );
  }
}