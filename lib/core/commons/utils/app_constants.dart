import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main_feature/domain/model/yeeguide.dart';
import '../../di/locator.dart';
import '../../domain/models/chatbot_conversation.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

enum YeeguideId {
  raruto,
  songo,
  domsa,
  madio,
  vaidewish,
  rita,
  issa,
  djibril
}

extension YeeguideIdExtension on YeeguideId {
  String get value {
    //gey
    switch (this) {
      case YeeguideId.raruto:
        return "raruto";
      case YeeguideId.songo:
        return "songo";
      case YeeguideId.domsa:
        return "domsa";
      case YeeguideId.madio:
        return "sane_madio";
      case YeeguideId.vaidewish:
        return "vaidewish";
      case YeeguideId.rita:
        return "rita";
      case YeeguideId.issa:
        return "issa";
      case YeeguideId.djibril:
        return "djibril";
      default:
        return "";
    }
  }
}

class AppConstants {

  static double screenWidth = 1.sw;
  static double screenHeight = 1.sh;
  // Map IDS :
  static const MarkerId userPosId = MarkerId("user_pos");
  static const CircleId userPosCircleId = CircleId("user_pos_circle");

  // OLD VERSIONS :

  //   static Conversation songoConvo = Conversation(
  //     steps: [
  //       ChatStep(
  //           prompt: "Oui, depuis des lustres !",
  //           response: ChatResponse(text: [
  //             "Dans ce cas, tu es au bon endroit !",
  //             "Salut #;username;#, moi c'est Usman Songo, ton nouveau Yeeguide. \n\nJe réponds à toutes tes questions sur les transports à Dakar.",
  //             "En route pour 2024 !",
  //             "Prêt pour une petite démo ?",
  //             // "#;enable_faq;#",
  //           ], nextSteps: [
  //             // PARTANT POUR UNE DEMO
  //             ChatStep(
  //                 prompt: 'Oui, on y va !',
  //                 response: ChatResponse(text: [
  //                   "Super, alors déjà, je sais parler Français, Anglais, et Wolof.",
  //                   "Parcontre, je suis encore médiocre en wolof donc peut-être que Yeebus a désactivé ça.",
  //                   "Ces satanés développeurs.. ils se croient tout puissant pff."
  //                 ], nextSteps: [
  //                   // ON RESTE EN FRANCAIS.
  //                   ChatStep(
  //                       prompt: "On reste en français dans ce cas.",
  //                       response: ChatResponse(text: [
  //                         "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                         "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                         "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                         "2 - Tu pioches n’importe laquelle.",
  //                         "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                         "(même qui va gagner les élections 2024 🌚)",
  //                         "On y va ?"
  //                       ], nextSteps: [
  //                         ChatStep(
  //                             prompt: "Oui, je veux voir ça.",
  //                             response: ChatResponse(text: [
  //                               "Bismillah !",
  //                               "#;enable_faq;#"
  //                             ], nextSteps: [
  //                               // FIN BRANCHE
  //                             ])),
  //                         ChatStep(
  //                             prompt:
  //                                 "Dis moi d'abord qui va gagner les élections 👀",
  //                             response: ChatResponse(text: [
  //                               "Bah moi bien évidemment.. *AHEM*",
  //                               "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                               "donc je mise plutôt sur.. humm..",
  //                               "Yousou Ndul c'est mon favoris. 😁"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "😂😂 Revenons en aux bus",
  //                                   response: ChatResponse(text: [
  //                                     "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                     "On lance le jeu 🎲",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                             ])),
  //                       ])),

  //                   // ON TESTE LE WOLOF.
  //                   ChatStep(
  //                       prompt: 'Ma khol wolof bi bokk 👀',
  //                       response: ChatResponse(text: [
  //                         "Mann Songo magui soukkendiku rewwmi ndakh niou mankoo téléchargé Yeebus dans les plus brefs délais.",
  //                         "... désolé je ne peux pas faire mieux 😭😭",
  //                         "On reste en français finalement, ça te va ?"
  //                       ], nextSteps: [
  //                         ChatStep(
  //                             prompt: "Oui, c'est mieux.",
  //                             response: ChatResponse(text: [
  //                               "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                               "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                               "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                               "2 - Tu pioches n’importe laquelle.",
  //                               "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                               "(même qui va gagner les élections 2024 🌚)",
  //                               "On y va ?"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "Oui, je veux voir ça.",
  //                                   response: ChatResponse(text: [
  //                                     "Bismillah !",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                               ChatStep(
  //                                   prompt:
  //                                       "Dis moi d'abord qui va gagner les élections 👀",
  //                                   response: ChatResponse(text: [
  //                                     "Bah moi bien évidemment.. *AHEM*",
  //                                     "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                                     "donc je mise plutôt sur.. humm..",
  //                                     "Yousou Ndul c'est mon favoris. 😁"
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "😂😂 Revenons en aux bus",
  //                                         response: ChatResponse(text: [
  //                                           "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                           "On lance le jeu 🎲",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [
  //                                           // FIN BRANCHE
  //                                         ])),
  //                                   ])),
  //                             ])),
  //                       ])),
  //                 ])),
  //             // PAS PARTANT POUR UNE DEMO (Confetti d'abord puis on loop) :
  //             ChatStep(
  //                 prompt: 'Non, je veux plus de confetti d\'abord 🙂',
  //                 response: ChatResponse(text: [
  //                   "Non mais sérieusement, tu pouvais pas juste suivre le script ? Ohlala..",
  //                   "Qui t'a dit que je sais faire ça moi ? 💀",
  //                   "Bon, voilà pour toi.., mais c'est la dernière fois",
  //                   // "#;drop_confetti;#",
  //                   "abracadabra !"
  //                 ], nextSteps: [
  //                   ChatStep(
  //                       prompt:
  //                           'Mercii 😂, on peut commencer la démo maintenant.',
  //                       response: ChatResponse(text: [
  //                         "Derien 🤝🏽 (façon j'ai pas le choix, j'ai été programmé pour ça..)",
  //                         "Super, alors déjà, je sais parler Français, Anglais, et Wolof.",
  //                         "Parcontre, je suis encore médiocre en wolof donc peut-être que Yeebus a désactivé ça.",
  //                         "Ces satanés développeurs.. ils se croient tout puissant pff."
  //                       ], nextSteps: [
  //                         // ON RESTE EN FRANCAIS.
  //                         ChatStep(
  //                             prompt: "On reste en français dans ce cas.",
  //                             response: ChatResponse(text: [
  //                               "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                               "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                               "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                               "2 - Tu pioches n’importe laquelle.",
  //                               "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                               "(même qui va gagner les élections 2024 🌚)",
  //                               "On y va ?"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "Oui, je veux voir ça.",
  //                                   response: ChatResponse(text: [
  //                                     "Bismillah !",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                               ChatStep(
  //                                   prompt:
  //                                       "Dis moi d'abord qui va gagner les élections 👀",
  //                                   response: ChatResponse(text: [
  //                                     "Bah moi bien évidemment.. *AHEM*",
  //                                     "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                                     "donc je mise plutôt sur.. humm..",
  //                                     "Yousou Ndul c'est mon favoris. 😁"
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "😂😂 Revenons en aux bus",
  //                                         response: ChatResponse(text: [
  //                                           "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                           "On lance le jeu 🎲",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [])),
  //                                   ])),
  //                             ])),

  //                         // ON TESTE LE WOLOF.
  //                         ChatStep(
  //                             prompt: 'Ma khol wolof bi bokk 👀',
  //                             response: ChatResponse(text: [
  //                               "Mann Songo magui soukkendiku rewwmi ndakh niou mankoo téléchargé Yeebus dans les plus brefs délais.",
  //                               "... désolé je ne peux pas faire mieux 😭😭",
  //                               "On reste en français finalement, ça te va ?"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "Oui, c'est mieux.",
  //                                   response: ChatResponse(text: [
  //                                     "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                                     "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                                     "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                                     "2 - Tu pioches n’importe laquelle.",
  //                                     "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                                     "(même qui va gagner les élections 2024 🌚)",
  //                                     "On y va ?"
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "Oui, je veux voir ça.",
  //                                         response: ChatResponse(text: [
  //                                           "Bismillah !",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [
  //                                           // FIN BRANCHE
  //                                         ])),
  //                                     ChatStep(
  //                                         prompt:
  //                                             "Dis moi d'abord qui va gagner les élections 👀",
  //                                         response: ChatResponse(text: [
  //                                           "Bah moi bien évidemment.. *AHEM*",
  //                                           "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                                           "donc je mise plutôt sur.. humm..",
  //                                           "Yousou Ndul c'est mon favoris. 😁"
  //                                         ], nextSteps: [
  //                                           ChatStep(
  //                                               prompt:
  //                                                   "😂😂 Revenons en aux bus",
  //                                               response: ChatResponse(text: [
  //                                                 "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                                 "On lance le jeu 🎲",
  //                                                 "#;enable_faq;#"
  //                                               ], nextSteps: [])),
  //                                         ])),
  //                                   ])),
  //                             ])),
  //                       ]))
  //                 ]))
  //           ]))
  //     ],
  //     faqSteps: [
  //       FaqStep(
  //           question:
  //               "Quel est le meilleur itinéraire pour aller de la place de l’obélisque au Monument de la renaissance en bus ?",
  //           answer: ChatResponse(text: [
  //             "Tu veux donc faire un trajet Colobane-Ouakam, voici ce que je te suggère : \n\n- Rends-toi à l’arrêt bus en face du collège Kennedy. \n\n- Prends la ligne 54 jusqu’à la cité universitaire (UCAD). \n\n- Rendez-vous à l’arrêt bus d’en face. \n\n- Prenez la ligne 7 (DDD) jusqu’à Ouakam. \n\nEntamez une marche de 5 minutes vers le monument (qui n’est pas difficile à voir 👀) \n\n15 - 25 minutes de trajet pour seulement 250 FCFA.",
  //             "🚨 ATTENTION : \n\nIl existe des carapides pour faire ce trajet beaucoup plus rapidement.\n\nCependant, l’équipe Yeebus est encore entrain de travailler sur les données en rapport avec le réseau informel.\n\nAlors n’hésite pas à contacter leur service client en attendant.",
  //             "🚨 ET SURTOUT : \n\nLes instructions écrites ne servent que d’indication approximative.\n\nL’application Yeebus mettra à ta disposition une carte où je pourrai te guider en temps réel d’un arrêt à un autre jusqu’à ta destination.\n\nMais elle est encore en cours de conception \n\n(décidemment ces développeurs de vrais incapables..)",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question:
  //               "Combien coûterait un trajet de Mermoz au Parc Zoologique de Hann en bus ?",
  //           answer: ChatResponse(text: [
  //             "3.000 FCFA...",
  //             "C’est ce que tu aurais payé en prenant un taxi.\n\nEn bus cela dépendra des lignes empruntés mais avec l’itinéraire optimal, pas plus de 350 FCFA.",
  //             "🚨 ET SURTOUT : \n\nL’équipe Yeebus étudie encore le système de tarification, je me base donc sur des estimations en attendant.\n\nPrend toujours un billet de plus que prévu avec toi, on ne sait jamais 😉",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question: "Est-ce que la ligne 7 passe vers UCAD ?",
  //           answer: ChatResponse(text: [
  //             "Oui, la ligne 7 passe vers UCAD.",
  //             "J’ai été programmé pour être simple et drôle donc je m’arrête là.\n\nQu’est-ce qui est jaune et qui attend ?",
  //             "Jonathan.\n\n*badum tss* 🥁",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question:
  //               "La ligne 7 est-elle accessible aux personnes à mobilité réduite ?",
  //           answer: ChatResponse(text: [
  //             "La ligne 7 de Dakar Dem Dikk peut être constituée de plusieurs modèle de bus.\n\nJe ne peux donc pas garantir que toute la ligne soit accessible.",
  //             "Cependant, la compagnie Dakar Dem Dikk a récemment reçu une toute nouvelle flotte de bus.\n\nIl se peut donc que la plupart des bus de la ligne 7 soient en effet accessibles, surtout s’ils disposent de l’icône suivant : \n\n♿",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question: "La mort ou tchi-tchi ?",
  //           answer: ChatResponse(text: [
  //             "Désolé, #;username;#, on me tue mais on ne me déshonore pas 😂😂",
  //             "Je vais me donner la mort avant même que tu n'aies dit 'd'accord, mais d'abord tchitchi ' 🤣",
  //             "Bref, pose une vraie question cette fois :",
  //             "#;enable_faq;#"
  //           ], nextSteps: [
  //             ChatStep(
  //                 prompt: "D'accord, mais d'abord tchi-tchi.",
  //                 response: ChatResponse(text: [
  //                   "😂😂😂😂 non merci #;username;#, je passe mon tour 🏃🏽‍",
  //                   "Pose moi une vraie question plutôt :"
  //                       "#;disable_faq;#",
  //                 ], nextSteps: [])),
  //           ])),
  //       FaqStep(
  //           question: "C’est bon, j’ai compris le concept 👍🏽",
  //           answer: ChatResponse(text: [
  //             "Super, tu as donc pu avoir un aperçu de mes compétences.",
  //             "L'application n'a pas encore été déployée donc les rats de l'équipe Yeebus sont probablement devant toi en ce moment même 👀.",
  //             "Bon, j'aime les chatier mais ce sont des gars motivés.",
  //             "Alors si tu aimes le concept de l'app, rejoins nous dans la communauté Whatsapp ! 🔥, \n\nOn y rigole bien entre bus preneurs.",
  //             "Ciao !"
  //           ], nextSteps: [])),
  //     ],
  //     afterFaq: ChatStep(
  //         prompt: "",
  //         response: ChatResponse(text: [
  //           "Super, tu as donc pu avoir un aperçu de mes compétences.",
  //           "L'application n'a pas encore été déployée donc les rats de l'équipe Yeebus sont probablement devant toi en ce moment même 👀.",
  //           "Bon, j'aime les chatier mais ce sont des gars motivés.",
  //           "Alors si tu aimes le concept de l'app, rejoins nous dans la communauté Whatsapp ! 🔥, \n\nOn y rigole bien entre bus preneurs.",
  //           "Ciao !"
  //         ], nextSteps: [
  //           // ChatStep(
  //           // prompt: "Oui, envoie la moi !.",
  //           // response: ChatResponse(
  //           // text: [
  //           // "#;drop_video;#",
  //           // ],
  //           // nextSteps: [
  //           //
  //           // ]
  //           // )
  //           // ),
  //         ])));
  // static Conversation domsaConvo = Conversation(
  //     steps: [
  //       ChatStep(
  //           prompt: "Oui, depuis des lustres !",
  //           response: ChatResponse(text: [
  //             "Dans c'cas mon reuf, t'es au bon endroit !",
  //             "Yo #;username;#, moi c'est Domsa, ton nouveau Yeeguide. \n\nJe réponds à toutes tes questions sur les transports à Dakar et la #Vie en général.",
  //             "Et j'te le dis dès maintenant, moi c'est Domsa, pas Damso #Vie 🖖🏽",
  //             "Prêt pour une petite démo ?",
  //             // "#;enable_faq;#",
  //           ], nextSteps: [
  //             // PARTANT POUR UNE DEMO
  //             ChatStep(
  //                 prompt: 'Oui, on y va !',
  //                 response: ChatResponse(text: [
  //                   "Ok. Alors d'ja moi j'parle Français, Anglais, et Wolof.",
  //                   "Parcontre, je suis encore médiocre en wolof donc peut-être que Yeebus a désactivé ça.",
  //                   "Tous les développeurs sont pareils, le diable parle à travers eux.\n\net ouais.."
  //                 ], nextSteps: [
  //                   // ON RESTE EN FRANCAIS.
  //                   ChatStep(
  //                       prompt: "On reste en français dans ce cas.",
  //                       response: ChatResponse(text: [
  //                         "En voilà un bon choix, tes yeux te remercieront pour ça. 🗿",
  //                         "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                         "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                         "2 - Tu pioches n’importe laquelle.",
  //                         "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                         "(même si tu me demandes qu'est-ce que la vie)",
  //                         "On y va ?"
  //                       ], nextSteps: [
  //                         ChatStep(
  //                             prompt: "Oui, je veux voir ça.",
  //                             response: ChatResponse(text: [
  //                               "C'est parti :",
  //                               "#;enable_faq;#"
  //                             ], nextSteps: [
  //                               // FIN BRANCHE
  //                             ])),
  //                         ChatStep(
  //                             prompt: "Dis moi d'abord qu'est-ce que la vie ",
  //                             response: ChatResponse(text: [
  //                               "Qu'est-ce que la vie mec ? J'sais pas trop en vrai \nCe que je sais c'est qu'elle est loin d'être belle et rose",
  //                               "La vie c'est de savoir d'où on vient, connaître ses origines\nPour pas oublier, pour rester vrai et pas devenir hautain\nMoi j'ai mes racines plantées dans le sol africain\nC'est ce qui me fait avancer malgré tous les coups durs",
  //                               "La vie c'est fragile mec, ça peut basculer vite\nFaut profiter de chaque instant avant que ça s'arrête\nMoi j'ai decidé d'être libre et de faire ma route",
  //                               "Une lutte constante pour trouver sa place et être tranquille.. \n\nDu moins, c'est c'que j'en ai compris."
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "🔥 Revenons en aux bus",
  //                                   response: ChatResponse(text: [
  //                                     "C'est vrai que l'app s'appelle Yeebus, pas Yeerap.. bref.",
  //                                     "On lance les dés 🎲",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                             ])),
  //                       ])),

