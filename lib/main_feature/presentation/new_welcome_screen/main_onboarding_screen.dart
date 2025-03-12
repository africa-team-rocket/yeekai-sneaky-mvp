import 'dart:math';

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_hero/local_hero.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:yeebus_filthy_mvp/main_feature/presentation/new_welcome_screen/widgets/human_message_widget.dart';
import 'package:yeebus_filthy_mvp/main_feature/presentation/new_welcome_screen/widgets/intro_message_onboarding.dart';

import '../../../core/commons/theme/app_colors.dart';
import '../../../core/commons/utils/custom_elastic_curve.dart';
import '../../../core/commons/utils/firebase_engine.dart';
import '../../../core/domain/models/chatbot_conversation.dart';
import 'choose_yeeguide_screen.dart';
import 'new_welcome_screen.dart';

class MainOnboardingScreen extends StatefulWidget {
  const MainOnboardingScreen({super.key});

  @override
  State<MainOnboardingScreen> createState() => _MainOnboardingScreenState();
}

class _MainOnboardingScreenState extends State<MainOnboardingScreen> {
  double animationLevel = 0;

  List<String> placeholderQuestions = [
    "Mme Rita est-elle dans son bureau ?",
    "J’ai perdu ma carte d’étudiant, que faire ?",
    "Est-ce qu'il y a des carapides qui vont à Sahm ?",
    "C’est quoi le menu du restaurant aujourd’hui ?",
    "Je suis nouveau à Dakar, quels sont les moyens de transports les plus adaptés ?",
    "Il arrive quand le bus de la ligne 7 ?"
  ];

