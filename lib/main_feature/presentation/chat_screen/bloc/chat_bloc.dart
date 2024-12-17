import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/commons/utils/resource.dart';
import '../../../../core/di/locator.dart';
import '../../../domain/model/chat_message.dart';
import '../../../domain/use_cases/add_message_to_history.dart';
import '../../../domain/use_cases/get_all_convo_history.dart';
import '../../../domain/use_cases/get_all_convo_history_by_yeeguide.dart';
import '../../../domain/use_cases/invoke_yeeguide.dart';
import '../../../domain/use_cases/stream_yeeguide.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // /!\ Il faudrait penser à gérer les différents cas suivants :
  // - On attend que le message soit ajouté à la base de données pour l'ajouter à la liste manuelle ou pas ?
  //   Je pense que c'est mieux d'avoir une seule source de vérité, donc d'attendre que ce soit dans la base de données
  //   Mais s'il n'est pas allé dans la base de données et s'est néanmoins envoyé à l'API, il faudrait l'afficher avec un point d'exclamation ou un truc du genre
  //   Pour l'instant ne te casse pas trop la tête, envoie en avance tout simplement

  // - Comment on gère le cas où le message a été envoyé mais n'a pas pu être délivré au serveur ?
  //   Il faudrait un truc dans le même style que whatsapp avec les signes que le message a été délivré
  //   Comme ça si le gars n'a pas de connexion internet, il verra que ses messages ne passent pas
  //   Et ils passeront qu'une fois qu'il sera de nouveau connecté

  // Ces deux cas vont de paire on pourra les gérer lors d'un autre sprint

  InvokeYeeguideUseCase _sendMessageByInvokeUseCase = InvokeYeeguideUseCase();
  StreamYeeguideUseCase _sendMessageByStreamUseCase = StreamYeeguideUseCase();
  AddMessageToHistoryUseCase _addMessageToHistoryUseCase =
      AddMessageToHistoryUseCase();
  GetAllConvoHistoryUseCase _getAllConvoHistoryUseCase =
      GetAllConvoHistoryUseCase();
  GetAllConvoHistoryByYeeguideUseCase _getAllConvoHistoryByYeeguideUseCase =
      GetAllConvoHistoryByYeeguideUseCase();

  ChatBloc() : super(const ChatState()) {
    on<SendMessageByInvoke>(_sendMessageByInvoke);
    on<SendMessageByStream>(_sendMessageByStream);
    on<AddMessageToHistory>(_addMessageToHistory);
    on<GetAllConvoHistory>(_getAllConvoHistory);
    on<GetAllConvoHistoryByYeeguide>(_getAllConvoHistoryByYeeguide);

    add(GetAllConvoHistoryByYeeguide(
        yeeguideId: locator.get<SharedPreferences>().getString("yeeguide_id") ??
            "raruto"));
  }

  Future<void> _sendMessageByInvoke(
      SendMessageByInvoke event, Emitter<ChatState> emit) async {
    emit(state.copyWith(messages: [
      ...state.messages,
      HumanChatMessage(
          message: event.message,
          conversationId: "",
          yeeguideId: event.yeeguideId)
    ]));
    add(AddMessageToHistory(
        chatMessage: HumanChatMessage(
            message: event.message,
            conversationId: "",
            yeeguideId: event.yeeguideId)));

    await for (final resource in _sendMessageByInvokeUseCase.execute(
      event.yeeguideId,
      event.message,
      // state.sender,
    )) {
      // Examinez le type de ressource et effectuez des actions en conséquence.
      switch (resource.type) {
        case ResourceType.success:
          emit(state.copyWith(isAITyping: false));
          debugPrint("Nouveau message reçu et envoyé avec succès !");
          add(AddMessageToHistory(
              chatMessage: AIChatMessage(message: resource.data?.output ?? "",conversationId:  "",
                  yeeguideId: event.yeeguideId)));
          // emit(state.copyWith(messages: [...state.messages, AIChatMessage(resource.data?.output ?? "", "", yeeguideId: event.yeeguideId)]));
          break;
        case ResourceType.error:
          emit(state.copyWith(isAITyping: false));
          debugPrint("Erreur lors de la connexion : ${resource.message}");
          // emit(state.copyWith(loginMessage: Resource.error(resource.message ?? "")));

          // Gérez l'erreur en conséquence.
          break;
        case ResourceType.loading:
          debugPrint(
              "Est entrain d'écrire... (tu devrais peut-être juste utiliser une variable");
          emit(state.copyWith(isAITyping: true));
          // Vous pouvez gérer le chargement si nécessaire.
          break;
      }
    }
  }

  Future<void> _sendMessageByStream(
      SendMessageByStream event, Emitter<ChatState> emit) async {
    emit(state.copyWith(
        messages: [...state.messages, HumanChatMessage(message: event.message, conversationId: "", yeeguideId: event.yeeguideId)]));
    add(AddMessageToHistory(chatMessage: HumanChatMessage(message: event.message, conversationId: "", yeeguideId: event.yeeguideId)));
    // Créez une nouvelle instance de AIChatMessage avec un message vide
    final aiMessage = AIChatMessage(message: "", conversationId: "", yeeguideId: event.yeeguideId);

    // Ajoutez le message AI vide au state

    await for (final resource in _sendMessageByStreamUseCase.execute(
        event.yeeguideId, event.message)) {
      // Examinez le type de ressource et effectuez des actions en conséquence.
      switch (resource.type) {
        case ResourceType.success:

          // /!\ TODO : N'oublie pas d'ajouter le message à l'historique
          if (state.isAITyping) {
            emit(state.copyWith(
              messages: [...state.messages, aiMessage],
              isAITyping: false,
            ));
          }

          if (resource.data != null && resource.data!.output != null) {
            // Mettez à jour le message AI avec le chunk reçu
            aiMessage.message += resource.data!.output!;

            // Émettez un nouveau state avec le message AI mis à jour
            emit(state.copyWith(
              messages: [
                ...state.messages.take(state.messages.length - 1),
                aiMessage,
              ],
              isAITyping: false,
            ));
          } else if (resource.data != null && resource.data!.isOver != null) {
            add(AddMessageToHistory(
                chatMessage: AIChatMessage(message: aiMessage.message,conversationId: "",
                    yeeguideId: aiMessage.yeeguideId)));
          }

          break;
        case ResourceType.error:
          emit(state.copyWith(isAITyping: false));
          debugPrint("Erreur lors de la connexion : ${resource.message}");
          // emit(state.copyWith(loginMessage: Resource.error(resource.message ?? "")));

          // Gérez l'erreur en conséquence.
          break;
        case ResourceType.loading:
          debugPrint(
              "Est entrain d'écrire... (tu devrais peut-être juste utiliser une variable");
          emit(state.copyWith(isAITyping: true));
          // Vous pouvez gérer le chargement si nécessaire.
          break;
      }
    }
  }

  Future<void> _addMessageToHistory(
      AddMessageToHistory event, Emitter<ChatState> emit) async {
    // On ajoute le message au préalable dans la liste car il devra apparaître peu importe :
    // Mais dans le futur on ajoutera des variables pour indiquer si le message est en état d'erreur
    // (non stocké ou non delivré) et ce sera indiqué dans le UI avec possibilité de réessayer

    // Si un message n'a jamais pu être envoyé au serveur, il devra disparaître mais bon
    // on pensera à tout ça dans un autre sprint

    await for (final resource
        in _addMessageToHistoryUseCase.execute(event.chatMessage)) {
      switch (resource.type) {
        case ResourceType.success:
          debugPrint(
              "Le message a été ajouté avec succès à l'historique de conversation");
          break;
        case ResourceType.error:
          debugPrint(
              "Erreur lors de l'ajout du message à l'historique: ${resource.message}");
          break;
        case ResourceType.loading:
          debugPrint("Ajout du message en cours...");
          break;
      }
    }
  }

  Future<void> _getAllConvoHistory(
      GetAllConvoHistory event, Emitter<ChatState> emit) async {
    await for (final resource in _getAllConvoHistoryUseCase.execute()) {
      switch (resource.type) {
        case ResourceType.success:
          if (resource.data != null) {
            emit(state.copyWith(messages: resource.data!));
            debugPrint("Messages récupérés avec succès !");
          } else {
            debugPrint(
                "Succès mais aucun message récupéré, c'est censé être impossible, debug le code");
          }
          break;
        case ResourceType.error:
          debugPrint(
              "Erreur lors de la récupération des messages: ${resource.message}");
          break;
        case ResourceType.loading:
          debugPrint("Chargement des messages en cours...");
          break;
      }
    }
  }

  Future<void> _getAllConvoHistoryByYeeguide(
      GetAllConvoHistoryByYeeguide event, Emitter<ChatState> emit) async {
    await for (final resource
        in _getAllConvoHistoryByYeeguideUseCase.execute(event.yeeguideId)) {
      switch (resource.type) {
        case ResourceType.success:
          if (resource.data != null) {
            emit(state.copyWith(messages: [
              AIChatMessage(message: "Dans quelle salle a eu lieu la démo de l'appli Yeekai durant la campagne ?", conversationId: "0", yeeguideId: "rita"),
              ...resource.data!]));

            if(resource.data!.isEmpty){
              emit(state.copyWith(messages: [
                AIChatMessage(message: "Dans quelle salle a eu lieu la démo de l'appli Yeekai durant la campagne ?", conversationId: "0", yeeguideId: "rita"),
                  // const HumanChatMessage(message: "Comment puis-je avoir un duplicata de mon bulletin ? \nJe suis étudiant en L2.", conversationId: "0", yeeguideId: "rita"),

              ]));

            }
            debugPrint("Messages récupérés avec succès !");
          } else {
            debugPrint(
                "Succès mais aucun message récupéré, c'est censé être impossible, debug le code");
          }
          break;
        case ResourceType.error:
          debugPrint(
              "Erreur lors de la récupération des messages: ${resource.message}");
          break;
        case ResourceType.loading:
          debugPrint("Chargement des messages en cours...");
          break;
      }
    }
  }
}