  //                   // ON TESTE LE WOLOF.
  //                   ChatStep(
  //                       prompt: 'Ma khol wolof bi bokk 👀',
  //                       response: ChatResponse(text: [
  //                         "Ladial or ni ko xall bef batay mu mél ni mu mél",
  //                         "petite punchline que j'ai volé à mon refré Dip Doundou Guiss, \nun vrai lyriciste.",
  //                         "On reste en français finalement, ça te va ?"
  //                       ], nextSteps: [
  //                         // ON RESTE EN FRANCAIS.
  //                         ChatStep(
  //                             prompt: "Oui, c'est mieux.",
  //                             response: ChatResponse(text: [
  //                               "En voilà un bon choix, tes yeux te remercieront pour ça. 🗿",
  //                               "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                               "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                               "2 - Tu pioches n’importe laquelle.",
  //                               "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                               "(même si tu me demandes qu'est-ce que la vie)",
  //                               "On y va ?"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "Oui, je veux voir ça.",
  //                                   response: ChatResponse(text: [
  //                                     "C'est parti :",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                               ChatStep(
  //                                   prompt:
  //                                       "Dis moi d'abord qu'est-ce que la vie ",
  //                                   response: ChatResponse(text: [
  //                                     "Qu'est-ce que la vie mec ? J'sais pas trop en vrai \nCe que je sais c'est qu'elle est loin d'être belle et rose",
  //                                     "La vie c'est de savoir d'où on vient, connaître ses origines\nPour pas oublier, pour rester vrai et pas devenir hautain\nMoi j'ai mes racines plantées dans le sol africain\nC'est ce qui me fait avancer malgré tous les coups durs",
  //                                     "La vie c'est fragile mec, ça peut basculer vite\nFaut profiter de chaque instant avant que ça s'arrête\nMoi j'ai decidé d'être libre et de faire ma route",
  //                                     "Une lutte constante pour trouver sa place et être tranquille.. \n\nDu moins, c'est c'que j'en ai compris."
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "🔥 Revenons en aux bus",
  //                                         response: ChatResponse(text: [
  //                                           "C'est vrai que l'app s'appelle Yeebus, pas Yeerap.. bref.",
  //                                           "On lance les dés 🎲",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [
  //                                           // FIN BRANCHE
  //                                         ])),
  //                                   ])),
  //                             ])),
  //                       ])),
  //                 ])),
  //             // PAS PARTANT POUR UNE DEMO (Confetti d'abord puis on loop) :
  //             ChatStep(
  //                 prompt: 'Non, je veux plus de confetti d\'abord 🙂',
  //                 response: ChatResponse(text: [
  //                   "J'aime ça, t'es du genre imprévisible toi.",
  //                   "Ne change jamais, la vie n'est pas faite pour suivre un script.",
  //                   "Voilà ton confetti.",
  //                   // "#;drop_confetti;#",
  //                   "#vie."
  //                 ], nextSteps: [
  //                   ChatStep(
  //                       prompt: "Merci, on peut commencer maintenant.",
  //                       response: ChatResponse(text: [
  //                         "Ok. Alors d'ja moi j'parle Français, Anglais, et Wolof.",
  //                         "Parcontre, je suis encore médiocre en wolof donc peut-être que Yeebus a désactivé ça.",
  //                         "Tous les développeurs sont pareils, le diable parle à travers eux.\n\net ouais.."
  //                       ], nextSteps: [
  //                         // ON RESTE EN FRANCAIS.
  //                         ChatStep(
  //                             prompt: "On reste en français dans ce cas.",
  //                             response: ChatResponse(text: [
  //                               "En voilà un bon choix, tes yeux te remercieront pour ça. 🗿",
  //                               "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                               "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                               "2 - Tu pioches n’importe laquelle.",
  //                               "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                               "(même si tu me demandes qu'est-ce que la vie)",
  //                               "On y va ?"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "Oui, je veux voir ça.",
  //                                   response: ChatResponse(text: [
  //                                     "C'est parti :",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                               ChatStep(
  //                                   prompt:
  //                                       "Dis moi d'abord qu'est-ce que la vie ",
  //                                   response: ChatResponse(text: [
  //                                     "Qu'est-ce que la vie mec ? J'sais pas trop en vrai \nCe que je sais c'est qu'elle est loin d'être belle et rose",
  //                                     "La vie c'est de savoir d'où on vient, connaître ses origines\nPour pas oublier, pour rester vrai et pas devenir hautain\nMoi j'ai mes racines plantées dans le sol africain\nC'est ce qui me fait avancer malgré tous les coups durs",
  //                                     "La vie c'est fragile mec, ça peut basculer vite\nFaut profiter de chaque instant avant que ça s'arrête\nMoi j'ai decidé d'être libre et de faire ma route",
  //                                     "Une lutte constante pour trouver sa place et être tranquille.. \n\nDu moins, c'est c'que j'en ai compris."
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "🔥 Revenons en aux bus",
  //                                         response: ChatResponse(text: [
  //                                           "C'est vrai que l'app s'appelle Yeebus, pas Yeerap.. bref.",
  //                                           "On lance les dés 🎲",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [
  //                                           // FIN BRANCHE
  //                                         ])),
  //                                   ])),
  //                             ])),

