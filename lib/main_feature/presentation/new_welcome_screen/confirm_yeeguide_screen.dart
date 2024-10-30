import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/commons/theme/app_colors.dart';
import '../../../core/commons/utils/app_constants.dart';
import '../../../core/di/locator.dart';
import 'username_screen.dart';

class ConfirmYeeguideScreen extends StatefulWidget {
  const ConfirmYeeguideScreen({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  State<ConfirmYeeguideScreen> createState() => _ConfirmYeeguideScreenState();
}

class _ConfirmYeeguideScreenState extends State<ConfirmYeeguideScreen> {
  double animationLevel = 0.0;

  @override
  void initState() {
    super.initState();
    debugPrint(
        "Screen width and height : " + 1.sw.toString() + " " + 1.sh.toString());
    _startAnimation();
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

  Future<void> _continueAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      animationLevel = 2;
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
          // margin: const EdgeInsets.symmetric(horizontal: 20.0),
          padding: EdgeInsets.only(bottom: 15.0),
          child: Row(
            children: [
              const SizedBox(
                width: 20.0,
              ),
              Flexible(
                flex: 2,
                child: Container(
                  constraints: const BoxConstraints(
                      maxHeight: 140, minHeight: 55, minWidth: 55),
                  // color: Colors.blue,
                  height: 65,
                  // padding: EdgeInsets.only(bottom: 10.0),

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      // Navigator.push(
                      //     context,
                      //     PageTransition(
                      //         type: PageTransitionType.fade,
                      //         duration: const Duration(milliseconds: 500),
                      //         child: IntermediateScreen(
                      //           selectedYeeguideIndex: selectedYeeguide,
                      //         )));
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
                          horizontal:
                              16), // Espacement intérieur pour le bouton
                      minimumSize: const Size(double.infinity,
                          55), // Pour que le bouton prenne toute la largeur de l'écran
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                flex: 7,
                child: Container(
                  constraints:
                      const BoxConstraints(maxHeight: 140, minHeight: 55),
                  // color: Colors.blue,
                  height: 65,
                  // padding: EdgeInsets.only(bottom: 10.0),

                  child: ElevatedButton(
                    onPressed: () {
                      locator.get<SharedPreferences>().setString("yeeguide_id",
                          AppConstants.yeeguidesList[widget.selectedIndex].id);
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              duration: const Duration(milliseconds: 500),
                              child: UsernameScreen(
                                selectedIndex: widget.selectedIndex,
                              ))
                          // TutorialChatScreen(
                          //   selectedYeeguideIndex: widget.selectedIndex,
                          //   username: '',
                          // ))
                          );
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
                          horizontal:
                              16), // Espacement intérieur pour le bouton
                      minimumSize: const Size(double.infinity,
                          55), // Pour que le bouton prenne toute la largeur de l'écran
                    ),
                    child: Text(
                      "Je confirme",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
            ],
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
                  width: 1.sw,
                  height: 110,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Confirme ton choix",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 1.sw > 340.0 ? 22 : 19,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Tu pourras toujours utiliser les autres guides une fois dans l’application",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 1.sw > 340.0 ? 13.5 : 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Hero(
                  tag: "tag-${widget.selectedIndex}",
                  child: SizedBox(
                    height: 300,
                    // color: Colors.red,
                    child: Image.asset(
                      AppConstants.yeeguidesList[widget.selectedIndex]
                          .profilePictureAsset,
                      height: 370,
                      width: 370,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  AppConstants.yeeguidesList[widget.selectedIndex].name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 130,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 8),
                          decoration: BoxDecoration(
                              color:
                              AppColors.secondaryText.withOpacity(.2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/message.png",
                                height: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                AppConstants.yeeguidesList[widget.selectedIndex].category,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.2,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryText,
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),

                    ],
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
