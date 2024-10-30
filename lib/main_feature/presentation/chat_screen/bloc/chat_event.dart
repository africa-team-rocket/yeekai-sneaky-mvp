
import '../../../domain/model/chat_message.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class SendMessageByInvoke extends ChatEvent {
  final String message;
  final String yeeguideId;

  SendMessageByInvoke({required this.message, required this.yeeguideId});
}

class SendMessageByStream extends ChatEvent {
  final String message;
  final String yeeguideId;

  SendMessageByStream({required this.message, required this.yeeguideId});
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
