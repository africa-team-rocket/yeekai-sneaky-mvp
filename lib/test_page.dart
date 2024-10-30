import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/commons/utils/resource.dart';
import 'core/di/locator.dart';
import 'main_feature/data/remote/api/yeebot_api.dart';
import 'main_feature/data/remote/api/yeebot_api_impl.dart';
import 'main_feature/domain/model/chat_message.dart';
import 'main_feature/domain/model/yeeguide_response.dart';
import 'main_feature/domain/repository/yeebot_repo.dart';


class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  String answer = "";
  YeebotRepo yeebotRepo = locator.get<YeebotRepo>();
  YeebotApi yeebotApi = YeebotApiImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1.sh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ElevatedButton(
              //   onPressed: () async {
              //     final Stream<String> rep = yeebotApi.streamYeeguide("sane_madio", "Bonsoir Sané Madio !");
              //     await for (var chunk in rep) {
              //       // debugPrint("Chunk $chunk");
              //     }
              //   },
              //   child: Text("Envoyer salut à Sané Madio (stream fromApi) !"),
              // ),
              ElevatedButton(
                onPressed: () async {
                  final Stream<YeeguideResponse> rep = yeebotRepo
                      .streamYeeguide("sane_madio", "Bonsoir Sané Madio !");
                  await for (var chunk in rep) {
                    debugPrint("Chunk $chunk");
                  }
                },
                child: Text("Envoyer salut à Sané Madio (stream fromRepo) !"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final Resource<YeeguideResponse> rep = await yeebotRepo
                      .invokeYeeguide("sane_madio", "Bonsoir Sané Madio !");
                  setState(() {
                    if (rep.data != null) {
                      answer = rep.data?.output ?? "";
                    }
                  });
                },
                child: Text("Envoyer salut à Sané Madio (fromRepo) !"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Créer une instance de ChatMessage pour un message d'IA
                  AIChatMessage aiMessage = AIChatMessage(
                    message: "Je suis un message d'IA",
                    conversationId: "",
                    yeeguideId: "yeeguide_id",
                  );
                  yeebotRepo.addConvoMessageToCache(aiMessage);
                  debugPrint("Message d'IA ajouté à la conversation");
                },
                child: Text("Ajouter un message d'IA à la conversation"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Créer une instance de ChatMessage pour un message d'IA
                  HumanChatMessage humanMessage = HumanChatMessage(
                      message: "Je suis un message d'humain",
                      conversationId: "",
                      yeeguideId: "madio");
                  yeebotRepo.addConvoMessageToCache(humanMessage);
                  debugPrint("Message d'humain ajouté à la conversation");
                },
                child: Text("Ajouter un message d'humain à la conversation"),
              ),

              ElevatedButton(
                onPressed: () async {
                  final Resource<List<ChatMessage>> messagesResource =
                      await yeebotRepo.getAllMessages();
                  if (messagesResource.data != null) {
                    final messages = messagesResource.data!;
                    debugPrint("Messages récupérés de la conversation :");
                    for (var message in messages) {
                      debugPrint(message.message);
                    }
                  } else {
                    debugPrint("Erreur lors de la récupération des messages");
                  }
                },
                child: Text("Récupérer tous les messages de la conversation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