  //                         // ON TESTE LE WOLOF.
  //                         ChatStep(
  //                             prompt: 'Ma khol wolof bi bokk 👀',
  //                             response: ChatResponse(text: [
  //                               "Ladial or ni ko xall bef batay mu mél ni mu mél",
  //                               "petite punchline que j'ai volé à mon refré Dip Doundou Guiss, \nun vrai lyriciste.",
  //                               "On reste en français finalement, ça te va ?"
  //                             ], nextSteps: [
  //                               // ON RESTE EN FRANCAIS.
  //                               ChatStep(
  //                                   prompt: "Oui, c'est mieux.",
  //                                   response: ChatResponse(text: [
  //                                     "En voilà un bon choix, tes yeux te remercieront pour ça. 🗿",
  //                                     "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                                     "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                                     "2 - Tu pioches n’importe laquelle.",
  //                                     "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                                     "(même si tu me demandes qu'est-ce que la vie)",
  //                                     "On y va ?"
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "Oui, je veux voir ça.",
  //                                         response: ChatResponse(text: [
  //                                           "C'est parti :",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [
  //                                           // FIN BRANCHE
  //                                         ])),
  //                                     ChatStep(
  //                                         prompt:
  //                                             "Dis moi d'abord qu'est-ce que la vie ",
  //                                         response: ChatResponse(text: [
  //                                           "Qu'est-ce que la vie mec ? J'sais pas trop en vrai \nCe que je sais c'est qu'elle est loin d'être belle et rose",
  //                                           "La vie c'est de savoir d'où on vient, connaître ses origines\nPour pas oublier, pour rester vrai et pas devenir hautain\nMoi j'ai mes racines plantées dans le sol africain\nC'est ce qui me fait avancer malgré tous les coups durs",
  //                                           "La vie c'est fragile mec, ça peut basculer vite\nFaut profiter de chaque instant avant que ça s'arrête\nMoi j'ai decidé d'être libre et de faire ma route",
  //                                           "Une lutte constante pour trouver sa place et être tranquille.. \n\nDu moins, c'est c'que j'en ai compris."
  //                                         ], nextSteps: [
  //                                           ChatStep(
  //                                               prompt:
  //                                                   "🔥 Revenons en aux bus",
  //                                               response: ChatResponse(text: [
  //                                                 "C'est vrai que l'app s'appelle Yeebus, pas Yeerap.. bref.",
  //                                                 "On lance les dés 🎲",
  //                                                 "#;enable_faq;#"
  //                                               ], nextSteps: [
  //                                                 // FIN BRANCHE
  //                                               ])),
  //                                         ])),
  //                                   ])),
  //                             ])),
  //                       ])),
  //                 ]))
  //           ]))
  //     ],
  //     faqSteps: [
  //       FaqStep(
  //           question:
  //               "Quel est le meilleur itinéraire pour aller de la place de l’obélisque au Monument de la renaissance en bus ?",
  //           answer: ChatResponse(text: [
  //             "Tu veux donc faire un trajet Colobane-Ouakam, voici ce que je te suggère : \n\n- Rends-toi à l’arrêt bus en face du collège Kennedy. \n\n- Prends la ligne 54 jusqu’à la cité universitaire (UCAD). \n\n- Rendez-vous à l’arrêt bus d’en face. \n\n- Prenez la ligne 7 (DDD) jusqu’à Ouakam. \n\nEntamez une marche de 5 minutes vers le monument (qui n’est pas difficile à voir 👀) \n\n15 - 25 minutes de trajet pour seulement 250 FCFA.",
  //             "🚨 ATTENTION : \n\nIl existe des carapides pour faire ce trajet beaucoup plus rapidement.\n\nCependant, l’équipe Yeebus est encore entrain de travailler sur les données en rapport avec le réseau informel.\n\nAlors n’hésite pas à contacter leur service client en attendant.",
  //             "🚨 ET SURTOUT : \n\nLes instructions écrites ne servent que d’indication approximative.\n\nL’application Yeebus mettra à ta disposition une carte où je pourrai te guider en temps réel d’un arrêt à un autre jusqu’à ta destination.\n\nMais elle est encore en cours de conception \n\n(décidemment ces développeurs de vrais incapables..)",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question:
  //               "Combien coûterait un trajet de Mermoz au Parc Zoologique de Hann en bus ?",
  //           answer: ChatResponse(text: [
  //             "3.000 FCFA...",
  //             "C’est ce que tu aurais payé en prenant un taxi.\n\nEn bus cela dépendra des lignes empruntés mais avec l’itinéraire optimal, pas plus de 350 FCFA.",
  //             "🚨 ET SURTOUT : \n\nL’équipe Yeebus étudie encore le système de tarification, je me base donc sur des estimations en attendant.\n\nPrend toujours un billet de plus que prévu avec toi, on ne sait jamais 😉",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question: "Est-ce que la ligne 7 passe vers UCAD ?",
  //           answer: ChatResponse(text: [
  //             "Oui, la ligne 7 passe vers UCAD.",
  //             "J’ai été programmé pour être simple et drôle donc je m’arrête là.\n\nQu’est-ce qui est jaune et qui attend ?",
  //             "Jonathan.\n\n*badum tss* 🥁",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question:
  //               "La ligne 7 est-elle accessible aux personnes à mobilité réduite ?",
  //           answer: ChatResponse(text: [
  //             "La ligne 7 de Dakar Dem Dikk peut être constituée de plusieurs modèle de bus.\n\nJe ne peux donc pas garantir que toute la ligne soit accessible.",
  //             "Cependant, la compagnie Dakar Dem Dikk a récemment reçu une toute nouvelle flotte de bus.\n\nIl se peut donc que la plupart des bus de la ligne 7 soient en effet accessibles, surtout s’ils disposent de l’icône suivant : \n\n♿",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question: "La mort ou tchi-tchi ?",
  //           answer: ChatResponse(text: [
  //             "Aah mon gars, #;username;#, tu poses la bonne question on dirait.",
  //             "Mais tu sais frérot, y'a pas photo pour moi c'est rapide\n\nJe choisis tchitchi, hors de question que j'me fasse tailler",
  //             "Bref, pose une vraie question cette fois :",
  //             "#;enable_faq;#"
  //           ], nextSteps: [
  //             ChatStep(
  //                 prompt: "D'accord, mais d'abord tchi-tchi.",
  //                 response: ChatResponse(text: [
  //                   "😂😂😂😂 non merci #;username;#, je passe mon tour 🏃🏽‍",
  //                   "Pose moi une vraie question plutôt :"
  //                       "#;disable_faq;#",
  //                 ], nextSteps: [])),
  //           ])),
  //       FaqStep(
  //           question: "C’est bon, j’ai compris le concept 👍🏽",
  //           answer: ChatResponse(text: [
  //             "Super, tu as donc pu avoir un aperçu de mes compétences.",
  //             "L'application n'a pas encore été déployée donc les rats de l'équipe Yeebus sont probablement devant toi en ce moment même 👀.",
  //             "Bon, j'aime les chatier mais ce sont des gars motivés.",
  //             "Alors si tu aimes le concept de l'app, rejoins nous dans la communauté Whatsapp ! 🔥, \n\nOn y rigole bien entre bus preneurs.",
  //             "Ciao !"
  //           ], nextSteps: [])),
  //     ],
  //     afterFaq: ChatStep(
  //         prompt: "",
  //         response: ChatResponse(text: [
  //           "Super, tu as donc pu avoir un aperçu de mes compétences.",
  //           "L'application n'a pas encore été déployée donc les rats de l'équipe Yeebus sont probablement devant toi en ce moment même 👀.",
  //           "Bon, j'aime les chatier mais ce sont des gars motivés.",
  //           "Alors si tu aimes le concept de l'app, rejoins nous dans la communauté Whatsapp ! 🔥, \n\nOn y rigole bien entre bus preneurs.",
  //           "Ciao !"
  //         ], nextSteps: [
  //           // ChatStep(
  //           // prompt: "Oui, envoie la moi !.",
  //           // response: ChatResponse(
  //           // text: [
  //           // "#;drop_video;#",
  //           // ],
  //           // nextSteps: [
  //           //
  //           // ]
  //           // )
  //           // ),
  //         ])));
  // //  A RESTRUCTURER PAR ICI :
  // static Conversation madioConvo = Conversation(
  //     steps: [
  //       ChatStep(
  //           prompt: "Oui, depuis des lustres !",
  //           response: ChatResponse(text: [
  //             "Dans ce cas, tu es au bon endroit !",
  //             "Salut #;username;#, moi c'est Sané Madio, ton nouveau Yeeguide. \n\nJe réponds à toutes tes questions sur les transports à Dakar.",
  //             "En route pour 2024 !",
  //             "Prêt pour une petite démo ?",
  //             // "#;enable_faq;#",
  //           ], nextSteps: [
  //             // PARTANT POUR UNE DEMO
  //             ChatStep(
  //                 prompt: 'Oui, on y va !',
  //                 response: ChatResponse(text: [
  //                   "Super, alors déjà, je sais parler Français, Anglais, et Wolof.",
  //                   "Parcontre, je suis encore médiocre en wolof donc peut-être que Yeebus a désactivé ça.",
  //                   "Ces satanés développeurs.. ils se croient tout puissant pff."
  //                 ], nextSteps: [
  //                   // ON RESTE EN FRANCAIS.
  //                   ChatStep(
  //                       prompt: "On reste en français dans ce cas.",
  //                       response: ChatResponse(text: [
  //                         "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                         "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                         "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                         "2 - Tu pioches n’importe laquelle.",
  //                         "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                         "(même qui va gagner les élections 2024 🌚)",
  //                         "On y va ?"
  //                       ], nextSteps: [
  //                         ChatStep(
  //                             prompt: "Oui, je veux voir ça.",
  //                             response: ChatResponse(text: [
  //                               "Bismillah !",
  //                               "#;enable_faq;#"
  //                             ], nextSteps: [
  //                               // FIN BRANCHE
  //                             ])),
  //                         ChatStep(
  //                             prompt:
  //                                 "Dis moi d'abord qui va gagner les élections 👀",
  //                             response: ChatResponse(text: [
  //                               "Bah moi bien évidemment.. *AHEM*",
  //                               "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                               "donc je mise plutôt sur.. humm..",
  //                               "Yousou Ndul c'est mon favoris. 😁"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "😂😂 Revenons en aux bus",
  //                                   response: ChatResponse(text: [
  //                                     "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                     "On lance le jeu 🎲",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                             ])),
  //                       ])),

  //                   // ON TESTE LE WOLOF.
  //                   ChatStep(
  //                       prompt: 'Ma khol wolof bi bokk 👀',
  //                       response: ChatResponse(text: [
  //                         "Mann Songo magui soukkendiku rewwmi ndakh niou mankoo téléchargé Yeebus dans les plus brefs délais.",
  //                         "... désolé je ne peux pas faire mieux 😭😭",
  //                         "On reste en français finalement, ça te va ?"
  //                       ], nextSteps: [
  //                         ChatStep(
  //                             prompt: "Oui, c'est mieux.",
  //                             response: ChatResponse(text: [
  //                               "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                               "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                               "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                               "2 - Tu pioches n’importe laquelle.",
  //                               "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                               "(même qui va gagner les élections 2024 🌚)",
  //                               "On y va ?"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "Oui, je veux voir ça.",
  //                                   response: ChatResponse(text: [
  //                                     "Bismillah !",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                               ChatStep(
  //                                   prompt:
  //                                       "Dis moi d'abord qui va gagner les élections 👀",
  //                                   response: ChatResponse(text: [
  //                                     "Bah moi bien évidemment.. *AHEM*",
  //                                     "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                                     "donc je mise plutôt sur.. humm..",
  //                                     "Yousou Ndul c'est mon favoris. 😁"
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "😂😂 Revenons en aux bus",
  //                                         response: ChatResponse(text: [
  //                                           "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                           "On lance le jeu 🎲",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [
  //                                           // FIN BRANCHE
  //                                         ])),
  //                                   ])),
  //                             ])),
  //                       ])),
  //                 ])),
  //             // PAS PARTANT POUR UNE DEMO (Confetti d'abord puis on loop) :
  //             ChatStep(
  //                 prompt: 'Non, je veux plus de confetti d\'abord 🙂',
  //                 response: ChatResponse(text: [
  //                   "Non mais sérieusement, tu pouvais pas juste suivre le script ? Ohlala..",
  //                   "Qui t'a dit que je sais faire ça moi ? 💀",
  //                   "Bon, voilà pour toi.., mais c'est la dernière fois",
  //                   // "#;drop_confetti;#",
  //                   "abracadabra !"
  //                 ], nextSteps: [
  //                   ChatStep(
  //                       prompt:
  //                           'Mercii 😂, on peut commencer la démo maintenant.',
  //                       response: ChatResponse(text: [
  //                         "Derien 🤝🏽 (façon j'ai pas le choix, j'ai été programmé pour ça..)",
  //                         "Super, alors déjà, je sais parler Français, Anglais, et Wolof.",
  //                         "Parcontre, je suis encore médiocre en wolof donc peut-être que Yeebus a désactivé ça.",
  //                         "Ces satanés développeurs.. ils se croient tout puissant pff."
  //                       ], nextSteps: [
  //                         // ON RESTE EN FRANCAIS.
  //                         ChatStep(
  //                             prompt: "On reste en français dans ce cas.",
  //                             response: ChatResponse(text: [
  //                               "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                               "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                               "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                               "2 - Tu pioches n’importe laquelle.",
  //                               "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                               "(même qui va gagner les élections 2024 🌚)",
  //                               "On y va ?"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "Oui, je veux voir ça.",
  //                                   response: ChatResponse(text: [
  //                                     "Bismillah !",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                               ChatStep(
  //                                   prompt:
  //                                       "Dis moi d'abord qui va gagner les élections 👀",
  //                                   response: ChatResponse(text: [
  //                                     "Bah moi bien évidemment.. *AHEM*",
  //                                     "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                                     "donc je mise plutôt sur.. humm..",
  //                                     "Yousou Ndul c'est mon favoris. 😁"
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "😂😂 Revenons en aux bus",
  //                                         response: ChatResponse(text: [
  //                                           "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                           "On lance le jeu 🎲",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [])),
  //                                   ])),
  //                             ])),

