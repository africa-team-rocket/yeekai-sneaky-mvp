import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../core/commons/utils/resource.dart';
import '../../../core/di/locator.dart';
import '../../domain/model/chat_message.dart';
import '../../domain/model/yeeguide_response.dart';
import '../../domain/repository/yeebot_repo.dart';
import '../local/dao/conversation_dao.dart';
import '../remote/api/yeebot_api.dart';

class YeebotRepoImpl extends YeebotRepo {
  final YeebotApi _yeebotApi = locator.get<YeebotApi>();
  final ConversationDao _convoDao = locator.get<ConversationDao>();

  // /!\ Petite précision sur les try catch dans les repository :
  // Tu n'as pas besoin d'en faire.
  // Ils ont déjà été catched et thrown depuis l'api/le dao ce qui les a contextualisé.
  // Si tu les rechatch ici tu vas simplement les rethrow ce qui serait inutile.
  // Laisse les se propager, une fois dans le use-case, tu pourras les catch et gérer comme il se doit.

  // Et ceci lève un doute en moi, est-il une bonne chose de retourner des Resource depuis le repo ?
  // C'est vrai, de toute façon ce n'est pas à ce niveau que loading, error et success ont leur sens..

  @override
  Future<Resource<YeeguideResponse>> invokeYeeguide(
      String yeeguideId, String message,  List<List<String>> chatHistory) async {
    final response = await _yeebotApi.invokeYeeguide(yeeguideId, message, chatHistory);
    if (response.data != null) {
      return Resource.success(YeeguideResponse.fromJson(
          jsonDecode(utf8.decode(response.data!.codeUnits))));
    } else {
      if (response.type == ResourceType.error) {
        return Resource.error(response.message ?? "");
      }
      return Resource.success(YeeguideResponse());
    }
  }

  @override
  Stream<YeeguideResponse> streamYeeguide(
      String yeeguideId, String message, List<List<String>> chatHistory) async* {
    // /!\ TODO : Il faudra, une fois que l'API sera de nouveau connecté à OpenAI, revenir sur cette partie de l'app
    // le split actuel fonctionne mais n'est pas fiable car part en couilles si dans la réponse il y'a les caractères "event: " ou "data:" ou "metadata:"
    // Idéalement, il faudrait que le stream ne soit pas un string mais un json ou autre, utiliser un regex pour les split peut être pertinent aussi on verra.

    // /!\ TODO : Régle aussi le soucis du guillemet sur la fin
    final streamResponse = await _yeebotApi.streamYeeguide(yeeguideId, message, chatHistory);

    Metadata? metadata;
    String? responseData;

    await for (final chunk in streamResponse) {
      debugPrint("Chunk: $chunk");

      final events = chunk.split('event: ');
      for (final event in events) {
        debugPrint("An event: $event");
        if (event.startsWith('metadata')) {
          final metadataJson = event.split('\n')[1].split('data: ')[1];
          debugPrint("Metadata JSON: $metadataJson");
          metadata = Metadata.fromJson(jsonDecode(metadataJson));

          yield YeeguideResponse(
              metadata: metadata,
              output: responseData?.substring(1, responseData.length) ?? "");
        } else if (event.startsWith('data')) {
          final data = event.split('\n')[1].split('data: "')[1].split('"')[0];
          responseData = data.replaceAll("\\n", "\n");
          debugPrint("Response Data: $responseData");

          yield YeeguideResponse(metadata: metadata, output: responseData);
        } else if (event.startsWith('end')) {
          yield YeeguideResponse(isOver: true);
          // La réponse est terminée
          // if (metadata != null && responseData != null) {
          //   final response = YeeguideResponse(
          //     metadata: metadata,
          //     output: responseData,
          //   );
          //   yield response;
          // }
          // Réinitialiser les variables pour la prochaine réponse
          metadata = null;
          responseData = null;
        }
      }
    }
  }

  @override
  void addConvoMessageToCache(ChatMessage message) {
    // try {
    _convoDao.addMessageToConversation(message);
    // } catch (e) {
    //   // Gérer l'exception ici (par exemple, en enregistrant l'erreur dans les logs)
    //   print('Erreur lors de l'ajout du message dans la base de données: $e');
    //   }
  }

  @override
  Future<Resource<List<ChatMessage>>> getAllMessages() async {
    // try {
    final messages = await _convoDao.getAllMessagesFromConversation();
    return Resource.success(messages);
    // } catch (e) {
    //   return Resource.error('Erreur lors de la récupération des messages dans le repo: $e');
    // }
  }

  @override
  Future<Resource<List<ChatMessage>>> getAllMessagesByYeeguideId(
      String yeeguideId) async {
    // try {
    final messages =
        await _convoDao.getMessagesFromConversationByYeeguideId(yeeguideId);
    return Resource.success(messages);
    // } catch (e) {
    //   return Resource.error('Erreur lors de la récupération des messages dans le repo: $e');
    // }
  }
}
