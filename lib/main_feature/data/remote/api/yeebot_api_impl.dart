import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yeebus_filthy_mvp/main_feature/data/remote/api/yeebot_api.dart';

import '../../../../core/commons/utils/resource.dart';
import '../../../../core/di/locator.dart';

class YeebotApiImpl extends YeebotApi {
  // /!\ TODO : Il faudrait penser à créer des classes d'exception custom ce serait plus pratique

  static const String API_BASE_URL = "https://yeekai-bot.replit.app";


  http.Client? _client;


  @override
  Future<Resource<String>> invokeYeeguide(
      String yeeguideId, String message, List<List<String>> chatHistory) async {

    // TODO: Implémenter la récupération de l'historique later



    final url = Uri.parse("$API_BASE_URL/yeegpt-1.0/invoke");
    final body = {
      "input": {
        "question": message,
        "user_profile": {
          // TODO : Implémenter le type d'utilisateur plus tard (visiteur ou étudiant)
          "user_type": "student",
          "pseudo": locator.get<SharedPreferences>().getString("username")
        },
        "chat_history": chatHistory,
        "yeeguide_id": yeeguideId
      },
      "config": {
        "configurable": {
          "session_id":
          "${locator.get<SharedPreferences>().getString("username") ?? "unknown-name"}-${locator.get<SharedPreferences>().getString("user_id") ?? "unknown-id"}-$yeeguideId", // Remplacer par une session appropriée
          // Remplacer par une session appropriée
        }
      },
      "kwargs": {}
    };
    final response = await http.post(url,
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json", 'Access-Control-Allow-Origin': '*'},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      debugPrint("Response: ${response.body}");
      return Resource.success(response.body);
    } else {
      debugPrint(
          "Une erreur inattendue s'est produite dans InvokeYeeguide: ${response.body}");
      debugPrint(response.statusCode.toString());
      throw Exception(
          "Une erreur inattendue s'est produite dans InvokeYeeguide: ${response.body}");
    }
  }

  @override
  Stream<String> streamYeeguide(String yeeguideId, String message, List<List<String>> chatHistory) async* {
    final url = Uri.parse("$API_BASE_URL/yeegpt-1.0/stream");

    // TODO: Implémenter la récupération de l'historique later

    final body = {
      "input": {
        "question": message,
        "user_profile": {
          "user_type": "student",
          "pseudo": "Al Amine"
        },
        "chat_history": chatHistory,
        "yeeguide_id": yeeguideId
      },
      "config": {
        "configurable": {
          "session_id":
          "${locator.get<SharedPreferences>().getString("username") ?? "unknown-name"}-${locator.get<SharedPreferences>().getString("user_id") ?? "unknown-id"}-$yeeguideId", // Remplacer par une session appropriée
          // Remplacer par une session appropriée
        }
      },
      "kwargs": {}
    };

    _client = http.Client(); // 👈 Nouvelle instance

    try {
      final request = http.Request('POST', url);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Access-Control-Allow-Origin'] = '*';
      request.body = jsonEncode(body);

      // final streamResponse = await request.send();
      final streamResponse = await _client!.send(request);

      if (streamResponse.statusCode == 200) {
        // Récupérer le flux de données binaires
        final stream = streamResponse.stream.transform(utf8.decoder);
        debugPrint("Stream :$stream");
        // Émettre chaque chunk du flux de données
        yield* stream;
      } else {
        throw Exception(
            "Une erreur inattendue s'est produite dans StreamYeeguide: ${streamResponse.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Une erreur s'est produite lors de la requête: $e");
    } finally {
      _client?.close(); // 👈 Toujours fermer proprement après
      _client = null;
    }
  }

  @override
  Resource<String> cancelStream() {
    debugPrint("CancelStreaming called");
    _client?.close(); // 🛑 Ferme le client et stoppe la requête en cours
    _client = null;
    return Resource.success("Annulé avec succès");
  }
}
