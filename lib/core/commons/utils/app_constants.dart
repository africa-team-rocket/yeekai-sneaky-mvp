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

    static Conversation djibrilConvo = Conversation(
      steps: [
        ChatStep(
            prompt: "Oui, depuis des lustres !",
            response: ChatResponse(text: [
            "Tiens tiens.. un nouvel aventurier vient de rejoindre Yeekai !",
            "Bonjour à toi, jeune ${locator.get<SharedPreferences>().getString("username")}",
            "Toi être la bienvenue dans les antres de la chasse au trésor de l'ESMT.",
              "Prêt à défier les forces du hazard et devenir le plus grand Pirate du campus ?!",
              // //"#;enable_faq;#",
            ], nextSteps: [
              // PARTANT POUR UNE DEMO
              ChatStep(
                  prompt: 'Oui, on y va !',
                  response: ChatResponse(text: [
                    "Parfait ${locator.get<SharedPreferences>().getString("username")}, toi être un aventurier né. ",
                    "Voici la première énigme :",
                    "Dans quelle salle a eu lieu la démo de l'applicaton Yeekai durant la campagne électorale ?"
                  ], nextSteps: [
                    // ON RESTE EN FRANCAIS.


                    ChatStep(
                        prompt: "Il n'y a jamais eu de démo",
                        response: ChatResponse(text: [
                          "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                        ], nextSteps: [

                          ChatStep(
                              prompt: "À la salle HA1",
                              response: ChatResponse(text: [
                                "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                "Toi être prêt pour la deuxième énigme ?"
                              ], nextSteps: [
                                ChatStep(
                                    prompt: "Oui, je suis prêt nom d'une pipe",
                                    response: ChatResponse(text: [
                                      "Super, voici la deuxième énigme :",
                                      "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                      "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HA8 (ou HA1 sinon) tu devras..",
                                      "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                      "Le trésor est en toi 🧘🏿‍"
                                    ], nextSteps: [
                                      ChatStep(
                                          prompt: "C'est bien compris, merci Djibril !",
                                          response: ChatResponse(text: [
                                            "Al hamdoullilah !",
                                            // //"#;enable_faq;#"
                                          ], nextSteps: [
                                            // FIN BRANCHE
                                          ])),
                                      ChatStep(
                                          prompt:
                                          "J'ai encore quelques questions",
                                          response: ChatResponse(text: [
                                            "Tant de questions il y'aura..",
                                            "Aucune réponse je ne posséderai.",
                                            "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                            "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                          ], nextSteps: [

                                          ])),
                                    ])),
                              ])),

                          ChatStep(
                              prompt: "À la salle HB8",
                              response: ChatResponse(text: [
                                "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                              ], nextSteps: [

                                ChatStep(
                                    prompt: "À la salle HA1",
                                    response: ChatResponse(text: [
                                      "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                      "Toi être prêt pour la deuxième énigme ?"
                                    ], nextSteps: [
                                      ChatStep(
                                          prompt: "Oui, je suis prêt nom d'une pipe",
                                          response: ChatResponse(text: [
                                            "Super, voici la deuxième énigme :",
                                            "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                            "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                            "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                            "Le trésor est en toi 🧘🏿‍"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "C'est bien compris, merci Djibril !",
                                                response: ChatResponse(text: [
                                                  "Alhamdoullilah !",
                                                  //"#;enable_faq;#"
                                                ], nextSteps: [
                                                  // FIN BRANCHE
                                                ])),
                                            ChatStep(
                                                prompt:
                                                "J'ai encore quelques questions",
                                                response: ChatResponse(text: [
                                                  "Tant de questions il y'aura..",
                                                  "Aucune réponse je ne posséderai.",
                                                  "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                  "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [

                                                ])),
                                          ])),
                                    ])),

                                ChatStep(
                                    prompt: "À la salle HB6",
                                    response: ChatResponse(text: [
                                      "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                                          ], nextSteps: [

                                      ChatStep(
                                          prompt: "À la salle HA1",
                                          response: ChatResponse(text: [
                                            "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                            "Toi être prêt pour la deuxième énigme ?"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "Oui, je suis prêt nom d'une pipe",
                                                response: ChatResponse(text: [
                                                  "Super, voici la deuxième énigme :",
                                                  "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                                  "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                                  "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                                  "Le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [
                                                  ChatStep(
                                                      prompt: "C'est bien compris, merci Djibril !",
                                                      response: ChatResponse(text: [
                                                        "Alhamdoullilah !",
                                                        //"#;enable_faq;#"
                                                      ], nextSteps: [
                                                        // FIN BRANCHE
                                                      ])),
                                                  ChatStep(
                                                      prompt:
                                                      "J'ai encore quelques questions",
                                                      response: ChatResponse(text: [
                                                        "Tant de questions il y'aura..",
                                                        "Aucune réponse je ne posséderai.",
                                                        "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                        "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                      ], nextSteps: [

                                                      ])),
                                                ])),
                                          ])),

                                    ])),


                              ])),

                          ChatStep(
                              prompt: "À la salle HB6",
                              response: ChatResponse(text: [
                                "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                              ], nextSteps: [

                                ChatStep(
                                    prompt: "À la salle HA1",
                                    response: ChatResponse(text: [
                                      "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                      "Toi être prêt pour la deuxième énigme ?"
                                    ], nextSteps: [
                                      ChatStep(
                                          prompt: "Oui, je suis prêt nom d'une pipe",
                                          response: ChatResponse(text: [
                                            "Super, voici la deuxième énigme :",
                                            "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                            "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                            "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                            "Le trésor est en toi 🧘🏿‍"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "C'est bien compris, merci Djibril !",
                                                response: ChatResponse(text: [
                                                  "Alhamdoullilah !",
                                                  //"#;enable_faq;#"
                                                ], nextSteps: [
                                                  // FIN BRANCHE
                                                ])),
                                            ChatStep(
                                                prompt:
                                                "J'ai encore quelques questions",
                                                response: ChatResponse(text: [
                                                  "Tant de questions il y'aura..",
                                                  "Aucune réponse je ne posséderai.",
                                                  "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                  "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [

                                                ])),
                                          ])),
                                    ])),

                                ChatStep(
                                    prompt: "À la salle HB6",
                                    response: ChatResponse(text: [
                                      "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                                          ], nextSteps: [

                                      ChatStep(
                                          prompt: "À la salle HA1",
                                          response: ChatResponse(text: [
                                            "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                            "Toi être prêt pour la deuxième énigme ?"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "Oui, je suis prêt nom d'une pipe",
                                                response: ChatResponse(text: [
                                                  "Super, voici la deuxième énigme :",
                                                  "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                                  "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                                  "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                                  "Le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [
                                                  ChatStep(
                                                      prompt: "C'est bien compris, merci Djibril !",
                                                      response: ChatResponse(text: [
                                                        "Alhamdoullilah !",
                                                        //"#;enable_faq;#"
                                                      ], nextSteps: [
                                                        // FIN BRANCHE
                                                      ])),
                                                  ChatStep(
                                                      prompt:
                                                      "J'ai encore quelques questions",
                                                      response: ChatResponse(text: [
                                                        "Tant de questions il y'aura..",
                                                        "Aucune réponse je ne posséderai.",
                                                        "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                        "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                      ], nextSteps: [

                                                      ])),
                                                ])),
                                          ])),

                                    ])),


                              ])),


                        ])),

                    ChatStep(
                        prompt: "À la salle HB8",
                        response: ChatResponse(text: [
                          "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce, réessayer tu dois.",
                        ], nextSteps: [

                          ChatStep(
                              prompt: "À la salle HA1",
                              response: ChatResponse(text: [
                                "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                "Toi être prêt pour la deuxième énigme ?"
                              ], nextSteps: [
                                ChatStep(
                                    prompt: "Oui, je suis prêt nom d'une pipe",
                                    response: ChatResponse(text: [
                                      "Super, voici la deuxième énigme :",
                                      "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                      "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                      "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                      "Le trésor est en toi 🧘🏿‍"
                                    ], nextSteps: [
                                      ChatStep(
                                          prompt: "C'est bien compris, merci Djibril !",
                                          response: ChatResponse(text: [
                                            "Alhamdoullilah !",
                                            //"#;enable_faq;#"
                                          ], nextSteps: [
                                            // FIN BRANCHE
                                          ])),
                                      ChatStep(
                                          prompt:
                                          "J'ai encore quelques questions",
                                          response: ChatResponse(text: [
                                            "Tant de questions il y'aura..",
                                            "Aucune réponse je ne posséderai.",
                                            "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                            "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                          ], nextSteps: [

                                          ])),
                                    ])),
                              ])),

                          ChatStep(
                              prompt: "IL n'y a jamais eu de demo",
                              response: ChatResponse(text: [
                                "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce, réessayer tu dois.",
                              ], nextSteps: [

                                ChatStep(
                                    prompt: "À la salle HA1",
                                    response: ChatResponse(text: [
                                      "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                      "Toi être prêt pour la deuxième énigme ?"
                                    ], nextSteps: [
                                      ChatStep(
                                          prompt: "Oui, je suis prêt nom d'une pipe",
                                          response: ChatResponse(text: [
                                            "Super, voici la deuxième énigme :",
                                            "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                            "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                            "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                            "Le trésor est en toi 🧘🏿‍"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "C'est bien compris, merci Djibril !",
                                                response: ChatResponse(text: [
                                                  "Alhamdoullilah !",
                                                  //"#;enable_faq;#"
                                                ], nextSteps: [
                                                  // FIN BRANCHE
                                                ])),
                                            ChatStep(
                                                prompt:
                                                "J'ai encore quelques questions",
                                                response: ChatResponse(text: [
                                                  "Tant de questions il y'aura..",
                                                  "Aucune réponse je ne posséderai.",
                                                  "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                  "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [

                                                ])),
                                          ])),
                                    ])),

                                ChatStep(
                                    prompt: "À la salle HB6",
                                    response: ChatResponse(text: [
                                      "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                                          ], nextSteps: [

                                      ChatStep(
                                          prompt: "À la salle HA1",
                                          response: ChatResponse(text: [
                                            "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                            "Toi être prêt pour la deuxième énigme ?"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "Oui, je suis prêt nom d'une pipe",
                                                response: ChatResponse(text: [
                                                  "Super, voici la deuxième énigme :",
                                                  "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                                  "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                                  "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                                  "Le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [
                                                  ChatStep(
                                                      prompt: "C'est bien compris, merci Djibril !",
                                                      response: ChatResponse(text: [
                                                        "Alhamdoullilah !",
                                                        //"#;enable_faq;#"
                                                      ], nextSteps: [
                                                        // FIN BRANCHE
                                                      ])),
                                                  ChatStep(
                                                      prompt:
                                                      "J'ai encore quelques questions",
                                                      response: ChatResponse(text: [
                                                        "Tant de questions il y'aura..",
                                                        "Aucune réponse je ne posséderai.",
                                                        "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                        "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                      ], nextSteps: [

                                                      ])),
                                                ])),
                                          ])),

                                    ])),


                              ])),

                          ChatStep(
                              prompt: "À la salle HB6",
                              response: ChatResponse(text: [
                                "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",

                              ], nextSteps: [

                                ChatStep(
                                    prompt: "À la salle HA1",
                                    response: ChatResponse(text: [
                                      "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                      "Toi être prêt pour la deuxième énigme ?"
                                    ], nextSteps: [
                                      ChatStep(
                                          prompt: "Oui, je suis prêt nom d'une pipe",
                                          response: ChatResponse(text: [
                                            "Super, voici la deuxième énigme :",
                                            "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                            "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                            "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                            "Le trésor est en toi 🧘🏿‍"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "C'est bien compris, merci Djibril !",
                                                response: ChatResponse(text: [
                                                  "Alhamdoullilah !",
                                                  //"#;enable_faq;#"
                                                ], nextSteps: [
                                                  // FIN BRANCHE
                                                ])),
                                            ChatStep(
                                                prompt:
                                                "J'ai encore quelques questions",
                                                response: ChatResponse(text: [
                                                  "Tant de questions il y'aura..",
                                                  "Aucune réponse je ne posséderai.",
                                                  "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                  "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [

                                                ])),
                                          ])),
                                    ])),

                              ])),

                        ])),

                    ChatStep(
                        prompt: "À la salle HA1",
                        response: ChatResponse(text: [
                          "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                          "Toi être prêt pour la deuxième énigme ?"
                        ], nextSteps: [
                          ChatStep(
                              prompt: "Oui, je suis prêt nom d'une pipe",
                              response: ChatResponse(text: [
                                "Super, voici la deuxième énigme :",
                                "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                "Le trésor est en toi 🧘🏿‍"
                              ], nextSteps: [
                                ChatStep(
                                    prompt: "C'est bien compris, merci Djibril !",
                                    response: ChatResponse(text: [
                                      "Alhamdoullilah !",
                                      //"#;enable_faq;#"
                                    ], nextSteps: [
                                      // FIN BRANCHE
                                    ])),
                                ChatStep(
                                    prompt:
                                    "J'ai encore quelques questions",
                                    response: ChatResponse(text: [
                                      "Tant de questions il y'aura..",
                                      "Aucune réponse je ne posséderai.",
                                      "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                      "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                    ], nextSteps: [

                                    ])),
                              ])),
                        ])),

                    ChatStep(
                        prompt: "À la salle HB6",
                        response: ChatResponse(text: [
                          "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                        ], nextSteps: [

                          ChatStep(
                              prompt: "À la salle HA1",
                              response: ChatResponse(text: [
                                "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                "Toi être prêt pour la deuxième énigme ?"
                              ], nextSteps: [
                                ChatStep(
                                    prompt: "Oui, je suis prêt nom d'une pipe",
                                    response: ChatResponse(text: [
                                      "Super, voici la deuxième énigme :",
                                      "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                      "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                      "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                      "Le trésor est en toi 🧘🏿‍"
                                    ], nextSteps: [
                                      ChatStep(
                                          prompt: "C'est bien compris, merci Djibril !",
                                          response: ChatResponse(text: [
                                            "Alhamdoullilah !",
                                            //"#;enable_faq;#"
                                          ], nextSteps: [
                                            // FIN BRANCHE
                                          ])),
                                      ChatStep(
                                          prompt:
                                          "J'ai encore quelques questions",
                                          response: ChatResponse(text: [
                                            "Tant de questions il y'aura..",
                                            "Aucune réponse je ne posséderai.",
                                            "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                            "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                          ], nextSteps: [

                                          ])),
                                    ])),
                              ])),

                          ChatStep(
                              prompt: "IL n'y a jamais eu de demo",
                              response: ChatResponse(text: [
                                "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                              ], nextSteps: [

                                ChatStep(
                                    prompt: "À la salle HA1",
                                    response: ChatResponse(text: [
                                      "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                      "Toi être prêt pour la deuxième énigme ?"
                                    ], nextSteps: [
                                      ChatStep(
                                          prompt: "Oui, je suis prêt nom d'une pipe",
                                          response: ChatResponse(text: [
                                            "Super, voici la deuxième énigme :",
                                            "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                            "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                            "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                            "Le trésor est en toi 🧘🏿‍"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "C'est bien compris, merci Djibril !",
                                                response: ChatResponse(text: [
                                                  "Alhamdoullilah !",
                                                  //"#;enable_faq;#"
                                                ], nextSteps: [
                                                  // FIN BRANCHE
                                                ])),
                                            ChatStep(
                                                prompt:
                                                "J'ai encore quelques questions",
                                                response: ChatResponse(text: [
                                                  "Tant de questions il y'aura..",
                                                  "Aucune réponse je ne posséderai.",
                                                  "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                  "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [

                                                ])),
                                          ])),
                                    ])),

                                ChatStep(
                                    prompt: "À la salle HB8",
                                    response: ChatResponse(text: [
                                      "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                                          ], nextSteps: [

                                      ChatStep(
                                          prompt: "À la salle HA1",
                                          response: ChatResponse(text: [
                                            "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                            "Toi être prêt pour la deuxième énigme ?"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "Oui, je suis prêt nom d'une pipe",
                                                response: ChatResponse(text: [
                                                  "Super, voici la deuxième énigme :",
                                                  "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                                  "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                                  "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                                  "Le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [
                                                  ChatStep(
                                                      prompt: "C'est bien compris, merci Djibril !",
                                                      response: ChatResponse(text: [
                                                        "Alhamdoullilah !",
                                                        //"#;enable_faq;#"
                                                      ], nextSteps: [
                                                        // FIN BRANCHE
                                                      ])),
                                                  ChatStep(
                                                      prompt:
                                                      "J'ai encore quelques questions",
                                                      response: ChatResponse(text: [
                                                        "Tant de questions il y'aura..",
                                                        "Aucune réponse je ne posséderai.",
                                                        "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                        "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                      ], nextSteps: [

                                                      ])),
                                                ])),
                                          ])),

                                    ])),


                              ])),

                          ChatStep(
                              prompt: "À la salle HB8",
                              response: ChatResponse(text: [
                                "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                              ], nextSteps: [

                                ChatStep(
                                    prompt: "À la salle HA1",
                                    response: ChatResponse(text: [
                                      "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                      "Toi être prêt pour la deuxième énigme ?"
                                    ], nextSteps: [
                                      ChatStep(
                                          prompt: "Oui, je suis prêt nom d'une pipe",
                                          response: ChatResponse(text: [
                                            "Super, voici la deuxième énigme :",
                                            "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                            "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                            "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                            "Le trésor est en toi 🧘🏿‍"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "C'est bien compris, merci Djibril !",
                                                response: ChatResponse(text: [
                                                  "Alhamdoullilah !",
                                                  //"#;enable_faq;#"
                                                ], nextSteps: [
                                                  // FIN BRANCHE
                                                ])),
                                            ChatStep(
                                                prompt:
                                                "J'ai encore quelques questions",
                                                response: ChatResponse(text: [
                                                  "Tant de questions il y'aura..",
                                                  "Aucune réponse je ne posséderai.",
                                                  "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                  "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [

                                                ])),
                                          ])),
                                    ])),

                              ])),

                        ])),


                  ])),
              // PAS PARTANT POUR UNE DEMO (Confetti d'abord puis on loop) :
              ChatStep(
                  prompt: 'Non, je veux plus de confetti d\'abord 🙂',
                  response: ChatResponse(text: [
                    "D'accord jeune pirate d'eau douce, ce sera ton troisième et dernier souhait.",
                    "(Qui lui a dit que je savais faire ça moi déjà ? 😭)",
                    "Latom nostradamus..",
                    "abracadabra !",
                    "toi être satisfait ?"
                  ], nextSteps: [
                    ChatStep(
                        prompt: 'Merci 😂 la chasse peut enfin commencer maintenant',
                        response: ChatResponse(text: [
                          "Parfait ${locator.get<SharedPreferences>().getString("username")}, toi être un aventurier né. ",
                          "Voici la première énigme :",
                          "Dans quelle salle a eu lieu la démo de l'applicaton Yeekai durant la campagne électorale ?"
                        ], nextSteps: [
                          // ON RESTE EN FRANCAIS.



                          ChatStep(
                              prompt: "Il n'y a jamais eu de démo",
                              response: ChatResponse(text: [
                                "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                              ], nextSteps: [

                                ChatStep(
                                    prompt: "À la salle HA1",
                                    response: ChatResponse(text: [
                                      "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                      "Toi être prêt pour la deuxième énigme ?"
                                    ], nextSteps: [
                                      ChatStep(
                                          prompt: "Oui, je suis prêt nom d'une pipe",
                                          response: ChatResponse(text: [
                                            "Super, voici la deuxième énigme :",
                                            "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                            "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                            "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                            "Le trésor est en toi 🧘🏿‍"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "C'est bien compris, merci Djibril !",
                                                response: ChatResponse(text: [
                                                  "Alhamdoullilah !",
                                                  //"#;enable_faq;#"
                                                ], nextSteps: [
                                                  // FIN BRANCHE
                                                ])),
                                            ChatStep(
                                                prompt:
                                                "J'ai encore quelques questions",
                                                response: ChatResponse(text: [
                                                  "Tant de questions il y'aura..",
                                                  "Aucune réponse je ne posséderai.",
                                                  "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                  "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [

                                                ])),
                                          ])),
                                    ])),

                                ChatStep(
                                    prompt: "À la salle HB8",
                                    response: ChatResponse(text: [
                                      "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                                    ], nextSteps: [

                                      ChatStep(
                                          prompt: "À la salle HA1",
                                          response: ChatResponse(text: [
                                            "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                            "Toi être prêt pour la deuxième énigme ?"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "Oui, je suis prêt nom d'une pipe",
                                                response: ChatResponse(text: [
                                                  "Super, voici la deuxième énigme :",
                                                  "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                                  "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                                  "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                                  "Le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [
                                                  ChatStep(
                                                      prompt: "C'est bien compris, merci Djibril !",
                                                      response: ChatResponse(text: [
                                                        "Alhamdoullilah !",
                                                        //"#;enable_faq;#"
                                                      ], nextSteps: [
                                                        // FIN BRANCHE
                                                      ])),
                                                  ChatStep(
                                                      prompt:
                                                      "J'ai encore quelques questions",
                                                      response: ChatResponse(text: [
                                                        "Tant de questions il y'aura..",
                                                        "Aucune réponse je ne posséderai.",
                                                        "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                        "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                      ], nextSteps: [

                                                      ])),
                                                ])),
                                          ])),

                                      ChatStep(
                                          prompt: "À la salle HB6",
                                          response: ChatResponse(text: [
                                            "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                                          ], nextSteps: [

                                            ChatStep(
                                                prompt: "À la salle HA1",
                                                response: ChatResponse(text: [
                                                  "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                                  "Toi être prêt pour la deuxième énigme ?"
                                                ], nextSteps: [
                                                  ChatStep(
                                                      prompt: "Oui, je suis prêt nom d'une pipe",
                                                      response: ChatResponse(text: [
                                                        "Super, voici la deuxième énigme :",
                                                        "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                                        "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                                        "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                                        "Le trésor est en toi 🧘🏿‍"
                                                      ], nextSteps: [
                                                        ChatStep(
                                                            prompt: "C'est bien compris, merci Djibril !",
                                                            response: ChatResponse(text: [
                                                              "Alhamdoullilah !",
                                                              //"#;enable_faq;#"
                                                            ], nextSteps: [
                                                              // FIN BRANCHE
                                                            ])),
                                                        ChatStep(
                                                            prompt:
                                                            "J'ai encore quelques questions",
                                                            response: ChatResponse(text: [
                                                              "Tant de questions il y'aura..",
                                                              "Aucune réponse je ne posséderai.",
                                                              "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                              "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                            ], nextSteps: [

                                                            ])),
                                                      ])),
                                                ])),

                                          ])),


                                    ])),

                                ChatStep(
                                    prompt: "À la salle HB6",
                                    response: ChatResponse(text: [
                                      "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                                    ], nextSteps: [

                                      ChatStep(
                                          prompt: "À la salle HA1",
                                          response: ChatResponse(text: [
                                            "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                            "Toi être prêt pour la deuxième énigme ?"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "Oui, je suis prêt nom d'une pipe",
                                                response: ChatResponse(text: [
                                                  "Super, voici la deuxième énigme :",
                                                  "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                                  "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                                  "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                                  "Le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [
                                                  ChatStep(
                                                      prompt: "C'est bien compris, merci Djibril !",
                                                      response: ChatResponse(text: [
                                                        "Alhamdoullilah !",
                                                        //"#;enable_faq;#"
                                                      ], nextSteps: [
                                                        // FIN BRANCHE
                                                      ])),
                                                  ChatStep(
                                                      prompt:
                                                      "J'ai encore quelques questions",
                                                      response: ChatResponse(text: [
                                                        "Tant de questions il y'aura..",
                                                        "Aucune réponse je ne posséderai.",
                                                        "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                        "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                      ], nextSteps: [

                                                      ])),
                                                ])),
                                          ])),

                                      ChatStep(
                                          prompt: "À la salle HB6",
                                          response: ChatResponse(text: [
                                            "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                                          ], nextSteps: [

                                            ChatStep(
                                                prompt: "À la salle HA1",
                                                response: ChatResponse(text: [
                                                  "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                                  "Toi être prêt pour la deuxième énigme ?"
                                                ], nextSteps: [
                                                  ChatStep(
                                                      prompt: "Oui, je suis prêt nom d'une pipe",
                                                      response: ChatResponse(text: [
                                                        "Super, voici la deuxième énigme :",
                                                        "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                                        "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                                        "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                                        "Le trésor est en toi 🧘🏿‍"
                                                      ], nextSteps: [
                                                        ChatStep(
                                                            prompt: "C'est bien compris, merci Djibril !",
                                                            response: ChatResponse(text: [
                                                              "Alhamdoullilah !",
                                                              //"#;enable_faq;#"
                                                            ], nextSteps: [
                                                              // FIN BRANCHE
                                                            ])),
                                                        ChatStep(
                                                            prompt:
                                                            "J'ai encore quelques questions",
                                                            response: ChatResponse(text: [
                                                              "Tant de questions il y'aura..",
                                                              "Aucune réponse je ne posséderai.",
                                                              "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                              "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                            ], nextSteps: [

                                                            ])),
                                                      ])),
                                                ])),

                                          ])),


                                    ])),


                              ])),

                          ChatStep(
                              prompt: "À la salle HB8",
                              response: ChatResponse(text: [
                                "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce, réessayer tu dois.",
                              ], nextSteps: [

                                ChatStep(
                                    prompt: "À la salle HA1",
                                    response: ChatResponse(text: [
                                      "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                      "Toi être prêt pour la deuxième énigme ?"
                                    ], nextSteps: [
                                      ChatStep(
                                          prompt: "Oui, je suis prêt nom d'une pipe",
                                          response: ChatResponse(text: [
                                            "Super, voici la deuxième énigme :",
                                            "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                            "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                            "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                            "Le trésor est en toi 🧘🏿‍"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "C'est bien compris, merci Djibril !",
                                                response: ChatResponse(text: [
                                                  "Alhamdoullilah !",
                                                  //"#;enable_faq;#"
                                                ], nextSteps: [
                                                  // FIN BRANCHE
                                                ])),
                                            ChatStep(
                                                prompt:
                                                "J'ai encore quelques questions",
                                                response: ChatResponse(text: [
                                                  "Tant de questions il y'aura..",
                                                  "Aucune réponse je ne posséderai.",
                                                  "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                  "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [

                                                ])),
                                          ])),
                                    ])),

                                ChatStep(
                                    prompt: "IL n'y a jamais eu de demo",
                                    response: ChatResponse(text: [
                                      "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce, réessayer tu dois.",
                                    ], nextSteps: [

                                      ChatStep(
                                          prompt: "À la salle HA1",
                                          response: ChatResponse(text: [
                                            "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                            "Toi être prêt pour la deuxième énigme ?"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "Oui, je suis prêt nom d'une pipe",
                                                response: ChatResponse(text: [
                                                  "Super, voici la deuxième énigme :",
                                                  "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                                  "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                                  "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                                  "Le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [
                                                  ChatStep(
                                                      prompt: "C'est bien compris, merci Djibril !",
                                                      response: ChatResponse(text: [
                                                        "Alhamdoullilah !",
                                                        //"#;enable_faq;#"
                                                      ], nextSteps: [
                                                        // FIN BRANCHE
                                                      ])),
                                                  ChatStep(
                                                      prompt:
                                                      "J'ai encore quelques questions",
                                                      response: ChatResponse(text: [
                                                        "Tant de questions il y'aura..",
                                                        "Aucune réponse je ne posséderai.",
                                                        "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                        "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                      ], nextSteps: [

                                                      ])),
                                                ])),
                                          ])),

                                      ChatStep(
                                          prompt: "À la salle HB6",
                                          response: ChatResponse(text: [
                                            "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                                          ], nextSteps: [

                                            ChatStep(
                                                prompt: "À la salle HA1",
                                                response: ChatResponse(text: [
                                                  "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                                  "Toi être prêt pour la deuxième énigme ?"
                                                ], nextSteps: [
                                                  ChatStep(
                                                      prompt: "Oui, je suis prêt nom d'une pipe",
                                                      response: ChatResponse(text: [
                                                        "Super, voici la deuxième énigme :",
                                                        "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                                        "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                                        "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                                        "Le trésor est en toi 🧘🏿‍"
                                                      ], nextSteps: [
                                                        ChatStep(
                                                            prompt: "C'est bien compris, merci Djibril !",
                                                            response: ChatResponse(text: [
                                                              "Alhamdoullilah !",
                                                              //"#;enable_faq;#"
                                                            ], nextSteps: [
                                                              // FIN BRANCHE
                                                            ])),
                                                        ChatStep(
                                                            prompt:
                                                            "J'ai encore quelques questions",
                                                            response: ChatResponse(text: [
                                                              "Tant de questions il y'aura..",
                                                              "Aucune réponse je ne posséderai.",
                                                              "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                              "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                            ], nextSteps: [

                                                            ])),
                                                      ])),
                                                ])),

                                          ])),


                                    ])),

                                ChatStep(
                                    prompt: "À la salle HB6",
                                    response: ChatResponse(text: [
                                      "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",

                                    ], nextSteps: [

                                      ChatStep(
                                          prompt: "À la salle HA1",
                                          response: ChatResponse(text: [
                                            "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                            "Toi être prêt pour la deuxième énigme ?"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "Oui, je suis prêt nom d'une pipe",
                                                response: ChatResponse(text: [
                                                  "Super, voici la deuxième énigme :",
                                                  "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                                  "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                                  "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                                  "Le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [
                                                  ChatStep(
                                                      prompt: "C'est bien compris, merci Djibril !",
                                                      response: ChatResponse(text: [
                                                        "Alhamdoullilah !",
                                                        //"#;enable_faq;#"
                                                      ], nextSteps: [
                                                        // FIN BRANCHE
                                                      ])),
                                                  ChatStep(
                                                      prompt:
                                                      "J'ai encore quelques questions",
                                                      response: ChatResponse(text: [
                                                        "Tant de questions il y'aura..",
                                                        "Aucune réponse je ne posséderai.",
                                                        "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                        "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                      ], nextSteps: [

                                                      ])),
                                                ])),
                                          ])),

                                    ])),

                              ])),

                          ChatStep(
                              prompt: "À la salle HA1",
                              response: ChatResponse(text: [
                                "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                "Toi être prêt pour la deuxième énigme ?"
                              ], nextSteps: [
                                ChatStep(
                                    prompt: "Oui, je suis prêt nom d'une pipe",
                                    response: ChatResponse(text: [
                                      "Super, voici la deuxième énigme :",
                                      "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                      "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                      "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                      "Le trésor est en toi 🧘🏿‍"
                                    ], nextSteps: [
                                      ChatStep(
                                          prompt: "C'est bien compris, merci Djibril !",
                                          response: ChatResponse(text: [
                                            "Alhamdoullilah !",
                                            //"#;enable_faq;#"
                                          ], nextSteps: [
                                            // FIN BRANCHE
                                          ])),
                                      ChatStep(
                                          prompt:
                                          "J'ai encore quelques questions",
                                          response: ChatResponse(text: [
                                            "Tant de questions il y'aura..",
                                            "Aucune réponse je ne posséderai.",
                                            "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                            "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                          ], nextSteps: [

                                          ])),
                                    ])),
                              ])),

                          ChatStep(
                              prompt: "À la salle HB6",
                              response: ChatResponse(text: [
                                "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                              ], nextSteps: [

                                ChatStep(
                                    prompt: "À la salle HA1",
                                    response: ChatResponse(text: [
                                      "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                      "Toi être prêt pour la deuxième énigme ?"
                                    ], nextSteps: [
                                      ChatStep(
                                          prompt: "Oui, je suis prêt nom d'une pipe",
                                          response: ChatResponse(text: [
                                            "Super, voici la deuxième énigme :",
                                            "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                            "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                            "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                            "Le trésor est en toi 🧘🏿‍"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "C'est bien compris, merci Djibril !",
                                                response: ChatResponse(text: [
                                                  "Alhamdoullilah !",
                                                  //"#;enable_faq;#"
                                                ], nextSteps: [
                                                  // FIN BRANCHE
                                                ])),
                                            ChatStep(
                                                prompt:
                                                "J'ai encore quelques questions",
                                                response: ChatResponse(text: [
                                                  "Tant de questions il y'aura..",
                                                  "Aucune réponse je ne posséderai.",
                                                  "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                  "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [

                                                ])),
                                          ])),
                                    ])),

                                ChatStep(
                                    prompt: "IL n'y a jamais eu de demo",
                                    response: ChatResponse(text: [
                                      "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                                    ], nextSteps: [

                                      ChatStep(
                                          prompt: "À la salle HA1",
                                          response: ChatResponse(text: [
                                            "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                            "Toi être prêt pour la deuxième énigme ?"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "Oui, je suis prêt nom d'une pipe",
                                                response: ChatResponse(text: [
                                                  "Super, voici la deuxième énigme :",
                                                  "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                                  "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                                  "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                                  "Le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [
                                                  ChatStep(
                                                      prompt: "C'est bien compris, merci Djibril !",
                                                      response: ChatResponse(text: [
                                                        "Alhamdoullilah !",
                                                        //"#;enable_faq;#"
                                                      ], nextSteps: [
                                                        // FIN BRANCHE
                                                      ])),
                                                  ChatStep(
                                                      prompt:
                                                      "J'ai encore quelques questions",
                                                      response: ChatResponse(text: [
                                                        "Tant de questions il y'aura..",
                                                        "Aucune réponse je ne posséderai.",
                                                        "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                        "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                      ], nextSteps: [

                                                      ])),
                                                ])),
                                          ])),

                                      ChatStep(
                                          prompt: "À la salle HB8",
                                          response: ChatResponse(text: [
                                            "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                                          ], nextSteps: [

                                            ChatStep(
                                                prompt: "À la salle HA1",
                                                response: ChatResponse(text: [
                                                  "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                                  "Toi être prêt pour la deuxième énigme ?"
                                                ], nextSteps: [
                                                  ChatStep(
                                                      prompt: "Oui, je suis prêt nom d'une pipe",
                                                      response: ChatResponse(text: [
                                                        "Super, voici la deuxième énigme :",
                                                        "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                                        "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                                        "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                                        "Le trésor est en toi 🧘🏿‍"
                                                      ], nextSteps: [
                                                        ChatStep(
                                                            prompt: "C'est bien compris, merci Djibril !",
                                                            response: ChatResponse(text: [
                                                              "Alhamdoullilah !",
                                                              //"#;enable_faq;#"
                                                            ], nextSteps: [
                                                              // FIN BRANCHE
                                                            ])),
                                                        ChatStep(
                                                            prompt:
                                                            "J'ai encore quelques questions",
                                                            response: ChatResponse(text: [
                                                              "Tant de questions il y'aura..",
                                                              "Aucune réponse je ne posséderai.",
                                                              "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                              "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                            ], nextSteps: [

                                                            ])),
                                                      ])),
                                                ])),

                                          ])),


                                    ])),

                                ChatStep(
                                    prompt: "À la salle HB8",
                                    response: ChatResponse(text: [
                                      "Mauvaise réponse tu as, améliorer ton haki de l'observation tu dois, jeune pirate d'eau douce.",
                                    ], nextSteps: [

                                      ChatStep(
                                          prompt: "À la salle HA1",
                                          response: ChatResponse(text: [
                                            "Bonne réponse tu as, ton observation être digne de passer à l'étape suivante.",
                                            "Toi être prêt pour la deuxième énigme ?"
                                          ], nextSteps: [
                                            ChatStep(
                                                prompt: "Oui, je suis prêt nom d'une pipe",
                                                response: ChatResponse(text: [
                                                  "Super, voici la deuxième énigme :",
                                                  "C’est le moment de faire du sport. Prend du recul, récupère le numéro de l entreprise monde impression et viens me trouver (Signé Djibril)",
                                                  "Dès que tu auras la réponse à cette énigme, venir me retrouver à la salle HB6 tu devras..",
                                                  "Si la bonne réponse tu as, récompensé tu seras.. oh et n'oublie pas :",
                                                  "Le trésor est en toi 🧘🏿‍"
                                                ], nextSteps: [
                                                  ChatStep(
                                                      prompt: "C'est bien compris, merci Djibril !",
                                                      response: ChatResponse(text: [
                                                        "Alhamdoullilah !",
                                                        //"#;enable_faq;#"
                                                      ], nextSteps: [
                                                        // FIN BRANCHE
                                                      ])),
                                                  ChatStep(
                                                      prompt:
                                                      "J'ai encore quelques questions",
                                                      response: ChatResponse(text: [
                                                        "Tant de questions il y'aura..",
                                                        "Aucune réponse je ne posséderai.",
                                                        "Si remarques tu as concernant le jeu, contacte les maîtres de Yeekai via Whatsapp ou téléphone : +221 78 870 84 28",
                                                        "Et n'oublie pas, le trésor est en toi 🧘🏿‍"
                                                      ], nextSteps: [

                                                      ])),
                                                ])),
                                          ])),

                                    ])),

                              ])),


                        ])),
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
              //"#;enable_faq;#"
            ], nextSteps: [])),
        FaqStep(
            question:
                "Combien coûterait un trajet de Mermoz au Parc Zoologique de Hann en bus ?",
            answer: ChatResponse(text: [
              "3.000 FCFA...",
              "C’est ce que tu aurais payé en prenant un taxi.\n\nEn bus cela dépendra des lignes empruntés mais avec l’itinéraire optimal, pas plus de 350 FCFA.",
              "🚨 ET SURTOUT : \n\nL’équipe Yeebus étudie encore le système de tarification, je me base donc sur des estimations en attendant.\n\nPrend toujours un billet de plus que prévu avec toi, on ne sait jamais 😉",
              //"#;enable_faq;#"
            ], nextSteps: [])),
        FaqStep(
            question: "Est-ce que la ligne 7 passe vers UCAD ?",
            answer: ChatResponse(text: [
              "Oui, la ligne 7 passe vers UCAD.",
              "J’ai été programmé pour être simple et drôle donc je m’arrête là.\n\nQu’est-ce qui est jaune et qui attend ?",
              "Jonathan.\n\n*badum tss* 🥁",
              //"#;enable_faq;#"
            ], nextSteps: [])),
        FaqStep(
            question:
                "La ligne 7 est-elle accessible aux personnes à mobilité réduite ?",
            answer: ChatResponse(text: [
              "La ligne 7 de Dakar Dem Dikk peut être constituée de plusieurs modèle de bus.\n\nJe ne peux donc pas garantir que toute la ligne soit accessible.",
              "Cependant, la compagnie Dakar Dem Dikk a récemment reçu une toute nouvelle flotte de bus.\n\nIl se peut donc que la plupart des bus de la ligne 7 soient en effet accessibles, surtout s’ils disposent de l’icône suivant : \n\n♿",
              //"#;enable_faq;#"
            ], nextSteps: [])),
        FaqStep(
            question: "La mort ou tchi-tchi ?",
            answer: ChatResponse(text: [
              "Désolé, #;username;#, on me tue mais on ne me déshonore pas 😂😂",
              "Je vais me donner la mort avant même que tu n'aies dit 'd'accord, mais d'abord tchitchi ' 🤣",
              "Bref, pose une vraie question cette fois :",
              //"#;enable_faq;#"
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

  //  A RESTRUCTURER PAR ICI :
 
  static Conversation domsaConvo = Conversation(
      steps: [
        ChatStep(
            prompt: "Oui, depuis des lustres !",
            response: ChatResponse(text: [
              "Bienvenue sur Yeebus 🥳🥳",
              "Salut, moi c'est Domsa Vie, tu n'as plus qu'à me donner ton nom et la chasse au trésor sera officiellement lancée ",
            ], nextSteps: [
              ChatStep(
                  prompt: ';#getname#;',
                  response: ChatResponse(text: [], nextSteps: [])),
            ]))
      ],
      faqSteps: [],
      afterFaq: ChatStep(
          prompt: "", response: ChatResponse(text: [], nextSteps: [])));

  // A RESTRUCTURER PAR ICI :
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
        script: djibrilConvo,
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
        script: djibrilConvo,
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
        script: djibrilConvo,
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
        script: djibrilConvo,
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
        script: djibrilConvo,
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
        script: djibrilConvo,
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
        script: djibrilConvo,
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
        script: djibrilConvo,
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
        script: djibrilConvo,
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
        script: djibrilConvo,
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
        script: djibrilConvo,
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
        script: djibrilConvo,
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

  ];
}
