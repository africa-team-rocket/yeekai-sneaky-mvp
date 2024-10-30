import '../../../domain/model/chat_message.dart';

class ChatState {
  final List<ChatMessage> messages;
  // final Resource<String>? sendMessageStatus;
  final bool isAITyping;

  const ChatState({
    this.messages = const [],
    this.isAITyping = false,
    // this.sendMessageStatus,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isAITyping,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isAITyping: isAITyping ?? this.isAITyping
      // sendMessageStatus: sendMessageStatus ?? this.sendMessageStatus,
    );
  }
}