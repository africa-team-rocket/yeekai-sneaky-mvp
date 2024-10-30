import 'dart:ui';

import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/commons/theme/app_colors.dart';
import '../../../../core/presentation/app_global_widgets.dart';

class CatalogScreenHeader extends StatefulWidget {
  const CatalogScreenHeader({super.key});

  @override
  State<CatalogScreenHeader> createState() => _CatalogScreenHeaderState();
}

class _CatalogScreenHeaderState extends State<CatalogScreenHeader> {
  bool isSearchModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65 + MediaQuery.of(context).padding.top,
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
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top/2, left: 5.0, right: 10.0),
              width: 1.sw,
              height: 95,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.1),
                // color: Colors.red,
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
                            Container(
                              height: 45,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              width: 1.sw * 0.73,
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
                                        width: 42,
                                        child: Center(
                                          child: Image.asset(
                                            "assets/icons/search_lit_icon.png",
                                            height: 18,
                                            width: 18,
                                          ),
                                        ),
                                      ),
                                      Text("Rechercher.."),
                                    ],
                                  ),
                                  Material(
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
                                      child: const SizedBox(
                                        height: 40,
                                        width: 42,
                                        child: Center(
                                            child: Icon(
                                          Icons.clear,
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Material(
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
                                    "Annuler",
                                    style: TextStyle(
                                        color: AppColors.primaryText,
                                        fontWeight: FontWeight.w400),
                                  )),
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
                            flex: 7,
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      onTap: () {
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
                                            padding: const EdgeInsets.only(
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
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        "Catalogue yeeguide",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryText,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    onTap: () {
                                      //TODO: Implement search

                                      // // widget.onPop();
                                      // setState(() {
                                      //   isSearchModeEnabled = true;
                                      // });
                                      // Navigator.pop(context);

                                      ////While this is not implemented
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        buildCustomSnackBar(
                                          context,
                                          "Fonctionnalité disponible prochainement 😉",
                                          SnackBarType.info,
                                          showCloseIcon: false,
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      height: 60,
                                      width: 42,
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
                                Material(
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
                                        "assets/icons/help.png",
                                        height: 22,
                                        width: 22,
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
              )),
        ),
      ),
    );
  }
}
