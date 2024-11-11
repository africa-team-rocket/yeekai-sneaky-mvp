import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/commons/theme/app_colors.dart';

class HumanMessageWidget extends StatelessWidget {
  final String text;

  final double rotation;
  final MainAxisAlignment mainAxis;
  const HumanMessageWidget({
    Key? key,
    required this.text,
    required this.rotation,
    required this.mainAxis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      duration: Duration(milliseconds: 300),
      // angle: rotation,
      turns: rotation,
      child: SizedBox(
        width: 1.sw,
        child: Padding(
          // /!\ TODO : Etudie pourquoi ici y'avait un soucis et régle ça
          // padding: chatBloc.state.messages[currentIndex+1] is HumanChatMessage || (currentIndex != 0 && chatBloc.state.messages[currentIndex-1] is HumanChatMessage) ? const EdgeInsets.symmetric(vertical: 1.3, horizontal: 10.0) : const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: mainAxis,
            children: [
              Container(
                  constraints: BoxConstraints(
                      maxWidth: 240, minWidth: 10, minHeight: 40),
                  width: 1.sw * 0.55,
                  margin: const EdgeInsets.only(left: 5.0, top: 0.0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                          color: Colors.black.withOpacity(.1))
                    ],
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
                    text,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceholderMessageWidget extends StatelessWidget {
  final String text;

  final double rotation;
  final MainAxisAlignment mainAxis;
  const PlaceholderMessageWidget({
    Key? key,
    required this.text,
    required this.rotation,
    required this.mainAxis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      duration: Duration(milliseconds: 300),
      // angle: rotation,
      turns: rotation,
      child: Padding(
        // /!\ TODO : Etudie pourquoi ici y'avait un soucis et régle ça
        // padding: chatBloc.state.messages[currentIndex+1] is HumanChatMessage || (currentIndex != 0 && chatBloc.state.messages[currentIndex-1] is HumanChatMessage) ? const EdgeInsets.symmetric(vertical: 1.3, horizontal: 10.0) : const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 0.0),
        child: Row(
          mainAxisAlignment: mainAxis,
          children: [
            Container(
                constraints:
                    BoxConstraints(maxWidth: 240, minWidth: 10, minHeight: 40),
                width: 1.sw * 0.55,
                margin: const EdgeInsets.only(left: 0.0, top: 0.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                        color: Colors.black.withOpacity(.1))
                  ],
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
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                )),
          ],
        ),
      ),
    );
  }
}