  @override
  void initState() {
    super.initState();
    FirebaseEngine.startOnboardingTracking();
    debugPrint(
        "Screen width and height : " + 1.sw.toString() + " " + 1.sh.toString());
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));

    setState(() {
      animationLevel = 0.5;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      animationLevel = 1;
    });
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      animationLevel = 2;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    _continueAnimation();
  }

  Future<void> _continueAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      animationLevel = 3;
    });

    await Future.delayed(const Duration(milliseconds: 1400));

    setState(() {
      animationLevel = 3.5;
    });

    // await Future.delayed(const Duration(milliseconds: 1500));

    // setState(() {
    //   animationLevel = 4;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.transparent,

        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          constraints: const BoxConstraints(maxHeight: 75, minHeight: 55),
          // color: Colors.blue,
          height: 150,
          
          width: 1.sw,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          padding: EdgeInsets.only(bottom: 15.0),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: animationLevel >= 3.9 ? 1.0 : 0,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 140, minHeight: 55),
              // color: Colors.blue,
              height: 65,
              width: 1.sw,
              // padding: EdgeInsets.only(bottom: 10.0),

              child: ElevatedButton(
                onPressed: () {
                  if (animationLevel < 3.9) {
                  } else {
                    if (animationLevel == 3.9) {
                      debugPrint("Pressed step 2");
                      FirebaseEngine.logOnboardingNextPressed(2);
                      setState(() {
                        animationLevel = 4;
                      });
                    } else if (animationLevel < 5) {
                      debugPrint("Pressed step 3");
                      FirebaseEngine.logOnboardingNextPressed(3);
                      setState(() {
                        animationLevel = 5;
                      });
                    } else if (animationLevel == 5) {
                      debugPrint("Pressed step 4");
                      FirebaseEngine.logOnboardingNextPressed(4);
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              duration: const Duration(milliseconds: 500),
                              child: ChooseYeeguideScreen()));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryText,
                  surfaceTintColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20), // Ajustez la valeur pour le border radius souhaité
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16), // Espacement intérieur pour le bouton
                  minimumSize: const Size(double.infinity,
                      55), // Pour que le bouton prenne toute la largeur de l'écran
                ),
                child: Text(
                  animationLevel < 4.0
                      ? "Suivant ➡️"
                      : animationLevel < 5.0
                          ? "Suivant ➡️"
                          : "Je veux un yeeguide 🙂",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        
        body: SingleChildScrollView(
          child: SizedBox(
            width: 1.sw,
            height: 1.sh,
            child: Stack(
              children: [
                Positioned(
                  bottom: -25,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: animationLevel >= 0.5 ? 1.0 : 0.0,
                    child: Container(
                      width: 1.sw,
                      height: 160,
                      padding: EdgeInsets.only(top: 5),
                      // color: Colors.red,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 10,
                            left: -20,
                            child: SizedBox(
                              width: 2.sw,
                              height: 80,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: placeholderQuestions.length,
                                itemBuilder: (context, index) {
                                  MainAxisAlignment alignment = index.isEven
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end;

                                  return PlaceholderMessageWidget(
                                    text: placeholderQuestions[index],
                                    rotation: index.isEven
                                        ? degToRad(0.5)
                                        : degToRad(-0.5),
                                    mainAxis: alignment,
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -20,
                            left: 0,
                            child: SizedBox(
                              width: 2.sw,
                              height: 80,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: placeholderQuestions.length,
                                itemBuilder: (context, index) {
                                  Random().nextDouble() * 10 - 5;
                                  MainAxisAlignment alignment = index.isEven
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end;

                                  return PlaceholderMessageWidget(
                                    text: placeholderQuestions[index],
                                    rotation: index.isEven
                                        ? degToRad(0.5)
                                        : degToRad(-0.5),
                                    mainAxis: alignment,
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: -50,
                            child: SizedBox(
                              width: 2.sw,
                              height: 80,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: placeholderQuestions.length,
                                itemBuilder: (context, index) {
                                  MainAxisAlignment alignment = index.isEven
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end;

                                  return PlaceholderMessageWidget(
                                    text: placeholderQuestions[index],
                                    rotation: index.isEven
                                        ? degToRad(0.5)
                                        : degToRad(-0.5),
                                    mainAxis: alignment,
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 40,
                            left: 0,
                            child: SizedBox(
                              width: 2.sw,
                              height: 80,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: placeholderQuestions.length,
                                itemBuilder: (context, index) {
                                  MainAxisAlignment alignment = index.isEven
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end;

                                  return PlaceholderMessageWidget(
                                    text: placeholderQuestions[index],
                                    rotation: index.isEven
                                        ? degToRad(0.5)
                                        : degToRad(-0.5),
                                    mainAxis: alignment,
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: -5,
                            left: -60,
                            child: SizedBox(
                              width: 2.sw,
                              height: 80,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: placeholderQuestions.length,
                                itemBuilder: (context, index) {
                                  MainAxisAlignment alignment = index.isEven
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end;

                                  return PlaceholderMessageWidget(
                                    text: placeholderQuestions[index],
                                    rotation: index.isEven
                                        ? degToRad(0.5)
                                        : degToRad(-0.5),
                                    mainAxis: alignment,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     padding: EdgeInsets.symmetric(horizontal: 20.0),
                //     // color: Colors.red,
                //     width: 1.sw,
                //     height: 1.sh * 0.75,
                //     child: Column(children: [
                //       PlaceholderMessageWidget(
                //           text:
                //               "Où puis-je trouver des tiak tiak à proximité ?",
                //           rotation: animationLevel == 3 ? 0 : degToRad(-0.5),
                //           mainAxis: MainAxisAlignment.end),
                //       const SizedBox(
                //         height: 15,
                //       )
                //     ]),
                //   ),
                // ),

                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10 + MediaQuery.of(context).padding.top,
                          width: 1.sw,
                        ),
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 300),
                          opacity: animationLevel >= 1 ? 1 : 0,
                          child: Text(
                            "Sauf avec Yeekai !",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 23,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 600),
                          opacity: animationLevel >= 2 ? 1 : 0,
                          child:  Text(
                            "Car ton yeeguide répond à toutes tes questions sur le campus",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 14,
                            ),
                          ),
                          // AnimatedTextKit(
                          //   repeatForever: false,
                          //
                          //   // pause: const Duration(milliseconds: 200),
                          //   animatedTexts: [
                          //     FadeAnimatedText(
                          //       "Car ton yeeguide répond à toutes tes questions sur le campus",
                          //       textAlign: TextAlign.start,
                          //       textStyle: TextStyle(
                          //         color: AppColors.primaryText,
                          //         fontSize: 14,
                          //       ),
                          //       duration: Duration(milliseconds: 1000)
                          //       // speed: const Duration(milliseconds: 40),
                          //     ),
                          //   ],
                          //   onFinished: () {
                          //     _continueAnimation();
                          //   },
                          //   totalRepeatCount: 1,
                          //
                          //   // totalRepeatCount: 4,
                          //   // pause: const Duration(milliseconds: 1000),
                          //   displayFullTextOnTap: true,
                          //   stopPauseOnTap: true,
                        ),

                        if (animationLevel >= 2) ...[
                          // Text(
                          //   "Car ton yeeguide répond à toutes tes questions sur le campus",
                          //   textAlign: TextAlign.start,
                          //   style: TextStyle(
                          //     color: AppColors.primaryText,
                          //     fontSize: 14,
                          //   ),
                          // ),
                        ]
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 1.sh * 0.15,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 1.sw * 0.09999),
                    width: 1.sw,
                    height: 1.sh * 0.5,
                    // color: Colors.red,
                    child: Column(
                      children: [
                        if (animationLevel == 3.5 || animationLevel == 3.9) ...[
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity:
                                animationLevel == 3.5 || animationLevel == 3.9
                                    ? 1.0
                                    : 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 59,
                                  child: Image.asset(
                                    "assets/yeeguides/rita_guide.png",
                                    height: 43,
                                    width: 43,
                                  ),
                                ),
                                IntroMessageOnboarding(
                                  image: "assets/images/map_mockup.png",
                                  onFinished: () {
                                    // await Future.delayed(
                                    //     const Duration(milliseconds: 200));

                                    setState(() {
                                      animationLevel = 3.9;
                                    });
                                  },
                                  chatResponse: ChatResponse(
                                    text: [
                                      "Voici le bureau de Mme Marthe :"
                                    ],
                                    nextSteps: [],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (animationLevel == 4.0 ||
                            animationLevel == 4.5 ||
                            animationLevel == 4.9) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 59,
                                child: Image.asset(
                                  "assets/yeeguides/rita_guide.png",
                                  height: 43,
                                  width: 43,
                                ),
                              ),
                              IntroMessageOnboarding(
                                onFinished: () {
                                  // await Future.delayed(
                                  //     const Duration(milliseconds: 200));
                                },
                                chatResponse: ChatResponse(
                                  text: [
                                    "Facile ! Il te suffit de demander un duplicata chez Mme Barro.",
                                    "Elle y sera entre 8h et 13h demain !"
                                  ],
                                  nextSteps: [],
                                ),
                              ),
                            ],
                          ),
                        ] else if (animationLevel == 5.0) ...[
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity: animationLevel >= 5.0 ? 1.0 : 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 58,
                                  child: Image.asset(
                                    "assets/yeeguides/rita_guide.png",
                                    height: 43,
                                    width: 43,
                                  ),
                                ),
                                IntroMessageOnboarding(
                                  onFinished: () {
                                    // await Future.delayed(
                                    //     const Duration(milliseconds: 200));
                                  },
                                  chatResponse: ChatResponse(
                                    text: [
                                      "Facile, tu peux prendre le 49 jusqu'à Sacré-Coeur puis le BRT.",
                                      "Il va te déposer juste devant l'ESMT, tu veux plus d'infos ?"
                                    ],
                                    nextSteps: [],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1000),
                  bottom: animationLevel < 3.0 || animationLevel > 3.9
                      ? 55
                      : 1.sh * 0.65,
                  right: animationLevel < 3.0 || animationLevel > 3.9
                      ? 20.0
                      : -1.sw * 0.36,
                  // left: animationLevel < 3.0 || animationLevel > 3.9 ? -25 : null,
                  // top: animationLevel < 3.0 || animationLevel > 3.9 ? 1.sh : 1.sh * 0.25,
                  curve: CustomElasticOutCurve(),
                  child: Hero(
                    tag: "question-1",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text: "C’est où le bureau de Mme Marthe ?",
                        rotation: animationLevel < 3.0 || animationLevel > 3.9
                            ? degToRad(-0.5)
                            : 0,
                        mainAxis: MainAxisAlignment.start,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1000),
                  bottom: animationLevel != 4 ? 10 : 1.sh * 0.65,
                  right: animationLevel != 4 ? -12 : 3.0,
                  curve: CustomElasticOutCurve(),
                  child: Hero(
                    tag: "question-2",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text: "J’ai perdu ma carte d’étudiant, que faire ?",
                        rotation:
                            animationLevel != 4 ? degToRad(1) : degToRad(0),
                        mainAxis: MainAxisAlignment.end,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1000),
                  bottom: -17,
                  right: -15,
                  curve: CustomElasticOutCurve(),
                  child: Hero(
                    tag: "question-3",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text:
                            "Il arrive quand le bus 7 ? J'attend depuis 20 minutes..",
                        rotation: degToRad(1),
                        mainAxis: MainAxisAlignment.end,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1000),
                  bottom: 70,
                  left: -17,
                  curve: CustomElasticOutCurve(),
                  child: Hero(
                    tag: "question-4",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text:
                            "C’est quoi le menu du resto aujourd’hui ?",
                        rotation: degToRad(-0.5),
                        mainAxis: MainAxisAlignment.start,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1000),
                  bottom: -20,
                  left: -15,
                  curve: CustomElasticOutCurve(),
                  child: Hero(
                    tag: "question-5",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text:
                            "Le resto est fermé actuellement, quelles sont mes autres options autour du campus ?",
                        rotation: degToRad(-0.5),
                        mainAxis: MainAxisAlignment.start,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1000),
                  bottom: animationLevel != 5 ? 40 : 1.sh * 0.65,
                  right: animationLevel != 5 ? 20 : -1.sw * 0.36,
                  curve: CustomElasticOutCurve(),
                  child: Hero(
                    tag: "question-6",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text: "Je suis nouveau à Dakar, comment aller à l'ESMT depuis Ouakam ?",
                        rotation: animationLevel != 5
                            ? degToRad(-0.5)
                            : degToRad(0.0),
                        mainAxis: MainAxisAlignment.start,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1000),
                  bottom: 55,
                  right: -15,
                  curve: CustomElasticOutCurve(),
                  child: Hero(
                    tag: "question-7",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text:
                            "Je suis nouveau à Dakar, quels sont les moyens de transports les plus adaptés ?",
                        rotation: 4,
                        mainAxis: MainAxisAlignment.end,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1000),
                  bottom: 3,
                  right: 0,
                  curve: CustomElasticOutCurve(),
                  child: Hero(
                    tag: "question-8",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text:
                            "Mme Rita est-elle dans son bureau ? J'aimerais demander un duplicata pour mon bulletin du second semestre",
                        rotation: -3,
                        mainAxis: MainAxisAlignment.end,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