  //                         // ON TESTE LE WOLOF.
  //                         ChatStep(
  //                             prompt: 'Ma khol wolof bi bokk 👀',
  //                             response: ChatResponse(text: [
  //                               "Mann Songo magui soukkendiku rewwmi ndakh niou mankoo téléchargé Yeebus dans les plus brefs délais.",
  //                               "... désolé je ne peux pas faire mieux 😭😭",
  //                               "On reste en français finalement, ça te va ?"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "Oui, c'est mieux.",
  //                                   response: ChatResponse(text: [
  //                                     "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                                     "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                                     "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                                     "2 - Tu pioches n’importe laquelle.",
  //                                     "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                                     "(même qui va gagner les élections 2024 🌚)",
  //                                     "On y va ?"
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "Oui, je veux voir ça.",
  //                                         response: ChatResponse(text: [
  //                                           "Bismillah !",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [
  //                                           // FIN BRANCHE
  //                                         ])),
  //                                     ChatStep(
  //                                         prompt:
  //                                             "Dis moi d'abord qui va gagner les élections 👀",
  //                                         response: ChatResponse(text: [
  //                                           "Bah moi bien évidemment.. *AHEM*",
  //                                           "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                                           "donc je mise plutôt sur.. humm..",
  //                                           "Yousou Ndul c'est mon favoris. 😁"
  //                                         ], nextSteps: [
  //                                           ChatStep(
  //                                               prompt:
  //                                                   "😂😂 Revenons en aux bus",
  //                                               response: ChatResponse(text: [
  //                                                 "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                                 "On lance le jeu 🎲",
  //                                                 "#;enable_faq;#"
  //                                               ], nextSteps: [])),
  //                                         ])),
  //                                   ])),
  //                             ])),
  //                       ]))
  //                 ]))
  //           ]))
  //     ],
  //     faqSteps: [
  //       FaqStep(
  //           question:
  //               "Quel est le meilleur itinéraire pour aller de la place de l’obélisque au Monument de la renaissance en bus ?",
  //           answer: ChatResponse(text: [
  //             "Tu veux donc faire un trajet Colobane-Ouakam, voici ce que je te suggère : \n\n- Rends-toi à l’arrêt bus en face du collège Kennedy. \n\n- Prends la ligne 54 jusqu’à la cité universitaire (UCAD). \n\n- Rendez-vous à l’arrêt bus d’en face. \n\n- Prenez la ligne 7 (DDD) jusqu’à Ouakam. \n\nEntamez une marche de 5 minutes vers le monument (qui n’est pas difficile à voir 👀) \n\n15 - 25 minutes de trajet pour seulement 250 FCFA.",
  //             "🚨 ATTENTION : \n\nIl existe des carapides pour faire ce trajet beaucoup plus rapidement.\n\nCependant, l’équipe Yeebus est encore entrain de travailler sur les données en rapport avec le réseau informel.\n\nAlors n’hésite pas à contacter leur service client en attendant.",
  //             "🚨 ET SURTOUT : \n\nLes instructions écrites ne servent que d’indication approximative.\n\nL’application Yeebus mettra à ta disposition une carte où je pourrai te guider en temps réel d’un arrêt à un autre jusqu’à ta destination.\n\nMais elle est encore en cours de conception \n\n(décidemment ces développeurs de vrais incapables..)",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question:
  //               "Combien coûterait un trajet de Mermoz au Parc Zoologique de Hann en bus ?",
  //           answer: ChatResponse(text: [
  //             "3.000 FCFA...",
  //             "C’est ce que tu aurais payé en prenant un taxi.\n\nEn bus cela dépendra des lignes empruntés mais avec l’itinéraire optimal, pas plus de 350 FCFA.",
  //             "🚨 ET SURTOUT : \n\nL’équipe Yeebus étudie encore le système de tarification, je me base donc sur des estimations en attendant.\n\nPrend toujours un billet de plus que prévu avec toi, on ne sait jamais 😉",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question: "Est-ce que la ligne 7 passe vers UCAD ?",
  //           answer: ChatResponse(text: [
  //             "Oui, la ligne 7 passe vers UCAD.",
  //             "J’ai été programmé pour être simple et drôle donc je m’arrête là.\n\nQu’est-ce qui est jaune et qui attend ?",
  //             "Jonathan.\n\n*badum tss* 🥁",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question:
  //               "La ligne 7 est-elle accessible aux personnes à mobilité réduite ?",
  //           answer: ChatResponse(text: [
  //             "La ligne 7 de Dakar Dem Dikk peut être constituée de plusieurs modèle de bus.\n\nJe ne peux donc pas garantir que toute la ligne soit accessible.",
  //             "Cependant, la compagnie Dakar Dem Dikk a récemment reçu une toute nouvelle flotte de bus.\n\nIl se peut donc que la plupart des bus de la ligne 7 soient en effet accessibles, surtout s’ils disposent de l’icône suivant : \n\n♿",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question: "La mort ou tchi-tchi ?",
  //           answer: ChatResponse(text: [
  //             "Désolé, #;username;#, on me tue mais on ne me déshonore pas 😂😂",
  //             "Je vais me donner la mort avant même que tu n'aies dit 'd'accord, mais d'abord tchitchi ' 🤣",
  //             "Bref, pose une vraie question cette fois :",
  //             "#;enable_faq;#"
  //           ], nextSteps: [
  //             ChatStep(
  //                 prompt: "D'accord, mais d'abord tchi-tchi.",
  //                 response: ChatResponse(text: [
  //                   "😂😂😂😂 non merci #;username;#, je passe mon tour 🏃🏽‍",
  //                   "Pose moi une vraie question plutôt :"
  //                       "#;disable_faq;#",
  //                 ], nextSteps: [])),
  //           ])),
  //       FaqStep(
  //           question: "C’est bon, j’ai compris le concept 👍🏽",
  //           answer: ChatResponse(text: [
  //             "Super, tu as donc pu avoir un aperçu de mes compétences.",
  //             "L'application n'a pas encore été déployée donc les rats de l'équipe Yeebus sont probablement devant toi en ce moment même 👀.",
  //             "Bon, j'aime les chatier mais ce sont des gars motivés.",
  //             "Alors si tu aimes le concept de l'app, rejoins nous dans la communauté Whatsapp ! 🔥, \n\nOn y rigole bien entre bus preneurs.",
  //             "Ciao !"
  //           ], nextSteps: [])),
  //     ],
  //     afterFaq: ChatStep(
  //         prompt: "",
  //         response: ChatResponse(text: [
  //           "Super, tu as donc pu avoir un aperçu de mes compétences.",
  //           "L'application n'a pas encore été déployée donc les rats de l'équipe Yeebus sont probablement devant toi en ce moment même 👀.",
  //           "Bon, j'aime les chatier mais ce sont des gars motivés.",
  //           "Alors si tu aimes le concept de l'app, rejoins nous dans la communauté Whatsapp ! 🔥, \n\nOn y rigole bien entre bus preneurs.",
  //           "Ciao !"
  //         ], nextSteps: [
  //           // ChatStep(
  //           // prompt: "Oui, envoie la moi !.",
  //           // response: ChatResponse(
  //           // text: [
  //           // "#;drop_video;#",
  //           // ],
  //           // nextSteps: [
  //           //
  //           // ]
  //           // )
  //           // ),
  //         ])));
  // static Conversation vaidewishConvo = Conversation(
  //     steps: [
  //       ChatStep(
  //           prompt: "Oui, depuis des lustres !",
  //           response: ChatResponse(text: [
  //             "Dans ce cas, tu es au bon endroit !",
  //             "Salut #;username;#, moi c'est Vaidewish, ton nouveau Yeeguide. \n\nJe réponds à toutes tes questions sur les transports à Dakar.",
  //             "En route pour 2024 !",
  //             "Prêt pour une petite démo ?",
  //             // "#;enable_faq;#",
  //           ], nextSteps: [
  //             // PARTANT POUR UNE DEMO
  //             ChatStep(
  //                 prompt: 'Oui, on y va !',
  //                 response: ChatResponse(text: [
  //                   "Super, alors déjà, je sais parler Français, Anglais, et Wolof.",
  //                   "Parcontre, je suis encore médiocre en wolof donc peut-être que Yeebus a désactivé ça.",
  //                   "Ces satanés développeurs.. ils se croient tout puissant pff."
  //                 ], nextSteps: [
  //                   // ON RESTE EN FRANCAIS.
  //                   ChatStep(
  //                       prompt: "On reste en français dans ce cas.",
  //                       response: ChatResponse(text: [
  //                         "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                         "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                         "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                         "2 - Tu pioches n’importe laquelle.",
  //                         "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                         "(même qui va gagner les élections 2024 🌚)",
  //                         "On y va ?"
  //                       ], nextSteps: [
  //                         ChatStep(
  //                             prompt: "Oui, je veux voir ça.",
  //                             response: ChatResponse(text: [
  //                               "Bismillah !",
  //                               "#;enable_faq;#"
  //                             ], nextSteps: [
  //                               // FIN BRANCHE
  //                             ])),
  //                         ChatStep(
  //                             prompt:
  //                                 "Dis moi d'abord qui va gagner les élections 👀",
  //                             response: ChatResponse(text: [
  //                               "Bah moi bien évidemment.. *AHEM*",
  //                               "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                               "donc je mise plutôt sur.. humm..",
  //                               "Yousou Ndul c'est mon favoris. 😁"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "😂😂 Revenons en aux bus",
  //                                   response: ChatResponse(text: [
  //                                     "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                     "On lance le jeu 🎲",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                             ])),
  //                       ])),

  //                   // ON TESTE LE WOLOF.
  //                   ChatStep(
  //                       prompt: 'Ma khol wolof bi bokk 👀',
  //                       response: ChatResponse(text: [
  //                         "Mann Songo magui soukkendiku rewwmi ndakh niou mankoo téléchargé Yeebus dans les plus brefs délais.",
  //                         "... désolé je ne peux pas faire mieux 😭😭",
  //                         "On reste en français finalement, ça te va ?"
  //                       ], nextSteps: [
  //                         ChatStep(
  //                             prompt: "Oui, c'est mieux.",
  //                             response: ChatResponse(text: [
  //                               "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                               "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                               "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                               "2 - Tu pioches n’importe laquelle.",
  //                               "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                               "(même qui va gagner les élections 2024 🌚)",
  //                               "On y va ?"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "Oui, je veux voir ça.",
  //                                   response: ChatResponse(text: [
  //                                     "Bismillah !",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                               ChatStep(
  //                                   prompt:
  //                                       "Dis moi d'abord qui va gagner les élections 👀",
  //                                   response: ChatResponse(text: [
  //                                     "Bah moi bien évidemment.. *AHEM*",
  //                                     "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                                     "donc je mise plutôt sur.. humm..",
  //                                     "Yousou Ndul c'est mon favoris. 😁"
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "😂😂 Revenons en aux bus",
  //                                         response: ChatResponse(text: [
  //                                           "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                           "On lance le jeu 🎲",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [
  //                                           // FIN BRANCHE
  //                                         ])),
  //                                   ])),
  //                             ])),
  //                       ])),
  //                 ])),
  //             // PAS PARTANT POUR UNE DEMO (Confetti d'abord puis on loop) :
  //             ChatStep(
  //                 prompt: 'Non, je veux plus de confetti d\'abord 🙂',
  //                 response: ChatResponse(text: [
  //                   "Non mais sérieusement, tu pouvais pas juste suivre le script ? Ohlala..",
  //                   "Qui t'a dit que je sais faire ça moi ? 💀",
  //                   "Bon, voilà pour toi.., mais c'est la dernière fois",
  //                   // "#;drop_confetti;#",
  //                   "abracadabra !"
  //                 ], nextSteps: [
  //                   ChatStep(
  //                       prompt:
  //                           'Mercii 😂, on peut commencer la démo maintenant.',
  //                       response: ChatResponse(text: [
  //                         "Derien 🤝🏽 (façon j'ai pas le choix, j'ai été programmé pour ça..)",
  //                         "Super, alors déjà, je sais parler Français, Anglais, et Wolof.",
  //                         "Parcontre, je suis encore médiocre en wolof donc peut-être que Yeebus a désactivé ça.",
  //                         "Ces satanés développeurs.. ils se croient tout puissant pff."
  //                       ], nextSteps: [
  //                         // ON RESTE EN FRANCAIS.
  //                         ChatStep(
  //                             prompt: "On reste en français dans ce cas.",
  //                             response: ChatResponse(text: [
  //                               "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                               "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                               "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                               "2 - Tu pioches n’importe laquelle.",
  //                               "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                               "(même qui va gagner les élections 2024 🌚)",
  //                               "On y va ?"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "Oui, je veux voir ça.",
  //                                   response: ChatResponse(text: [
  //                                     "Bismillah !",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                               ChatStep(
  //                                   prompt:
  //                                       "Dis moi d'abord qui va gagner les élections 👀",
  //                                   response: ChatResponse(text: [
  //                                     "Bah moi bien évidemment.. *AHEM*",
  //                                     "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                                     "donc je mise plutôt sur.. humm..",
  //                                     "Yousou Ndul c'est mon favoris. 😁"
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "😂😂 Revenons en aux bus",
  //                                         response: ChatResponse(text: [
  //                                           "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                           "On lance le jeu 🎲",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [])),
  //                                   ])),
  //                             ])),

