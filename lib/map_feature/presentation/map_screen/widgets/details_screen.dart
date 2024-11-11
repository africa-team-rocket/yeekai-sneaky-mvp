import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:yeebus_filthy_mvp/map_feature/presentation/map_screen/map_screen.dart';

import '../../../../core/commons/theme/app_colors.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/presentation/app_global_widgets.dart';
import '../../../domain/model/main_place.dart';

class DetailsScreen extends StatefulWidget {
  final Function closeDetails;
  final MainPlace placeDetails;
  const DetailsScreen(
      {super.key, required this.closeDetails, required this.placeDetails});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class ProfileSection extends StatelessWidget {
  final String title;

  final String? icon;
  final bool? isTrueTopOrBottomFalse;
  final void Function() onTap;
  const ProfileSection({
    super.key,
    required this.title,
    this.icon,
    this.isTrueTopOrBottomFalse,
    required this.onTap,
  });

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

class _DetailsScreenState extends State<DetailsScreen> {
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
                                            itemCount: widget
                                                .placeDetails
                                                .photos
                                                .length, // Number of images in the list
                                            itemBuilder: (context, index) {
                                              // Build a container for each image in the list
                                              return Container(
                                                height: 130,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(widget
                                                            .placeDetails
                                                            .photos[
                                                        index]), // Use the image path from the list
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
                                          widget.placeDetails.placeName +
                                              " : " +
                                              widget.placeDetails
                                                  .shortDescription,
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
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: AppColors.primaryVar0,
                                                  size: 20.0,
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  "${widget.placeDetails.rating}  •  ${widget.placeDetails.floor}  •  ${widget.placeDetails.building}",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .secondaryText,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.8,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              widget.placeDetails.timeDetail,
                                              style: TextStyle(
                                                  color:
                                                      AppColors.secondaryText,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.8,
                                                  fontSize: 14),
                                            ),
                                          ],
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
                              'À propos',
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
                                          "${widget.placeDetails.about}",
                                          textAlign: TextAlign.justify,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            if (widget.placeDetails is Office) ...[
                              const SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Responsable',
                                style: TextStyle(
                                  color: Color(0xFF302F2E),
                                  fontSize: 17,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0.0),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: (widget.placeDetails as Office)
                                        .responsables
                                        .length,
                                    itemBuilder: (context, index) {
                                      // final officeHour =
                                      //     (widget.placeDetails as Office)
                                      //         .officeHours[index];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        child: Material(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            onTap: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                buildCustomSnackBar(
                                                  context,
                                                  "Fonctionnalité bientôt disponible 😉",
                                                  SnackBarType.info,
                                                ),
                                              );
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  // height: 60,
                                                  width: 1.sw,
                                                  // margin: EdgeInsets.symmetric(horizontal: 15.0),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 0.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    border: Border.all(
                                                        width: 0.9,
                                                        color: Colors.white),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 150,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            SizedBox(
                                                              // color: Colors.yellow,
                                                              // const Color.fromRGBO(255, 193, 7, 1),
                                                              width: 120,
                                                              height: 150,
                                                              child: Stack(
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/images/thierry_kondengar.png",
                                                                    height: 150,
                                                                    width: 170,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 15,
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    Container(
                                                              // width: 1.sw,
                                                              // color: Colors.green,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        (widget.placeDetails
                                                                                as Office)
                                                                            .responsables[index]
                                                                            .fullName,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          height:
                                                                              1,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              AppColors.primaryText,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
                                                                      Text(
                                                                        (widget.placeDetails
                                                                                as Office)
                                                                            .responsables[index]
                                                                            .email,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Colors.black54,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  Container(
                                                                    // color: Colors.red,
                                                                    // width: 1.sw * 0.22,
                                                                    // height: 50,
                                                                    child: Text(
                                                                      (widget.placeDetails
                                                                              as Office)
                                                                          .responsables[
                                                                              index]
                                                                          .description,
                                                                      maxLines:
                                                                          3,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ))
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 7,
                                                      ),
                                                      Row(
                                                        children: [
                                                          if (
                                                              // AppConstants
                                                              // .yeeguidesList[index].languages
                                                              // .contains(Languages.fr)
                                                              true) ...[
                                                            Expanded(
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        6,
                                                                    vertical:
                                                                        6),
                                                                decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .secondaryText
                                                                        .withOpacity(
                                                                            .2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        (widget.placeDetails
                                                                                as Office)
                                                                            .responsables[index]
                                                                            .position,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          height:
                                                                              1.2,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              AppColors.primaryText,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                          // AppConstants
                                                          // .yeeguidesList[index].languages
                                                          // .contains(Languages.wol)
                                                          if ((widget.placeDetails
                                                                  as Office)
                                                              .responsables[
                                                                  index]
                                                              .isTeacher) ...[
                                                            Expanded(
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        6,
                                                                    vertical:
                                                                        6),
                                                                decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .secondaryText
                                                                        .withOpacity(
                                                                            .2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        "Professeur",
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          height:
                                                                              1.2,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              AppColors.primaryText,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          if (
                                                              // AppConstants
                                                              // .yeeguidesList[index].languages
                                                              // .contains(Languages.fr)
                                                              true) ...[
                                                            Expanded(
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        6,
                                                                    vertical:
                                                                        6),
                                                                decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .secondaryText
                                                                        .withOpacity(
                                                                            .2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        (widget.placeDetails
                                                                                as Office)
                                                                            .responsables[index]
                                                                            .phoneNumber,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          height:
                                                                              1.2,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              AppColors.primaryText,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                          // AppConstants
                                                          // .yeeguidesList[index].languages
                                                          // .contains(Languages.wol)

                                                          Expanded(
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          6,
                                                                      vertical:
                                                                          6),
                                                              decoration: BoxDecoration(
                                                                  color: AppColors
                                                                      .secondaryText
                                                                      .withOpacity(
                                                                          .2),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      (widget.placeDetails
                                                                              as Office)
                                                                          .responsables[
                                                                              index]
                                                                          .linkedin,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        height:
                                                                            1.2,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: AppColors
                                                                            .primaryText,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Services fournis',
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
                                          ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    10.0), // Nécessaire pour éviter les erreurs de dimensionnement dans les `Column`
                                            physics:
                                                NeverScrollableScrollPhysics(), // Désactive le défilement dans le `ListView.builder`
                                            itemCount:
                                                (widget.placeDetails as Office)
                                                    .servicesProvided
                                                    .length,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    (widget.placeDetails
                                                                as Office)
                                                            .servicesProvided[
                                                        index],
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                  if (index <
                                                      (widget.placeDetails
                                                                  as Office)
                                                              .servicesProvided
                                                              .length -
                                                          1)
                                                    Divider(
                                                      color: Colors.grey
                                                          .withOpacity(.22),
                                                      height: 25,
                                                    ),
                                                ],
                                              );
                                            },
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
                                'Horaires',
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
                                          ListView.builder(
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                (widget.placeDetails as Office)
                                                    .officeHours
                                                    .length,
                                            itemBuilder: (context, index) {
                                              final officeHour = (widget
                                                      .placeDetails as Office)
                                                  .officeHours[index];
                                              final isUnavailable =
                                                  officeHour ==
                                                      "indisponible (congés)";

                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        daysOfWeek[
                                                            index], // Affichage du jour
                                                        style: TextStyle(),
                                                      ),
                                                      Text(
                                                        officeHour,
                                                        textAlign:
                                                            TextAlign.justify,
                                                        style: TextStyle(
                                                          color: isUnavailable
                                                              ? AppColors
                                                                  .bootstrapRed
                                                              : Colors.black,
                                                          fontWeight:
                                                              isUnavailable
                                                                  ? FontWeight
                                                                      .w600
                                                                  : FontWeight
                                                                      .normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if (index <
                                                      (widget.placeDetails
                                                                  as Office)
                                                              .officeHours
                                                              .length -
                                                          1)
                                                    Divider(
                                                      color: Colors.grey
                                                          .withOpacity(.22),
                                                      height: 25,
                                                    ),
                                                ],
                                              );
                                            },
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
                            ],
                            if (widget.placeDetails is Restroom) ...[
                              const SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Caractéristiques',
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
                                    const SizedBox(height: 15),
                                    if (widget.placeDetails is Restroom) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Niveau de fréquentation"),
                                                Text(
                                                    "${(widget.placeDetails as Restroom).occupancyLevel}"),
                                              ],
                                            ),
                                            Divider(
                                              color:
                                                  Colors.grey.withOpacity(.25),
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Urinoirs disponible"),
                                                Text(
                                                    "${(widget.placeDetails as Restroom).urinalsAvailable}"),
                                              ],
                                            ),
                                            Divider(
                                              color:
                                                  Colors.grey.withOpacity(.25),
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Niveau de propreté"),
                                                Text(
                                                    "${(widget.placeDetails as Restroom).cleanlinessLevel}"),
                                              ],
                                            ),
                                            Divider(
                                              color:
                                                  Colors.grey.withOpacity(.25),
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Eau disponible"),
                                                Text("Oui"),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                            Text(
                              'Note et commentaires',
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
                                  const SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Ce que les autres pensent de cet endroit"),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        MapEntityRating(),
                                        Divider(
                                          color: Colors.grey.withOpacity(.25),
                                          height: 40,
                                        ),
                                        if (widget.placeDetails
                                            is Restroom) ...[
                                          UserComment(
                                              username: "Adji Sonko",
                                              userPicture:
                                                  "assets/images/adji_sonko.png",
                                              userComment:
                                                  "Toilettes très propres idéal pour les filles, tout ce qui est abulitions etc"),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          UserComment(
                                              username: "Ousmane Sarr",
                                              userPicture:
                                                  "assets/images/ousmane_sarr.png",
                                              userComment:
                                                  "Une réparation des portières côté homme ne serait pas de refus."),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                        ] else if (widget.placeDetails
                                            is Office) ...[
                                          UserComment(
                                            username: "Fatou Ba",
                                            userPicture:
                                                "assets/images/adji_sonko.png",
                                            userComment:
                                                "Mr. Kondengar est toujours prêt à aider et répond aux questions avec beaucoup de patience et de professionnalisme. Un grand atout pour notre campus !",
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          UserComment(
                                            username: "Seydou Ndiaye",
                                            userPicture:
                                                "assets/images/ousmane_sarr.png",
                                            userComment:
                                                "J'ai été impressionnée par la qualité de service de Mr. Kondengar. Il sait mettre les étudiants à l'aise et s'assure que tout est bien compris.",
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ],
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
                                                  widget.closeDetails();
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
                                                      "${widget.placeDetails.placeName}",
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
                                    SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              border: Border.all(
                                                color: widget
                                                        .placeDetails.isOpen
                                                    ? AppColors.bootstrapGreen
                                                    : AppColors.bootstrapRed,
                                              )),
                                          child: Text(
                                            widget.placeDetails.isOpen
                                                ? "Ouvert"
                                                : "Fermé",
                                            style: TextStyle(
                                                color: widget
                                                        .placeDetails.isOpen
                                                    ? AppColors.bootstrapGreen
                                                    : AppColors.bootstrapRed,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13),
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

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    scrollController.removeListener(() {});
    super.dispose();
  }

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
}
