import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_context_menu/src/default_builder/mobile_menu_widget_builder.dart';
import 'package:super_context_menu/super_context_menu.dart';

import '../../../../core/commons/theme/app_colors.dart';
import '../../../../core/commons/utils/firebase_engine.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/presentation/app_global_widgets.dart';
import '../../../domain/model/chat_message.dart';
import '../../../domain/model/yeeguide.dart';
import '../bloc/chat_bloc.dart';

// LES WIDGETS DU CHAT DE L'ASSISTANT : Tu dois tous les revoir pour avoir moins de stateful

// 1 - Isole la logique actuelle de SuitedMessageBubbles dans un widget SpecialAssistantMessagesSectionWidget puis commence à
// travailler avec le reste à l'identique.

// 2 - Faire monter SuitedMessageBubble dans Assistant en terme de state pour que Suited devienne stateless, de toute façon il n'y a qu'un par widget
// so tu n'as pas d'arguments.

// 3 - Il s'agirait de réetudier mais en vrai je pense que tout peut monter ensemble, ça ne dépendra que de toi

// 4 - Renseigen toi sur big stateful widget vs many small ones : https://stackoverflow.com/questions/66559843/one-big-statefulwidget-or-multiple-small-statefulwidgets#:~:text=Keep%20in%20mind%20that%20everything,need%20state%20management%20(stateless).

// 5 - Fais aussi des tests de performance, de toute façon si le code est performant, tu peux t'en tenir qu'à la base et avancer.

