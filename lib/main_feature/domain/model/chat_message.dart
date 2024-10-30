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
