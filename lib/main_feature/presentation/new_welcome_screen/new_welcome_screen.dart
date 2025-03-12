import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif/gif.dart';
import 'dart:math' as math;
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:yeebus_filthy_mvp/main_feature/presentation/new_welcome_screen/widgets/human_message_widget.dart';

import '../../../core/commons/theme/app_colors.dart';
import '../../../core/commons/utils/custom_elastic_curve.dart';
import '../../../core/commons/utils/firebase_engine.dart';
import 'main_onboarding_screen.dart';

class NewWelcomeScreen extends StatefulWidget {
  const NewWelcomeScreen({super.key});

  @override
  State<NewWelcomeScreen> createState() => _NewWelcomeScreenState();
}

double degToRad(double deg) {
  return deg * math.pi / 180;
}

class _NewWelcomeScreenState extends State<NewWelcomeScreen>
    with SingleTickerProviderStateMixin {
  double animationLevel = 0;
  late final GifController _controller;

  @override
  void initState() {
    super.initState();
    FirebaseEngine.startOnboardingTracking();
    _controller = GifController(vsync: this);
    debugPrint(
        "Screen width and height : " + 1.sw.toString() + " " + 1.sh.toString());
    // _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      animationLevel = 1;
    });
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      animationLevel = 2;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      animationLevel = 3;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      animationLevel = 4;
    });
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
            opacity: animationLevel >= 4 ? 1.0 : 0,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 140, minHeight: 55),
              // color: Colors.blue,
              height: 65,
              width: 1.sw,
              // padding: EdgeInsets.only(bottom: 10.0),

              child: ElevatedButton(
                onPressed: () {
                  FirebaseEngine.logOnboardingNextPressed(1);
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          duration: const Duration(milliseconds: 500),
                          child: MainOnboardingScreen()));
                },
                style: ElevatedButton.styleFrom(
                  surfaceTintColor: Colors.blue,

                  backgroundColor: AppColors.primaryText,
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
                  "Suivant ➡️",
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
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1600),
                  curve: CustomElasticOutCurve(),
                  top: ((animationLevel < 3 ? -60 : 65) +
                      (1.sh >= 784 ? (1.sh * 0.12) : 0)),
                  // Breakpoint à 500 dpi (environ)
                  right: ((animationLevel < 3 ? 1.sw : 27) -
                      (1.sh >= 1080 ? (1.sw * 0.1) : 0)),
                  child: Hero(
                    tag: "question-1",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text: "La bibliothèque est-elle ouverte ?",
                        rotation: degToRad(0.5),
                        mainAxis: MainAxisAlignment.start,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1500),
                  curve: CustomElasticOutCurve(),
                  // Breakpoint à 400 dpi (environ)

                  top: ((animationLevel < 3 ? -75 : 65) +
                      (1.sh >= 784 ? (1.sh * 0.12) : 0)),
                  left: ((animationLevel < 3 ? 1.sw : 45) -
                      (1.sh >= 1080 ? (1.sw * 0.1) : 0)),
                  child: Hero(
                    tag: "question-2",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text: "Mme Rita est-elle dans son bureau ?",
                        rotation: degToRad(-0.5),
                        mainAxis: MainAxisAlignment.end,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1500),
                  curve: CustomElasticOutCurve(),
                  top: ((animationLevel < 3 ? -60 : 185) +
                      (1.sh >= 784 ? (1.sh * 0.12) : 0)),
                  right: ((animationLevel < 3 ? 1.sw : 27) -
                      (1.sh >= 1080 ? (1.sw * 0.1) : 0)),
                  child: Hero(
                    tag: "question-3",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text:
                            "C’est où le bureau de Mme Marte ?",
                        rotation: degToRad(0.5),
                        mainAxis: MainAxisAlignment.start,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1600),
                  curve: CustomElasticOutCurve(),
                  top: ((animationLevel < 3 ? -85 : 185) +
                      (1.sh >= 784 ? (1.sh * 0.12) : 0)),
                  left: ((animationLevel < 3 ? 1.sw : 50) -
                      (1.sh >= 1080 ? (1.sw * 0.1) : 0)),
                  child: Hero(
                    tag: "question-4",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text:
                            "J’ai perdu ma carte d’étudiant, que faire ?",
                        rotation: degToRad(-0.5),
                        mainAxis: MainAxisAlignment.end,
                      ),
                    ),
                  ),
                ),
                // LOWER BOTTOM
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1700),
                  curve: CustomElasticOutCurve(),
                  bottom: ((animationLevel < 3
                          ? -60
                          : 1.sh >= 610
                              ? 80
                              : 75) +
                      (1.sh >= 784 ? (1.sh * 0.12) : 0)),
                  right: ((animationLevel < 3 ? 1.sw : 27) -
                      (1.sh >= 1080 ? (1.sw * 0.1) : 0)),
                  child: Hero(
                    tag: "question-5",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text: "Où se trouve la salle HB6 ?",
                        rotation: degToRad(-0.5),
                        mainAxis: MainAxisAlignment.start,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1600),
                  curve: CustomElasticOutCurve(),
                  bottom: ((animationLevel < 3
                          ? -80
                          : 1.sh >= 610
                              ? 80
                              : 75) +
                      (1.sh >= 784 ? (1.sh * 0.12) : 0)),
                  left: ((animationLevel < 3 ? 1.sw : 45) -
                      (1.sh >= 1080 ? (1.sw * 0.1) : 0)),
                  child: Hero(
                    tag: "question-6",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text: "Quelle classé a gagné le championnat de foot ?",
                        rotation: degToRad(0.5),
                        mainAxis: MainAxisAlignment.end,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1500),
                  curve: CustomElasticOutCurve(),
                  bottom: ((animationLevel < 3
                          ? -60
                          : 1.sh >= 610
                              ? 180
                              : 170) +
                      (1.sh >= 784 ? (1.sh * 0.12) : 0)),
                  right: ((animationLevel < 3 ? 1.sw : 27) -
                      (1.sh >= 1080 ? (1.sw * 0.1) : 0)),
                  child: Hero(
                    tag: "question-7",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text: "C’est quoi le menu du restaurant aujourd’hui ?",
                        rotation: degToRad(-0.5),
                        mainAxis: MainAxisAlignment.start,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1500),
                  curve: CustomElasticOutCurve(),
                  bottom: ((animationLevel < 3
                          ? -75
                          : 1.sh >= 610
                              ? 180
                              : 170) +
                      (1.sh >= 784 ? (1.sh * 0.12) : 0)),
                  left: ((animationLevel < 3 ? 1.sw : 50) -
                      (1.sh >= 1080 ? (1.sw * 0.1) : 0)),
                  child: Hero(
                    tag: "question-8",
                    child: Material(
                      color: Colors.transparent,
                      child: HumanMessageWidget(
                        text: "Il arrive quand le bus de la ligne 7 ?",
                        rotation: degToRad(0.5),
                        mainAxis: MainAxisAlignment.end,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: animationLevel >= 2 ? 1 : 0,
                    child: Text(
                      "Être étudiant à l'ESMT, \n c'est pas évident..",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                AnimatedAlign(
                  duration: Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                  alignment: animationLevel == 0
                      ? Alignment.center
                      : Alignment.bottomCenter,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: animationLevel >= 1 ? 0 : 1,
                    child: SizedBox(
                      width: 230,
                      child:
                          // Lottie.asset('assets/animations/yeelogo.json',
                          //     frameRate: FrameRate.max,
                          //     repeat: false,
                          //     onLoaded: (LottieComposition comp) => {}),
                          Gif(
                        // fps: 50,
                        duration: Duration(milliseconds: 1000),
                        image: AssetImage("assets/animations/yeelogo.gif"),
                        controller:
                            _controller, // if duration and fps is null, original gif fps will be used.
                        //fps: 30,
                        //duration: const Duration(seconds: 3),
                        autostart: Autostart.no,
                        placeholder: (context) => SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset(
                            "assets/icons/yeebus_flat_logo.png",
                          ),
                        ),
                        onFetchCompleted: () {
                          _controller.reset();
                          _controller
                              .forward()
                              .then((value) => {_startAnimation()});
                        },
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