class MessageLoader extends StatelessWidget {
  const MessageLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      // color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            Flexible(
              flex: 1,
              child: SizedBox(
                width: 1.sw,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 1.sw,
                  // color: Colors.yellow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: 1.sw * 0.9, minWidth: 10, minHeight: 40),
                        margin: const EdgeInsets.only(left: 5.0, top: 5.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F4F4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: SizedBox(
                            width: 22,
                            child:
                                Lottie.asset('assets/animations/typing.json'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}




class AssistantMessagesSectionWidget extends StatefulWidget {
  const AssistantMessagesSectionWidget({
    super.key,
    required this.chatResponse,
    required this.isTyping,
    required this.currentIndex,
    required this.chatBloc,
  });

  final AIChatMessage chatResponse;
  final bool isTyping;
  final int currentIndex;
  final ChatBloc chatBloc;

  @override
  State<AssistantMessagesSectionWidget> createState() => _AssistantMessagesSectionWidgetState();
}

class _AssistantMessagesSectionWidgetState extends State<AssistantMessagesSectionWidget> {

  List<String> splitByNewLine(String text) {
    return text.split('\n\n').where((line) => line.trim().isNotEmpty).toList();
  }


  List<String> textMessages = [];

  @override
  void initState() {

    textMessages = splitByNewLine(widget.chatResponse.message);
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        if (widget.currentIndex == 0 ||
            _isDifferentDay(widget.chatBloc.state.messages.reversed.toList()[widget.currentIndex].creationDate,
                widget.chatBloc.state.messages.reversed.toList()[widget.currentIndex - 1].creationDate)) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
              _getFormattedDate(
                  widget.chatBloc.state.messages.reversed.toList()[widget.currentIndex].creationDate),
              style: TextStyle(color: AppColors.secondaryText, fontSize: 12.5),
              textAlign: TextAlign.center,
            ),
          )
        ],
        for (int index = 0;
        index < textMessages.length;
        index++)
          SizedBox(
          width: 1.sw,
          // color: Colors.red,
          child: SwipeActionCell(
            // controller: SwipeActionControlle,
            backgroundColor: Colors.transparent,
            openAnimationCurve: Curves.easeInOut,
            openAnimationDuration: 200,
            fullSwipeFactor: 0.2,
            key: widget.key ?? ValueKey(widget.currentIndex.toString()),
            trailingActions: [
              SwipeAction(
                  closeOnTap: true,
                  backgroundRadius: 0.5,
                  widthSpace: 53,
                  content: Material(
                    //back to white here

                  color: Colors.transparent,
                    // shape: BoxShape.circle,
                    child: InkWell(
                      onTap: () {
                        FirebaseEngine.logCustomEvent("retry_message_clicked", {});

                        ScaffoldMessenger.of(context).showSnackBar(
                          buildCustomSnackBar(
                            context,
                            "Fonctionnalité disponible prochainement 😉",
                            SnackBarType.info,
                            showCloseIcon: false,
                          ),
                        );},
                      child: Center(
                        child: Image.asset(
                          "assets/icons/retry.png",
                          width: 20,
                        ),
                      ),
                    ),
                  ),
                  // performsFirstActionWithFullSwipe: true,
                  style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  onTap: (CompletionHandler handler) {
                    FirebaseEngine.logCustomEvent("retry_message_clicked", {});

                    ScaffoldMessenger.of(context).showSnackBar(
                      buildCustomSnackBar(
                        context,
                        "Fonctionnalité disponible prochainement 😉",
                        SnackBarType.info,
                        showCloseIcon: false,
                      ),
                    );},
                  color: Colors.transparent),
              SwipeAction(
                  backgroundRadius: 0.5,
                  widthSpace: 53,
                  content: Material(
                    color: Colors.white,
                    // shape: BoxShape.circle,
                    child: InkWell(
    onTap: () {
      FirebaseEngine.logCustomEvent("listen_message_clicked", {});

      ScaffoldMessenger.of(context).showSnackBar(
    buildCustomSnackBar(
    context,
    "Fonctionnalité disponible prochainement 😉",
    SnackBarType.info,
    showCloseIcon: false,
    ),
    );},
                      child: Center(
                        child: Image.asset(
                          "assets/icons/voice.png",
                          width: 20,
                        ),
                      ),
                    ),
                  ),
                  // performsFirstActionWithFullSwipe: true,
                  style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  onTap: (CompletionHandler handler) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      buildCustomSnackBar(
                        context,
                        "Fonctionnalité disponible prochainement 😉",
                        SnackBarType.info,
                        showCloseIcon: false,
                      ),
                    );},
                  color: Colors.transparent),
            ],
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AIMessageBubble(
                    chatResponse: AIChatMessage(message: textMessages[index], conversationId: widget.chatResponse.conversationId, yeeguideId: widget.chatResponse.yeeguideId),
                    isTyping: widget.isTyping,
                  )
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}

class AIMessageBubble extends StatelessWidget {
  const AIMessageBubble(
      {Key? key, required this.chatResponse, required this.isTyping})
      : super(key: key);

  final AIChatMessage chatResponse;
  final bool isTyping;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: SizedBox(
        width: 1.sw,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 1.sw,
          // color: Colors.yellow,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContextMenuWidget(
                mobileMenuWidgetBuilder: DefaultMobileMenuWidgetBuilder(
                    enableBackgroundBlur: true, brightness: Brightness.light),
                previewBuilder: (context, child) {
                  return Container(
                    constraints: BoxConstraints(
                        maxWidth: 1.sw * 0.9, minWidth: 10, minHeight: 40),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chatResponse.message,
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primaryText,
                              overflow: TextOverflow.ellipsis),
                          textAlign: TextAlign.start,
                          maxLines: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          _getFormattedDateWithPretext(
                              chatResponse.creationDate),
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primaryText.withOpacity(.6),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  );
                },
                menuProvider: (_) {
                  return Menu(
                    children: [
                      MenuAction(title: 'Signaler la réponse', callback: () {}),
                      MenuSeparator(),
                      MenuAction(title: 'Copier', callback: () {
                        FirebaseEngine.logCustomEvent("copy_message_clicked", {});

                      }),
                      MenuSeparator(),
                      MenuAction(title: 'Réessayer', callback: () {
                        FirebaseEngine.logCustomEvent("retry_message_clicked", {});

                      }),
                      MenuSeparator(),
                      MenuAction(title: 'Écouter en audio', callback: () {
                        FirebaseEngine.logCustomEvent("listen_message_clicked", {});

                      }),
                    ],
                  );
                },
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: 1.sw * 0.9, minWidth: 10, minHeight: 40),
                  margin: const EdgeInsets.only(left: 5.0, top: 5.0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    // color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:
                      // On ne met pas de typing checker pour l'instant on gérera ça plus tard
                      isTyping
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: SizedBox(
                                width: 22,
                                child: Lottie.asset(
                                    'assets/animations/typing.json'),
                              ),
                            )
                          : TextBox(
                              onTextFinished: () {
                                // if(chatResponse.message == chatBloc)
                              },
                              text: chatResponse.message),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tu peux recréer cette logique sans stateful widget donc on verra dans le futur comment économiser ici.
// Pour l'instant je garde l'animation ça me permet de visualiser la responsivité de la bulle

class TextBox extends StatefulWidget {
  const TextBox(
      {Key? key,
      required this.onTextFinished,
      required this.text,
      this.duration})
      : super(key: key);
  final Function onTextFinished;
  final String text;
  final Duration? duration;

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontSize: 13,
        color: AppColors.primaryText,
      ),
      textAlign: TextAlign.start,
    );
    // return AnimatedTextKit(
    //   totalRepeatCount: 1,
    //   pause: const Duration(milliseconds: 00),
    //   onFinished: () {
    //     widget.onTextFinished();
    //   },
    //   animatedTexts: [
    //     TyperAnimatedText(
    //       widget.text,
    //       speed: const Duration(milliseconds: 40),
    //       textStyle: TextStyle(
    //         fontSize: 13,
    //         color: AppColors.primaryText,
    //       ),
    //       textAlign: TextAlign.start,
    //     ),
    //   ],
    // );
  }
}

