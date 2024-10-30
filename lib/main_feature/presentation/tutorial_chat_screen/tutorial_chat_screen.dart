import 'dart:math';

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yeebus_filthy_mvp/main_feature/presentation/tutorial_chat_screen/widgets/tutorial_chat_footer.dart';
import 'package:yeebus_filthy_mvp/main_feature/presentation/tutorial_chat_screen/widgets/tutorial_chat_header.dart';

import '../../../core/commons/theme/app_colors.dart';
import '../../../core/commons/utils/app_constants.dart';
import '../../../core/domain/models/chatbot_conversation.dart';

String remplacerNomDansPhrase(String phrase, String nom) {
  // Chercher la séquence "#;username;#" dans la phrase
  String sequenceAChercher = "#;username;#";
  int index = phrase.indexOf(sequenceAChercher);

  // Si la séquence est trouvée, la remplacer par le nom
  if (index != -1) {
    String nouvellePhrase =
        phrase.replaceRange(index, index + sequenceAChercher.length, nom);
    return nouvellePhrase;
  } else {
    // Retourner la phrase inchangée si la séquence n'est pas trouvée
    return phrase;
  }
}

// Ceci est le script incomplet de la conversation du tutoriel avec Usman Songo.
// C'est le seul script pour l'instant.

// ### SUGGESTION : Met les tous dans les static de l'app et pour les champs qui doivent être remplacés utilise le format {#;;#}
// Conversation devrait juste avoir un step pas une liste je pense.
Conversation conservation1 = Conversation(
    steps: [
      ChatStep(
          prompt: "Oui, depuis des lustres !",
          response: ChatResponse(text: [
            "Dans ce cas, tu es au bon endroit !",
            "Salut #;username;#, moi c'est Usman Songo, ton nouveau Yeeguide. \n\nJe réponds à toutes tes questions sur les transports à Dakar.",
            "En route pour 2024 !",
            "Prêt pour une petite démo ?",
            // "#;enable_faq;#",
          ], nextSteps: [
            // PARTANT POUR UNE DEMO
            ChatStep(
                prompt: 'Oui, on y va !',
                response: ChatResponse(text: [
                  "Super, alors déjà, je sais parler Français, Anglais, et Wolof.",
                  "Parcontre, je suis encore médiocre en wolof donc peut-être que Yeebus a désactivé ça.",
                  "Ces satanés développeurs.. ils se croient tout puissant pff."
                ], nextSteps: [
                  // ON RESTE EN FRANCAIS.
                  ChatStep(
                      prompt: "On reste en français dans ce cas.",
                      response: ChatResponse(text: [
                        "Bon choix 😂, tes yeux te remercieront pour ça.",
                        "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
                        "1 - Yeebus va générer une liste de questions tirées au hasard.",
                        "2 - Tu pioches n’importe laquelle.",
                        "3 - J’y répond les doigts dans le nez parce que je sais tout.",
                        "(même qui va gagner les élections 2024 🌚)",
                        "On y va ?"
                      ], nextSteps: [
                        ChatStep(
                            prompt: "Oui, je veux voir ça.",
                            response: ChatResponse(text: [
                              "Bismillah !",
                              "#;enable_faq;#"
                            ], nextSteps: [
                              // FIN BRANCHE
                            ])),
                        ChatStep(
                            prompt:
                                "Dis moi d'abord qui va gagner les élections 👀",
                            response: ChatResponse(text: [
                              "Bah moi bien évidemment.. *AHEM*",
                              "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
                              "donc je mise plutôt sur.. humm..",
                              "Yousou Ndul c'est mon favoris. 😁"
                            ], nextSteps: [
                              ChatStep(
                                  prompt: "😂😂 Revenons en aux bus",
                                  response: ChatResponse(text: [
                                    "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
                                    "On lance le jeu 🎲",
                                    "#;enable_faq;#"
                                  ], nextSteps: [
                                    // FIN BRANCHE
                                  ])),
                            ])),
                      ])),

                  // ON TESTE LE WOLOF.
                  ChatStep(
                      prompt: 'Ma khol wolof bi bokk 👀',
                      response: ChatResponse(text: [
                        "Mann Songo magui soukkendiku rewwmi ndakh niou mankoo téléchargé Yeebus dans les plus brefs délais.",
                        "... désolé je ne peux pas faire mieux 😭😭",
                        "On reste en français finalement, ça te va ?"
                      ], nextSteps: [
                        ChatStep(
                            prompt: "Oui, c'est mieux.",
                            response: ChatResponse(text: [
                              "Bon choix 😂, tes yeux te remercieront pour ça.",
                              "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
                              "1 - Yeebus va générer une liste de questions tirées au hasard.",
                              "2 - Tu pioches n’importe laquelle.",
                              "3 - J’y répond les doigts dans le nez parce que je sais tout.",
                              "(même qui va gagner les élections 2024 🌚)",
                              "On y va ?"
                            ], nextSteps: [
                              ChatStep(
                                  prompt: "Oui, je veux voir ça.",
                                  response: ChatResponse(text: [
                                    "Bismillah !",
                                    "#;enable_faq;#"
                                  ], nextSteps: [
                                    // FIN BRANCHE
                                  ])),
                              ChatStep(
                                  prompt:
                                      "Dis moi d'abord qui va gagner les élections 👀",
                                  response: ChatResponse(text: [
                                    "Bah moi bien évidemment.. *AHEM*",
                                    "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
                                    "donc je mise plutôt sur.. humm..",
                                    "Yousou Ndul c'est mon favoris. 😁"
                                  ], nextSteps: [
                                    ChatStep(
                                        prompt: "😂😂 Revenons en aux bus",
                                        response: ChatResponse(text: [
                                          "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
                                          "On lance le jeu 🎲",
                                          "#;enable_faq;#"
                                        ], nextSteps: [
                                          // FIN BRANCHE
                                        ])),
                                  ])),
                            ])),
                      ])),
                ])),
            // PAS PARTANT POUR UNE DEMO (Confetti d'abord puis on loop) :
            ChatStep(
                prompt: 'Non, je veux plus de confetti d\'abord 🙂',
                response: ChatResponse(text: [
                  "Non mais sérieusement, tu pouvais pas juste suivre le script ? Ohlala..",
                  "Qui t'a dit que je sais faire ça moi ? 💀",
                  "Bon, voilà pour toi.., mais c'est la dernière fois",
                  // "#;drop_confetti;#",
                  "abracadabra !"
                ], nextSteps: [
                  ChatStep(
                      prompt:
                          'Mercii 😂, on peut commencer la démo maintenant.',
                      response: ChatResponse(text: [
                        "Derien 🤝🏽 (façon j'ai pas le choix, j'ai été programmé pour ça..)",
                        "Super, alors déjà, je sais parler Français, Anglais, et Wolof.",
                        "Parcontre, je suis encore médiocre en wolof donc peut-être que Yeebus a désactivé ça.",
                        "Ces satanés développeurs.. ils se croient tout puissant pff."
                      ], nextSteps: [
                        // ON RESTE EN FRANCAIS.
                        ChatStep(
                            prompt: "On reste en français dans ce cas.",
                            response: ChatResponse(text: [
                              "Bon choix 😂, tes yeux te remercieront pour ça.",
                              "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
                              "1 - Yeebus va générer une liste de questions tirées au hasard.",
                              "2 - Tu pioches n’importe laquelle.",
                              "3 - J’y répond les doigts dans le nez parce que je sais tout.",
                              "(même qui va gagner les élections 2024 🌚)",
                              "On y va ?"
                            ], nextSteps: [
                              ChatStep(
                                  prompt: "Oui, je veux voir ça.",
                                  response: ChatResponse(text: [
                                    "Bismillah !",
                                    "#;enable_faq;#"
                                  ], nextSteps: [
                                    // FIN BRANCHE
                                  ])),
                              ChatStep(
                                  prompt:
                                      "Dis moi d'abord qui va gagner les élections 👀",
                                  response: ChatResponse(text: [
                                    "Bah moi bien évidemment.. *AHEM*",
                                    "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
                                    "donc je mise plutôt sur.. humm..",
                                    "Yousou Ndul c'est mon favoris. 😁"
                                  ], nextSteps: [
                                    ChatStep(
                                        prompt: "😂😂 Revenons en aux bus",
                                        response: ChatResponse(text: [
                                          "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
                                          "On lance le jeu 🎲",
                                          "#;enable_faq;#"
                                        ], nextSteps: [])),
                                  ])),
                            ])),

                        // ON TESTE LE WOLOF.
                        ChatStep(
                            prompt: 'Ma khol wolof bi bokk 👀',
                            response: ChatResponse(text: [
                              "Mann Songo magui soukkendiku rewwmi ndakh niou mankoo téléchargé Yeebus dans les plus brefs délais.",
                              "... désolé je ne peux pas faire mieux 😭😭",
                              "On reste en français finalement, ça te va ?"
                            ], nextSteps: [
                              ChatStep(
                                  prompt: "Oui, c'est mieux.",
                                  response: ChatResponse(text: [
                                    "Bon choix 😂, tes yeux te remercieront pour ça.",
                                    "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
                                    "1 - Yeebus va générer une liste de questions tirées au hasard.",
                                    "2 - Tu pioches n’importe laquelle.",
                                    "3 - J’y répond les doigts dans le nez parce que je sais tout.",
                                    "(même qui va gagner les élections 2024 🌚)",
                                    "On y va ?"
                                  ], nextSteps: [
                                    ChatStep(
                                        prompt: "Oui, je veux voir ça.",
                                        response: ChatResponse(text: [
                                          "Bismillah !",
                                          "#;enable_faq;#"
                                        ], nextSteps: [
                                          // FIN BRANCHE
                                        ])),
                                    ChatStep(
                                        prompt:
                                            "Dis moi d'abord qui va gagner les élections 👀",
                                        response: ChatResponse(text: [
                                          "Bah moi bien évidemment.. *AHEM*",
                                          "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
                                          "donc je mise plutôt sur.. humm..",
                                          "Yousou Ndul c'est mon favoris. 😁"
                                        ], nextSteps: [
                                          ChatStep(
                                              prompt:
                                                  "😂😂 Revenons en aux bus",
                                              response: ChatResponse(text: [
                                                "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
                                                "On lance le jeu 🎲",
                                                "#;enable_faq;#"
                                              ], nextSteps: [])),
                                        ])),
                                  ])),
                            ])),
                      ]))
                ]))
          ]))
    ],
    faqSteps: [
      FaqStep(
          question:
              "Quel est le meilleur itinéraire pour aller de la place de l’obélisque au Monument de la renaissance en bus ?",
          answer: ChatResponse(text: [
            "Tu veux donc faire un trajet Colobane-Ouakam, voici ce que je te suggère : \n\n- Rends-toi à l’arrêt bus en face du collège Kennedy. \n\n- Prends la ligne 54 jusqu’à la cité universitaire (UCAD). \n\n- Rendez-vous à l’arrêt bus d’en face. \n\n- Prenez la ligne 7 (DDD) jusqu’à Ouakam. \n\nEntamez une marche de 5 minutes vers le monument (qui n’est pas difficile à voir 👀) \n\n15 - 25 minutes de trajet pour seulement 250 FCFA.",
            "🚨 ATTENTION : \n\nIl existe des carapides pour faire ce trajet beaucoup plus rapidement.\n\nCependant, l’équipe Yeebus est encore entrain de travailler sur les données en rapport avec le réseau informel.\n\nAlors n’hésite pas à contacter leur service client en attendant.",
            "🚨 ET SURTOUT : \n\nLes instructions écrites ne servent que d’indication approximative.\n\nL’application Yeebus mettra à ta disposition une carte où je pourrai te guider en temps réel d’un arrêt à un autre jusqu’à ta destination.\n\nMais elle est encore en cours de conception \n\n(décidemment ces développeurs de vrais incapables..)",
            "#;enable_faq;#"
          ], nextSteps: [])),
      FaqStep(
          question:
              "Combien coûterait un trajet de Mermoz au Parc Zoologique de Hann en bus ?",
          answer: ChatResponse(text: [
            "3.000 FCFA...",
            "C’est ce que tu aurais payé en prenant un taxi.\n\nEn bus cela dépendra des lignes empruntés mais avec l’itinéraire optimal, pas plus de 350 FCFA.",
            "🚨 ET SURTOUT : \n\nL’équipe Yeebus étudie encore le système de tarification, je me base donc sur des estimations en attendant.\n\nPrend toujours un billet de plus que prévu avec toi, on ne sait jamais 😉",
            "#;enable_faq;#"
          ], nextSteps: [])),
      FaqStep(
          question: "Est-ce que la ligne 7 passe vers UCAD ?",
          answer: ChatResponse(text: [
            "Oui, la ligne 7 passe vers UCAD.",
            "J’ai été programmé pour être simple et drôle donc je m’arrête là.\n\nQu’est-ce qui est jaune et qui attend ?",
            "Jonathan.\n\n*badum tss* 🥁",
            "#;enable_faq;#"
          ], nextSteps: [])),
      FaqStep(
          question:
              "La ligne 7 est-elle accessible aux personnes à mobilité réduite ?",
          answer: ChatResponse(text: [
            "La ligne 7 de Dakar Dem Dikk peut être constituée de plusieurs modèle de bus.\n\nJe ne peux donc pas garantir que toute la ligne soit accessible.",
            "Cependant, la compagnie Dakar Dem Dikk a récemment reçu une toute nouvelle flotte de bus.\n\nIl se peut donc que la plupart des bus de la ligne 7 soient en effet accessibles, surtout s’ils disposent de l’icône suivant : \n\n♿",
            "#;enable_faq;#"
          ], nextSteps: [])),
      FaqStep(
          question: "La mort ou tchi-tchi ?",
          answer: ChatResponse(text: [
            "Désolé, #;username;#, on me tue mais on ne me déshonore pas 😂😂",
            "Je vais me donner la mort avant même que tu n'aies dit 'd'accord, mais d'abord tchitchi ' 🤣",
            "Bref, pose une vraie question cette fois :",
            "#;enable_faq;#"
          ], nextSteps: [
            ChatStep(
                prompt: "D'accord, mais d'abord tchi-tchi.",
                response: ChatResponse(text: [
                  "😂😂😂😂 non merci #;username;#, je passe mon tour 🏃🏽‍",
                  "Pose moi une vraie question plutôt :"
                      "#;disable_faq;#",
                ], nextSteps: [])),
          ])),
      FaqStep(
          question: "C’est bon, j’ai compris le concept 👍🏽",
          answer: ChatResponse(text: [
            "Super, tu as donc pu avoir un aperçu de mes compétences.",
            "L'application n'a pas encore été déployée donc les rats de l'équipe Yeebus sont probablement devant toi en ce moment même 👀.",
            "Bon, j'aime les chatier mais ce sont des gars motivés.",
            "Alors si tu aimes le concept de l'app, rejoins nous dans la communauté Whatsapp ! 🔥, \n\nOn y rigole bien entre bus preneurs.",
            "Ciao !"
          ], nextSteps: [])),
    ],
    afterFaq: ChatStep(
        prompt: "",
        response: ChatResponse(text: [
          "Super, tu as donc pu avoir un aperçu de mes compétences.",
          "L'application n'a pas encore été déployée donc les rats de l'équipe Yeebus sont probablement devant toi en ce moment même 👀.",
          "Bon, j'aime les chatier mais ce sont des gars motivés.",
          "Alors si tu aimes le concept de l'app, rejoins nous dans la communauté Whatsapp ! 🔥, \n\nOn y rigole bien entre bus preneurs.",
          "Ciao !"
        ], nextSteps: [
          // ChatStep(
          // prompt: "Oui, envoie la moi !.",
          // response: ChatResponse(
          // text: [
          // "#;drop_video;#",
          // ],
          // nextSteps: [
          //
          // ]
          // )
          // ),
        ])));

