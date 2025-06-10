import 'dart:ui';

import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/commons/theme/app_colors.dart';
import '../../../../core/commons/utils/custom_pop_up_menu.dart';
import '../../../../core/commons/utils/firebase_engine.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/presentation/app_global_widgets.dart';
import '../../../domain/model/yeeguide.dart';
import '../../catalog_screen/catalog_screen.dart';
import '../../home_screen/home_screen.dart';
import '../../new_welcome_screen/new_welcome_screen.dart';
import '../../yeeguide_profile_screen/bloc/yeeguide_profile_screen.dart';

class ChatScreenHeader extends StatefulWidget {
  const ChatScreenHeader({Key? key}) : super(key: key);

  @override
  State<ChatScreenHeader> createState() => _ChatScreenHeaderState();
}

class _ChatScreenHeaderState extends State<ChatScreenHeader> {
  bool isSearchModeEnabled = false;

  void _showAlertDialog(BuildContext innerContext) {
    showCupertinoModalPopup<void>(
      context: innerContext,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          'Attention',
          style: TextStyle(fontSize: 20, color: AppColors.primaryText),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'Vous êtes sur le point de recommencer à Zéro, ne faites ceci que si vous êtes bloqué',
            style: TextStyle(fontSize: 15.5, color: AppColors.primaryText),
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            // isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Annuler',
              style: TextStyle(color: AppColors.bootstrapRed),
            ),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            isDefaultAction: true,
            onPressed: () {
              locator
                  .get<SharedPreferences>().clear();

              // Future.delayed(
              //     Duration(milliseconds: 500),
              //     () => {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //               buildCustomSnackBar(context,
              //                   "Yeeguide changé avec succès", SnackBarType.info))
              //         });
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 500),
                      child: NewWelcomeScreen()));
            },
            child: Text(
              'Oui, je veux recommencer',
              style: TextStyle(color: AppColors.primaryVar0),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70 + MediaQuery.of(context).padding.top,
      decoration:
          BoxDecoration(color: Colors.white.withOpacity(0.6), boxShadow: [
        BoxShadow(
            spreadRadius: 0,
            blurRadius: 16,
            offset: const Offset(0, 0),
            blurStyle: BlurStyle.outer,
            color: Colors.grey.withOpacity(.25)
        )
      ]),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 20.0),
              // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top/2),

              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top / 2,
                  left: 5.0,
                  right: 10.0),
              width: 1.sw,
              height: 95,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.1),
                // border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0))
                // ), // Bord inférieur gris
              ),
              child: AnimatedSwitcherPlus.translationBottom(
                duration: Duration(milliseconds: 300),
                child: isSearchModeEnabled
                    ? Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 5,
                              child: Container(
                                height: 45,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                // width: 1.sw * 0.73,
                                decoration: BoxDecoration(
                                    color: Color(0xFFECECEC),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          child: Center(
                                            child: Image.asset(
                                              "assets/icons/search_lit_icon.png",
                                              height: 18,
                                              width: 18,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text("Rechercher.."),
                                      ],
                                    ),
                                    //   if (false) ...[
                                    //     Material(
                                    //       color: Colors.transparent,
                                    //       child: InkWell(
                                    //         borderRadius: BorderRadius.circular(30),
                                    //         onTap: () {
                                    //           // widget.onPop();
                                    //           // Navigator.pop(context);
                                    //         },
                                    //         child: const SizedBox(
                                    //           height: 40,
                                    //           width: 42,
                                    //           child: Center(
                                    //               child: Icon(
                                    //             Icons.clear,
                                    //           )),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ]
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              flex: 2,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  // splashColor: Colors.grey.shade50,
                                  // focusColor: Colors.red,
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () {
                                    // widget.onPop();
                                    // Navigator.pop(context);
                                    setState(() {
                                      isSearchModeEnabled = false;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Center(
                                        child: Text(
                                      "Fermer",
                                      style: TextStyle(
                                          color: AppColors.primaryText,
                                          fontWeight: FontWeight.w400),
                                    )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
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
                                          FocusScope.of(context).unfocus();
                                          FirebaseEngine.pagesTracked("home_screen");
                                          Future.delayed(Duration.zero, () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    duration: const Duration(
                                                        milliseconds: 100),
                                                    child: HomeScreen()));
                                          });
                                          // widget.onPop();
                                        },
                                        child: SizedBox(
                                          height: 60,
                                          // width: 50,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
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
                                      constraints: BoxConstraints(
                                          minHeight: 60, maxHeight: 70),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          onTap: () {
                                            FirebaseEngine.pagesTracked("yeeguide_profile_screen");

                                            Navigator.push(
                                                context,
                                                "Concentre toi sur le trésor 😡",
                                                SnackBarType.info,
                                                showCloseIcon: false,
                                              ),
                                            );
                                            // Navigator.push(
                                            //     context,
                                            //     PageTransition(
                                            //         type:
                                            //             PageTransitionType.fade,
                                            //         duration: const Duration(
                                            //             milliseconds: 500),
                                            //         child:
                                            //             YeeguideProfileScreen()));
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
                                                          .get<
                                                              SharedPreferences>()
                                                          .getString(
                                                              "yeeguide_id") ??
                                                      "",
                                                  child: Image.asset(
                                                    Yeeguide.getById(locator
                                                                .get<
                                                                    SharedPreferences>()
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
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
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
                                                                      FontWeight
                                                                          .w500,
                                                                  color: AppColors
                                                                      .primaryText,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "Yeeguide",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          textAlign:
                                                              TextAlign.start,
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
                                onTap: () {
                                  //TODO: Implement search

                                  // widget.onPop();
                                  // setState(() {
                                  //   isSearchModeEnabled = true;
                                  // });
                                  // Navigator.pop(context);

                                  //////////////////////////
                                  FirebaseEngine.logCustomEvent("ai_search_unavailable_usecase",{});

                                  //While this feature is not available
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    buildCustomSnackBar(
                                      context,
                                      "Fonctionnalité disponible prochainement 😉",
                                      showCloseIcon: false,
                                      SnackBarType.info,
                                    ),
                                  );
                                },
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      buildCustomSnackBar(
                                        context,
                                        "Fonctionnalité disponible prochainement 😉",
                                        SnackBarType.info,
                                        showCloseIcon: false,
                                      ),
                                    );},
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
                                onTap: () {
                                  showBlurryMenu(
                                    color: Color(0xFFF2F2F2).withOpacity(.8),
                                    context: context,
                                    // shadowColor: Colors.grey.withOpacity(.2),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: .5, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(
                                          12.0), // Ajustez le borderRadius selon vos besoins
                                    ),
                                    elevation: 0,
                                    items: [
                                      PopupBlurryMenuItem(
                                        onTap: () {
                                          FirebaseEngine.logCustomEvent("supprimer_conversation_clicked", {});

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            buildCustomSnackBar(
                                              context,
                                              "Fonctionnalité disponible prochainement 😉",
                                              showCloseIcon: false,
                                              SnackBarType.info,
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Supprimer",
                                              style: TextStyle(
                                                color: AppColors.bootstrapRed,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Image.asset(
                                              "assets/icons/trash_red.png",
                                              height: 21,
                                              width: 21,
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupBlurryMenuItem(
                                        onTap: () {
                                          FirebaseEngine.logCustomEvent("renommer_conversation_clicked", {});

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            buildCustomSnackBar(
                                              context,
                                              "Fonctionnalité disponible prochainement 😉",
                                              showCloseIcon: false,
                                              SnackBarType.info,
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          width: 1.sw,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Renommer",
                                                style: TextStyle(
                                                  color: AppColors.primaryText,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              Image.asset(
                                                "assets/icons/edit.png",
                                                height: 21,
                                                width: 21,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      PopupBlurryMenuItem(
                                        onTap: () {
                                          FirebaseEngine.logCustomEvent("nouvelle_conversation_clicked", {});

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            buildCustomSnackBar(
                                              context,
                                              "Fonctionnalité disponible prochainement 😉",
                                              showCloseIcon: false,
                                              SnackBarType.info,
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Nouvelle conversation",
                                                style: TextStyle(
                                                  color: AppColors.primaryText,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                )),
                                            Image.asset(
                                              "assets/icons/more.png",
                                              height: 21,
                                              width: 21,
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupBlurryMenuItem(
                                        onTap: () {
                                          FirebaseEngine.logCustomEvent("historique_conversation_clicked", {});

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            buildCustomSnackBar(
                                              context,
                                              "Fonctionnalité disponible prochainement 😉",
                                              showCloseIcon: false,
                                              SnackBarType.info,
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Historique",
                                              style: TextStyle(
                                                color: AppColors.primaryText,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Image.asset(
                                              "assets/icons/history.png",
                                              height: 21,
                                              width: 21,
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupBlurryMenuItem(
                                        onTap: () {
                                          FirebaseEngine.logCustomEvent("parametres_vocaux_clicked", {});

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            buildCustomSnackBar(
                                              context,
                                              "Fonctionnalité disponible prochainement 😉",
                                              showCloseIcon: false,
                                              SnackBarType.info,
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Paramètres",
                                              style: TextStyle(
                                                color: AppColors.primaryText,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Image.asset(
                                              "assets/icons/gear.png",
                                              height: 21,
                                              width: 21,
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupBlurryMenuItem(
                                        onTap: () {
                                          FirebaseEngine.pagesTracked("catalog_screen");

                                          Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType.fade,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                child: const CatalogScreen()),
                                          ).then((value) => {setState(() {})});
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Changer de Yeeguide",
                                                style: TextStyle(
                                                  color: AppColors.primaryText,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                )),
                                            Icon(
                                              Icons.space_dashboard_outlined,
                                              size: 21,
                                              // color: AppColors.primaryVar0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    position:
                                        RelativeRect.fromLTRB(550, 94, 10, 0),
                                  );
                                  // widget.onPop();
                                  // Navigator.pop(context);
                                },
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
              )),
        ),
      ),
    );
  }
}