// HUMAN CHAT MESSAGE WIDGET :

String _getFormattedDate(DateTime date) {
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  final beforeYesterday = now.subtract(const Duration(days: 2));

  if (date.day == now.day && date.month == now.month && date.year == now.year) {
    return "Aujourd'hui";
  } else if (date.day == yesterday.day &&
      date.month == yesterday.month &&
      date.year == yesterday.year) {
    return "Hier";
  } else if (date.day == beforeYesterday.day &&
      date.month == beforeYesterday.month &&
      date.year == beforeYesterday.year) {
    return "Avant-hier";
  } else {
    return DateFormat('dd MM. yyyy').format(date);
  }
}

String _getFormattedDateWithPretext(DateTime date) {
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  final beforeYesterday = now.subtract(const Duration(days: 2));

  if (date.day == now.day && date.month == now.month && date.year == now.year) {
    return "Envoyé aujourd'hui à ${DateFormat('H:mm').format(date)}";
  } else if (date.day == yesterday.day &&
      date.month == yesterday.month &&
      date.year == yesterday.year) {
    return "Envoyé hier à ${DateFormat('H:mm').format(date)}";
  } else if (date.day == beforeYesterday.day &&
      date.month == beforeYesterday.month &&
      date.year == beforeYesterday.year) {
    return "Envoyé avant-hier à ${DateFormat('H:mm').format(date)}";
  } else {
    return "Envoyé le${DateFormat('dd MM. yyyy').format(date)} à ${DateFormat('H:mm').format(date)}";
  }
}

bool _isDifferentDay(DateTime date1, DateTime date2) {
  return date1.day != date2.day ||
      date1.month != date2.month ||
      date1.year != date2.year;
}

class HumanChatMessageWidget extends StatelessWidget {
  const HumanChatMessageWidget(
      {Key? key, required this.chatBloc, required this.currentIndex})
      : super(key: key);