// ################# Classes utiles pour l'organisation du Ui CHat

// Cette classe abstraite représente tout ce qui apparaîtra dans la liste des messages
// # SUGGESTION : Un meilleur nom serait préférable.
abstract class ChatMessagesSection {
  ChatMessagesSection();
}

// Cette classe représente les sections avec des messages de l'utilisateur (un seul possible pour l'instant)
class UserMessagesSection extends ChatMessagesSection {
  final String initialPrompt;
  final List<ChatStep> nextSteps;

  UserMessagesSection({required this.initialPrompt, required this.nextSteps});
}

// Cette classe représente les sections avec des messages de l'assistant (plusieurs possibles)
// # SUGGESTION : Dans le futur, ça pourra envoyer plus que des messages, donc vocaux, ressources UI, images etc, il faudra
// faire évoluer ta classe ce jour là.
class AssistantMessagesSection extends ChatMessagesSection {
  final ChatResponse chatResponse;

  AssistantMessagesSection({required this.chatResponse});
}

// ################# Fin classes utiles pour l'organisation du Ui CHat

// Ecran du tutorial du chatScreen
class TutorialChatScreen extends StatefulWidget {
  const TutorialChatScreen(
      {Key? key, required this.selectedYeeguideIndex, required this.username})
      : super(key: key);
  final int selectedYeeguideIndex;
  final String username;

