import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:yeebus_filthy_mvp/main_feature/presentation/new_welcome_screen/widgets/yeeguides_snap_list.dart';

import '../../../core/commons/theme/app_colors.dart';
import '../../../core/commons/utils/app_constants.dart';
import 'confirm_yeeguide_screen.dart';

class ChooseYeeguideScreen extends StatefulWidget {
  const ChooseYeeguideScreen({super.key});

  @override
  State<ChooseYeeguideScreen> createState() => _ChooseYeeguideScreenState();
}

class _ChooseYeeguideScreenState extends State<ChooseYeeguideScreen> {
  double animationLevel = 0;
  int selectedYeeguide = 5;

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
          child: Container(
            constraints: const BoxConstraints(maxHeight: 140, minHeight: 55),
            // color: Colors.blue,
            height: 65,
            width: 1.sw,
            // padding: EdgeInsets.only(bottom: 10.0),

            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        duration: const Duration(milliseconds: 500),
                        child: ConfirmYeeguideScreen(
                          selectedIndex: selectedYeeguide,
                        )));
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
                "Sélectionner 🎯",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: SizedBox(
            width: 1.sw,
            height: 1.sh,
            child: Column(
              children: [
                SizedBox(
                  height: 10 + MediaQuery.of(context).padding.top,
                  width: 1.sw,
                ),
                SizedBox(
                  height: 70,
                  width: 1.sw,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Choisis ton yeeguide",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 1.sw > 340.0 ? 22 : 19,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Chaque guide est spécialisé dans un domaine différent pour t’aider.",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 1.sw > 340.0 ? 13.5 : 11.5,
                          ),
                        ),
                        // if (animationLevel >= 1) ...[
                        //   AnimatedTextKit(
                        //     repeatForever: false,
                        //
                        //     pause: const Duration(milliseconds: 200),
                        //     animatedTexts: [
                        //       TyperAnimatedText(
                        //         "Chaque guide est spécialisé dans un domaine différent pour t’aider.",
                        //         textAlign: TextAlign.start,
                        //         textStyle: TextStyle(
                        //           color: AppColors.primaryText,
                        //           fontSize: 1.sw > 340.0 ? 13.5 : 11.5,
                        //         ),
                        //         speed: const Duration(milliseconds: 30),
                        //       ),
                        //     ],
                        //     onFinished: () {
                        //       _continueAnimation();
                        //     },
                        //     totalRepeatCount: 1,
                        //
                        //     // totalRepeatCount: 4,
                        //     // pause: const Duration(milliseconds: 1000),
                        //     displayFullTextOnTap: true,
                        //     stopPauseOnTap: true,
                        //   ),
                        // ]
                      ],
                    ),
                  ),
                ),
                if (1.sw >= 400) ...[
                  SizedBox(
                    height: 1.sh * 0.15,
                  ),
                ] else if(1.sw >= 390)...[
                  SizedBox(
                    height: 40,
                  ),
                ],
                Stack(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: YeeguidesSnapList(onSelectedYeeguide: (index) {
                          setState(() {
                            selectedYeeguide = index;
                          });
                        }, onTapYeeguide: (index) {

                          if(index == selectedYeeguide) {
                            if (AppConstants.availableYeeguides.contains(
                                AppConstants.yeeguidesList[index].id)) {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      duration: const Duration(
                                          milliseconds: 500),
                                      child: ConfirmYeeguideScreen(
                                        selectedIndex: index,
                                      )));
                            } else {
                              setState(() {
                                selectedYeeguide = index;
                              });
                            }
                          }
                        })),
                    Positioned(
                      right: 0,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: animationLevel >= 2 && selectedYeeguide != 2
                            ? 1.0
                            : 0.0,
                        child: SizedBox(
                          width: 62,
                          child:
                              Lottie.asset('assets/animations/swipe_left.json'),
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    debugPrint(
        "Screen width and height : " + 1.sw.toString() + " " + 1.sh.toString());
    _startAnimation();
  }

  Future<void> _continueAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      animationLevel = 2;
    });
  }

  Future<void> _startAnimation() async {
    // await Future.delayed(const Duration(milliseconds: 200));

    // setState(() {
    //   animationLevel = 0.5;
    // });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      animationLevel = 1;
    });
  }
}
