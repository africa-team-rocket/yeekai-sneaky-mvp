import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/commons/theme/app_colors.dart';
import '../../../../core/commons/utils/app_constants.dart';
import '../../../../core/domain/models/chatbot_conversation.dart';
import '../../tutorial_chat_screen/tutorial_chat_screen.dart';

class IntroMessageOnboarding extends StatefulWidget {
  const IntroMessageOnboarding({
    Key? key,
    required this.chatResponse,
    this.image,
    this.onFinished,
  }) : super(key: key);

  final ChatResponse chatResponse;
  final Function? onFinished;
  final String? image;

  @override
  State<IntroMessageOnboarding> createState() => _IntroMessageOnboardingState();
}

class _IntroMessageOnboardingState extends State<IntroMessageOnboarding> {
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
      flex: 16,
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
                child: IntroMessageBubbleOnboarding(
                  animationLevel: 1,
                  isFirst: index == 0,
                  text: widget.chatResponse.text[index],
                  isTypingChecker: index == 0 ? isTyping : false,
                  onTextFinished: () {
                    debugPrint("The index : $index");
                    // debugPrint("The index : ${widget.chatMessages.length}");
                    // if(currentIndex < widget.chatMessages.length - 1)
                    //   currentIndex++;

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
                        if (widget.onFinished != null) {
                          widget.onFinished!();
                        }
                      }
                    }
                  },
                ),
              ),
            if (widget.image != null) ...[
              AnimatedSizeAndFade.showHide(
                show: !isTyping && widget.image != null,
                fadeDuration: const Duration(milliseconds: 700),
                sizeDuration: const Duration(milliseconds: 700),
                child: Container(
                    constraints: BoxConstraints(
                        maxWidth: AppConstants.screenWidth,
                        minWidth: 10,
                        minHeight: 40),
                    // width: 1.sw,
                    margin: const EdgeInsets.only(left: 10.0, top: 5.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryText.withOpacity(.1),
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:
                        // isTypingChecker ?
                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 5),
                        //   child: SizedBox(
                        //     width: 22,
                        //     child: Lottie.asset('assets/animations/typing.json'),
                        //   ),
                        // )
                        //     :
                        Container(
                      width: 1.sw,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: AssetImage(widget.image!),
                            fit: BoxFit.none,
                            scale: 6.0),
                      ),
                    )),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class IntroMessageBubbleOnboarding extends StatelessWidget {
  const IntroMessageBubbleOnboarding({
    super.key,
    required this.animationLevel,
    required this.text,
    required this.onTextFinished,
    required this.isTypingChecker,
    required this.isFirst,
  });

  final String text;
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
              constraints: BoxConstraints(
                  maxWidth: AppConstants.screenWidth,
                  minWidth: 10,
                  minHeight: 40),
              // width: 1.sw,
              margin: const EdgeInsets.only(left: 10.0, top: 5.0),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.secondaryText.withOpacity(.1),
                // color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child:
                  // isTypingChecker ?
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 5),
                  //   child: SizedBox(
                  //     width: 22,
                  //     child: Lottie.asset('assets/animations/typing.json'),
                  //   ),
                  // )
                  //     :
                  IntroMessageTextBox(
                onTextFinished: onTextFinished,
                text: text,
                isFirst: isFirst,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tu peux recréer cette logique sans stateful widget donc on verra dans le futur comment économiser ici.

class IntroMessageTextBox extends StatefulWidget {
  const IntroMessageTextBox({
    Key? key,
    required this.onTextFinished,
    required this.text,
    this.duration,
    required this.isFirst,
  }) : super(key: key);
  final Function onTextFinished;
  final String text;
  final bool isFirst;
  final Duration? duration;

  @override
  State<IntroMessageTextBox> createState() => _IntroMessageTextBoxState();
}

class _IntroMessageTextBoxState extends State<IntroMessageTextBox> {
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
                    ? remplacerNomDansPhrase(widget.text, "cher utilisateur")
                    : widget.text,
                speed: const Duration(milliseconds: 10),
                textStyle: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryText,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          )
        : const SizedBox();
  }
}
