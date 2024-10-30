import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/cupertino.dart';
import '../../../../core/data/database_instance.dart';
import '../../../../core/di/locator.dart';
import '../../../domain/model/chat_message.dart';
import '../../exceptions/local_database_exception.dart';

abstract class ConversationDao {
  Future<void> addMessageToConversation(ChatMessage message);
  Future<List<ChatMessage>> getAllMessagesFromConversation();
  Future<List<ChatMessage>> getMessagesFromConversationByYeeguideId(
      String yeeguideId);
}

class ConversationDaoImpl implements ConversationDao {
  // /!\ Je te recommande d'ajouter le champ "conversation_id" et de le laisser à "default" même
  // même si ce n'est pas encore géré, ça t'évitera de galérer à faire la migration dans le futur.

  @override
  Future<void> addMessageToConversation(ChatMessage message) async {
    sql.Database database =
        await locator.get<AppLocalDatabase>().getOrCreateDatabase;

    try {
      await database.insert('conversation', {
        'content': message.message,
        'yeeguide_id': message.yeeguideId,
        'is_user_message': message is HumanChatMessage ? 1 : 0,
        'run_id': null, // Vous pouvez ajouter un run_id ici si nécessaire
        'creation_date': message.formattedCreationDate(),
      });
    } catch (error) {
      debugPrint('An error occurred in addMessageToConversation: $error');
      throw LocalDatabaseException('addMessageToConversation');
    }
  }

  @override
  Future<List<ChatMessage>> getAllMessagesFromConversation() async {
    sql.Database database =
        await locator.get<AppLocalDatabase>().getOrCreateDatabase;

    try {
      final maps = await database.query(
        'conversation',
        orderBy: 'creation_date ASC', // Trier par date de création
      );

      return maps.map((map) {
        final isUserMessage = map['is_user_message'] == 1;
        final message = map['content'] as String;
        final creationDate = DateTime.parse(map['creation_date'] as String);
        final yeeguideId = map['yeeguide_id'] as String;

        if (isUserMessage) {
          return HumanChatMessage(
              message: message, conversationId: '', yeeguideId: yeeguideId)
            ..creationDate = creationDate;
        } else {
          // final yeeguideId = map['yeeguide_id'] as String?;
          return AIChatMessage(
              message: message, conversationId: '', yeeguideId: yeeguideId)
            ..creationDate = creationDate;
        }
      }).toList();
    } catch (error) {
      debugPrint('An error occurred in getAllMessagesFromConversation: $error');
      throw LocalDatabaseException('getAllMessagesFromConversation');
    }
  }

  Future<List<ChatMessage>> getMessagesFromConversationByYeeguideId(
      String yeeguideId) async {
    final database = await locator.get<AppLocalDatabase>().getOrCreateDatabase;

    try {
      final maps = await database.query(
        'conversation',
        where: 'yeeguide_id = ?', // Filtrer par yeeguide_id
        // where: 'is_user_message = 0 AND yeeguide_id = ? OR is_user_message = 1',
        whereArgs: [yeeguideId],
        orderBy: 'creation_date ASC', // Trier par date de création
      );

      return maps.map((_map) {
        final isUserMessage = _map['is_user_message'] == 1;
        final message = _map['content'] as String;
        final creationDate = DateTime.parse(_map['creation_date'] as String);
        final yeeguideId = _map['yeeguide_id'] as String;

        if (isUserMessage) {
          return HumanChatMessage(
              message: message, conversationId: '', yeeguideId: yeeguideId)
            ..creationDate = creationDate;
        } else {
          // final yeeguideId = _map['yeeguide_id'] as String?;
          return AIChatMessage(
              message: message, conversationId: '', yeeguideId: yeeguideId)
            ..creationDate = creationDate;
        }
      }).toList();
    } catch (error) {
      debugPrint(
          'An error occurred in getMessagesFromConversationByYeeguideId: $error');
      throw LocalDatabaseException('getMessagesFromConversationByYeeguideId');
    }
  }
}
