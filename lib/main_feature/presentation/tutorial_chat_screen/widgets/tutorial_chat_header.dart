import 'dart:ui';

import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/commons/theme/app_colors.dart';
import '../../../../core/di/locator.dart';
import '../../../domain/model/yeeguide.dart';

class TutorialChatScreenHeader extends StatefulWidget {
  const TutorialChatScreenHeader({Key? key}) : super(key: key);

  @override
  State<TutorialChatScreenHeader> createState() =>
      _TutorialChatScreenHeaderState();
}

class _TutorialChatScreenHeaderState extends State<TutorialChatScreenHeader> {
  bool isSearchModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      // padding: EdgeInsets.only(bottom: 15),
      decoration:
          BoxDecoration(color: Colors.white.withOpacity(0.6), boxShadow: [
        BoxShadow(
            spreadRadius: 0,
            blurRadius: 16,
            offset: const Offset(0, 0),
            blurStyle: BlurStyle.outer,
            color: Colors.grey.withOpacity(.25))
      ]),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 20.0),
            padding: const EdgeInsets.only(top: 15, left: 5.0, right: 10.0),
            width: 1.sw,
            height: 95,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.1),
              // border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0))
              // ), // Bord inférieur gris
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 5,
                  child: Container(
                    constraints: BoxConstraints(minWidth: 100),
                    // color: Colors.red,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         type: PageTransitionType.fade,
                                //         duration:
                                //             const Duration(milliseconds: 100),
                                //         child: HomeScreen()));
                                // widget.onPop();
                              },
                              child: SizedBox(
                                height: 60,
                                // width: 50,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Image.asset(
                                      "assets/icons/lit_back_icon.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Container(
                            constraints:
                                BoxConstraints(minHeight: 60, maxHeight: 70),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     PageTransition(
                                  //         type: PageTransitionType.fade,
                                  //         duration:
                                  //             const Duration(milliseconds: 500),
                                  //         child: YeeguideProfileScreen()));
                                  // widget.onPop();
                                  // Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Hero(
                                        tag: locator
                                                .get<SharedPreferences>()
                                                .getString("yeeguide_id") ??
                                            "",
                                        child: Image.asset(
                                          Yeeguide.getById(locator
                                                      .get<SharedPreferences>()
                                                      .getString(
                                                          "yeeguide_id") ??
                                                  "raruto")
                                              .profilePictureAsset,
                                          height: 43,
                                          width: 43,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          // height: 44,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  // color: Colors.red,
                                                  child: Text(
                                                    Yeeguide.getById(locator
                                                                .get<
                                                                    SharedPreferences>()
                                                                .getString(
                                                                    "yeeguide_id") ??
                                                            "raruto")
                                                        .name,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .primaryText,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Yeeguide",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black54,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Container(
                //   constraints: const BoxConstraints(maxWidth: 55),
                //   child:
                Flexible(
                  flex: 1,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {},
                      child: SizedBox(
                        height: 60,
                        child: Center(
                          child: Image.asset(
                            "assets/icons/search_lit_icon.png",
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // ),
                // Container(
                //   constraints: const BoxConstraints(maxWidth: 55),
                //   child:
                Visibility(
                  visible: false,
                  //TODO: check if we really need this
                  child: Flexible(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          // widget.onPop();
                          // Navigator.pop(context);
                        },
                        child: SizedBox(
                          height: 60,
                          // width: 42,
                          child: Center(
                            child: Image.asset(
                              "assets/icons/call_lit_icon.png",
                              height: 18,
                              width: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // ),
                // Container(
                //   constraints: const BoxConstraints(maxWidth: 55),
                //   child:
                Flexible(
                  child: Material(
                    // color: Colors.green,
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {},
                      child: SizedBox(
                        height: 60,
                        child: Center(
                            child: Image.asset(
                          "assets/icons/more_lit_icon.png",
                          height: 18,
                          width: 18,
                        )),
                      ),
                    ),
                  ),
                ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