  final ChatBloc chatBloc;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (currentIndex == 0 ||
            _isDifferentDay(chatBloc.state.messages.reversed.toList()[currentIndex].creationDate,
                chatBloc.state.messages.reversed.toList()[currentIndex - 1].creationDate)) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
              _getFormattedDate(
                  chatBloc.state.messages.reversed.toList()[currentIndex].creationDate),
              style: TextStyle(color: AppColors.secondaryText, fontSize: 12.5),
              textAlign: TextAlign.center,
            ),
          )
        ],
        SizedBox(
          width: 1.sw,
          child: SwipeActionCell(
            //back to white here
            backgroundColor: Colors.transparent,
            openAnimationCurve: Curves.easeInOut,
            openAnimationDuration: 200,
            fullSwipeFactor: 0.2,
            key: key ?? ValueKey(currentIndex.toString()),
            trailingActions: [
              SwipeAction(
                  backgroundRadius: 0.5,
                  widthSpace: 53,
                  content: Material(
                    color: Colors.white,

                    // shape: BoxShape.circle,
                    child: InkWell(
                      onTap: () {
                        FirebaseEngine.logCustomEvent("delete_message_clicked", {});

                        ScaffoldMessenger.of(context).showSnackBar(
                          buildCustomSnackBar(
                            context,
                            "Fonctionnalité disponible prochainement 😉",
                            SnackBarType.info,
                            showCloseIcon: false,
                          ),
                        );},
                      child: Center(
                        child: Image.asset(
                          "assets/icons/trash_red.png",
                          width: 20,
                        ),
                      ),
                    ),
                  ),
                  // performsFirstActionWithFullSwipe: true,
                  style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  onTap: (CompletionHandler handler) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      buildCustomSnackBar(
                        context,
                        "Fonctionnalité disponible prochainement 😉",
                        SnackBarType.info,
                        showCloseIcon: false,
                      ),
                    );},
                  color: Colors.transparent),
              SwipeAction(
                  backgroundRadius: 0.5,
                  widthSpace: 53,
                  content: Material(
                    color: Colors.transparent,
                    // shape: BoxShape.circle,
                    child: InkWell(
                      onTap: () {
                        FirebaseEngine.logCustomEvent("edit_message_clicked", {});

                        ScaffoldMessenger.of(context).showSnackBar(
                      buildCustomSnackBar(
                      context,
                      "Fonctionnalité disponible prochainement 😉",
                      SnackBarType.info,
                      showCloseIcon: false,
                      ),
                      );},
                      child: Center(
                        child: Image.asset(
                          "assets/icons/edit.png",
                          width: 20,
                        ),
                      ),
                    ),
                  ),
                  // performsFirstActionWithFullSwipe: true,
                  style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  onTap: (CompletionHandler handler) async {
                    // list.removeAt(index);
                    // setState(() {});
                  },
                  color: Colors.transparent),
            ],
            child: Padding(
              // /!\ TODO : Etudie pourquoi ici y'avait un soucis et régle ça
              // padding: chatBloc.state.messages.reversed.toList()[currentIndex+1] is HumanChatMessage || (currentIndex != 0 && chatBloc.state.messages.reversed.toList()[currentIndex-1] is HumanChatMessage) ? const EdgeInsets.symmetric(vertical: 1.3, horizontal: 10.0) : const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ContextMenuWidget(
                    mobileMenuWidgetBuilder: DefaultMobileMenuWidgetBuilder(
                        enableBackgroundBlur: true,
                        brightness: Brightness.light),
                    previewBuilder: (context, child) {
                      // Il y'a un peu une boucle ici, tu devrais recréer un flat widget pour ce use case
                      // Et il gérerait aussi la longueur du message donc parfait
                      return Padding(
                        // padding: chatBloc.state.messages.reversed.toList()[currentIndex+1] is HumanChatMessage || (currentIndex != 0 && chatBloc.state.messages.reversed.toList()[currentIndex-1] is HumanChatMessage) ? const EdgeInsets.symmetric(vertical: 1.3, horizontal: 10.0) : const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                constraints: BoxConstraints(
                                    maxWidth: 1.sw * 0.75,
                                    minWidth: 10,
                                    minHeight: 40),
                                margin:
                                    const EdgeInsets.only(left: 5.0, top: 0.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                    colors: [
                                      AppColors
                                          .primaryVar0, // Couleur du bas droit
                                      const Color(0xFF3FBBFF)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (chatBloc.state.messages.reversed.toList()[currentIndex]
                                              as HumanChatMessage)
                                          .message,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 10,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      _getFormattedDateWithPretext(
                                          (chatBloc.state.messages.reversed.toList()[currentIndex]
                                                  as HumanChatMessage)
                                              .creationDate),
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(.7)),
                                      // textAlign: TextAlign.start,
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      );
                    },
                    menuProvider: (_) {
                      return Menu(
                        children: [
                          MenuAction(title: 'Copier', callback: () {
                            FirebaseEngine.logCustomEvent("copy_message_clicked", {});

                          }),
                          MenuSeparator(),
                          MenuAction(title: 'Modifier', callback: () {
                            FirebaseEngine.logCustomEvent("edit_message_clicked", {});

                          }),
                          MenuSeparator(),
                          MenuAction(title: 'Supprimer', callback: () {
                            FirebaseEngine.logCustomEvent("delete_message_clicked", {});

                          }),
                        ],
                      );
                    },
                    child: Container(
                        constraints: BoxConstraints(
                            maxWidth: 1.sw * 0.75, minWidth: 10, minHeight: 40),
                        margin: const EdgeInsets.only(left: 5.0, top: 0.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
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
                          (chatBloc.state.messages.reversed.toList()[currentIndex]
                                  as HumanChatMessage)
                              .message,
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