  //                         // ON TESTE LE WOLOF.
  //                         ChatStep(
  //                             prompt: 'Ma khol wolof bi bokk 👀',
  //                             response: ChatResponse(text: [
  //                               "Mann Songo magui soukkendiku rewwmi ndakh niou mankoo téléchargé Yeebus dans les plus brefs délais.",
  //                               "... désolé je ne peux pas faire mieux 😭😭",
  //                               "On reste en français finalement, ça te va ?"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "Oui, c'est mieux.",
  //                                   response: ChatResponse(text: [
  //                                     "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                                     "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                                     "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                                     "2 - Tu pioches n’importe laquelle.",
  //                                     "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                                     "(même qui va gagner les élections 2024 🌚)",
  //                                     "On y va ?"
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "Oui, je veux voir ça.",
  //                                         response: ChatResponse(text: [
  //                                           "Bismillah !",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [
  //                                           // FIN BRANCHE
  //                                         ])),
  //                                     ChatStep(
  //                                         prompt:
  //                                             "Dis moi d'abord qui va gagner les élections 👀",
  //                                         response: ChatResponse(text: [
  //                                           "Bah moi bien évidemment.. *AHEM*",
  //                                           "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                                           "donc je mise plutôt sur.. humm..",
  //                                           "Yousou Ndul c'est mon favoris. 😁"
  //                                         ], nextSteps: [
  //                                           ChatStep(
  //                                               prompt:
  //                                                   "😂😂 Revenons en aux bus",
  //                                               response: ChatResponse(text: [
  //                                                 "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                                 "On lance le jeu 🎲",
  //                                                 "#;enable_faq;#"
  //                                               ], nextSteps: [])),
  //                                         ])),
  //                                   ])),
  //                             ])),
  //                       ]))
  //                 ]))
  //           ]))
  //     ],
  //     faqSteps: [
  //       FaqStep(
  //           question:
  //               "Quel est le meilleur itinéraire pour aller de la place de l’obélisque au Monument de la renaissance en bus ?",
  //           answer: ChatResponse(text: [
  //             "Tu veux donc faire un trajet Colobane-Ouakam, voici ce que je te suggère : \n\n- Rends-toi à l’arrêt bus en face du collège Kennedy. \n\n- Prends la ligne 54 jusqu’à la cité universitaire (UCAD). \n\n- Rendez-vous à l’arrêt bus d’en face. \n\n- Prenez la ligne 7 (DDD) jusqu’à Ouakam. \n\nEntamez une marche de 5 minutes vers le monument (qui n’est pas difficile à voir 👀) \n\n15 - 25 minutes de trajet pour seulement 250 FCFA.",
  //             "🚨 ATTENTION : \n\nIl existe des carapides pour faire ce trajet beaucoup plus rapidement.\n\nCependant, l’équipe Yeebus est encore entrain de travailler sur les données en rapport avec le réseau informel.\n\nAlors n’hésite pas à contacter leur service client en attendant.",
  //             "🚨 ET SURTOUT : \n\nLes instructions écrites ne servent que d’indication approximative.\n\nL’application Yeebus mettra à ta disposition une carte où je pourrai te guider en temps réel d’un arrêt à un autre jusqu’à ta destination.\n\nMais elle est encore en cours de conception \n\n(décidemment ces développeurs de vrais incapables..)",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question:
  //               "Combien coûterait un trajet de Mermoz au Parc Zoologique de Hann en bus ?",
  //           answer: ChatResponse(text: [
  //             "3.000 FCFA...",
  //             "C’est ce que tu aurais payé en prenant un taxi.\n\nEn bus cela dépendra des lignes empruntés mais avec l’itinéraire optimal, pas plus de 350 FCFA.",
  //             "🚨 ET SURTOUT : \n\nL’équipe Yeebus étudie encore le système de tarification, je me base donc sur des estimations en attendant.\n\nPrend toujours un billet de plus que prévu avec toi, on ne sait jamais 😉",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question: "Est-ce que la ligne 7 passe vers UCAD ?",
  //           answer: ChatResponse(text: [
  //             "Oui, la ligne 7 passe vers UCAD.",
  //             "J’ai été programmé pour être simple et drôle donc je m’arrête là.\n\nQu’est-ce qui est jaune et qui attend ?",
  //             "Jonathan.\n\n*badum tss* 🥁",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question:
  //               "La ligne 7 est-elle accessible aux personnes à mobilité réduite ?",
  //           answer: ChatResponse(text: [
  //             "La ligne 7 de Dakar Dem Dikk peut être constituée de plusieurs modèle de bus.\n\nJe ne peux donc pas garantir que toute la ligne soit accessible.",
  //             "Cependant, la compagnie Dakar Dem Dikk a récemment reçu une toute nouvelle flotte de bus.\n\nIl se peut donc que la plupart des bus de la ligne 7 soient en effet accessibles, surtout s’ils disposent de l’icône suivant : \n\n♿",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question: "La mort ou tchi-tchi ?",
  //           answer: ChatResponse(text: [
  //             "Désolé, #;username;#, on me tue mais on ne me déshonore pas 😂😂",
  //             "Je vais me donner la mort avant même que tu n'aies dit 'd'accord, mais d'abord tchitchi ' 🤣",
  //             "Bref, pose une vraie question cette fois :",
  //             "#;enable_faq;#"
  //           ], nextSteps: [
  //             ChatStep(
  //                 prompt: "D'accord, mais d'abord tchi-tchi.",
  //                 response: ChatResponse(text: [
  //                   "😂😂😂😂 non merci #;username;#, je passe mon tour 🏃🏽‍",
  //                   "Pose moi une vraie question plutôt :"
  //                       "#;disable_faq;#",
  //                 ], nextSteps: [])),
  //           ])),
  //       FaqStep(
  //           question: "C’est bon, j’ai compris le concept 👍🏽",
  //           answer: ChatResponse(text: [
  //             "Super, tu as donc pu avoir un aperçu de mes compétences.",
  //             "L'application n'a pas encore été déployée donc les rats de l'équipe Yeebus sont probablement devant toi en ce moment même 👀.",
  //             "Bon, j'aime les chatier mais ce sont des gars motivés.",
  //             "Alors si tu aimes le concept de l'app, rejoins nous dans la communauté Whatsapp ! 🔥, \n\nOn y rigole bien entre bus preneurs.",
  //             "Ciao !"
  //           ], nextSteps: [])),
  //     ],
  //     afterFaq: ChatStep(
  //         prompt: "",
  //         response: ChatResponse(text: [
  //           "Super, tu as donc pu avoir un aperçu de mes compétences.",
  //           "L'application n'a pas encore été déployée donc les rats de l'équipe Yeebus sont probablement devant toi en ce moment même 👀.",
  //           "Bon, j'aime les chatier mais ce sont des gars motivés.",
  //           "Alors si tu aimes le concept de l'app, rejoins nous dans la communauté Whatsapp ! 🔥, \n\nOn y rigole bien entre bus preneurs.",
  //           "Ciao !"
  //         ], nextSteps: [
  //           // ChatStep(
  //           // prompt: "Oui, envoie la moi !.",
  //           // response: ChatResponse(
  //           // text: [
  //           // "#;drop_video;#",
  //           // ],
  //           // nextSteps: [
  //           //
  //           // ]
  //           // )
  //           // ),
  //         ])));
  // static Conversation rarutoConvo = Conversation(
  //     steps: [
  //       ChatStep(
  //           prompt: "Oui, depuis des lustres !",
  //           response: ChatResponse(text: [
  //             "Dans ce cas, tu es au bon endroit !",
  //             "Salut #;username;#, moi c'est Raruto, ton nouveau Yeeguide. \n\nJe réponds à toutes tes questions sur les transports à Dakar.",
  //             "En route pour 2024 !",
  //             "Prêt pour une petite démo ?",
  //             // "#;enable_faq;#",
  //           ], nextSteps: [
  //             // PARTANT POUR UNE DEMO
  //             ChatStep(
  //                 prompt: 'Oui, on y va !',
  //                 response: ChatResponse(text: [
  //                   "Super, alors déjà, je sais parler Français, Anglais, et Wolof.",
  //                   "Parcontre, je suis encore médiocre en wolof donc peut-être que Yeebus a désactivé ça.",
  //                   "Ces satanés développeurs.. ils se croient tout puissant pff."
  //                 ], nextSteps: [
  //                   // ON RESTE EN FRANCAIS.
  //                   ChatStep(
  //                       prompt: "On reste en français dans ce cas.",
  //                       response: ChatResponse(text: [
  //                         "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                         "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                         "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                         "2 - Tu pioches n’importe laquelle.",
  //                         "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                         "(même qui va gagner les élections 2024 🌚)",
  //                         "On y va ?"
  //                       ], nextSteps: [
  //                         ChatStep(
  //                             prompt: "Oui, je veux voir ça.",
  //                             response: ChatResponse(text: [
  //                               "Bismillah !",
  //                               "#;enable_faq;#"
  //                             ], nextSteps: [
  //                               // FIN BRANCHE
  //                             ])),
  //                         ChatStep(
  //                             prompt:
  //                                 "Dis moi d'abord qui va gagner les élections 👀",
  //                             response: ChatResponse(text: [
  //                               "Bah moi bien évidemment.. *AHEM*",
  //                               "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                               "donc je mise plutôt sur.. humm..",
  //                               "Yousou Ndul c'est mon favoris. 😁"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "😂😂 Revenons en aux bus",
  //                                   response: ChatResponse(text: [
  //                                     "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                     "On lance le jeu 🎲",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                             ])),
  //                       ])),

  //                   // ON TESTE LE WOLOF.
  //                   ChatStep(
  //                       prompt: 'Ma khol wolof bi bokk 👀',
  //                       response: ChatResponse(text: [
  //                         "Mann Songo magui soukkendiku rewwmi ndakh niou mankoo téléchargé Yeebus dans les plus brefs délais.",
  //                         "... désolé je ne peux pas faire mieux 😭😭",
  //                         "On reste en français finalement, ça te va ?"
  //                       ], nextSteps: [
  //                         ChatStep(
  //                             prompt: "Oui, c'est mieux.",
  //                             response: ChatResponse(text: [
  //                               "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                               "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                               "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                               "2 - Tu pioches n’importe laquelle.",
  //                               "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                               "(même qui va gagner les élections 2024 🌚)",
  //                               "On y va ?"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "Oui, je veux voir ça.",
  //                                   response: ChatResponse(text: [
  //                                     "Bismillah !",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                               ChatStep(
  //                                   prompt:
  //                                       "Dis moi d'abord qui va gagner les élections 👀",
  //                                   response: ChatResponse(text: [
  //                                     "Bah moi bien évidemment.. *AHEM*",
  //                                     "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                                     "donc je mise plutôt sur.. humm..",
  //                                     "Yousou Ndul c'est mon favoris. 😁"
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "😂😂 Revenons en aux bus",
  //                                         response: ChatResponse(text: [
  //                                           "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                           "On lance le jeu 🎲",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [
  //                                           // FIN BRANCHE
  //                                         ])),
  //                                   ])),
  //                             ])),
  //                       ])),
  //                 ])),
  //             // PAS PARTANT POUR UNE DEMO (Confetti d'abord puis on loop) :
  //             ChatStep(
  //                 prompt: 'Non, je veux plus de confetti d\'abord 🙂',
  //                 response: ChatResponse(text: [
  //                   "Non mais sérieusement, tu pouvais pas juste suivre le script ? Ohlala..",
  //                   "Qui t'a dit que je sais faire ça moi ? 💀",
  //                   "Bon, voilà pour toi.., mais c'est la dernière fois",
  //                   // "#;drop_confetti;#",
  //                   "abracadabra !"
  //                 ], nextSteps: [
  //                   ChatStep(
  //                       prompt:
  //                           'Mercii 😂, on peut commencer la démo maintenant.',
  //                       response: ChatResponse(text: [
  //                         "Derien 🤝🏽 (façon j'ai pas le choix, j'ai été programmé pour ça..)",
  //                         "Super, alors déjà, je sais parler Français, Anglais, et Wolof.",
  //                         "Parcontre, je suis encore médiocre en wolof donc peut-être que Yeebus a désactivé ça.",
  //                         "Ces satanés développeurs.. ils se croient tout puissant pff."
  //                       ], nextSteps: [
  //                         // ON RESTE EN FRANCAIS.
  //                         ChatStep(
  //                             prompt: "On reste en français dans ce cas.",
  //                             response: ChatResponse(text: [
  //                               "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                               "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                               "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                               "2 - Tu pioches n’importe laquelle.",
  //                               "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                               "(même qui va gagner les élections 2024 🌚)",
  //                               "On y va ?"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "Oui, je veux voir ça.",
  //                                   response: ChatResponse(text: [
  //                                     "Bismillah !",
  //                                     "#;enable_faq;#"
  //                                   ], nextSteps: [
  //                                     // FIN BRANCHE
  //                                   ])),
  //                               ChatStep(
  //                                   prompt:
  //                                       "Dis moi d'abord qui va gagner les élections 👀",
  //                                   response: ChatResponse(text: [
  //                                     "Bah moi bien évidemment.. *AHEM*",
  //                                     "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                                     "donc je mise plutôt sur.. humm..",
  //                                     "Yousou Ndul c'est mon favoris. 😁"
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "😂😂 Revenons en aux bus",
  //                                         response: ChatResponse(text: [
  //                                           "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                           "On lance le jeu 🎲",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [])),
  //                                   ])),
  //                             ])),

