import 'dart:ui';

import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_hero/local_hero.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/commons/theme/app_colors.dart';
import '../../../core/commons/utils/firebase_engine.dart';
import '../../../core/di/locator.dart';
import '../../../core/presentation/app_global_widgets.dart';
import '../new_welcome_screen/new_welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController scrollController = ScrollController();
  bool isProfilePicVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    scrollController.addListener(() {
      debugPrint(
          "Current scroll:" + scrollController.position.pixels.toString());
      if (scrollController.position.pixels > 295 && isProfilePicVisible) {
        setState(() {
          isProfilePicVisible = false;
        });
      } else if (scrollController.position.pixels < 295 &&
          !isProfilePicVisible) {
        setState(() {
          isProfilePicVisible = true;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    scrollController.removeListener(() {});
    super.dispose();
  }

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
            'Vous êtes sur le point de supprimer toutes vos données, votre yeeguide se sentira abandonné et seul dans le noir..',
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
              FirebaseEngine.logCustomEvent("disconnect_user", {"username":locator.get<SharedPreferences>().getString("username") ??
              "unknown"});
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
              'Oui, je supprime',
              style: TextStyle(color: AppColors.primaryVar0),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext initialContext) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 245, 242, 242),
            body: SizedBox(
                width: 1.sw,
                height: 1.sh,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0,bottom: MediaQuery.of(context).padding.bottom + 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 90 +
                                  MediaQuery.of(context).padding.top
                              ,
                            ),
                            Stack(
                              children: [
                                SizedBox(
                                  height: 265,
                                  width: 1.sw - 40,
                                ),
                                if (isProfilePicVisible) ...[
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Stack(children: [
                                      Image.asset(
                                        "assets/images/profile_pic_placeholder.png",
                                        height: 210,
                                        width: 210,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 30,
                                        child: Material(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            onTap: () {
                                              FirebaseEngine.logCustomEvent("unavailable_edit_profile", {});

                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(
                                context,
                                "Fonctionnalité disponible prochainement 😉",
                                SnackBarType.info,
                                showCloseIcon: false,
                              ),
                            );},
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        spreadRadius: 1,
                                                        blurRadius: 4,
                                                        offset:
                                                            const Offset(0, 0),
                                                        blurStyle:
                                                            BlurStyle.outer,
                                                        color: Colors.black
                                                            .withOpacity(.05))
                                                  ]),
                                              child: Center(
                                                  child: Icon(
                                                Icons.edit,
                                                size: 18,
                                                color: AppColors.primaryText,
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ],
                                Positioned(
                                  bottom: 0,
                                  child: SizedBox(
                                    width: 1.sw - 40,
                                    // color: Colors.green,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          // Yeeguide.getById(locator
                                          //             .get<SharedPreferences>()
                                          //             .getString(
                                          //                 "yeeguide_id") ??
                                          //         "raruto")
                                          //     .name,
                                          locator.get<SharedPreferences>().getString("username") ?? "User",
                                          style: TextStyle(
                                              color: AppColors.primaryText,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "@" + (locator.get<SharedPreferences>().getString("username") ?? '') +"theuser",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: AppColors.secondaryText),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      FirebaseEngine.logCustomEvent("unavailable_contributions", {});

                                      ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(
                                context,
                                "Fonctionnalité disponible prochainement 😉",
                                SnackBarType.info,
                                showCloseIcon: false,
                              ),
                            );},
                                    child: Container(
                                      height: 64,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "15",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text("Contributions"),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      FirebaseEngine.logCustomEvent("unavailable_yeemoney", {});

                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(
                                context,
                                "Fonctionnalité disponible prochainement 😉",
                                SnackBarType.info,
                                showCloseIcon: false,
                              ),
                            );},
                                    child: Container(
                                      height: 64,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "2000",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text("Yeemoney"),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 1.sw,
                                ),
                                Text(
                                  "Conversations",
                                  style:
                                      TextStyle(color: AppColors.secondaryText),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                ProfileSection(
                                  title: "Notifications",
                                  isTrueTopOrBottomFalse: true,
                                  onTap: () {
                                    FirebaseEngine.logCustomEvent("view_notifications", {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      buildCustomSnackBar(
                                        context,
                                        "Fonctionnalité disponible prochainement 😉",
                                        SnackBarType.info,
                                        showCloseIcon: false,
                                      ),
                                    );
                                  },
                                ),
                                ProfileSection(
                                  title: "Utilisation des données IA",
                                  onTap: () {
                                    FirebaseEngine.logCustomEvent("view_ai_data_usage", {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      buildCustomSnackBar(
                                        context,
                                        "Fonctionnalité disponible prochainement 😉",
                                        SnackBarType.info,
                                        showCloseIcon: false,
                                      ),
                                    );
                                  },
                                ),
                                ProfileSection(
                                  title: "Messages éphémères",
                                  onTap: () {
                                    FirebaseEngine.logCustomEvent("view_ephemeral_messages", {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      buildCustomSnackBar(
                                        context,
                                        "Fonctionnalité disponible prochainement 😉",
                                        SnackBarType.info,
                                        showCloseIcon: false,
                                      ),
                                    );
                                  },
                                ),
                                ProfileSection(
                                  title: "Supprimer mon compte",
                                  onTap: () {
                                    FirebaseEngine.logCustomEvent("delete_account", {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      buildCustomSnackBar(
                                        context,
                                        "Fonctionnalité disponible prochainement 😉",
                                        SnackBarType.info,
                                        showCloseIcon: false,
                                      ),
                                    );
                                  },
                                ),
                                ProfileSection(
                                  title: "Déconnexion",
                                  onTap: () {
                                    FirebaseEngine.logCustomEvent("logout", {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      buildCustomSnackBar(
                                        context,
                                        "Fonctionnalité disponible prochainement 😉",
                                        SnackBarType.info,
                                        showCloseIcon: false,
                                      ),
                                    );
                                  },
                                ),

                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 1.sw,
                                ),
                                Text(
                                  "Préférences",
                                  style:
                                      TextStyle(color: AppColors.secondaryText),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                ProfileSection(
                                  title: "Thème et apparence",
                                  isTrueTopOrBottomFalse: true,
                                  onTap: () {
                                    FirebaseEngine.logCustomEvent("view_theme_settings", {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      buildCustomSnackBar(
                                        context,
                                        "Fonctionnalité disponible prochainement 😉",
                                        SnackBarType.info,
                                        showCloseIcon: false,
                                      ),
                                    );
                                  },
                                ),
                                ProfileSection(
                                  title: "Langue de l'application",
                                  onTap: () {
                                    FirebaseEngine.logCustomEvent("view_language_settings", {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      buildCustomSnackBar(
                                        context,
                                        "Fonctionnalité disponible prochainement 😉",
                                        SnackBarType.info,
                                        showCloseIcon: false,
                                      ),
                                    );
                                  },
                                ),
                                ProfileSection(
                                  title: "Centre d'aide",
                                  onTap: () {
                                    FirebaseEngine.logCustomEvent("view_help_center", {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      buildCustomSnackBar(
                                        context,
                                        "Fonctionnalité disponible prochainement 😉",
                                        SnackBarType.info,
                                        showCloseIcon: false,
                                      ),
                                    );
                                  },
                                ),
                                ProfileSection(
                                  title: "Conditions d'utilisation",
                                  onTap: () {
                                    FirebaseEngine.logCustomEvent("view_terms_of_service", {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      buildCustomSnackBar(
                                        context,
                                        "Fonctionnalité disponible prochainement 😉",
                                        SnackBarType.info,
                                        showCloseIcon: false,
                                      ),
                                    );
                                  },
                                ),
                                ProfileSection(
                                  title: "Politique de confidentialité",
                                  isTrueTopOrBottomFalse: false,
                                  onTap: () {
                                    FirebaseEngine.logCustomEvent("view_privacy_policy", {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      buildCustomSnackBar(
                                        context,
                                        "Fonctionnalité disponible prochainement 😉",
                                        SnackBarType.info,
                                        showCloseIcon: false,
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 15),
                                Container(
                                  constraints: const BoxConstraints(
                                      maxHeight: 140, minHeight: 55),
                                  // color: Colors.blue,
                                  height: 60,
                                  width: 1.sw,
                                  // padding: EdgeInsets.only(bottom: 10.0),

                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showAlertDialog(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.bootstrapRed,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Ajustez la valeur pour le border radius souhaité
                                      ),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              16), // Espacement intérieur pour le bouton
                                      minimumSize: const Size(double.infinity,
                                          55), // Pour que le bouton prenne toute la largeur de l'écran
                                    ),
                                    child: const Text(
                                      "Déconnexion",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Pour revenir à l'accueil principal de l'application",
                                  style: TextStyle(
                                      color: AppColors.secondaryText,
                                      fontSize: 12),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Version 0.0 \nTu veux appuyer ici ? 🙃",
                                  style: TextStyle(
                                      color: AppColors.secondaryText,
                                      fontSize: 12),
                                ),
                                // Text(
                                //   "Build 1",
                                //   style: TextStyle(
                                //       color: AppColors.secondaryText,
                                //       fontSize: 12),
                                // ),
                                const SizedBox(
                                  height: 15.0,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height:  65 + MediaQuery.of(context).padding.top,
                      // padding: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 16,
                                offset: const Offset(0, 0),
                                blurStyle: BlurStyle.outer,
                                color: Colors.grey.withOpacity(.25))
                          ]),
                      child: Center(
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                            child: Container(
                                // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top/2
                                    , left: 5.0, right: 10.0,bottom: 5),
                                width: 1.sw,
                                height: 65 + MediaQuery.of(context).padding.top,
                                decoration: BoxDecoration(
                                  // color: Colors.red,
                                  color: Colors.white.withOpacity(.1),
                                  // border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0))
                                  // ), // Bord inférieur gris
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 7,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  // widget.onPop();
                                                },
                                                child: Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 40,
                                                          minWidth: 20),
                                                  height: 60,
                                                  // width: 50,
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5.0),
                                                      child: Image.asset(
                                                        "assets/icons/lit_back_icon.png",
                                                        height: 19,
                                                        width: 19,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 6,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: Row(
                                                  children: [
                                                    if (!isProfilePicVisible) ...[
                                                      Image.asset(
                                                        "assets/images/profile_pic_placeholder.png",
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                    ],
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      // isProfilePicVisible
                                                      //     ? "Profil"
                                                      //     : Yeeguide.getById(locator
                                                      //                 .get<
                                                      //                     SharedPreferences>()
                                                      //                 .getString(
                                                      //                     "yeeguide_id") ??
                                                      //             "raruto")
                                                      //         .name,
                                                      isProfilePicVisible
                                                          ? "Profil"
                                                          : locator.get<SharedPreferences>().getString("username") ?? "User",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColors.primaryText,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                      maxLines: 1,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 3,
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
                                            width: 42,
                                            child: Center(
                                              child: Image.asset(
                                                "assets/icons/gear.png",
                                                height: 23,
                                                width: 23,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))));
  }
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
    required this.title,
    this.icon,
    this.isTrueTopOrBottomFalse,
    required this.onTap,
  });

  final String title;
  final String? icon;
  final bool? isTrueTopOrBottomFalse;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Material(
        borderRadius: isTrueTopOrBottomFalse != null
            ? BorderRadius.only(
                topLeft: isTrueTopOrBottomFalse!
                    ? const Radius.circular(10)
                    : Radius.zero,
                topRight: isTrueTopOrBottomFalse!
                    ? const Radius.circular(10)
                    : Radius.zero,
                bottomLeft: isTrueTopOrBottomFalse!
                    ? Radius.zero
                    : const Radius.circular(10),
                bottomRight: isTrueTopOrBottomFalse!
                    ? Radius.zero
                    : const Radius.circular(10))
            : BorderRadius.zero,

        // borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(10),
        //     topRight: Radius.circular(10)),
        color: Colors.white,
        child: InkWell(
          borderRadius: isTrueTopOrBottomFalse != null
              ? BorderRadius.only(
                  topLeft: isTrueTopOrBottomFalse!
                      ? const Radius.circular(10)
                      : Radius.zero,
                  topRight: isTrueTopOrBottomFalse!
                      ? const Radius.circular(10)
                      : Radius.zero,
                  bottomLeft: isTrueTopOrBottomFalse!
                      ? Radius.zero
                      : const Radius.circular(10),
                  bottomRight: isTrueTopOrBottomFalse!
                      ? Radius.zero
                      : const Radius.circular(10))
              : BorderRadius.zero,
          // borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(10),
          //     topRight: Radius.circular(10)),
          onTap: onTap,
          child: Container(
            width: 1.sw,
            height: 40,
            decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: isTrueTopOrBottomFalse != null
                    ? BorderRadius.only(
                        topLeft: isTrueTopOrBottomFalse!
                            ? const Radius.circular(10)
                            : Radius.zero,
                        topRight: isTrueTopOrBottomFalse!
                            ? const Radius.circular(10)
                            : Radius.zero,
                        bottomLeft: isTrueTopOrBottomFalse!
                            ? Radius.zero
                            : const Radius.circular(10),
                        bottomRight: isTrueTopOrBottomFalse!
                            ? Radius.zero
                            : const Radius.circular(10))
                    : BorderRadius.zero),
            child: Center(
                child: Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text(title),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