  @override
  State<TutorialChatScreen> createState() => _TutorialChatScreenState();
}

class _TutorialChatScreenState extends State<TutorialChatScreen> {
  // Animation level est une valeur que j'utilise pour savoir où est-ce qu'on en est dans le processus d'animations
  // Par exemple, lorsqu'on ouvre cette page, certains éléments ne doivent pas apparaître avant 3 secondes.
  // Donc je pose une condition sur ces éléments ex animationLevel == 1 et je met animationLevel à 1 seulement après 3 secondes dans
  // la méthode _startAnimation :
  int animationLevel = 0;

  // Il s'agit là de la liste de tous les messages qui apparaissent sur la liste
  // # SUGGESTION : Il ne s'agit pas seulement des messages mais aussi d'autres éléments du UI so renommer le bail ne serait pas mal.

  // Tu ajoute un 3e type de section qui prend un objet qui représentera la liste de réponses, puis dans ton ui tu vas recadrer ça
  // pour afficher le widget.

  // Il faudra un moyen pour retirer le padding du expanded, peut-être une bool pour savoir si on est en mode FAQ ou pas.
  List<ChatMessagesSection> chatMessagesSections = [];

  // Ceci représente la liste des options actuelles que l'utilisateur a comme réponses.
  // Lorsque la liste est vide, le widget qui affiche les options disparaît et vice-versa.
  List<ChatStep> currentUserOptions = [];

