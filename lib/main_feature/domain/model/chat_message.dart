import 'package:intl/intl.dart';

// Classe abstraite représentant un message dans un chat
abstract class ChatMessage {
  String message;
  String conversationId;
  String yeeguideId; // déplacer yeeguideId ici
  late DateTime creationDate;

  // Constructeur
  ChatMessage({
    required this.message,
    required this.conversationId,
    required this.yeeguideId, // ajouter yeeguideId ici
  }) {
    creationDate = DateTime.now();
  }

  // Méthode pour formater la date et l'heure d'envoi du message
  String formattedCreationDate() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(creationDate);
  }

  // Méthode abstraite copyWith
  ChatMessage copyWith({
    String? message,
    String? conversationId,
    String? yeeguideId,
  });

  // Méthode utilitaire pour transformer une liste de messages en chat_history
  static List<List<String>> toChatHistory(List<ChatMessage> messages, {int limit = 3}) {
    final chatHistory = <List<String>>[];

    for (int i = 0; i < messages.length - 1; i++) {
      final userMessage = messages[i];
      final nextMessage = messages[i + 1];

      if (userMessage is HumanChatMessage && nextMessage is AIChatMessage) {
        chatHistory.add([userMessage.message, nextMessage.message]);
        i++; // On saute le suivant car on l’a déjà traité
      }
    }


    // Garder uniquement les dernières `limit` interactions
    final start = chatHistory.length > limit ? chatHistory.length - limit : 0;
    return chatHistory.sublist(start);
  }

}

// Classe représentant un message de l'IA
class AIChatMessage extends ChatMessage {
  // Constructeur
  AIChatMessage({
    required String message,
    required String conversationId,
    required String yeeguideId,
  }) : super(
          message: message,
          conversationId: conversationId,
          yeeguideId: yeeguideId,
        );

  // Méthode copyWith
  @override
  AIChatMessage copyWith({
    String? message,
    String? conversationId,
    String? yeeguideId,
  }) {
    return AIChatMessage(
      message: message ?? this.message,
      conversationId: conversationId ?? this.conversationId,
      yeeguideId: yeeguideId ?? this.yeeguideId,
    );
  }
}

// Classe représentant un message de l'humain
class HumanChatMessage extends ChatMessage {
  // Constructeur
  HumanChatMessage({
    required String message,
    required String conversationId,
    required String yeeguideId,
  }) : super(
          message: message,
          conversationId: conversationId,
          yeeguideId: yeeguideId,
        );

  // Méthode copyWith
  @override
  HumanChatMessage copyWith({
    String? message,
    String? conversationId,
    String? yeeguideId,
  }) {
    return HumanChatMessage(
      message: message ?? this.message,
      conversationId: conversationId ?? this.conversationId,
      yeeguideId: yeeguideId ?? this.yeeguideId,
    );
  }
}
