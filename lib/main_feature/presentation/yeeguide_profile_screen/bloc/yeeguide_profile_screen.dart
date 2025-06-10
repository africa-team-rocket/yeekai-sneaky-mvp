import 'dart:ui';

import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_hero/local_hero.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/commons/theme/app_colors.dart';
import '../../../../core/commons/utils/firebase_engine.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/presentation/app_global_widgets.dart';
import '../../../domain/model/yeeguide.dart';

class YeeguideProfileScreen extends StatefulWidget {
  const YeeguideProfileScreen({super.key});

  @override
  State<YeeguideProfileScreen> createState() => _YeeguideProfileScreenState();
}

class _YeeguideProfileScreenState extends State<YeeguideProfileScreen> {
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

  @override
  Widget build(BuildContext initialContext) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 245, 242, 242),
            body: SizedBox(
                width: 1.sw,
                height: 1.sh,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30 + MediaQuery.of(context).padding.bottom),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 85 + MediaQuery.of(context).padding.top,
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
                                    child: Image.asset(
                                      // "assets/yeeguides/songo_guide.png",
                                      Yeeguide.getById(locator
                                                  .get<SharedPreferences>()
                                                  .getString("yeeguide_id") ??
                                              "raruto")
                                          .profilePictureAsset,
                                      height: 210,
                                      width: 210,
                                    ),
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
                                          Yeeguide.getById(locator
                                                      .get<SharedPreferences>()
                                                      .getString(
                                                          "yeeguide_id") ??
                                                  "raruto")
                                              .name,
                                          style: TextStyle(
                                              color: AppColors.primaryText,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),

                                        Text(
                                          Yeeguide.getById(locator
                                                      .get<SharedPreferences>()
                                                      .getString(
                                                          "yeeguide_id") ??
                                                  "raruto")
                                              .tag,
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
                                      FirebaseEngine.logCustomEvent("ai_call_unavailable_usecase",{});

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
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/call_lit_icon.png",
                                            width: 15,
                                          ),
                                          const SizedBox(height: 7),
                                          Text("Appel"),
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
                                      FirebaseEngine.logCustomEvent("ai_search_unavailable_usecase",{});

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
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/search_lit_icon.png",
                                            width: 15,
                                          ),
                                          const SizedBox(height: 7),
                                          Text("Rechercher"),
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
                        SizedBox(width: 1.sw),
                        Text("Conversations", style: TextStyle(color: AppColors.secondaryText)),
                        const SizedBox(height: 5),
                        ProfileSection(
                          title: "Gestion du focus",
                          isTrueTopOrBottomFalse: true,
                          onTap: () {
                            FirebaseEngine.logCustomEvent("gestion_focus_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                        ProfileSection(
                          title: "Nouvelle conversation",
                          onTap: () {
                            FirebaseEngine.logCustomEvent("nouvelle_conversation_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                        ProfileSection(
                          title: "Historique de conversation",
                          onTap: () {
                            FirebaseEngine.logCustomEvent("historique_conversation_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                        ProfileSection(
                          title: "Supprimer",
                          onTap: () {
                            FirebaseEngine.logCustomEvent("supprimer_conversation_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                        ProfileSection(
                          title: "Renommer",
                          onTap: () {
                            FirebaseEngine.logCustomEvent("renommer_conversation_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                        ProfileSection(
                          title: "Souvenirs épinglés",
                          isTrueTopOrBottomFalse: false,
                          onTap: () {
                            FirebaseEngine.logCustomEvent("souvenirs_epingles_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 1.sw),
                        Text("Préférences", style: TextStyle(color: AppColors.secondaryText)),
                        const SizedBox(height: 5),
                        ProfileSection(
                          title: "Réponse en live",
                          isTrueTopOrBottomFalse: true,
                          onTap: () {
                            FirebaseEngine.logCustomEvent("reponse_live_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                        ProfileSection(
                          title: "Instructions personnalisées",
                          onTap: () {
                            FirebaseEngine.logCustomEvent("instructions_personnalisees_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                        ProfileSection(
                          title: "Changer de yeeguide",
                          onTap: () {
                            FirebaseEngine.logCustomEvent("changer_yeeguide_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                        ProfileSection(
                          title: "Langue",
                          isTrueTopOrBottomFalse: false,
                          onTap: () {
                            FirebaseEngine.logCustomEvent("changer_langue_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 1.sw),
                        Text("Accessibilité", style: TextStyle(color: AppColors.secondaryText)),
                        const SizedBox(height: 5),
                        ProfileSection(
                          title: "Appel",
                          isTrueTopOrBottomFalse: true,
                          onTap: () {
                            FirebaseEngine.logCustomEvent("appel_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                        ProfileSection(
                          title: "Paramètres vocaux",
                          isTrueTopOrBottomFalse: false,
                          onTap: () {
                            FirebaseEngine.logCustomEvent("parametres_vocaux_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 1.sw),
                        Text("Confidentialité et sécurité", style: TextStyle(color: AppColors.secondaryText)),
                        const SizedBox(height: 5),
                        ProfileSection(
                          title: "Signaler un problème",
                          isTrueTopOrBottomFalse: true,
                          onTap: () {
                            FirebaseEngine.logCustomEvent("signaler_probleme_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                        ProfileSection(
                          title: "Partager la discussion",
                          isTrueTopOrBottomFalse: false,
                          onTap: () {
                            FirebaseEngine.logCustomEvent("partager_discussion_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 1.sw),
                        Text("Paramètres avancés", style: TextStyle(color: AppColors.secondaryText)),
                        const SizedBox(height: 5),
                        ProfileSection(
                          title: "Alertes & notifications",
                          isTrueTopOrBottomFalse: true,
                          onTap: () {
                            FirebaseEngine.logCustomEvent("alertes_notifications_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                        ProfileSection(
                          title: "Publicité",
                          onTap: () {
                            FirebaseEngine.logCustomEvent("publicite_clicked", {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(context, "Fonctionnalité disponible prochainement 😉", SnackBarType.info, showCloseIcon: false),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 65 + MediaQuery.of(context).padding.top,
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
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                          child: Container(
                              // padding: EdgeInsets.symmetric(horizontal: 20.0),
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top, left: 5.0, right: 10.0),
                              width: 1.sw,
                              height: 20,
                              decoration: BoxDecoration(
                                //color: Colors.white.withOpacity(.1),
                                color: Colors.white.withOpacity(.1),
                                // border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0))
                                // ), // Bord inférieur gris
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                                FirebaseEngine.pagesTracked("chat_screen");
                                                Navigator.pop(context);
                                                // widget.onPop();
                                              },
                                              child: Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 40, minWidth: 20),
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
                                                      // "assets/yeeguides/songo_guide.png",
                                                      Yeeguide.getById(locator
                                                                  .get<
                                                                      SharedPreferences>()
                                                                  .getString(
                                                                      "yeeguide_id") ??
                                                              "raruto")
                                                          .profilePictureAsset,
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                  ],
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    isProfilePicVisible
                                                        ? "Profil yeeguide"
                                                        : Yeeguide.getById(locator
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
                                          FirebaseEngine.logCustomEvent("ai_settings_unavailable_usecase",{});


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
      padding: EdgeInsets.only(bottom: 1),
      child: Material(
        borderRadius: isTrueTopOrBottomFalse != null
            ? BorderRadius.only(
                topLeft:
                    isTrueTopOrBottomFalse! ? Radius.circular(10) : Radius.zero,
                topRight:
                    isTrueTopOrBottomFalse! ? Radius.circular(10) : Radius.zero,
                bottomLeft:
                    isTrueTopOrBottomFalse! ? Radius.zero : Radius.circular(10),
                bottomRight:
                    isTrueTopOrBottomFalse! ? Radius.zero : Radius.circular(10))
            : BorderRadius.zero,

        // borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(10),
        //     topRight: Radius.circular(10)),
        color: Colors.white,
        child: InkWell(
          borderRadius: isTrueTopOrBottomFalse != null
              ? BorderRadius.only(
                  topLeft: isTrueTopOrBottomFalse!
                      ? Radius.circular(10)
                      : Radius.zero,
                  topRight: isTrueTopOrBottomFalse!
                      ? Radius.circular(10)
                      : Radius.zero,
                  bottomLeft: isTrueTopOrBottomFalse!
                      ? Radius.zero
                      : Radius.circular(10),
                  bottomRight: isTrueTopOrBottomFalse!
                      ? Radius.zero
                      : Radius.circular(10))
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
                            ? Radius.circular(10)
                            : Radius.zero,
                        topRight: isTrueTopOrBottomFalse!
                            ? Radius.circular(10)
                            : Radius.zero,
                        bottomLeft: isTrueTopOrBottomFalse!
                            ? Radius.zero
                            : Radius.circular(10),
                        bottomRight: isTrueTopOrBottomFalse!
                            ? Radius.zero
                            : Radius.circular(10))
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