  //                         // ON TESTE LE WOLOF.
  //                         ChatStep(
  //                             prompt: 'Ma khol wolof bi bokk 👀',
  //                             response: ChatResponse(text: [
  //                               "Mann Songo magui soukkendiku rewwmi ndakh niou mankoo téléchargé Yeebus dans les plus brefs délais.",
  //                               "... désolé je ne peux pas faire mieux 😭😭",
  //                               "On reste en français finalement, ça te va ?"
  //                             ], nextSteps: [
  //                               ChatStep(
  //                                   prompt: "Oui, c'est mieux.",
  //                                   response: ChatResponse(text: [
  //                                     "Bon choix 😂, tes yeux te remercieront pour ça.",
  //                                     "Pour la démo, c’est super simple,\n\nNous allons faire un jeu.  🎰",
  //                                     "1 - Yeebus va générer une liste de questions tirées au hasard.",
  //                                     "2 - Tu pioches n’importe laquelle.",
  //                                     "3 - J’y répond les doigts dans le nez parce que je sais tout.",
  //                                     "(même qui va gagner les élections 2024 🌚)",
  //                                     "On y va ?"
  //                                   ], nextSteps: [
  //                                     ChatStep(
  //                                         prompt: "Oui, je veux voir ça.",
  //                                         response: ChatResponse(text: [
  //                                           "Bismillah !",
  //                                           "#;enable_faq;#"
  //                                         ], nextSteps: [
  //                                           // FIN BRANCHE
  //                                         ])),
  //                                     ChatStep(
  //                                         prompt:
  //                                             "Dis moi d'abord qui va gagner les élections 👀",
  //                                         response: ChatResponse(text: [
  //                                           "Bah moi bien évidemment.. *AHEM*",
  //                                           "plus sérieusement, j'aurais bien gagné hein mais ligaments croisés tu connais..",
  //                                           "donc je mise plutôt sur.. humm..",
  //                                           "Yousou Ndul c'est mon favoris. 😁"
  //                                         ], nextSteps: [
  //                                           ChatStep(
  //                                               prompt:
  //                                                   "😂😂 Revenons en aux bus",
  //                                               response: ChatResponse(text: [
  //                                                 "C'est vrai que l'app s'appelle Yeebus, pas Yeepolitique.. bref.",
  //                                                 "On lance le jeu 🎲",
  //                                                 "#;enable_faq;#"
  //                                               ], nextSteps: [])),
  //                                         ])),
  //                                   ])),
  //                             ])),
  //                       ]))
  //                 ]))
  //           ]))
  //     ],
  //     faqSteps: [
  //       FaqStep(
  //           question:
  //               "Quel est le meilleur itinéraire pour aller de la place de l’obélisque au Monument de la renaissance en bus ?",
  //           answer: ChatResponse(text: [
  //             "Tu veux donc faire un trajet Colobane-Ouakam, voici ce que je te suggère : \n\n- Rends-toi à l’arrêt bus en face du collège Kennedy. \n\n- Prends la ligne 54 jusqu’à la cité universitaire (UCAD). \n\n- Rendez-vous à l’arrêt bus d’en face. \n\n- Prenez la ligne 7 (DDD) jusqu’à Ouakam. \n\nEntamez une marche de 5 minutes vers le monument (qui n’est pas difficile à voir 👀) \n\n15 - 25 minutes de trajet pour seulement 250 FCFA.",
  //             "🚨 ATTENTION : \n\nIl existe des carapides pour faire ce trajet beaucoup plus rapidement.\n\nCependant, l’équipe Yeebus est encore entrain de travailler sur les données en rapport avec le réseau informel.\n\nAlors n’hésite pas à contacter leur service client en attendant.",
  //             "🚨 ET SURTOUT : \n\nLes instructions écrites ne servent que d’indication approximative.\n\nL’application Yeebus mettra à ta disposition une carte où je pourrai te guider en temps réel d’un arrêt à un autre jusqu’à ta destination.\n\nMais elle est encore en cours de conception \n\n(décidemment ces développeurs de vrais incapables..)",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question:
  //               "Combien coûterait un trajet de Mermoz au Parc Zoologique de Hann en bus ?",
  //           answer: ChatResponse(text: [
  //             "3.000 FCFA...",
  //             "C’est ce que tu aurais payé en prenant un taxi.\n\nEn bus cela dépendra des lignes empruntés mais avec l’itinéraire optimal, pas plus de 350 FCFA.",
  //             "🚨 ET SURTOUT : \n\nL’équipe Yeebus étudie encore le système de tarification, je me base donc sur des estimations en attendant.\n\nPrend toujours un billet de plus que prévu avec toi, on ne sait jamais 😉",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question: "Est-ce que la ligne 7 passe vers UCAD ?",
  //           answer: ChatResponse(text: [
  //             "Oui, la ligne 7 passe vers UCAD.",
  //             "J’ai été programmé pour être simple et drôle donc je m’arrête là.\n\nQu’est-ce qui est jaune et qui attend ?",
  //             "Jonathan.\n\n*badum tss* 🥁",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question:
  //               "La ligne 7 est-elle accessible aux personnes à mobilité réduite ?",
  //           answer: ChatResponse(text: [
  //             "La ligne 7 de Dakar Dem Dikk peut être constituée de plusieurs modèle de bus.\n\nJe ne peux donc pas garantir que toute la ligne soit accessible.",
  //             "Cependant, la compagnie Dakar Dem Dikk a récemment reçu une toute nouvelle flotte de bus.\n\nIl se peut donc que la plupart des bus de la ligne 7 soient en effet accessibles, surtout s’ils disposent de l’icône suivant : \n\n♿",
  //             "#;enable_faq;#"
  //           ], nextSteps: [])),
  //       FaqStep(
  //           question: "La mort ou tchi-tchi ?",
  //           answer: ChatResponse(text: [
  //             "Désolé, #;username;#, on me tue mais on ne me déshonore pas 😂😂",
  //             "Je vais me donner la mort avant même que tu n'aies dit 'd'accord, mais d'abord tchitchi ' 🤣",
  //             "Bref, pose une vraie question cette fois :",
  //             "#;enable_faq;#"
  //           ], nextSteps: [
  //             ChatStep(
  //                 prompt: "D'accord, mais d'abord tchi-tchi.",
  //                 response: ChatResponse(text: [
  //                   "😂😂😂😂 non merci #;username;#, je passe mon tour 🏃🏽‍",
  //                   "Pose moi une vraie question plutôt :"
  //                       "#;disable_faq;#",
  //                 ], nextSteps: [])),
  //           ])),
  //       FaqStep(
  //           question: "C’est bon, j’ai compris le concept 👍🏽",
  //           answer: ChatResponse(text: [
  //             "Super, tu as donc pu avoir un aperçu de mes compétences.",
  //             "L'application n'a pas encore été déployée donc les rats de l'équipe Yeebus sont probablement devant toi en ce moment même 👀.",
  //             "Bon, j'aime les chatier mais ce sont des gars motivés.",
  //             "Alors si tu aimes le concept de l'app, rejoins nous dans la communauté Whatsapp ! 🔥, \n\nOn y rigole bien entre bus preneurs.",
  //             "Ciao !"
  //           ], nextSteps: [])),
  //     ],
  //     afterFaq: ChatStep(
  //         prompt: "",
  //         response: ChatResponse(text: [
  //           "Super, tu as donc pu avoir un aperçu de mes compétences.",
  //           "L'application n'a pas encore été déployée donc les rats de l'équipe Yeebus sont probablement devant toi en ce moment même 👀.",
  //           "Bon, j'aime les chatier mais ce sont des gars motivés.",
  //           "Alors si tu aimes le concept de l'app, rejoins nous dans la communauté Whatsapp ! 🔥, \n\nOn y rigole bien entre bus preneurs.",
  //           "Ciao !"
  //         ], nextSteps: [
  //           // ChatStep(
  //           // prompt: "Oui, envoie la moi !.",
  //           // response: ChatResponse(
  //           // text: [
  //           // "#;drop_video;#",
  //           // ],
  //           // nextSteps: [
  //           //
  //           // ]
  //           // )
  //           // ),
  //         ])));

  static Conversation songoConvo = Conversation(
      steps: [
        ChatStep(
            prompt: "Oui, depuis des lustres !",
            response: ChatResponse(text: [
              "Bienvenue sur Yeebus 🥳🥳",
              "Salut, moi c'est Usman Songo, tu n'as plus qu'à me donner ton nom et je serai officiellement ton nouveau yeeguide 🙂",
            ], nextSteps: [
              ChatStep(
                  prompt: ';#getname#;',
                  response: ChatResponse(text: [], nextSteps: [])),
            ]))
      ],
      faqSteps: [],
      afterFaq: ChatStep(
          prompt: "", response: ChatResponse(text: [], nextSteps: [])));

  static Conversation domsaConvo = Conversation(
      steps: [
        ChatStep(
            prompt: "Oui, depuis des lustres !",
            response: ChatResponse(text: [
              "Bienvenue sur Yeebus 🥳🥳",
              "Salut, moi c'est Domsa Vie, tu n'as plus qu'à me donner ton nom et je serai officiellement ton nouveau yeeguide 🙂",
            ], nextSteps: [
              ChatStep(
                  prompt: ';#getname#;',
                  response: ChatResponse(text: [], nextSteps: [])),
            ]))
      ],
      faqSteps: [],
      afterFaq: ChatStep(
          prompt: "", response: ChatResponse(text: [], nextSteps: [])));
  //  A RESTRUCTURER PAR ICI :
  static Conversation madioConvo = Conversation(
      steps: [
        ChatStep(
            prompt: "Oui, depuis des lustres !",
            response: ChatResponse(text: [
              "Bienvenue sur Yeebus 🥳🥳",
              "Salut, moi c'est Sané Madio, tu n'as plus qu'à me donner ton nom et je serai officiellement ton nouveau yeeguide 🙂",
            ], nextSteps: [
              ChatStep(
                  prompt: ';#getname#;',
                  response: ChatResponse(text: [], nextSteps: [])),
            ]))
      ],
      faqSteps: [],
      afterFaq: ChatStep(
          prompt: "", response: ChatResponse(text: [], nextSteps: [])));

  static Conversation vaidewishConvo = Conversation(
      steps: [
        ChatStep(
            prompt: "Oui, depuis des lustres !",
            response: ChatResponse(text: [
              "Bienvenue sur Yeebus 🥳🥳",
              "Salut, moi c'est Vaidewish, tu n'as plus qu'à me donner ton nom et je serai officiellement ton nouveau yeeguide 🙂",
            ], nextSteps: [
              ChatStep(
                  prompt: ';#getname#;',
                  response: ChatResponse(text: [], nextSteps: [])),
            ]))
      ],
      faqSteps: [],
      afterFaq: ChatStep(
          prompt: "", response: ChatResponse(text: [], nextSteps: [])));

  static Conversation rarutoConvo = Conversation(
      steps: [
        ChatStep(
            prompt: "Oui, depuis des lustres !",
            response: ChatResponse(text: [
              "Bienvenue sur Yeebus 🥳🥳",
              "Salut, moi c'est Raruto, tu n'as plus qu'à me donner ton nom et je serai officiellement ton nouveau yeeguide 🙂",
            ], nextSteps: [
              ChatStep(
                  prompt: ';#getname#;',
                  response: ChatResponse(text: [], nextSteps: [])),
            ]))
      ],
      faqSteps: [],
      afterFaq: ChatStep(
          prompt: "", response: ChatResponse(text: [], nextSteps: [])));

  static List<String> availableYeeguides = [
    // YeeguideId.raruto.value,
    // YeeguideId.madio.value,
    // YeeguideId.domsa.value,
    // YeeguideId.songo.value,
    // YeeguideId.vaidewish.value,
    // YeeguideId.rita.value,
    // YeeguideId.issa.value,
    YeeguideId.djibril.value

  ];

