import 'dart:math';
import 'dart:ui';

import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_pointer/transparent_pointer.dart';
import 'package:yeebus_filthy_mvp/core/commons/utils/firebase_engine.dart';
import 'package:yeebus_filthy_mvp/main_feature/presentation/home_screen/widgets/yeeguide_subpage.dart';

import '../../../core/commons/theme/app_colors.dart';
import '../../../core/di/locator.dart';
import '../../../core/presentation/app_global_widgets.dart';
import '../../../map_feature/presentation/map_screen/map_screen.dart';
import '../../domain/model/yeeguide.dart';
import '../catalog_screen/catalog_screen.dart';
import '../chat_screen/chat_screen.dart';
import '../profile_screen/profile_screen.dart';
// /!\ TODO : Je pense que le main_feature ne devrait contenir que la page d'accueil et les éléments intermédiaires
// en gros le coeur de l'appli, la page de messagerie sera un feature à part, la carte aussi, l'onboarding également, le changement de yeeguide et le profil aussi si tu veux

class CompanyData {
  final String companyName;
  final String statusImage;
  final String statusNumber;

  CompanyData({
    required this.companyName,
    required this.statusImage,
    required this.statusNumber,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController mainTabController;
  double tabBarOffset = 0.0;
  double headerPos = 0.0;

  late final AnimationController _bsController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  // ..repeat(reverse: true);

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 0.89),
  ).animate(CurvedAnimation(
    parent: _bsController,
    curve: Curves.easeInOut,
  ));

  final List<CompanyData> companies = [
    CompanyData(
      companyName: "Administration",
      statusImage: "assets/images/statut_administration.png",
      statusNumber: "4",
    ),
    CompanyData(
      companyName: "INGC 3",
      statusImage: "assets/images/statut_ingc3.png",
      statusNumber: "1",
    ),
    CompanyData(
      companyName: "LPTI 1",
      statusImage: "assets/images/statut_lpti1.png",
      statusNumber: "4",
    ),
    CompanyData(
      companyName: "Amicale",
      statusImage: "assets/images/statut_amicale.png",
      statusNumber: "0",
    ),
    CompanyData(
      companyName: "Team Yeekai",
      statusImage: "assets/images/statut_yeebus.jpg",
      statusNumber: "0",
    ),
    CompanyData(
      companyName: "MPSSI",
      statusImage: "assets/images/statut_mpssi-1.png",
      statusNumber: "0",
    ),
  ];

  List<String> _suggestionMessages = [
    "📚 À quelle heure ouvre la bibliothèque ?",
    "🍽️ Quel est le menu du restaurant ?",
    "👩‍💼 Est-ce que Madame Rita est dans son bureau ?",
    "💳 J'ai perdu ma carte étudiant, que faire ?",
    "📑 Comment avoir mon bulletin du second semestre ?",
    "🚻 Quelles sont les toilettes les plus propres ?",
    "🕌 Où puis-je prier au sein de l'école ?",
    "🔬 Où est le labo E26 ?",
    "🧑‍🏫 Est-ce que la salle HB6 est occupée ?",
    "👨‍🏫 Qui est Mr GBETIE ?",
    "🏦 Quels sont les numéros bancaires pour payer ma scolarité ?",
    "⚡ Comment trouver de l'aide pour mes cours d'électricité ?",
    "🏀 Est-ce que le championnat inter classe de basket de l'école est en cours ?",
    "⚽ Quelle classe a gagné le tournoi de football de l'école cette année ?",
    "🚌 C'est quand la sortie d'intégration de l'école ?",
    "📚 Comment emprunter un livre à la bibliothèque ?",
    "❓ Ça veut dire quoi TPE ?",
    "🏛️ En quelle année l'ESMT a-t-il été créé ?",
    "💼 Combien coûte le master en gestion de projet à l'ESMT ?",
    "📝 Quelles sont les procédures pour s'inscrire en MiTMN ?",
    "🔄 Est-il possible de me réorienter en LPTI depuis LMEN ?",
    "📞 C'est quoi le numéro du gérant du restaurant ?",
    "📠 J'aimerais avoir le contact du gérant de la reprographie",
    "🚪 Pourquoi la portière à l'entrée de l'école est toujours fermée ?",
    "👜 J'ai perdu mon portefeuille dans le campus, comment faire ?",
    "🎓 Existe-t-il un service de soutien académique ou de tutorat pour les étudiants ?",
    "🚏 Où sont situés les arrêts de transport en commun les plus proches du campus de l'ESMT ?",
    "🔧 Comment signaler un problème technique ou de maintenance sur le campus ?",
    "⚕️ Où se situe l'infirmerie ?",
    "🧑‍🎓 Qui est le président de l'amicale de l'ESMT ?",
  ];