  List<FaqStep> alreadyAnsweredFaqOptions = [];
  List<FaqStep> currentUserFaqOptions = [];
  bool isFaqVisible = false;

  // Ceci représente la prochaine étape dans la discussion sélectionnée par l'utilisateur.
  // C'est d'ici que tu tires la liste de réponses prévues une fois le choix de l'utilisateur effectué. Et à l'intérieur, des chatResponses
  // il y'aura un autre ChatStep, ainsi de suite.
  ChatStep? nextSelectedStep;
  // Une petite booléenne pour décider de si on inverse le scrollview ou pas.
  bool isScrollable = false;
  final ScrollController _scrollController = ScrollController();

  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;

  @override
  void initState() {
    super.initState();
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 1));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 1));

    chatMessagesSections.add(AssistantMessagesSection(
        chatResponse: AppConstants.yeeguidesList[widget.selectedYeeguideIndex]
            .script.steps[0].response));

    _startAnimation();
  }

  @override
  void dispose() {
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // C'est la méthode _startAnimation qui gère animationLevel
  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 900));

    setState(() {
      animationLevel++;
      // _controllerCenterRight.play();
      // _controllerCenterLeft.play();
    });

    await Future.delayed(const Duration(milliseconds: 2500));

    setState(() {
      animationLevel++;
    });
  }

  @override
  Widget build(BuildContext context) {
    askQuestion(int index) {
      setState(() {
        alreadyAnsweredFaqOptions.add(currentUserFaqOptions[index]);
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          chatMessagesSections.add(UserMessagesSection(
              initialPrompt: currentUserFaqOptions[index].question,
              nextSteps: currentUserFaqOptions[index].answer.nextSteps));
        });
      });

      Future.delayed(const Duration(milliseconds: 1400), () {
        setState(() {
          chatMessagesSections.add(AssistantMessagesSection(
            chatResponse: currentUserFaqOptions[index].answer,
          ));
        });
      });

      // Future.delayed(Duration(milliseconds: 500), (){
      // setState(() {

      // });

      // chatMessagesSections.add(
      //     AssistantMessagesSection(
      //         chatResponse:
      //         nextSelectedStep!
      //             .response));

      // });
    }

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
          child: Column(
            children: [
              // CHAT HEADER (Clean ça en fin de semaine)
              AnimatedOpacity(
                  opacity: animationLevel >= 2 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: TutorialChatScreenHeader()),
              // CHAT BODY
              Expanded(
                // Il y'avait un SizedBox de 1.sw ici au cas où qqch part en yeuks.
                child: Stack(
                  children: [
                    NotificationListener(
                      onNotification: (scrollNotification) {
                        if (_scrollController.position.maxScrollExtent > 0 &&
                            !isScrollable) {
                          // print("ScrollStartNotification");
                          setState(() {
                            isScrollable = true;
                          });
                          return false;
                        }
                        return true;
                        // add your logic here
                      },
                      child: SingleChildScrollView(
                        reverse: isScrollable,
                        controller: _scrollController,
                        child: Column(
                          children: [
                            AnimatedContainer(
                                duration: const Duration(milliseconds: 700),
                                padding: EdgeInsets.only(
                                    // 163-10
                                    left: 10.0,
                                    right: 10.0,
                                    bottom: isFaqVisible ? 10 : 163),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    AnimatedOpacity(
                                      opacity: animationLevel >= 2 ? 1.0 : 0.0,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: Text(
                                        "Aujourd'hui",
                                        style: TextStyle(
                                            color: AppColors.secondaryText),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      width: 1.sw,
                                      // color: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7),
                                      // color: Colors.red,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: SizedBox(
                                              height: 59,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Hero(
                                                    tag:
                                                        "tag-${widget.selectedYeeguideIndex}",
                                                    child: Image.asset(
                                                      AppConstants
                                                          .yeeguidesList[widget
                                                              .selectedYeeguideIndex]
                                                          .profilePictureAsset,
                                                      height: 43,
                                                      width: 43,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // if(chatMessagesSections.isNotEmpty)...[

                                          SuitedMessageBubbles(
                                            // chatMessages: conservation1
                                            //     .steps.first.response.text,
                                            username: widget.username,
                                            chatResponse: (chatMessagesSections
                                                        .first
                                                    as AssistantMessagesSection)
                                                .chatResponse,
                                            animationLevel: animationLevel,
                                            updateCurrentUserOptions: (
                                                {required List<ChatStep>?
                                                    newOptions,
                                                required List<FaqStep>?
                                                    newFaqOptions}) {
                                              if (newOptions != null) {
                                                setState(() {
                                                  currentUserOptions =
                                                      newOptions;
                                                });
                                              } else if (newFaqOptions !=
                                                  null) {
                                                setState(() {
                                                  currentUserFaqOptions =
                                                      newFaqOptions;
                                                  isFaqVisible = true;
                                                });
                                              }
                                            },
                                            dropConfetti: () {
                                              debugPrint("Called confetti");
                                              _controllerCenterLeft.play();
                                              _controllerCenterRight.play();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                    // if(currentUserFaqOptions.isNotEmpty)...[
                                    //   const SizedBox(
                                    //     height: 15,
                                    //   ),
                                    // ],
                                    ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: chatMessagesSections.length,
                                      itemBuilder: (context, index) {
                                        return index == 0
                                            ? Container()
                                            : chatMessagesSections[index]
                                                    is UserMessagesSection
                                                ? UserMessagesSectionWidget(
                                                    text: (chatMessagesSections[
                                                                index]
                                                            as UserMessagesSection)
                                                        .initialPrompt)
                                                : AssistantMessagesSectionWidget(
                                                    widget: widget,
                                                    chatResponse:
                                                        (chatMessagesSections[
                                                                    index]
                                                                as AssistantMessagesSection)
                                                            .chatResponse,
                                                    animationLevel:
                                                        animationLevel,
                                                    messageSectionIndex: index,
                                                    updateCurrentUserOptions: (
                                                        {required List<
                                                                ChatStep>?
                                                            newOptions,
                                                        required List<FaqStep>?
                                                            newFaqOptions}) {
                                                      if (newOptions != null) {
                                                        setState(() {
                                                          currentUserOptions =
                                                              newOptions;
                                                        });
                                                      } else if (newFaqOptions !=
                                                          null) {
                                                        setState(() {
                                                          currentUserFaqOptions =
                                                              newFaqOptions;
                                                          isFaqVisible = true;
                                                        });
                                                      }
                                                    },
                                                    dropConfetti: () {
                                                      debugPrint(
                                                          "Called confetti");
                                                      _controllerCenterRight
                                                          .play();
                                                      _controllerCenterLeft
                                                          .play();
                                                    },
                                                  );
                                      },
                                    ),
                                    AnimatedSizeAndFade.showHide(
                                      fadeDuration:
                                          const Duration(milliseconds: 900),
                                      sizeDuration:
                                          const Duration(milliseconds: 900),
                                      show: currentUserFaqOptions.isNotEmpty,
                                      child: SizedBox(
                                        height: isFaqVisible ? null : 0,
                                        child: Stack(
                                          children: [
                                            FAQWidget(
                                              faqSteps: currentUserFaqOptions,
                                              askQuestion: askQuestion,
                                              toggleFAQ: (bool newState) {
                                                setState(() {
                                                  isFaqVisible = newState;
                                                });
                                              },
                                              alreadySteppedFaqs:
                                                  alreadyAnsweredFaqOptions,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )

                                // ListView.builder(
                                //   physics: NeverScrollableScrollPhysics(),
                                //   shrinkWrap: true,
                                //   itemCount: chatMessagesSections.length,
                                //   itemBuilder: (context, index) {
                                //     return AssistantMessagesSection(messageSectionIndex: index, widget: widget, chatMessages: chatMessagesSections[index].messages, animationLevel: animationLevel);
                                //   },
                                // ),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                // AnimatedOpacity(
                                //   opacity: animationLevel >= 2 ? 1.0 : 0.0,
                                //   duration: Duration(milliseconds: 500),
                                //   child: Text("Aujourd'hui",
                                //     style: TextStyle(
                                //         color: AppColors.secondaryText
                                //     ),
                                //   ),
                                // ),

                                ),
                          ],
                        ),
                      ),
                    ),

                    AnimatedPositioned(
                        duration: const Duration(milliseconds: 400),
                        bottom: currentUserOptions.isNotEmpty ? 0 : -152,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: TutorialChatScreenFooter(
                            scrollController: _scrollController,
                            shouldOpenKeyboard: false,
                          ),
                        )),
                    Positioned(
                      top: 65,
                      right: 0,
                      child: ConfettiWidget(
                        maxBlastForce: 15.0,
                        confettiController: _controllerCenterRight,
                        blastDirection: pi + 0.7, // radial value - LEFT
                        particleDrag: 0.05, // apply drag to the confetti
                        emissionFrequency: 0.19, // how often it should emit
                        numberOfParticles: 4, // number of particles to emit
                        gravity: 0.5, // gravity - or fall speed
                        shouldLoop: false,
                        colors: const [
                          Colors.green,
                          Colors.blue,
                          Colors.pink,
                          Colors.yellow
                        ], // manually specify the colors to be used
                        strokeWidth: 0,
                        strokeColor: Colors.white,
                      ),
                    ),
                    //CENTER LEFT - Emit right
                    Positioned(
                      left: 0,
                      top: 65,
                      child: ConfettiWidget(
                        maxBlastForce: 15.0,
                        confettiController: _controllerCenterLeft,
                        blastDirection: -0.8, // radial value - LEFT
                        particleDrag: 0.05, // apply drag to the confetti
                        emissionFrequency: 0.19, // how often it should emit
                        numberOfParticles: 4, // number of particles to emit
                        gravity: 0.5, // gravity - or fall speed
                        shouldLoop: false,
                        colors: const [
                          Colors.green,
                          Colors.blue,
                          Colors.pink,
                          Colors.yellow,
                        ], // manually specify the colors to be used
                        strokeWidth: 0,
                        strokeColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FAQWidget extends StatefulWidget {
  const FAQWidget(
      {Key? key,
      required this.faqSteps,
      required this.askQuestion,
      required this.toggleFAQ,
      required this.alreadySteppedFaqs})
      : super(key: key);

  final List<FaqStep> faqSteps;
  final List<FaqStep> alreadySteppedFaqs;
  final Function(int index) askQuestion;
  final Function(bool newState) toggleFAQ;

  @override
  State<FAQWidget> createState() => _FAQWidgetState();
}

class _FAQWidgetState extends State<FAQWidget> {
  int animationLevel = 0;

  @override
  void initState() {
    _startAnimation();
    super.initState();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 2300));

    setState(() {
      animationLevel = 1;
    });
  }

  @override
  void dispose() {
    // if (this.mounted) {

    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 510,
      width: 1.sw,
      margin: const EdgeInsets.only(top: 15),
      // color: Colors.red,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: animationLevel == 0
            ? const QuestionsListShimmerLoad()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.faqSteps.length == 6
                            ? "Sélectionnez une question :"
                            : widget.faqSteps.length >= 3
                                ? "Il ne vous reste plus que ${widget.faqSteps.length - 1} questions :"
                                : widget.faqSteps.length == 2
                                    ? "Il ne vous reste plus qu'une question :"
                                    : "Il n'y a plus de questions, appuyez pour terminer :",
                        style: TextStyle(color: AppColors.secondaryText),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  for (int index = 0; index < widget.faqSteps.length; index++)
                    if (!widget.alreadySteppedFaqs
                        .contains(widget.faqSteps[index])) ...[
                      // Seulement afficher le QuestionWidget si l'élément n'est pas dans alreadySteppedFaqs
                      QuestionWidget(
                        question: widget.faqSteps[index].question,
                        askQuestion: () {
                          widget.toggleFAQ(false);
                          widget.askQuestion(index);
                        },
                      )
                    ]

                  // QuestionWidget(question: "C’est bon, j’ai compris le concept 👍🏽")
                ],
              ),
      ),
      // child: QuestionsListShimmerLoad(),
    );
  }
}

class QuestionsListShimmerLoad extends StatelessWidget {
  const QuestionsListShimmerLoad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.secondaryText.withOpacity(.5),
      highlightColor: AppColors.secondaryText,
      period: const Duration(milliseconds: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Questions en cours de génération...",
                style: TextStyle(color: AppColors.primaryText),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const QuestionWidgetShimmer(width: 100),
          const QuestionWidgetShimmer(width: 180),
          const QuestionWidgetShimmer(width: 230),
          const QuestionWidgetShimmer(width: 255, height: 50),
          const QuestionWidgetShimmer(width: 180),
          const QuestionWidgetShimmer(width: 210),
          const QuestionWidgetShimmer(width: 257, height: 50),
          const QuestionWidgetShimmer(width: 254, height: 50),
          const QuestionWidgetShimmer(width: 180),
        ],
      ),
    );
  }
}

class QuestionWidgetShimmer extends StatelessWidget {
  const QuestionWidgetShimmer({
    super.key,
    required this.width,
    this.height,
  });

  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 27,
      width: width,
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.secondaryText.withOpacity(.3),
        border: Border.all(
          color: AppColors.secondaryText.withOpacity(.5),
          width: 1.0,
        ),
      ),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    super.key,
    required this.question,
    required this.askQuestion,
  });

  final Function() askQuestion;
  final String question;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      constraints: const BoxConstraints(
        maxWidth: 330,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.secondaryText.withOpacity(.5),
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: () {
          askQuestion();
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            question,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}

class UserMessagesSectionWidget extends StatefulWidget {
  const UserMessagesSectionWidget({Key? key, required this.text})
      : super(key: key);
  final String text;

  @override
  State<UserMessagesSectionWidget> createState() =>
      _UserMessagesSectionWidgetState();
}

class _UserMessagesSectionWidgetState extends State<UserMessagesSectionWidget> {
  bool isVisible = false;

  @override
  void initState() {
    _startAnimation();
    super.initState();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      isVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSizeAndFade.showHide(
      show: isVisible,
      fadeDuration: const Duration(milliseconds: 300),
      sizeDuration: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                constraints: const BoxConstraints(
                    maxWidth: 245, minWidth: 10, minHeight: 40),
                margin: const EdgeInsets.only(left: 5.0, top: 0.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: [
                      AppColors.primaryVar0, // Couleur du bas droit
                      const Color(0xFF3FBBFF)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.text,
                  style: const TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}

// LES WIDGETS DU CHAT DE L'ASSISTANT : Tu dois tous les revoir pour avoir moins de stateful

// 1 - Isole la logique actuelle de SuitedMessageBubbles dans un widget SpecialAssistantMessagesSectionWidget puis commence à
// travailler avec le reste à l'identique.

// 2 - Faire monter SuitedMessageBubble dans Assistant en terme de state pour que Suited devienne stateless, de toute façon il n'y a qu'un par widget
// so tu n'as pas d'arguments.

// 3 - Il s'agirait de réetudier mais en vrai je pense que tout peut monter ensemble, ça ne dépendra que de toi

// 4 - Renseigen toi sur big stateful widget vs many small ones : https://stackoverflow.com/questions/66559843/one-big-statefulwidget-or-multiple-small-statefulwidgets#:~:text=Keep%20in%20mind%20that%20everything,need%20state%20management%20(stateless).

// 5 - Fais aussi des tests de performance, de toute façon si le code est performant, tu peux t'en tenir qu'à la base et avancer.

class AssistantMessagesSectionWidget extends StatelessWidget {
  const AssistantMessagesSectionWidget({
    super.key,
    required this.widget,
    required this.chatResponse,
    required this.animationLevel,
    required this.messageSectionIndex,
    required this.updateCurrentUserOptions,
    required this.dropConfetti,
  });

  final TutorialChatScreen widget;
  final ChatResponse chatResponse;
  final int animationLevel;
  final int messageSectionIndex;
  final Function(
      {required List<ChatStep>? newOptions,
      required List<FaqStep>? newFaqOptions}) updateCurrentUserOptions;
  final Function() dropConfetti;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      // color: Colors.red,
      padding: const EdgeInsets.symmetric(vertical: 7),
      // color: Colors.red,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            flex: 2,
            child: SizedBox(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Hero(
                    tag: "tag-${widget.selectedYeeguideIndex}",
                    child: Image.asset(
                      AppConstants.yeeguidesList[widget.selectedYeeguideIndex]
                          .profilePictureAsset,
                      height: 43,
                      width: 43,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SuitedMessageBubbles(
            username: widget.username,
            chatResponse: chatResponse,
            animationLevel: animationLevel,
            dropConfetti: dropConfetti,
            updateCurrentUserOptions: updateCurrentUserOptions,
          )
        ],
      ),
    );
  }
}

class SuitedMessageBubbles extends StatefulWidget {
  const SuitedMessageBubbles(
      {Key? key,
      required this.chatResponse,
      required this.animationLevel,
      required this.updateCurrentUserOptions,
      required this.username,
      required this.dropConfetti})
      : super(key: key);

  final ChatResponse chatResponse;
  final String username;
  final int animationLevel;
  final Function({
    required List<ChatStep>? newOptions,
    required List<FaqStep>? newFaqOptions,
  }) updateCurrentUserOptions;
  final Function() dropConfetti;

  @override
  State<SuitedMessageBubbles> createState() => _SuitedMessageBubblesState();
}

class _SuitedMessageBubblesState extends State<SuitedMessageBubbles> {
  bool isTyping = true;
  List<String> actualMessages = [];
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    // await Future.delayed(Duration(milliseconds: 1000));

    // Ici c'est le délai pour l'envoi du premier message custom :

    setState(() {
      actualMessages.add(widget.chatResponse.text.first);
    });

    if ([
      "Dans ce cas, tu es au bon endroit !",
      "Dans c'cas mon reuf, t'es au bon endroit !"
    ].contains(widget.chatResponse.text.first)) {
      await Future.delayed(const Duration(milliseconds: 900));
      setState(() {
        isTyping = false;
      });
      return;
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 8,
      child: SizedBox(
        width: 1.sw,
        // height: 450,
        // constraints: BoxConstraints(
        //   minHeight: 40
        // ),
        // color: Colors.blue,
        child: Column(
          children: [
            for (int index = 0;
                index < widget.chatResponse.text.length;
                index++)
              AnimatedSizeAndFade.showHide(
                show: index <= (actualMessages.length - 1),
                fadeDuration: const Duration(milliseconds: 400),
                sizeDuration: const Duration(milliseconds: 400),
                child: ChatbotBubbleText(
                  animationLevel: widget.animationLevel,
                  isFirst: index == 0,
                  text: widget.chatResponse.text[index],
                  username: widget.username,
                  isTypingChecker: index == 0 ? isTyping : false,
                  onTextFinished: () {
                    debugPrint("The index : $index");
                    // debugPrint("The index : ${widget.chatMessages.length}");
                    // if(currentIndex < widget.chatMessages.length - 1)
                    //   currentIndex++;
                    if (index + 1 <= widget.chatResponse.text.length - 1 &&
                            widget.chatResponse.text[index + 1] ==
                                "abracadabra !" ||
                        index + 1 <= widget.chatResponse.text.length - 1 &&
                            widget.chatResponse.text[index + 1] == "#vie.") {
                      debugPrint("Drop sum confettito");
                      Future.delayed(const Duration(milliseconds: 650), () {
                        widget.dropConfetti();
                      });
                    }

                    if (widget.chatResponse.text[index] == "#;enable_faq;#" ||
                        index + 1 <= widget.chatResponse.text.length - 1 &&
                            widget.chatResponse.text[index + 1] ==
                                "#;enable_faq;#") {
                      debugPrint("Nous sommes arrivé au FAQ !");

                      // Quand on enable le FAQ, vérifie
                      // if(widget.al)
                      widget.updateCurrentUserOptions(
                          newOptions: null,
                          newFaqOptions: conservation1.faqSteps);
                      return;
                    }

                    if (widget.chatResponse.text[index] ==
                        "Dans ce cas, tu es au bon endroit !") {
                      Future.delayed(const Duration(milliseconds: 1100), () {
                        setState(() {
                          actualMessages.add("");
                        });
                      });
                    } else {
                      if (index < widget.chatResponse.text.length - 1) {
                        setState(() {
                          Future.delayed(const Duration(milliseconds: 400), () {
                            setState(() {
                              // Ici tu vérifies si on a le code du FAQ ou pas
                              actualMessages.add("");
                            });
                          });
                        });
                      } else {
                        debugPrint("ChatStep terminé, voici les options :");
                        widget.updateCurrentUserOptions(
                            newOptions: widget.chatResponse.nextSteps,
                            newFaqOptions: null);
                        debugPrint(widget.chatResponse.nextSteps.toString());
                      }
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ChatbotBubbleText extends StatelessWidget {
  const ChatbotBubbleText({
    super.key,
    required this.animationLevel,
    required this.text,
    required this.onTextFinished,
    required this.isTypingChecker,
    required this.isFirst,
    required this.username,
  });

  final String text;
  final String username;
  final int animationLevel;
  final Function onTextFinished;
  final bool isTypingChecker;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 1.sw,
      // color: Colors.yellow,
      child: AnimatedOpacity(
        opacity: animationLevel >= 1 ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(
                  maxWidth: 245, minWidth: 10, minHeight: 40),
              margin: const EdgeInsets.only(left: 5.0, top: 5.0),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.secondaryText.withOpacity(.13),
                borderRadius: BorderRadius.circular(20),
              ),
              child: isTypingChecker
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        width: 22,
                        child: Lottie.asset('assets/animations/typing.json'),
                      ),
                    )
                  : TextBox(
                      onTextFinished: onTextFinished,
                      text: text,
                      isFirst: isFirst,
                      username: username,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tu peux recréer cette logique sans stateful widget donc on verra dans le futur comment économiser ici.

class TextBox extends StatefulWidget {
  const TextBox(
      {Key? key,
      required this.onTextFinished,
      required this.text,
      this.duration,
      required this.isFirst,
      required this.username})
      : super(key: key);
  final Function onTextFinished;
  final String text;
  final String username;
  final bool isFirst;
  final Duration? duration;

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  bool _delayCompleted = false;

  @override
  void initState() {
    super.initState();
    // Ajoutez cette ligne pour déclencher le changement après 3 secondes
    Future.delayed(
        widget.isFirst ? Duration.zero : const Duration(milliseconds: 300), () {
      setState(() {
        _delayCompleted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _delayCompleted
        ? AnimatedTextKit(
            totalRepeatCount: 1,
            pause: const Duration(milliseconds: 00),
            onFinished: () {
              widget.onTextFinished();
            },
            animatedTexts: [
              TyperAnimatedText(
                widget.text.contains("#;username;#")
                    ? remplacerNomDansPhrase(
                        widget.text,
                        widget.username.isNotEmpty
                            ? widget.username
                            : "cher utilisateur")
                    : widget.text,
                speed: const Duration(milliseconds: 40),
                textStyle: TextStyle(
                  fontSize: 13,
                  color: AppColors.primaryText,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          )
        : const SizedBox();
  }
}
