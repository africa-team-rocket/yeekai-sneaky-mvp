

import '../../../core/commons/utils/resource.dart';
import '../model/chat_message.dart';
import '../model/yeeguide_response.dart';

abstract class YeebotRepo{

  Future<Resource<YeeguideResponse>> invokeYeeguide(String yeeguideId, String message, List<List<String>> chatHistory);

  Stream<YeeguideResponse> streamYeeguide(String yeeguideId, String message, List<List<String>> chatHistory);

  void addConvoMessageToCache(ChatMessage message);

  void cancelStream();

  Future<Resource<List<ChatMessage>>> getAllMessages();

  Future<Resource<List<ChatMessage>>> getAllMessagesByYeeguideId(String yeeguideId);

  // Future<Resource<AuthResponseEntity?>> getConvoHistoryFromCache();

  // void clearConversation();

}