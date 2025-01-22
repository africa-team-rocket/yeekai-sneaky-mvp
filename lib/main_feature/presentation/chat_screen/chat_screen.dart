import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yeebus_filthy_mvp/main_feature/presentation/chat_screen/widgets/chat_footer.dart';
import 'package:yeebus_filthy_mvp/main_feature/presentation/chat_screen/widgets/chat_header.dart';
import 'package:yeebus_filthy_mvp/main_feature/presentation/chat_screen/widgets/chat_messages.dart';

import '../../../core/commons/theme/app_colors.dart';
import '../../domain/model/chat_message.dart';
import 'bloc/chat_bloc.dart';
import 'bloc/chat_state.dart';

class InitialPrompt {
  final String text;
  final bool shouldSendInitialPrompt;

  InitialPrompt({required this.text, required this.shouldSendInitialPrompt});
}

// Ecran du tutorial du chatScreen
class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {Key? key, required this.shouldOpenKeyboard, this.initialPrompt})
      : super(key: key);
  final bool shouldOpenKeyboard;
  final InitialPrompt? initialPrompt;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // TODO NEXT :
  // Demain :
  // - Implémenter les swipe-to convenablement : OK
  // - Implémenter les chipWidget : OK (ajouter la date en français et bien isoler les widgets dans le futur
  // - Implémenter le multiligne sur le widget d'écriture : OK
  // - Les éléments violets sur l'interface font chier, change ça au niveau du textfield : OK
  // - Mettre des flat widget pour l'overview et gérer la longueur du message : OK
  // - Faire en sorte que tous les messages ne s'écrivent pas quand on ouvre l'interface pour la première fois : OK

  // - Implémenter le stream : TERMINE 90% (une fois l'API branché tu finalise ça)
  // - Implémenter la pagination des messages pour éviter de tout charger d'un seul coup
  // - Implémenter la suppression de tous les messages
  // - Implémenter le reste de la logique pour que tout soit cohérent entre le back le front et l'id de l'utilisateur
  // - Prendre une journée pour clean le widget tree, minimiser les dépenses, améliorer les performances du code.
  // - Quand on envoie un message, rescroll jusqu'en bas

  // TODO QUELQUES IDEES :
  // - Si dans le futur tu as les mécanismes de " non-délivré " etc et que l'utilisateur envoie plusieurs
  // messages, alors sur les réponses du Yeeguide, cite le message en réponse ça peut aider.

  // List<ChatMessage> chatMessagesMock =  [
  //   AIChatMessage("Bonjour!", "conversation_id_1", yeeguideId: "raruto"),
  //   HumanChatMessage("Salut!", "conversation_id_2"),
  //   AIChatMessage("Comment vas-tu?", "conversation_id_3", yeeguideId: "raruto"),
  //   HumanChatMessage("Je vais bien, merci!", "conversation_id_4"),
  //   AIChatMessage("Que fais-tu de beau?", "conversation_id_5", yeeguideId: "raruto"),
  //   HumanChatMessage("Je lis un livre.", "conversation_id_6"),
  //   AIChatMessage("Intéressant! De quoi parle le livre?", "conversation_id_7", yeeguideId: "raruto"),
  //   HumanChatMessage("Il s'agit d'un roman de science-fiction.", "conversation_id_8"),
  //   AIChatMessage("J'aime beaucoup la science-fiction.", "conversation_id_9", yeeguideId: "raruto"),
  //   HumanChatMessage("Moi aussi!", "conversation_id_10"),
  //   AIChatMessage("As-tu lu Dune?", "conversation_id_11", yeeguideId: "raruto"),
  //   HumanChatMessage("Oui, c'est un classique!", "conversation_id_12"),
  //   AIChatMessage("Nous avons des goûts similaires alors!", "conversation_id_13", yeeguideId: "raruto"),
  //   HumanChatMessage("C'est vrai!", "conversation_id_14"),
  //   AIChatMessage("Je dois y aller maintenant. À bientôt!", "conversation_id_15", yeeguideId: "raruto"),
  //   HumanChatMessage("À bientôt!", "conversation_id_16"),
  //   AIChatMessage("Reviens me parler si tu as besoin de quelque chose.", "conversation_id_17", yeeguideId: "raruto"),
  //   HumanChatMessage("D'accord, merci!", "conversation_id_18"),
  //   AIChatMessage("De rien, c'est mon plaisir.", "conversation_id_19", yeeguideId: "raruto"),
  //   HumanChatMessage("Au revoir!", "conversation_id_20"),
  // ];

  final ScrollController _scrollController = ScrollController();
  bool showScrollButton = false;

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.other];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint('Couldn\'t check connectivity status : $e');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });


    // ignore: avoid_print
    debugPrint('Connectivity changed: $_connectionStatus');
  }



  @override
  void initState() {
    // initializeDateFormatting("fr_FR");
    // initializeDateFormatting("fr_FR", n).then((value) => (){
    // Intl.systemLocale = await findSystemLocale();
    // });


    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
      create: (_) {
        return ChatBloc();
      },
      child: BlocBuilder<ChatBloc, ChatState>(builder: (context, snapshot) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            // /!\ Il y'avait un SingleChildScrollView, tu l'as retiré au cas où qqch part en yeuks.
            body: SizedBox(
              height: 1.sh,
              child: Stack(
                children: [
                  // CHAT HEADER (Clean ça en fin de semaine)
                  // Image.asset(
                  //   "assets/bg_test.png",
                  //   height: 1.sh,
                  //   width: 1.sw,
                  // ),
                  NotificationListener(
                    onNotification: (scrollNotification) {
                      if (_scrollController.position.pixels > 300 &&
                          !showScrollButton) {
                        debugPrint("Il y'a du scroll à !");
                        setState(() {
                          showScrollButton =
                              _scrollController.position.pixels > 300;
                        });
                        return true;
                      } else if (_scrollController.position.pixels <= 300 &&
                          showScrollButton) {
                        debugPrint("Y'a plus de scroll à !");
                        setState(() {
                          showScrollButton =
                              _scrollController.position.pixels > 300;
                        });
                        return true;
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      reverse: true,
                      controller: _scrollController,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 65 + MediaQuery.of(context).padding.top,
                          ),
                          Container(
                              padding: EdgeInsets.only(bottom: 110 + MediaQuery.of(context).padding.bottom),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFF8E3),
                                        borderRadius: BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                                spreadRadius: 0,
                                                blurRadius: 10,
                                                offset: const Offset(0, 0),
                                                blurStyle: BlurStyle.outer,
                                                color: Colors.grey.withOpacity(.25)
                                            )
                                          ]
                                      ),
                                      width: 1.sw,
                                      child: Text(
                                        // "⚠️ Cette application est un prototype. L'assistant ne fournit pas encore de réponses à 100% précises, il sert à uniquement tester le concept. Amusez-vous, et faites nous un feedback.",
                                        "⚠️ Cette application est un prototype. L'assistant n'est pas encore fonctionnel, veuillez vous référer à la carte ou à notre communauté whatsapp en attendant (+221 76 309 94 67).",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(

                                        fontSize: 12,
                                      ),)),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        // chatMessagesMock.length,
                                        context
                                            .read<ChatBloc>()
                                            .state
                                            .messages
                                            .length,
                                    itemBuilder: (context, index) {
                                      return context
                                                  .read<ChatBloc>()
                                                  .state
                                                  .messages[index]
                                              is HumanChatMessage
                                          ? HumanChatMessageWidget(
                                              chatBloc:
                                                  context.read<ChatBloc>(),
                                              currentIndex: index,
                                              // text: (context.read<ChatBloc>().state.messages[
                                              // index]
                                              // as HumanChatMessage).message
                                            )
                                          : AssistantMessagesSectionWidget(
                                              chatResponse: (context
                                                      .read<ChatBloc>()
                                                      .state
                                                      .messages[index]
                                                  as AIChatMessage),
                                              chatBloc:
                                                  context.read<ChatBloc>(),
                                              isTyping: false,
                                              currentIndex: index,
                                            );
                                    },
                                  ),
                                  if (context
                                      .read<ChatBloc>()
                                      .state
                                      .isAITyping) ...[
                                    // /!\ TODO : Il faudrait remplacer ce widget par un truc stateless
                                    const MessageLoader()
                                  ]
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ChatScreenFooter(
                        initialPrompt: widget.initialPrompt,
                        shouldOpenKeyboard: widget.shouldOpenKeyboard,
                        chatBloc: context.read<ChatBloc>(),
                        isConnected : _connectionStatus.first != ConnectivityResult.none,
                        scrollController: _scrollController,),
                  ),
                  const ChatScreenHeader(),
                  AnimatedPositioned(
                    bottom:
                    // -80,
                    _connectionStatus.first == ConnectivityResult.none
                        ? -9 //(up)
                     : -70,
                    duration: Duration(milliseconds: 200),
                    child: Container(
                        width: 1.sw,
                        height: 0 + MediaQuery.of(context).padding.top,
                        color: Colors.redAccent,
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 10)),
                            Text("Vous n'êtes pas connecté à internet",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                              ),
                            ),
                          ],
                        )),
                  ),
                  Positioned(
                    bottom: 100.0,
                    right: 15.0,
                    child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: showScrollButton
                            ? Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 0,
                                          blurRadius: 16,
                                          offset: const Offset(0, 0),
                                          blurStyle: BlurStyle.outer,
                                          color: Colors.grey.withOpacity(.4))
                                    ]),
                                child: Material(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    onTap: () {
                                      _scrollController.animateTo(0.0,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut);
                                    },
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: AppColors.primaryText,
                                        size: 35.0,
                                      ),
                                    ),),
                                  ),
                                ),
                              )
                            : null),
                  ),



                  // Je retire le scroll listener pour l'instant si ça redevient utile tu sauras où le trouver

                  // CHAT BODY
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
