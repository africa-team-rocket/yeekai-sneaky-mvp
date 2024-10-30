import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../../../../core/commons/theme/app_colors.dart';
import '../../../../core/commons/utils/app_constants.dart';
import '../../../domain/model/yeeguide.dart';

class YeeguidesSnapList extends StatefulWidget {
  const YeeguidesSnapList(
      {Key? key, required this.onSelectedYeeguide, required this.onTapYeeguide})
      : super(key: key);
  final Function(int newIndex) onSelectedYeeguide;
  final Function(int newIndex) onTapYeeguide;

  @override
  State<YeeguidesSnapList> createState() => _YeeguidesSnapListState();
}

class _YeeguidesSnapListState extends State<YeeguidesSnapList> {
  // List<int> data = [];
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScrollSnapListState> _snapListKey =
      GlobalKey<ScrollSnapListState>();

  @override
  void dispose() {
    // Idem ici aussi :
    // widget.onSelectedYeeguide(5);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // for (int i = 0; i < 10; i++) {
    //   data.add(Random().nextInt(100) + 1);
    // }

    // _scrollController.addListener(() {
    // if (_scrollController.) {
    //   _scrollController.jumpTo(2);
    //   _scrollController.animateTo(5.0,
    //       duration: Duration(milliseconds: 5000), curve: Curves.bounceInOut);
    //   // }

    //   if (_scrollController.position.atEdge &&
    //       _scrollController.position.pixels == 0) {
    //     // On est en haut de la liste
    //     debugPrint("ZA ENDOOOO TOP !!!");
    //     // Placez ici la logique pour faire boucler vers la fin
    //   } else if (_scrollController.position.atEdge &&
    //       _scrollController.position.pixels ==
    //           _scrollController.position.maxScrollExtent) {
    //     // On est en bas de la liste
    //     debugPrint("ZA ENDOOOO BOTTOM !!!");
    //     // Placez ici la logique pour faire boucler vers le début
    //     _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    //   }
    // });
  }

  void _onItemFocus(int index) {
    // print(index);
    // setState(() {
    //   _focusedIndex = index;
    // });
    print("TOEEE");
    // if (!AppConstants.availableYeeguides.contains(AppConstants.yeeguidesList[index].id)){
      widget.onSelectedYeeguide(index);
    // }

  }

  Widget _buildListItem(BuildContext context, int index) {
    // Utilisez l'opérateur modulo pour obtenir un index cyclique
    final realIndex = index % AppConstants.yeeguidesList.length;

    //horizontal
    return Container(
      margin: realIndex == 0 ? const EdgeInsets.only(left: 20.0) : null,
      width: 280,
      // 405
      // height: AppConstants.screenHeight * 0.53,
      child: Container(
        decoration: BoxDecoration(
            // color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                  color: Colors.grey.withOpacity(.2))
            ]),
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // height: AppConstants.screenHeight * 0.53,
              width: 280,
              child: Material(
                color: Colors.white, // Couleur de fond blanche du Material
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    widget.onTapYeeguide(index);
                    _snapListKey.currentState?.focusToItem(index);
                    // _onItemFocus(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 7.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          // color: Colors.red,
                          height: 180,
                          width: 220,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Hero(
                                  tag: "tag-$index",
                                  child: Image.asset(
                                    // "assets/yeeguides/songo_guide.png",
                                    AppConstants.yeeguidesList[index]
                                        .profilePictureAsset,
                                    height: 300,
                                    width: 300,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          AppConstants.yeeguidesList[index].name,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          AppConstants.yeeguidesList[index].tag,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.2,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Yeeguide.buildRichText(
                            AppConstants.yeeguidesList[index].shortBio),
                        // RichText(
                        //   textAlign: TextAlign.justify,
                        //   text: TextSpan(
                        //     text: ,
                        //
                        //   // text: "En tant que leader, il est de mon devoir de te guider à travers les rues de Dakar. Alors",
                        //       style: TextStyle(
                        //           // fontSize: 14,
                        //           // height: 0.8,
                        //           color: AppColors.primaryText),
                        //       children: [
                        //         TextSpan(
                        //           text: " #EnMarche",
                        //           style: TextStyle(
                        //               color: AppColors.primaryVar0,
                        //               // fontWeight: FontWeight.w400,
                        //               fontSize: 14),
                        //         ),
                        //         TextSpan(
                        //           text: " la révolution !",
                        //           style: TextStyle(
                        //               color: AppColors.primaryText,
                        //               // fontWeight: FontWeight.w400,
                        //               fontSize: 14),
                        //         ),
                        //       ]),
                        // ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 10),
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
                                      width: 7,
                                    ),
                                    Text(
                                      AppConstants.yeeguidesList[index].category,
                                      style: TextStyle(
                                        fontSize: 14,
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
                        // ElevatedButton(
                        //   onPressed: () {
                        //     // Navigator.push(
                        //     //     context,
                        //     // PageTransition(
                        //     //     type: PageTransitionType.fade,
                        //     //     duration: const Duration(milliseconds: 100),
                        //     //     child: RegisterAuthScreen()));
                        //     // _controller.nextPage(duration: Duration(milliseconds: 400), curve: Curves.linear);
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     surfaceTintColor: Colors.blue,
                        //     backgroundColor: const Color(0xFFEFF6FC),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(
                        //           5), // Ajustez la valeur pour le border radius souhaité
                        //     ),
                        //     elevation: 0,
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal:
                        //             10), // Espacement intérieur pour le bouton
                        //     minimumSize: const Size(double.infinity,
                        //         40), // Pour que le bouton prenne toute la largeur de l'écran
                        //   ),
                        //   child: Text(
                        //     "Voir profil",
                        //     style: TextStyle(
                        //       color: AppColors.primaryVar0,
                        //       fontWeight: FontWeight.w400,
                        //       fontSize: 15,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!AppConstants.availableYeeguides.contains(AppConstants.yeeguidesList[index].id)) ...[
              Positioned(
                left: -38,
                top: 18,
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(-30 / 360),
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                      color: Color(0xFFFCDD72),
                      child: Text("Indisponible")),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  ///Override default dynamicItemSize calculation
  double customEquation(double distance) {
    return 1 - min(distance.abs() / 500, 0.2);
    // return 1-(distance/1000);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // margin: EdgeInsets.only(top: 7.0),
      // color: Colors.red,
      height: 375,
      width: 1.sw,
      // color: Colors.blue,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ScrollSnapList(
              key: _snapListKey,
              onItemFocus: _onItemFocus,
              initialIndex: 5,
              // scrollPhysics: BouncingScrollPhysics(),
              // padding: EdgeInsets.only(top: 5),
              itemSize: 280,
              onReachEnd: () {
                // _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                // debugPrint("ZA ENDOOOO !!!");
                // _scrollController.jumpTo(_scrollController.position.minScrollExtent);
              },
              // margin: EdgeInsets.symmetric(,
              // padding: EdgeInsets.symmetric(horizontal: 20.0),
              selectedItemAnchor: SelectedItemAnchor.START,
              itemBuilder: _buildListItem,
              itemCount: AppConstants.yeeguidesList.length,
              dynamicItemSize: true,
              listController: _scrollController,
              dynamicSizeEquation: customEquation, //optional
            ),
          ),
        ],
      ),
    );
  }
}
