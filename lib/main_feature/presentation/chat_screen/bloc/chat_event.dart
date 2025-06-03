
import '../../../domain/model/chat_message.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class SendMessageByInvoke extends ChatEvent {
  final String message;
  final String yeeguideId;
  final List<List<String>> chatHistory;

  SendMessageByInvoke({required this.message, required this.yeeguideId, required this.chatHistory});
}

class SendMessageByStream extends ChatEvent {
  final String message;
  final String yeeguideId;
  final List<List<String>> chatHistory;


  SendMessageByStream({required this.message, required this.yeeguideId, required this.chatHistory});
}

class AddMessageToHistory extends ChatEvent {
  final ChatMessage chatMessage;

  AddMessageToHistory({required this.chatMessage});
}

class GetAllConvoHistory extends ChatEvent {
  GetAllConvoHistory();
}

class GetAllConvoHistoryByYeeguide extends ChatEvent {
  final String yeeguideId;

  GetAllConvoHistoryByYeeguide({required this.yeeguideId});
}