  final _scrollViewController = ScrollController();
  final FirebaseAnalytics anal = FirebaseAnalytics.instance;


  @override
  void dispose() {

    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();

    _scrollViewController.dispose();
    _bsController.dispose();
    mainTabController.dispose();
    _scrollViewController.removeListener(_handleScroll);
    super.dispose();
  }

  // PageStorageBucket _mainBucket = PageStorageBucket();

  var tab1Key = PageStorageKey("tab1");

  double getTabBarPosition() {
    // Obtenez le nombre total d'onglets
    int tabCount = mainTabController.length;

    // Calculez la position de l'onglet actuel en utilisant l'offset et l'index
    double position = mainTabController.offset + mainTabController.index;

    // Si la position est négative (on est avant le premier onglet), retournez 0
    if (position < 0) {
      return 0;
    }
    // Si la position est supérieure au nombre d'onglets - 1 (on est après le dernier onglet), retournez le nombre d'onglets - 1
    else if (position > tabCount - 1) {
      return tabCount - 1;
    }
    // Sinon, retournez la position telle quelle
    else {
      return position;
    }
  }

  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));

    _controllerCenterLeft.play();
    _controllerCenterRight.play();

    await Future.delayed(const Duration(milliseconds: 200));


    locator.get<SharedPreferences>().setBool("isOldUser", true);

  }

  @override
  void initState() {
    super.initState();

    anal.setAnalyticsCollectionEnabled(true);

    _controllerCenterRight =
        ConfettiController(duration: const Duration(milliseconds: 400));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(milliseconds: 400));

    if(locator
        .get<SharedPreferences>()
        .getBool("isOldUser") !=
        true){

      _startAnimation();

    }



    mainTabController = TabController(
      vsync: this,
      initialIndex: 0,
      length: 2,
    );
    // if (_scrollViewController.hasClients) {
      _scrollViewController.addListener(_handleScroll);
    // }

    mainTabController.animation!.addListener(() {
      // Faites quelque chose en fonction de l'onglet actif
      double value = getTabBarPosition();
      // print("Offset : ${value}");

      if (tabBarOffset <= 0.1) {
        // if (_scrollViewController.hasClients) {
          _scrollViewController.animateTo(0.0,
              curve: Curves.linear, duration: Duration(microseconds: 1));
        // }
      }

      if (tabBarOffset != value) {
        setState(() {
          tabBarOffset = value;
        });
        if (tabBarOffset < 0.5 && _bsController.value == 1.0) {
          _bsController.reverse();
          if (headerPos != 0.0) {
            setState(() {
              headerPos = 0.0;
            });
          }

          // setState(() {
          //   isBsUp = true;
          // });
        } else if (tabBarOffset > 0.5 && _bsController.value == 0.0) {
          _bsController.forward();
        }
      }


      // 📌 **Ajout du tracking Firebase** :
      if (value == 0.0) {
        debugPrint("Pinged ai");
        FirebaseEngine.pagesTracked("ai_tab_screen");  // Onglet 0
      } else if (value == 1.0) {
        debugPrint("Pinged info");
        FirebaseEngine.pagesTracked("info_tab_screen");   // Onglet 1
      }
    });

  }

  double _initialScrollPosition = 0.0;
  ScrollDirection _previousScrollSense = ScrollDirection.reverse;

  void _handleScroll() {
    final maxScroll = _scrollViewController.position.maxScrollExtent;
    final currentScroll = _scrollViewController.position.pixels;

    if (_scrollViewController.position.userScrollDirection !=
        _previousScrollSense) {
      debugPrint("Current scroll: $currentScroll");
      setState(() {
        _initialScrollPosition = currentScroll;
      });
    }

    if (_scrollViewController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      final scrollDelta = currentScroll - _initialScrollPosition;
      final scrollRange = 20.0;
      final tweenRange = Tween<double>(begin: 00.0, end: -55.0);

      setState(() {
        _previousScrollSense = ScrollDirection.reverse;
        headerPos =
            tweenRange.lerp((scrollDelta / scrollRange).clamp(0.0, 1.0));
      });
    } else if (_scrollViewController.position.userScrollDirection ==
        ScrollDirection.forward) {
      final scrollDelta = currentScroll - _initialScrollPosition;
      final scrollRange = 30.0;
      final tweenRange = Tween<double>(begin: 00.0, end: -65.0);

      setState(() {
        _previousScrollSense = ScrollDirection.forward;
        headerPos =
            tweenRange.lerp((scrollDelta / scrollRange).clamp(0.0, 1.0));
      });
    }

    // }

    // final scrollDelta = currentScroll - _initialScrollPosition;
    // final scrollRange = 30.0;
    //
    // setState(() {
    //   _headerHeight = lerpDouble(
    //     10.0,
    //     70.0,
    //     scrollDelta.clamp(0.0, scrollRange) / scrollRange,
    //   )!;
    // });
  }

  void toggleBs() {
    if (_bsController.value == 1.0) {
      _bsController.forward();
    } else {
      _bsController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            // color: Colors.red,
            height: 1.sh,
            child: Stack(
              children: [

                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    // color: Colors.red,
                    width: 1.sw,
                    height: 1.sh,
                    child: TabBarView(
                      controller: mainTabController,
                      children: [
                        Container(
                            padding: EdgeInsets.only(
                                top: 95 + MediaQuery.of(context).padding.top),
                            height: 1.sh,
                            color: Colors.white,
                            key: tab1Key,
                            child: YeeguideSubPage(
                                introChatResponse: locator
                                            .get<SharedPreferences>()
                                            .getBool("isOldUser") !=
                                        null
                                    ? Yeeguide.getById(locator
                                                .get<SharedPreferences>()
                                                .getString("yeeguide_id") ??
                                            "raruto")
                                        .introChatResponse
                                    : Yeeguide.getById(locator
                                                .get<SharedPreferences>()
                                                .getString("yeeguide_id") ??
                                            "raruto")
                                        .welcomeChatResponse)),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          controller: _scrollViewController,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              // padding: EdgeInsets.only(top: 149, bottom: 40),
                              padding: EdgeInsets.only(
                                  top: 125 + MediaQuery.of(context).padding.top,
                                  bottom: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      "Statut",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryText),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 1.sw,
                                    height: 135,
                                    child: ListView.separated(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: companies.length,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(width: 10.0),
                                      itemBuilder: (context, index) {
                                        final company = companies[index];
                                        return CompanyStatus(
                                          companyName: company.companyName,
                                          statusImage: company.statusImage,
                                          statusNumber: company.statusNumber,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    child: Text(
                                      "Canaux",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryText),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CompanyChannel(
                                    companyLogo: "assets/images/logo_infos.png",
                                    companyName: "Flash-info ESMT",
                                    date: "il y'a 12 heures",
                                    notification: "1",
                                    message:
                                      "Bonjour à tous, la date limite pour les inscriptions pour la filière LPTI est repoussée jusqu'au 15 Octobre veui..."
                                  ),
                                  CompanyChannel(
                                    companyLogo: "assets/images/logo_opportunities.png",
                                    companyName: "Opportunités Stage & Emploi",
                                    date: "il y'a 4 jours",
                                    notification: "",
                                    message:
                                      "STAGE : Une entreprise de la place cherche 3 profils développeurs junior + 1 business analyst pou..."
                                  ),
                                  CompanyChannel(
                                      companyLogo:
                                          "assets/images/logo_market.png",
                                      companyName: "Marketplace",
                                      date: "hier à 12 heures",
                                      notification: "",
                                      image:
                                          "assets/images/annonce_marketplace.jpg",
                                      message:
                                          "Ps4 à vendre 120.000 3 jeux : - Spiderman miles morales - fifa 23 - Mortal kombat État : Neuf Raison de vente : Plus de temps pour jouer commence à travailler"),
                                  const SizedBox(height: 90),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 20.0, right: 20.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text(
                                  //         "Plus de canaux",
                                  //         style: TextStyle(
                                  //             fontSize: 18,
                                  //             fontWeight: FontWeight.w500,
                                  //             color: AppColors.primaryText),
                                  //       ),
                                  //       Material(
                                  //         color: Colors.transparent,
                                  //         child: InkWell(
                                  //           borderRadius:
                                  //               BorderRadius.circular(30),
                                  //           onTap: () {
                                  //             ScaffoldMessenger.of(context).showSnackBar(
                                  //               buildCustomSnackBar(
                                  //                 context,
                                  //                 "Fonctionnalité disponible prochainement 😉",
                                  //                 SnackBarType.info,
                                  //                 showCloseIcon: false,
                                  //               ),
                                  //             );
                                  //             },
                                  //           child: SizedBox(
                                  //             height: 38,
                                  //             width: 38,
                                  //             child: Center(
                                  //               child: Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.only(
                                  //                         right: 0.0),
                                  //                 child: Icon(
                                  //                   Icons.add,
                                  //                   color:
                                  //                       AppColors.primaryText,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedPositioned(
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 200),
                  top: headerPos,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 0),
                    // height: Platform.isIOS ? 95 + MediaQuery.of(context).padding.top : 125,
                    height: 90 + MediaQuery.of(context).padding.top,
                    width: 1.sw,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 0,
                              blurRadius: 16,
                              offset: const Offset(0, 1),
                              blurStyle: BlurStyle.outer,
                              color: Colors.grey.withOpacity(.3))
                        ]),
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedOpacity(
                              duration: Duration(milliseconds: 100),
                              opacity: (headerPos + 55.0) / 55.0,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 18.0, right: 15.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Padding(
                                        //   padding:
                                        //       const EdgeInsets.only(top: 1),
                                        //   child: Image.asset(
                                        //     "assets/icons/yeebus_flat_logo.png",
                                        //     width: 22,
                                        //     height: 22,
                                        //   ),
                                        // ),
                                        // const SizedBox(
                                        //   width: 8,
                                        // ),
                                        Text(
                                          "Yeekai",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primaryText),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            onTap: () {
                                              // widget.onPop();
                                              // Navigator.pop(context);
                                              // FirebaseEngine.addsItemToCart("1", "tez", 2.0);
                                              FirebaseEngine.pagesTracked("map_screen");
                                              //anal.logEvent(
                                              //  name: "pages_tracked",
                                              //  parameters: {
                                              //    "page_name": "map_screen"
                                              //  }
                                              //);
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .fade,
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      child: MapScreen()));
                                            },
                                            child: SizedBox(
                                              height: 48,
                                              width: 48,
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 0.0),
                                                  child: Image.asset(
                                                    "assets/icons/map.png",
                                                    height: 24,
                                                    width: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            onTap: () {
                                              FirebaseEngine.pagesTracked("profile_screen");

                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .fade,
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      child: ProfileScreen()));
                                            },
                                            child: SizedBox(
                                              height: 48,
                                              width: 48,
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 0.0),
                                                  child: Image.asset(
                                                    "assets/icons/profile.png",
                                                    height: 24,
                                                    width: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 1.sw,
                              child: TabBar(
                                dividerHeight: 0,
                                controller: mainTabController,
                                indicatorColor: AppColors.primaryVar0,
                                // overlayColor: Colors.red,
                                labelColor: AppColors.primaryText,
                                indicatorWeight: 1.0,
                                indicatorSize: TabBarIndicatorSize.label,
                                unselectedLabelColor: AppColors.secondaryText,
                                tabs: [
                                  const Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Yeeguide",
                                          style: TextStyle(
                                              fontSize: 13.5,
                                              // color: AppColors.primaryVar0,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Actus",
                                          style: TextStyle(
                                              fontSize: 13.5,

                                              // color: AppColors.primaryVar0,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        Container(
                                          height: 16,
                                          width: 16,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.primaryVar0),
                                          child: Center(
                                            child: Text(
                                              "3",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        )
                                      ],
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
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TransparentPointer(
                    child: Container(
                      // width: 1.sw,
                      // constraints: BoxConstraints(maxHeight: 1.sh * 0.5),
                      // color: Colors.blue,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SlideTransition(
                            position: _offsetAnimation,
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F3F3),

                                // color: Colors.red,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(23.0),
                                    topRight: Radius.circular(23.0)),
                              ),
                              child: Container(
                                height: 110,
                                // color: Colors.red,
                                // padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: AnimatedOpacity(
                                  opacity: tabBarOffset >= 0.5 ? 0.0 : 1.0,
                                  duration: Duration(milliseconds: 300),
                                  child: MasonryGridView.builder(
                                    gridDelegate:
                                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    scrollDirection: Axis.horizontal,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    itemCount: _suggestionMessages.length,
                                    // crossAxisCount: 3,
                                    crossAxisSpacing: 9,
                                    mainAxisSpacing: 9,

                                    itemBuilder: (context, index) {
                                      return Material(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          // borderRadius: BorderRadius.circular(15),
                                          onTap: () {
                                            FirebaseEngine.pagesTracked("chat_screen");

                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    child: ChatScreen(
                                                      shouldOpenKeyboard: true,
                                                      initialPrompt: InitialPrompt(
                                                          text: _suggestionMessages[
                                                                  index]
                                                              .substring(
                                                                  3,
                                                                  _suggestionMessages[
                                                                          index]
                                                                      .length),
                                                          shouldSendInitialPrompt:
                                                              false),
                                                    )));
                                          },
                                          onDoubleTap: () {
                                            FirebaseEngine.pagesTracked("map_screen");

                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    child: ChatScreen(
                                                      shouldOpenKeyboard: false,
                                                      initialPrompt: InitialPrompt(
                                                          text: _suggestionMessages[
                                                                  index]
                                                              .substring(
                                                                  3,
                                                                  _suggestionMessages[
                                                                          index]
                                                                      .length),
                                                          shouldSendInitialPrompt:
                                                              true),
                                                    )));
                                          },
                                          child: Container(
                                            height: 33,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            // margin: EdgeInsets.only(left: index == 0 ? 10 : 0), // Ajout d'une marge uniquement pour le premier élément
                                            decoration: BoxDecoration(
                                              // color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Text(
                                                _suggestionMessages[index],
                                                style: TextStyle(
                                                    fontSize: 12.5,
                                                    color:
                                                        AppColors.primaryText),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1.sw,
                            // color: Colors.blue.withOpacity(.5),
                            color: Color(0xFFF3F3F3),
                            child: Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 70, minWidth: 60),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 15.0,
                                        right: 0.0,
                                        bottom: MediaQuery.of(context)
                                                .padding
                                                .bottom +
                                            20,
                                        top: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 5,
                                            blurRadius: 10,
                                            offset: const Offset(0, 20),
                                            color: Colors.grey.withOpacity(.1))
                                      ],
                                      // color: AppColors.primaryText.withOpacity(.7)),
                                    ),
                                    // height: 44,
                                    child: Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          showCupertinoModalPopup<void>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CupertinoActionSheet(
                                              // title: const Text('Title'),
                                              // message: const Text('Message'),
                                              actions: <CupertinoActionSheetAction>[
                                                CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'Voir les discussions archivées',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .primaryVar0),
                                                  ),
                                                ),
                                                CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    FirebaseEngine.pagesTracked("catalog_screen");

                                                    Navigator.push(
                                                            context,
                                                            PageTransition(
                                                                type:
                                                                    PageTransitionType
                                                                        .fade,
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            500),
                                                                child:
                                                                    const CatalogScreen()))
                                                        .then((value) =>
                                                            {setState(() {})});
                                                  },
                                                  child: Text(
                                                    'Changer de yeeguide',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .primaryVar0),
                                                  ),
                                                ),
                                              ],
                                              cancelButton:
                                                  CupertinoActionSheetAction(
                                                isDefaultAction: true,
                                                isDestructiveAction: true,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Fermer',
                                                  style: TextStyle(
                                                      // color: AppColors.primaryVar0
                                                      ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          height: 57,
                                          // width: 47,
                                          child: Center(
                                            child: Icon(
                                              Icons.space_dashboard_rounded,
                                              size: 34,
                                              color: AppColors.primaryVar0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 17,
                                  child: Hero(
                                    tag: "chat-footer",
                                    child: Container(
                                      height: 57,
                                      // height: 100,
                                      // width: 1.sw,
                                      // padding: EdgeInsets.only(left: 15.0),
                                      margin: EdgeInsets.only(
                                          left: 10.0,
                                          right: 15.0,
                                          bottom: MediaQuery.of(context)
                                                  .padding
                                                  .bottom +
                                              20,
                                          top: 5.0),

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 5,
                                              blurRadius: 10,
                                              offset: const Offset(0, 20),
                                              color:
                                                  Colors.grey.withOpacity(.1))
                                        ],
                                        // color: AppColors.primaryText.withOpacity(.7)),
                                      ),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          onTap: () {
                                            FirebaseEngine.pagesTracked("chat_screen");

                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    child: ChatScreen(
                                                      shouldOpenKeyboard: true,
                                                    )));
                                          },
                                          // onLongPress: (){
                                          //   Navigator.push(
                                          //       context,
                                          //       PageTransition(
                                          //           type: PageTransitionType.fade,
                                          //           duration: const Duration(milliseconds: 500),
                                          //           child: ChatScreen(shouldOpenKeyboard: false,)));
                                          // },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                // color: Colors.red,
                                                // width: 1.sw * 0.64,
                                                // height: 190,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0),
                                                  child: Text(
                                                    // readOnly: true,
                                                    "Posez une question...",
                                                    style: TextStyle(
                                                      fontSize: 13.5,
                                                      // color: Colors.black45,
                                                      color:
                                                          AppColors.primaryText,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 44,
                                                width: 46,
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                child: Material(
                                                  color: AppColors.primaryVar0,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    onTap: () {
                                                      FirebaseEngine.logCustomEvent("mic_unavailable_usecase",{});

                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        buildCustomSnackBar(
                                                          context,
                                                          "Fonctionnalité disponible prochainement 😉",
                                                          SnackBarType.info,
                                                          showCloseIcon: false,
                                                        ),
                                                      );
                                                    },
                                                    child: SizedBox(
                                                      height: 55,
                                                      width: 47,
                                                      child: Center(
                                                        child: Image.asset(
                                                          "assets/icons/mic_bold.png",
                                                          width: 14,
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
                Positioned(
                  top: 65,
                  right: 0,
                  child: ConfettiWidget(
                    maxBlastForce: 15.0,
                    confettiController: _controllerCenterRight,
                    blastDirection: pi + 0.7, // radial value - LEFT
                    particleDrag: 0.05, // apply drag to the confetti
                    emissionFrequency: 0.19, // how often it should emit
                    numberOfParticles: 4, // number of particles to emit
                    gravity: 0.5, // gravity - or fall speed
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.yellow
                    ], // manually specify the colors to be used
                    strokeWidth: 0,
                    strokeColor: Colors.white,
                  ),
                ),
                //CENTER LEFT - Emit right
                Positioned(
                  left: 0,
                  top: 65,
                  child: ConfettiWidget(
                    maxBlastForce: 15.0,
                    confettiController: _controllerCenterLeft,
                    blastDirection: -0.8, // radial value - LEFT
                    particleDrag: 0.05, // apply drag to the confetti
                    emissionFrequency: 0.19, // how often it should emit
                    numberOfParticles: 4, // number of particles to emit
                    gravity: 0.5, // gravity - or fall speed
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.yellow,
                    ], // manually specify the colors to be used
                    strokeWidth: 0,
                    strokeColor: Colors.white,
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

class CompanyChannel extends StatelessWidget {
  const CompanyChannel({
    super.key,
    required this.companyLogo,
    required this.companyName,
    required this.date,
    required this.notification,
    required this.message,
    this.image,
  });

  final String companyLogo;
  final String companyName;
  final String date;
  final String notification;
  final String message;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
          // borderRadius: BorderRadius.circular(30),
          onTap: () {
            FirebaseEngine.logCustomEvent("canal_unavailable_usecase",{});

            ScaffoldMessenger.of(context).showSnackBar(
              buildCustomSnackBar(
                context,
                "Fonctionnalité disponible prochainement 😉",
                SnackBarType.info,
                showCloseIcon: false,
              ),
            );},
          child: Container(
            padding: EdgeInsets.only(
                left: 20.0, right: 15.0, top: 10.0, bottom: 10.0),
            width: 1.sw,
            // height: 75,
            // color: Colors.red,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          companyLogo,
                          width: 35,
                          height: 35,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companyName,
                              style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryText),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  date + (notification != "" ? " ⸱" : ""),
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: notification == ""
                                          ? FontWeight.normal
                                          : FontWeight.w400,
                                      color: notification == ""
                                          ? AppColors.secondaryText
                                          : AppColors.primaryVar0),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                if (notification != "") ...[
                                  Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primaryVar0),
                                    child: Center(
                                      child: Text(
                                        notification,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  )
                                ]
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(
                      size: 22,
                      Icons.more_vert,
                      color: AppColors.primaryText,
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 12.5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
                if (image != null) ...[
                  const SizedBox(height: 8),
                  Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage(
                              // Met /assets quand on reviendra sur mobile
                              // statusImage
                              image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.30),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ))
                ]
              ],
            ),
          )),
    );
  }
}

class CompanyStatus extends StatelessWidget {
  const CompanyStatus({
    super.key,
    required this.companyName,
    required this.statusNumber,
    required this.statusImage,
  });

  final String companyName;
  final String statusNumber;
  final String statusImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      // height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(
              // Met /assets quand on reviendra sur mobile
              statusImage
              // "assets/images/logo_ddd.png"
              ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.80),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.black.withOpacity(.6),
            onTap: () {
              FirebaseEngine.logCustomEvent("status_unavailable_usecase",{});

            },
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (statusNumber != "0") ...[
                    Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(.3)),
                      child: Center(
                        child: Text(
                          statusNumber,
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox()
                  ],
                  Text(
                    companyName,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
