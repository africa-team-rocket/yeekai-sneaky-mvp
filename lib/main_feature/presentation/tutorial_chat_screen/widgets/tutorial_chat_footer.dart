import 'dart:io';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/commons/theme/app_colors.dart';
import '../../../../core/presentation/app_global_widgets.dart';

class TutorialChatScreenFooter extends StatefulWidget {
  const TutorialChatScreenFooter({
    Key? key,
    required this.scrollController,
    required this.shouldOpenKeyboard,
  }) : super(key: key);

  final bool shouldOpenKeyboard;
  // On aurait aussi pu écouter l'évènement de l'autre côté mais on va simplement vite, on verra après
  final ScrollController scrollController;

  @override
  State<TutorialChatScreenFooter> createState() =>
      _TutorialChatScreenFooterState();
}

class _TutorialChatScreenFooterState extends State<TutorialChatScreenFooter> {
  String _chatText = "";
  TextEditingController _chatTextController = TextEditingController();
  FocusNode _focusNode = FocusNode();


  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 1));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 1));


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
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding:
            EdgeInsets.only(top: 15.0, bottom: Platform.isIOS ? 23.0 : 15.0),
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
          width: 1.sw * 0.9,
          margin: const EdgeInsets.only(
              left: 15.0, right: 50.0, bottom: 0.0, top: 5.0),
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
                      onTap: () {},
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
