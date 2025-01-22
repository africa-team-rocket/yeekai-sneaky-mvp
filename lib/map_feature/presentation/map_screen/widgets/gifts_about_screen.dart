import 'dart:async';
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
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:yeebus_filthy_mvp/map_feature/presentation/map_screen/map_screen.dart';

import '../../../../core/commons/theme/app_colors.dart';
import '../../../../core/commons/utils/app_constants.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/presentation/app_global_widgets.dart';
import '../../../domain/model/main_place.dart';

class GiftsAboutScreen extends StatefulWidget {
  const GiftsAboutScreen({super.key, required this.closeGiftsPage});

  final Function closeGiftsPage;

  @override
  State<GiftsAboutScreen> createState() => _GiftsAboutScreenState();
}

class _GiftsAboutScreenState extends State<GiftsAboutScreen> {
  final ScrollController scrollController = ScrollController();
  bool isProfilePicVisible = true;
  final PageController pageController = PageController();

  final List<String> daysOfWeek = [
    "lundi",
    "Mardi",
    "mercredi",
    "jeudi",
    "vendredi",
    "samedi",
    "dimanche",
  ];

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
              locator.get<SharedPreferences>().clear();

              // Future.delayed(
              //     Duration(milliseconds: 500),
              //     () => {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //               buildCustomSnackBar(context,
              //                   "Yeeguide changé avec succès", SnackBarType.info))
              //         });
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
                        padding: EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            bottom: MediaQuery.of(context).padding.bottom + 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 105 + MediaQuery.of(context).padding.top,
                            ),
                            Container(
                              width: 1.sw,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 1.sw,
                                    height: 140,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(7),
                                              topRight: Radius.circular(7)),
                                          child: PageView.builder(
                                            controller: pageController,
                                            itemCount: 1, // Number of images in the list
                                            itemBuilder: (context, index) {
                                              // Build a container for each image in the list
                                              return Container(
                                                height: 130,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage("assets/image/gifts_ad_image.png"), // Use the image path from the list
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),

                                          // child: PageView(
                                          //   controller: _controller,
                                          //   children: widget.images.map((e) => Container(
                                          //       decoration: BoxDecoration(
                                          //         image: DecorationImage(
                                          //           image: AssetImage(e),
                                          //           fit: BoxFit.cover,
                                          //         ),
                                          //         // color: Colors.blue,
                                          //       ))).toList()
                                          // ),
                                        ),
                                        IgnorePointer(
                                          child: Container(
                                            width: 1.sw,
                                            height: 140,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.black.withOpacity(.6),
                                                  Colors.transparent,
                                                  Colors.transparent
                                                ],
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          heightFactor:
                                              // 1.sw >= 342 ? 1.sh * 0.016 :
                                              1.sh * 0.0193,
                                          child: SmoothPageIndicator(
                                            controller: pageController,
                                            count: 3,
                                            effect: WormEffect(
                                              spacing: 4,
                                              dotColor:
                                                  Colors.white.withOpacity(.7),
                                              activeDotColor: Colors.white,
                                              dotHeight: 8,
                                              dotWidth: 8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Des trésors cachés dans l'école ?!",
                                          style: TextStyle(
                                            color: Color(0xFF302F2E),
                                            fontSize: 17,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Ils peuvent apparaître n'importe quand !",
                                              style: TextStyle(
                                                  color:
                                                      AppColors.secondaryText,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.8,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),


                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              '🚨 Tu risques de rater un trésor à 50k !',
                              style: TextStyle(
                                color: Color(0xFF302F2E),
                                fontSize: 17,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              width: 1.sw,
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "À chaque évènement du calendrier..\n\n(Noël, St Valentin, Pacques, Tabaski etc.) \n\n"
                                          "il y aura dans l’école..\n\n"
                                          "Des boites qui seront cachés, contenant soit : \n\n"

                                    "- Un trésor valorisé à 50k max\n"
                                    "- Un indice vers le trésor\n"
                                    "- Rien du tout\n\n"

                                    "Et vous pourrez les trouver grace à la carte pendant...\n\n"
                                    "la durée limitée de l’évènement\n\n(24h minimum).",
                                          textAlign: TextAlign.justify,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              '⚠️ ET SURTOUT : Si tu ne le cherche pas..',
                              style: TextStyle(
                                color: Color(0xFF302F2E),
                                fontSize: 17,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              width: 1.sw,
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Quelqu'un d'autre le trouvera, alors..\n\n"
                                              "Que ce soit :\n\n"

                                              "- Les oeufs de pacques ou..\n"
                                              "- Les paniers ramadan ou..\n"
                                              "- Les bouquets St.Valentin ou..\n"
                                              "- Les cadeaux de noël..\n\n"

                                              "Seuls les étudiants les plus vifs seront récompensés !\n\n"
                                              "PS : En dehors des évènements principaux, des cadeaux surprise apparaîtront aussi au quotidien",
                                          textAlign: TextAlign.justify,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Material(
                              color: AppColors.primaryColor,
                              borderRadius:
                              BorderRadius.circular(10),
                              child: InkWell(
                                onTap: () {
                                  widget.closeGiftsPage();
                                },
                                borderRadius:
                                BorderRadius.circular(
                                    17),
                                child: Padding(
                                  padding: const EdgeInsets
                                      .symmetric(
                                      vertical: 14),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      Text(
                                        "Je participe à la chasse 🥳",
                                        style: TextStyle(
                                            color: Colors
                                                .white,
                                            fontWeight:
                                            FontWeight
                                                .w400,
                                            fontSize:
                                            AppConstants.screenWidth >=
                                                342
                                                ? 15
                                                : 14),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            )
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
                      child: Center(
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                            child: Container(
                                // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top / 2,
                                    left: 5.0,
                                    right: 10.0,
                                    bottom: 5),
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
                                                  widget.closeGiftsPage();
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
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      "Info chasse au trésor",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .primaryText,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      maxLines: 1,
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CountdownTimerWidget(height: 60,)
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



class CountdownTimerWidget extends StatefulWidget {


  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();

  final double height;

  const CountdownTimerWidget({super.key, required this.height});

}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Duration _duration;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Initialiser le compte à rebours (48 heures, 24 minutes, 12 secondes)
    _duration = Duration(hours: 48, minutes: 24, seconds: 12);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_duration.inSeconds > 0) {
          _duration = _duration - const Duration(seconds: 1);
        } else {
          timer.cancel();
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    final int days = duration.inDays;
    final int hours = duration.inHours % 24;
    final int minutes = duration.inMinutes % 60;
    final int seconds = duration.inSeconds % 60;
    return "${days.toString().padLeft(2, '0')}j:${hours.toString().padLeft(2, '0')}h:${minutes.toString().padLeft(2, '0')}mn:${seconds.toString().padLeft(2, '0')}s";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: Colors.red, // Remplacez par AppColors.bootstrapRed
            ),
          ),
          child: Text(
            _formatDuration(_duration),
            style: TextStyle(
              color: Colors.red, // Remplacez par AppColors.bootstrapRed
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
