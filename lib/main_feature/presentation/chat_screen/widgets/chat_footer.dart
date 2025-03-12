import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/commons/theme/app_colors.dart';
import '../../../../core/commons/utils/firebase_engine.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/presentation/app_global_widgets.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../chat_screen.dart';

class ChatScreenFooter extends StatefulWidget {
  const ChatScreenFooter(
      {Key? key,
      required this.chatBloc,
      required this.scrollController,
      required this.shouldOpenKeyboard,
      this.initialPrompt, required this.isConnected})
      : super(key: key);

  final ChatBloc chatBloc;
  final bool isConnected;
  final bool shouldOpenKeyboard;
  final InitialPrompt? initialPrompt;
  // On aurait aussi pu écouter l'évènement de l'autre côté mais on va simplement vite, on verra après
  final ScrollController scrollController;

  @override
  State<ChatScreenFooter> createState() => _ChatScreenFooterState();
}

class _ChatScreenFooterState extends State<ChatScreenFooter> {
  String _chatText = "";
  TextEditingController _chatTextController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initialPrompt != null) {
      if (widget.initialPrompt!.shouldSendInitialPrompt) {
        Future.delayed(const Duration(milliseconds: 300), () {
          FirebaseEngine.logCustomEvent("send_ai_message",{"yeeguideId":locator.get<SharedPreferences>().getString("yeeguide_id") ??
          "raruto","message":widget.initialPrompt!.text,"username": locator.get<SharedPreferences>().getString("username") ?? "unknown"});

          widget.chatBloc.add(SendMessageByStream(
              message: widget.initialPrompt!.text,
              yeeguideId:
                  locator.get<SharedPreferences>().getString("yeeguide_id") ??
                      "raruto"));
          // FocusScope.of(context).unfocus();
          _chatTextController.text = "";
          widget.scrollController.animateTo(0.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut);
        });
      } else {
        _chatTextController.text = widget.initialPrompt!.text;
      }
    }
    if (widget.shouldOpenKeyboard) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _focusNode.requestFocus();
      });
    }
    _chatTextController.addListener(() {
      setState(() {
        _chatText = _chatTextController.text;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(

        padding:
            EdgeInsets.only(top: 15.0, bottom: 15.0 + MediaQuery.of(context).padding.bottom),
        margin: const EdgeInsets.only(top: 0),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, -2),
              color: Colors.grey.withOpacity(.15))
        ]),
        child: Container(
          // height: 55,
          // height: 100,
          width: 1.sw,
          margin: const EdgeInsets.only(
              left: 15.0, right: 15.0, bottom: 0.0, top: 5.0),
          padding: const EdgeInsets.only(left: 0.0, right: 9.0, bottom: 0.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              // color: AppColors.primaryText.withOpacity(.7)),
              color: AppColors.secondaryText.withOpacity(.14)),
          child: Hero(
            tag: "chat-footer",
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        FirebaseEngine.logCustomEvent("send_photos_message_clicked", {});

                      },
                      child: SizedBox(
                        height: 55,
                        width: 47,
                        child: Center(
                          child: Image.asset(
                            "assets/icons/camera.png",
                            width: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    // width: 1.sw * 0.64,
                    // height: 190,
                    child: TextField(
                      focusNode: _focusNode,
                      cursorErrorColor: Colors.blue,
                      // readOnly: true,
                      enableSuggestions: true,
                      controller: _chatTextController,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primaryText,
                        overflow: TextOverflow.ellipsis,
                      ),
                      decoration: const InputDecoration(
                        // fillColor: Colors.red,
                        border: InputBorder.none,
                        hintText: "Posez une question...",
                        labelStyle: TextStyle(fontWeight: FontWeight.normal),
                        hintStyle: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      cursorColor: AppColors.primaryVar0,
                      showCursor: true,
                      maxLines: 4,
                      minLines: 1,
                    ),
                  ),
                  Container(
                    height: 44,
                    width: 46,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                        color: Colors.grey.withOpacity(.25),
                      )
                    ]),
                    child: Material(
                      color: AppColors.primaryVar0,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {



                          if (_chatText.isEmpty) {
                            //TODO: Check if we need this feature
                            //While this feature is unavailable
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(
                                context,
                                "Fonctionnalité disponible prochainement 😉",
                                SnackBarType.info,
                                showCloseIcon: false,
                              ),
                            );
                          }

                          if (!widget.chatBloc.state.isAITyping &&
                              _chatTextController.text.isNotEmpty) {

                            if(widget.isConnected == false){
                              ScaffoldMessenger.of(context).showSnackBar(
                                buildCustomSnackBar(
                                  context,
                                  "Pas connecté à internet",
                                  SnackBarType.info,
                                  showCloseIcon: false,
                                ),
                              );
                              return;
                            }

                            FirebaseEngine.logCustomEvent("send_ai_message",{"yeeguideId":locator.get<SharedPreferences>().getString("yeeguide_id") ??
                                "raruto","message": _chatText,"username": locator.get<SharedPreferences>().getString("username") ?? "unknown"});

                            widget.chatBloc.add(SendMessageByStream(
                                message: _chatText,
                                yeeguideId: locator
                                        .get<SharedPreferences>()
                                        .getString("yeeguide_id") ??
                                    "raruto"));
                            FocusScope.of(context).unfocus();
                            _chatTextController.text = "";
                            Future.delayed(const Duration(milliseconds: 400),
                                () {
                              widget.scrollController.animateTo(0.0,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut);
                            });
                          } else {
                            FirebaseEngine.logCustomEvent("mic_unavailable_usecase",{});
                            debugPrint("Pas encore d'audio/Attend qu'il aie fini de parler");
                          }
                        },
                        child: SizedBox(
                          height: 55,
                          width: 47,
                          child: Center(
                            child: Image.asset(
                              _chatText.isEmpty
                                  ? "assets/icons/mic_bold.png"
                                  : "assets/icons/direction.png",
                              width: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 43,
                  //   height: 42,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       // Ajoutez la logique que vous souhaitez exécuter lorsque le bouton est pressé
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: AppColors
                  //           .primaryVar0, // Couleur de fond du bouton
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius:
                  //         BorderRadius.circular(
                  //             10), // Bordure du bouton
                  //       ),
                  //       // minimumSize: const Size(50,
                  //       //     50),
                  //       minimumSize: const Size(90,90)// Taille minimale du bouton
                  //     ),
                  //     child: Stack(
                  //       children: [Image.asset(
                  //         // "assets/icons/direction.png",
                  //         "assets/icons/mic_bold.png",
                  //         width: 70,
                  //         height: 70,
                  //       ),]
                  //     ),
                  //   ),
                  // ),
                  // Image.asset(
                  //   // "assets/icons/direction.png",
                  //   "assets/icons/mic_bold.png",
                  //   width: 70,
                  //   height: 70,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