  static List<Yeeguide> yeeguidesList = [
    Yeeguide(
        id: YeeguideId.rita.value,
        category: "General",
        name: "Rita",
        profilePictureAsset: "assets/yeeguides/rita_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/rita_guide_square.png",
        tag: "@ritaguide",
        shortBio:
        "Salut, je suis ta marraine virtuelle. Celle qui répond à toutes tes questions sur le campus de l'ESMT !",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 12,
        script: rarutoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour ${locator.get<SharedPreferences>().getString("username")}",
          "Comment puis-je t'aider aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Haha t'as bien fait de me choisir 😌!",
          "Bienvenue à bord, ${locator.get<SharedPreferences>().getString("username")} !",
          "Comment puis-je t'aider aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.issa.value,
        name: "Issa",
        category: "General",
        profilePictureAsset: "assets/yeeguides/issa_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/issa_guide_square.png",
        tag: "@issaguide",
        shortBio:
        "Salut, je suis ton parrain virtuel. Celui qui répond à toutes tes questions sur le campus de l'ESMT !",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 8,
        script: songoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour ${locator.get<SharedPreferences>().getString("username")}",
          "Comment puis-je t'aider aujourd'hui mon pote ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Haha t'as bien fait de me choisir 😌!",
          "Bienvenue à bord, ${locator.get<SharedPreferences>().getString("username")} !",
          "Comment puis-je t'aider aujourd'hui mon pote ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.raruto.value,
        name: "Raruto",
        category: "Transport",
        profilePictureAsset: "assets/yeeguides/raruto_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/raruto_guide_square.png",
        tag: "@theramenguide",
        shortBio:
        "Je suis ptet pas le roi des pirates, mais moins j'ai déjà trouvé mon trésor #JtmHinata, bref, choisis-moi !",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 8,
        script: rarutoConvo,
        introChatResponse : ChatResponse(text: [
          "Ohayo ${locator.get<SharedPreferences>().getString("username")}-kun 🍥",
          "Comment puis-je t'aider aujourd'hui 'ttebayo ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Haha t'as bien fait de me choisir, bakayoro 😌!",
          "Bienvenue à bord, ${locator.get<SharedPreferences>().getString("username")}-kun 🍥",
          "Comment puis-je t'aider aujourd'hui 'ttebayo ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.songo.value,
        name: "Usman Songo",
        category: "Administration",
        profilePictureAsset: "assets/yeeguides/songo_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/songo_guide_square.png",
        tag: "@songotheguide",
        shortBio:
        "En tant que leader, il est de mon devoir de te guider à travers les rues de Dakar. Alors #EnMarche !",
        usesAudio: true,
        languages: [Languages.fr, Languages.wol],
        nbSubs: 34,
        script: songoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour cher patriote ${locator.get<SharedPreferences>().getString("username")} 👋🏽",
          "Comment puis-je t'aider à te déplacer aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Tu as donc choisi Songo mou sell mi..",
          "Bienvenue à toi cher patriote ${locator.get<SharedPreferences>().getString("username")} 👋🏽",
          "Comment puis-je t'aider à te déplacer aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.domsa.value,
        name: "Domsa Vie",
        category: "Amicale",
        profilePictureAsset: "assets/yeeguides/domsa_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/domsa_guide_square.png",
        tag: "@domstheguide",
        shortBio:
        "Si t’es venu dire que tu t’en vas, fallait rester où t’étais. Moi je t’aide à prendre le bus, rien de plus. #Vie 🖖🏾",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 12,
        script: domsaConvo,
        introChatResponse : ChatResponse(text: [
          "Yo à toi le fréro ${locator.get<SharedPreferences>().getString("username")} 🖖🏾",
          "As-tu des questions sur la vie ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Ohh t'as choisi Dems, tu dois être sage comme gars toi.",
          "Bienvenue à toi le fréro ${locator.get<SharedPreferences>().getString("username")} 🖖🏾",
          "As-tu des questions sur la vie ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.madio.value,
        name: "Sané Madio",
        category: "Vie sportive",
        profilePictureAsset: "assets/yeeguides/madio_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/madio_guide_square.png",
        tag: "@nanthiotheguide",
        shortBio:
        "Si tu aimes parler foot et que tu veux un guide rapide, précis et efficace, alors je suis ton homme. #Can2024 #Bus",
        usesAudio: true,
        languages: [Languages.fr, Languages.wol],
        nbSubs: 28,
        script: madioConvo,
        introChatResponse : ChatResponse(text: [
          "Mais ça c'est mon pote ${locator.get<SharedPreferences>().getString("username")} 👋🏿!",
          "Que puis-je t'apprendre sur le foot ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Oh, on dirait que j'ai un nouvel ami à bord !",
          "Bienvenue à toi, ${locator.get<SharedPreferences>().getString("username")} 👋🏿!",
          "Que puis-je t'apprendre sur le foot ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.vaidewish.value,
        name: "Vaidewish",
        category: "Infos & gossip",
        profilePictureAsset: "assets/yeeguides/vaidewish_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/vaidewish_guide_square.png",
        tag: "@vaidetheguide",
        shortBio:
        "Bollywood ça paie plus assez 😭, les pubs non plus.. donc je t’aide sur #Yeebus pour arrondir les fins du mois..",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 16,
        script: vaidewishConvo,
        introChatResponse : ChatResponse(text: [
          "Namasté ${locator.get<SharedPreferences>().getString("username")}",
          "Quand tu poses des questions là, Yeebus me paie !",
          "Alors comment puis-je t'aider aujourd'hui way 😭 ?",
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Ehhh bienvenue à toi ${locator.get<SharedPreferences>().getString("username")} 🤩",
          "Quand tu poses des questions là, Yeebus me paie !",
          "Alors comment puis-je t'aider aujourd'hui way 😭 ?",
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.djibril.value,
        category: "Chasse au trésor",
        name: "Djibril",
        profilePictureAsset: "assets/yeeguides/djibril_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/djibril_guide_square.png",
        tag: "@djibithegenie",
        shortBio:
        "Trouver le trésor du campus tu dois, t'y aider je ferai. Es-tu prêt, jeune padawan ?",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 12,
        script: rarutoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour à toi, jeune ${locator.get<SharedPreferences>().getString("username")}",
          "Voici ta première énigme :",
          "Dans quelle salle a eu lieu la démo de l'appli Yeekai durant la campagne ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Bienvenue à toi, jeune ${locator.get<SharedPreferences>().getString("username")}",
          "Voici ta première énigme :",
          "Dans quelle salle a eu lieu la démo de l'appli Yeekai durant la campagne ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.rita.value,
        category: "General",
        name: "Rita",
        profilePictureAsset: "assets/yeeguides/rita_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/rita_guide_square.png",
        tag: "@ritaguide",
        shortBio:
        "Salut, je suis ta marraine virtuelle. Celle qui répond à toutes tes questions sur le campus de l'ESMT !",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 12,
        script: rarutoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour ${locator.get<SharedPreferences>().getString("username")}",
          "Comment puis-je t'aider aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Haha t'as bien fait de me choisir 😌!",
          "Bienvenue à bord, ${locator.get<SharedPreferences>().getString("username")} !",
          "Comment puis-je t'aider aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.issa.value,
        name: "Issa",
        category: "General",
        profilePictureAsset: "assets/yeeguides/issa_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/issa_guide_square.png",
        tag: "@issaguide",
        shortBio:
        "Salut, je suis ton parrain virtuel. Celui qui répond à toutes tes questions sur le campus de l'ESMT !",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 8,
        script: songoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour ${locator.get<SharedPreferences>().getString("username")}",
          "Comment puis-je t'aider aujourd'hui mon pote ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Haha t'as bien fait de me choisir 😌!",
          "Bienvenue à bord, ${locator.get<SharedPreferences>().getString("username")} !",
          "Comment puis-je t'aider aujourd'hui mon pote ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.raruto.value,
        name: "Raruto",
        category: "Transport",
        profilePictureAsset: "assets/yeeguides/raruto_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/raruto_guide_square.png",
        tag: "@theramenguide",
        shortBio:
        "Je suis ptet pas le roi des pirates, mais moins j'ai déjà trouvé mon trésor #JtmHinata, bref, choisis-moi !",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 8,
        script: rarutoConvo,
        introChatResponse : ChatResponse(text: [
          "Ohayo ${locator.get<SharedPreferences>().getString("username")}-kun 🍥",
          "Comment puis-je t'aider aujourd'hui 'ttebayo ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Haha t'as bien fait de me choisir, bakayoro 😌!",
          "Bienvenue à bord, ${locator.get<SharedPreferences>().getString("username")}-kun 🍥",
          "Comment puis-je t'aider aujourd'hui 'ttebayo ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.songo.value,
        name: "Usman Songo",
        category: "Administration",
        profilePictureAsset: "assets/yeeguides/songo_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/songo_guide_square.png",
        tag: "@songotheguide",
        shortBio:
        "En tant que leader, il est de mon devoir de te guider à travers les rues de Dakar. Alors #EnMarche !",
        usesAudio: true,
        languages: [Languages.fr, Languages.wol],
        nbSubs: 34,
        script: songoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour cher patriote ${locator.get<SharedPreferences>().getString("username")} 👋🏽",
          "Comment puis-je t'aider à te déplacer aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Tu as donc choisi Songo mou sell mi..",
          "Bienvenue à toi cher patriote ${locator.get<SharedPreferences>().getString("username")} 👋🏽",
          "Comment puis-je t'aider à te déplacer aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.domsa.value,
        name: "Domsa Vie",
        category: "Amicale",
        profilePictureAsset: "assets/yeeguides/domsa_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/domsa_guide_square.png",
        tag: "@domstheguide",
        shortBio:
        "Si t’es venu dire que tu t’en vas, fallait rester où t’étais. Moi je t’aide à prendre le bus, rien de plus. #Vie 🖖🏾",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 12,
        script: domsaConvo,
        introChatResponse : ChatResponse(text: [
          "Yo à toi le fréro ${locator.get<SharedPreferences>().getString("username")} 🖖🏾",
          "As-tu des questions sur la vie ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Ohh t'as choisi Dems, tu dois être sage comme gars toi.",
          "Bienvenue à toi le fréro ${locator.get<SharedPreferences>().getString("username")} 🖖🏾",
          "As-tu des questions sur la vie ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.madio.value,
        name: "Sané Madio",
        category: "Vie sportive",
        profilePictureAsset: "assets/yeeguides/madio_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/madio_guide_square.png",
        tag: "@nanthiotheguide",
        shortBio:
        "Si tu aimes parler foot et que tu veux un guide rapide, précis et efficace, alors je suis ton homme. #Can2024 #Bus",
        usesAudio: true,
        languages: [Languages.fr, Languages.wol],
        nbSubs: 28,
        script: madioConvo,
        introChatResponse : ChatResponse(text: [
          "Mais ça c'est mon pote ${locator.get<SharedPreferences>().getString("username")} 👋🏿!",
          "Que puis-je t'apprendre sur le foot ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Oh, on dirait que j'ai un nouvel ami à bord !",
          "Bienvenue à toi, ${locator.get<SharedPreferences>().getString("username")} 👋🏿!",
          "Que puis-je t'apprendre sur le foot ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.vaidewish.value,
        name: "Vaidewish",
        category: "Infos & gossip",
        profilePictureAsset: "assets/yeeguides/vaidewish_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/vaidewish_guide_square.png",
        tag: "@vaidetheguide",
        shortBio:
        "Bollywood ça paie plus assez 😭, les pubs non plus.. donc je t’aide sur #Yeebus pour arrondir les fins du mois..",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 16,
        script: vaidewishConvo,
        introChatResponse : ChatResponse(text: [
          "Namasté ${locator.get<SharedPreferences>().getString("username")}",
          "Quand tu poses des questions là, Yeebus me paie !",
          "Alors comment puis-je t'aider aujourd'hui way 😭 ?",
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Ehhh bienvenue à toi ${locator.get<SharedPreferences>().getString("username")} 🤩",
          "Quand tu poses des questions là, Yeebus me paie !",
          "Alors comment puis-je t'aider aujourd'hui way 😭 ?",
        ], nextSteps: [])
    ),
        Yeeguide(
        id: YeeguideId.djibril.value,
        category: "Chasse au trésor",
        name: "Djibril",
        profilePictureAsset: "assets/yeeguides/djibril_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/djibril_guide_square.png",
        tag: "@djibithegenie",
        shortBio:
        "Trouver le trésor du campus tu dois, t'y aider je ferai. Es-tu prêt, jeune padawan ?",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 12,
        script: rarutoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour à toi, jeune ${locator.get<SharedPreferences>().getString("username")}",
          "Voici ta première énigme :",
          "Dans quelle salle a eu lieu la démo de l'appli Yeekai durant la campagne ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Bienvenue à toi, jeune ${locator.get<SharedPreferences>().getString("username")}",
          "Voici ta première énigme :",
          "Dans quelle salle a eu lieu la démo de l'appli Yeekai durant la campagne ?"
        ], nextSteps: [])
    ),


    Yeeguide(
        id: YeeguideId.rita.value,
        category: "General",
        name: "Rita",
        profilePictureAsset: "assets/yeeguides/rita_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/rita_guide_square.png",
        tag: "@ritaguide",
        shortBio:
        "Salut, je suis ta marraine virtuelle. Celle qui répond à toutes tes questions sur le campus de l'ESMT !",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 12,
        script: rarutoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour ${locator.get<SharedPreferences>().getString("username")}",
          "Comment puis-je t'aider aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Haha t'as bien fait de me choisir 😌!",
          "Bienvenue à bord, ${locator.get<SharedPreferences>().getString("username")} !",
          "Comment puis-je t'aider aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.issa.value,
        name: "Issa",
        category: "General",
        profilePictureAsset: "assets/yeeguides/issa_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/issa_guide_square.png",
        tag: "@issaguide",
        shortBio:
        "Salut, je suis ton parrain virtuel. Celui qui répond à toutes tes questions sur le campus de l'ESMT !",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 8,
        script: songoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour ${locator.get<SharedPreferences>().getString("username")}",
          "Comment puis-je t'aider aujourd'hui mon pote ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Haha t'as bien fait de me choisir 😌!",
          "Bienvenue à bord, ${locator.get<SharedPreferences>().getString("username")} !",
          "Comment puis-je t'aider aujourd'hui mon pote ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.raruto.value,
        name: "Raruto",
        category: "Transport",
        profilePictureAsset: "assets/yeeguides/raruto_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/raruto_guide_square.png",
        tag: "@theramenguide",
        shortBio:
        "Je suis ptet pas le roi des pirates, mais moins j'ai déjà trouvé mon trésor #JtmHinata, bref, choisis-moi !",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 8,
        script: rarutoConvo,
        introChatResponse : ChatResponse(text: [
          "Ohayo ${locator.get<SharedPreferences>().getString("username")}-kun 🍥",
          "Comment puis-je t'aider aujourd'hui 'ttebayo ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Haha t'as bien fait de me choisir, bakayoro 😌!",
          "Bienvenue à bord, ${locator.get<SharedPreferences>().getString("username")}-kun 🍥",
          "Comment puis-je t'aider aujourd'hui 'ttebayo ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.songo.value,
        name: "Usman Songo",
        category: "Administration",
        profilePictureAsset: "assets/yeeguides/songo_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/songo_guide_square.png",
        tag: "@songotheguide",
        shortBio:
        "En tant que leader, il est de mon devoir de te guider à travers les rues de Dakar. Alors #EnMarche !",
        usesAudio: true,
        languages: [Languages.fr, Languages.wol],
        nbSubs: 34,
        script: songoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour cher patriote ${locator.get<SharedPreferences>().getString("username")} 👋🏽",
          "Comment puis-je t'aider à te déplacer aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Tu as donc choisi Songo mou sell mi..",
          "Bienvenue à toi cher patriote ${locator.get<SharedPreferences>().getString("username")} 👋🏽",
          "Comment puis-je t'aider à te déplacer aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.domsa.value,
        name: "Domsa Vie",
        category: "Amicale",
        profilePictureAsset: "assets/yeeguides/domsa_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/domsa_guide_square.png",
        tag: "@domstheguide",
        shortBio:
        "Si t’es venu dire que tu t’en vas, fallait rester où t’étais. Moi je t’aide à prendre le bus, rien de plus. #Vie 🖖🏾",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 12,
        script: domsaConvo,
        introChatResponse : ChatResponse(text: [
          "Yo à toi le fréro ${locator.get<SharedPreferences>().getString("username")} 🖖🏾",
          "As-tu des questions sur la vie ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Ohh t'as choisi Dems, tu dois être sage comme gars toi.",
          "Bienvenue à toi le fréro ${locator.get<SharedPreferences>().getString("username")} 🖖🏾",
          "As-tu des questions sur la vie ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.madio.value,
        name: "Sané Madio",
        category: "Vie sportive",
        profilePictureAsset: "assets/yeeguides/madio_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/madio_guide_square.png",
        tag: "@nanthiotheguide",
        shortBio:
        "Si tu aimes parler foot et que tu veux un guide rapide, précis et efficace, alors je suis ton homme. #Can2024 #Bus",
        usesAudio: true,
        languages: [Languages.fr, Languages.wol],
        nbSubs: 28,
        script: madioConvo,
        introChatResponse : ChatResponse(text: [
          "Mais ça c'est mon pote ${locator.get<SharedPreferences>().getString("username")} 👋🏿!",
          "Que puis-je t'apprendre sur le foot ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Oh, on dirait que j'ai un nouvel ami à bord !",
          "Bienvenue à toi, ${locator.get<SharedPreferences>().getString("username")} 👋🏿!",
          "Que puis-je t'apprendre sur le foot ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.vaidewish.value,
        name: "Vaidewish",
        category: "Infos & gossip",
        profilePictureAsset: "assets/yeeguides/vaidewish_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/vaidewish_guide_square.png",
        tag: "@vaidetheguide",
        shortBio:
        "Bollywood ça paie plus assez 😭, les pubs non plus.. donc je t’aide sur #Yeebus pour arrondir les fins du mois..",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 16,
        script: vaidewishConvo,
        introChatResponse : ChatResponse(text: [
          "Namasté ${locator.get<SharedPreferences>().getString("username")}",
          "Quand tu poses des questions là, Yeebus me paie !",
          "Alors comment puis-je t'aider aujourd'hui way 😭 ?",
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Ehhh bienvenue à toi ${locator.get<SharedPreferences>().getString("username")} 🤩",
          "Quand tu poses des questions là, Yeebus me paie !",
          "Alors comment puis-je t'aider aujourd'hui way 😭 ?",
        ], nextSteps: [])
    ),
        Yeeguide(
        id: YeeguideId.djibril.value,
        category: "Chasse au trésor",
        name: "Djibril",
        profilePictureAsset: "assets/yeeguides/djibril_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/djibril_guide_square.png",
        tag: "@djibithegenie",
        shortBio:
        "Trouver le trésor du campus tu dois, t'y aider je ferai. Es-tu prêt, jeune padawan ?",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 12,
        script: rarutoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour à toi, jeune ${locator.get<SharedPreferences>().getString("username")}",
          "Voici ta première énigme :",
          "Dans quelle salle a eu lieu la démo de l'appli Yeekai durant la campagne ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Bienvenue à toi, jeune ${locator.get<SharedPreferences>().getString("username")}",
          "Voici ta première énigme :",
          "Dans quelle salle a eu lieu la démo de l'appli Yeekai durant la campagne ?"
        ], nextSteps: [])
    ),


  ];

  static List<Yeeguide> yeeguidesOriginalList = [
    Yeeguide(
        id: YeeguideId.rita.value,
        category: "General",
        name: "Rita",
        profilePictureAsset: "assets/yeeguides/rita_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/rita_guide_square.png",
        tag: "@ritaguide",
        shortBio:
        "Salut, je suis ta marraine virtuelle. Celle qui répond à toutes tes questions sur le campus de l'ESMT !",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 12,
        script: rarutoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour ${locator.get<SharedPreferences>().getString("username")}",
          "Comment puis-je t'aider aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Haha t'as bien fait de me choisir 😌!",
          "Bienvenue à bord, ${locator.get<SharedPreferences>().getString("username")} !",
          "Comment puis-je t'aider aujourd'hui ?"
        ], nextSteps: [])
    ),
        Yeeguide(
        id: YeeguideId.djibril.value,
        category: "Chasse au trésor",
        name: "Djibril",
        profilePictureAsset: "assets/yeeguides/djibril_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/djibril_guide_square.png",
        tag: "@djibithegenie",
        shortBio:
        "Trouver le trésor du campus tu dois, t'y aider je ferai. Es-tu prêt, jeune padawan ?",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 12,
        script: rarutoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour à toi, jeune ${locator.get<SharedPreferences>().getString("username")}",
          "Voici ta première énigme :",
          "Dans quelle salle a eu lieu la démo de l'appli Yeekai durant la campagne ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Bienvenue à toi, jeune ${locator.get<SharedPreferences>().getString("username")}",
          "Voici ta première énigme :",
          "Dans quelle salle a eu lieu la démo de l'appli Yeekai durant la campagne ?"
        ], nextSteps: [])
    ),


    Yeeguide(
        id: YeeguideId.issa.value,
        name: "Issa",
        category: "General",
        profilePictureAsset: "assets/yeeguides/issa_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/issa_guide_square.png",
        tag: "@issaguide",
        shortBio:
        "Salut, je suis ton parrain virtuel. Celui qui répond à toutes tes questions sur le campus de l'ESMT !",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 8,
        script: songoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour ${locator.get<SharedPreferences>().getString("username")}",
          "Comment puis-je t'aider aujourd'hui mon pote ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Haha t'as bien fait de me choisir 😌!",
          "Bienvenue à bord, ${locator.get<SharedPreferences>().getString("username")} !",
          "Comment puis-je t'aider aujourd'hui mon pote ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.raruto.value,
        name: "Raruto",
        category: "Transport",
        profilePictureAsset: "assets/yeeguides/raruto_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/raruto_guide_square.png",
        tag: "@theramenguide",
        shortBio:
        "Je suis ptet pas le roi des pirates, mais moins j'ai déjà trouvé mon trésor #JtmHinata, bref, choisis-moi !",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 8,
        script: rarutoConvo,
        introChatResponse : ChatResponse(text: [
          "Ohayo ${locator.get<SharedPreferences>().getString("username")}-kun 🍥",
          "Comment puis-je t'aider aujourd'hui 'ttebayo ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Haha t'as bien fait de me choisir, bakayoro 😌!",
          "Bienvenue à bord, ${locator.get<SharedPreferences>().getString("username")}-kun 🍥",
          "Comment puis-je t'aider aujourd'hui 'ttebayo ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.songo.value,
        name: "Usman Songo",
        category: "Administration",
        profilePictureAsset: "assets/yeeguides/songo_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/songo_guide_square.png",
        tag: "@songotheguide",
        shortBio:
        "En tant que leader, il est de mon devoir de te guider à travers les rues de Dakar. Alors #EnMarche !",
        usesAudio: true,
        languages: [Languages.fr, Languages.wol],
        nbSubs: 34,
        script: songoConvo,
        introChatResponse : ChatResponse(text: [
          "Bonjour cher patriote ${locator.get<SharedPreferences>().getString("username")} 👋🏽",
          "Comment puis-je t'aider à te déplacer aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Tu as donc choisi Songo mou sell mi..",
          "Bienvenue à toi cher patriote ${locator.get<SharedPreferences>().getString("username")} 👋🏽",
          "Comment puis-je t'aider à te déplacer aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.domsa.value,
        name: "Domsa Vie",
        category: "Amicale",
        profilePictureAsset: "assets/yeeguides/domsa_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/domsa_guide_square.png",
        tag: "@domstheguide",
        shortBio:
        "Si t’es venu dire que tu t’en vas, fallait rester où t’étais. Moi je t’aide à prendre le bus, rien de plus. #Vie 🖖🏾",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 12,
        script: domsaConvo,
        introChatResponse : ChatResponse(text: [
          "Yo à toi le fréro ${locator.get<SharedPreferences>().getString("username")} 🖖🏾",
          "As-tu des questions sur la vie ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Ohh t'as choisi Dems, tu dois être sage comme gars toi.",
          "Bienvenue à toi le fréro ${locator.get<SharedPreferences>().getString("username")} 🖖🏾",
          "As-tu des questions sur la vie ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.madio.value,
        name: "Sané Madio",
        category: "Vie sportive",
        profilePictureAsset: "assets/yeeguides/madio_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/madio_guide_square.png",
        tag: "@nanthiotheguide",
        shortBio:
        "Si tu aimes parler foot et que tu veux un guide rapide, précis et efficace, alors je suis ton homme. #Can2024 #Bus",
        usesAudio: true,
        languages: [Languages.fr, Languages.wol],
        nbSubs: 28,
        script: madioConvo,
        introChatResponse : ChatResponse(text: [
          "Mais ça c'est mon pote ${locator.get<SharedPreferences>().getString("username")} 👋🏿!",
          "Que puis-je t'apprendre sur le foot ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Oh, on dirait que j'ai un nouvel ami à bord !",
          "Bienvenue à toi, ${locator.get<SharedPreferences>().getString("username")} 👋🏿!",
          "Que puis-je t'apprendre sur le foot ou les transports à Dakar aujourd'hui ?"
        ], nextSteps: [])
    ),
    Yeeguide(
        id: YeeguideId.vaidewish.value,
        name: "Vaidewish",
        category: "Infos & gossip",
        profilePictureAsset: "assets/yeeguides/vaidewish_guide.png",
        profilePictureSquareAsset: "assets/yeeguides/vaidewish_guide_square.png",
        tag: "@vaidetheguide",
        shortBio:
        "Bollywood ça paie plus assez 😭, les pubs non plus.. donc je t’aide sur #Yeebus pour arrondir les fins du mois..",
        usesAudio: true,
        languages: [Languages.fr],
        nbSubs: 16,
        script: vaidewishConvo,
        introChatResponse : ChatResponse(text: [
          "Namasté ${locator.get<SharedPreferences>().getString("username")}",
          "Quand tu poses des questions là, Yeebus me paie !",
          "Alors comment puis-je t'aider aujourd'hui way 😭 ?",
        ], nextSteps: []),
        welcomeChatResponse : ChatResponse(text: [
          "Ehhh bienvenue à toi ${locator.get<SharedPreferences>().getString("username")} 🤩",
          "Quand tu poses des questions là, Yeebus me paie !",
          "Alors comment puis-je t'aider aujourd'hui way 😭 ?",
        ], nextSteps: [])
    ),
  ];
}
