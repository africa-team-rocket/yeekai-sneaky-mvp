import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

import '../../../map_feature/presentation/map_screen/map_screen.dart';
import '../../commons/theme/app_colors.dart';
import '../../commons/utils/app_constants.dart';
import '../../commons/utils/raw_explandable_bottom_sheet.dart';
import '../../data/local/entity/current_dest_local_entity.dart';
import 'cubit/root_app_bar_cubit.dart';
import 'cubit/root_app_bar_state.dart';


class RootAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RootAppBar({
    super.key,
    required this.isActive,
    required this.rootContext,
    this.onTextChanged,
    this.textValue,
  });

  final bool isActive;
  final BuildContext rootContext;
  final Function(String value)? onTextChanged;
  final String? textValue;

  @override
  Size get preferredSize => const Size.fromHeight(145);
  // Size get preferredSize => Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return
      Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                width: 1.sw,
                height: 5,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Couleur de l'ombre
                      spreadRadius: 0.2, // Rayon de dispersion de l'ombre
                      blurRadius: 6, // Rayon de flou de l'ombre
                      offset: const Offset(
                          0, 2), // Décalage de l'ombre (horizontal, vertical)
                    ),
                  ],
                ),
              ),
            ),
            AppBar(
              automaticallyImplyLeading: false, // Masquer le bouton de retour
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent, // <-- SEE HERE
                statusBarIconBrightness:
                Brightness.dark, //<-- For Android SEE HERE (dark icons)
                statusBarBrightness:
                Brightness.light, //<-- For iOS SEE HERE (dark icons)
              ),
              elevation: 0,
              toolbarHeight: 145,
              backgroundColor: Colors.white,
              title:

              SizedBox(
                height: 145,
                child: BlocProvider(

                  create: (_) => RootAppBarCubit()..getFavDestinations(),
                  child: BlocBuilder<RootAppBarCubit, RootAppBarState>(
                      builder: (context, state) {
                        return Stack(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Positioned(
                            top: 66.0,
                            left: 0.0,
                            right: 0.0,
                            bottom: 0.0,
                            child: Material(
                              color: Colors.white,
                              child: SizedBox(
                                width: AppConstants.screenWidth,
                                height: 70,
                                child:  state.favDestinations.length >= 3 ? Row(
                                  // mainAxisAlignment: MainAxisAlignment,
                                  children: [
                                      CurrentDestShortcut(currentDest: state.favDestinations[0]),
                                      CurrentDestShortcut(currentDest: state.favDestinations[1]),
                                      CurrentDestShortcut(currentDest: state.favDestinations[2]),
                                      OtherDestsShortcut(rootContext: rootContext),
                                  ],
                                ) : ShortcutsShimmer(),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 55,
                            width: AppConstants.screenWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1.5),
                                      color: Colors.grey.withOpacity(.14))
                                ]),
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: !isActive
                                    ? () {
                                  FocusScope.of(rootContext).unfocus();
                                  Navigator.push(
                                    rootContext,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          duration: const Duration(milliseconds: 100),
                                          child: MapScreen(searchMode: true))
                                    // MaterialPageRoute (
                                    //   builder: (BuildContext context) => MapScreen(searchMode: true),
                                    // ),
                                  );
                                }
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(isActive ?
                                      "assets/icons/back_left_icon_blue.png"
                                          : "assets/icons/search.png",
                                        height: 16,
                                        width: 16,
                                      ),
                                      // ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            isActive
                                                ? Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                TextField(
                                                  // controller: textEditingController,
                                                  //   onChanged:(value)=>onTextChanged!(value),
                                                    decoration: const InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText:
                                                        // // hintText ??
                                                        "Recherchez ici..."),
                                                    keyboardType:
                                                    TextInputType.text,
                                                    onSubmitted: (value) {
                                                      // onFieldSubmit!(value);
                                                    }),
                                              ],
                                            )
                                                : Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Où voulez vous aller ?",
                                                  style: TextStyle(
                                                      color: AppColors.primaryText,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14.sp),
                                                ),
                                                Text(
                                                  "Au travail, à la maison..",
                                                  style: TextStyle(
                                                      color: AppColors.secondaryText,
                                                      fontSize: 11.5.sp,
                                                      fontWeight: FontWeight.normal),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      InkWell(
                                        onTap: (){},
                                        borderRadius: BorderRadius.circular(50),
                                        radius: 16,
                                        child: SizedBox(
                                          height: 60,
                                          width: 63,
                                          child: Center(
                                            child: CircleAvatar(
                                              radius: 14, // ou toute autre taille souhaitée
                                              backgroundImage: AssetImage("assets/images/profile_pic_placeholder.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Image.asset(
                                      //   textValue == null || textValue!.isEmpty ? "assets/icons/mic_circle.png" : "assets/icons/cross_circle.png",
                                      //   height: 33,
                                      //   width: 33,
                                      // ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Positioned(
                          //     top: 66.0, left: 0.0,child: Text(state.favDestinations.toString(),style: TextStyle(color: Colors.black),)),
                        ],

                      );
                    }
                  ),
                ),
              ),
            ),
          ]);
  }
}

class ShortcutsShimmer extends StatelessWidget {
  const ShortcutsShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.secondaryText.withOpacity(.5),
      highlightColor: AppColors.secondaryText,
      period: Duration(milliseconds: 1000),
      child: Row(
        children: [
          CurrentDestShimmer(),
          CurrentDestShimmer(),
          CurrentDestShimmer(),
          CurrentDestShimmer(),
        ],
      ),
    );
  }
}

class CurrentDestShimmer extends StatelessWidget {
  const CurrentDestShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        // color: Colors.blue,
        padding: const EdgeInsets.only(bottom: 8,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: AppColors.secondaryText.withOpacity(.5),
                    shape: BoxShape.circle
                )
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: 4,
                width: 28,
                decoration: BoxDecoration(
                    color: AppColors.secondaryText.withOpacity(.5),
                    borderRadius: BorderRadius.circular(5)
                )
            ),
          ],
        ),
      ),
    );
  }
}

class OtherDestsShortcut extends StatelessWidget {
  const OtherDestsShortcut({
    super.key,
    required this.rootContext,
  });

  final BuildContext rootContext;

  @override
  Widget build(BuildContext context) {
    return Expanded(
    child: InkWell(
      borderRadius: BorderRadius.circular(20),

      onTap: (){
        // Navigator.push(
        //     rootContext,
        //     PageTransition(
        //         type: PageTransitionType.leftToRight,
        //         duration: const Duration(milliseconds: 400),
        //         child: CurrentDestinationsList())
        //   // MaterialPageRoute (
        //   //   builder: (BuildContext context) => MapScreen(searchMode: true),
        //   // ),
        // ).then((value) => {
        //   context.read<RootAppBarCubit>().getFavDestinations()
        // });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: AppColors.primaryVar0,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      width: .4, color: AppColors.secondaryText)
                // border: Border
              ),
              child: Center(
                  child: Image.asset("assets/icons/more_fav_white.png",
                    height: 10,
                    width: 10,
                  )),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              "Autres",
              style: TextStyle(
                  color: AppColors.secondaryText, fontSize: 12, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    ),
                                    );
  }
}

class CurrentDestShortcut extends StatelessWidget {
  final CurrentDestLocalEntity currentDest;
  const CurrentDestShortcut({
    super.key, required this.currentDest,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: (){

        },
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(currentDest.iconUrl,
                    height: 20,
                    width: 20,
                    // colorFilter: ColorFilter.mode(AppColors.primaryVar0, BlendMode.srcIn)
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                currentDest.label,
                style: TextStyle(
                    color: AppColors.secondaryText, fontSize: 12, fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BsTopBar extends StatelessWidget{
  const BsTopBar({
    super.key,
    required this.isActive,
    required this.rootContext,
    this.onTextChanged,
    this.textValue,
    required this.bsKey,
    required this.onTap,
    required this.onBackPressed,
    this.selectedEntityTitle,
    required this.textEditingController,
    this.onSubmitValue, required this.onCancelSearch,
  });

  final bool isActive;
  final BuildContext rootContext;
  final TextEditingController textEditingController;
  final Function onTap;
  final Function onCancelSearch;
  final Function onBackPressed;
  final GlobalKey<ExpandableBottomSheetState> bsKey;
  final Function(String value)? onTextChanged;
  final Function(String value)? onSubmitValue;
  final String? textValue;
  final String? selectedEntityTitle;

  // @override
  // Size get preferredSize => const Size.fromHeight(150);
  // // Size get preferredSize => Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    // Mon intuition me dit que tout englober dans le valuelistenable juste pour changer un background,
    // c'est pas forcément optimal, pourquoi pas utiliser un stack comme ça le value listenable n'affectera que le background ?
    return ValueListenableBuilder<SheetPositionPair>(
        valueListenable: bsKey.currentState!.sheetPosition,
        builder: (context, sheetPosition, child) {
          return Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          height: 145,
          // color: Colors.red,
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if(sheetPosition.gSheetPosition >= 0.95) ...[
                AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  // top: 66.0,
                  top: sheetPosition.gSheetPosition == 1.0 && isActive ? 66.0 : -5.2,
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    // top: 66.0,
                    opacity: sheetPosition.gSheetPosition == 1.0 && isActive ? 1.0 : 0.0,
                    child: Material(
                      // color: Colors.red,

                      color: Colors.white,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.3),
                        width: AppConstants.screenWidth,
                        height: 70,
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),

                                onTap: (){

                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            // border: Border.all(
                                            //     width: .4, color: AppColors.secondaryText)
                                          // border: Border
                                        ),
                                        child: Center(
                                          child: Image.asset("assets/icons/home_fav_blue.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Maison",
                                        style: TextStyle(
                                            color: AppColors.secondaryText, fontSize: 12, fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),

                                onTap: (){

                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            // border: Border.all(
                                            //     width: .4, color: AppColors.secondaryText)
                                          // border: Border
                                        ),
                                        child: Center(
                                          child: Image.asset("assets/icons/work_fav_blue.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Travail",
                                        style: TextStyle(
                                            color: AppColors.secondaryText, fontSize: 12, fontWeight: FontWeight.w400),

                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),

                                onTap: (){

                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            // border: Border.all(
                                            //     width: 0, color: AppColors.secondaryText)
                                          // border: Border
                                        ),
                                        child: Center(
                                            child: Image.asset("assets/icons/cart_fav_blue.png",
                                              height: 20,
                                              width: 20,
                                            )),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Courses",
                                        style: TextStyle(
                                            color: AppColors.secondaryText, fontSize: 12, fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),

                                onTap: (){
                                  // Navigator.push(
                                  //     rootContext,
                                  //     PageTransition(
                                  //         type: PageTransitionType.leftToRight,
                                  //         duration: const Duration(milliseconds: 400),
                                  //         child: CurrentDestinationsList())
                                  //   // MaterialPageRoute (
                                  //   //   builder: (BuildContext context) => MapScreen(searchMode: true),
                                  //   // ),
                                  // );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: AppColors.primaryVar0,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                                width: .4, color: AppColors.secondaryText)
                                          // border: Border
                                        ),
                                        child: Center(
                                            child: Image.asset("assets/icons/more_fav_white.png",
                                              height: 14,
                                              width: 14,
                                            )),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Autres",
                                        style: TextStyle(
                                            color: AppColors.secondaryText, fontSize: 12, fontWeight: FontWeight.w400),
                                      )
                                    ],
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
              ],
              Container(
                margin: const EdgeInsets.only(top: 10, left: 19.0, right: 19.0),
                height: 55,
                width: AppConstants.screenWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 1.5),
                          color: Colors.grey.withOpacity(.18))

                    ]),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: !isActive
                        ? () => onTap()
                    // () {
                    // FocusScope.of(rootContext).unfocus();
                    // Navigator.push(
                    //   rootContext,
                    //   MaterialPageRoute (
                    //     builder: (BuildContext context) => const SearchScreen(),
                    //   ),
                    // );
                    // }
                        : null,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: (){
                            FocusScope.of(context).unfocus();
                            Future.delayed(const Duration(milliseconds: 390),
                                    () {
                                  onBackPressed();
                                });
                          },
                          child: SizedBox(
                            // padding: EdgeInsets.only(left: 20.0),
                            height: 55.0,
                            width: 56.0,
                            // decoration: BoxDecoration(
                            //   // color: Colors.red,
                            //   borderRadius: BorderRadius.circular(20)
                            // ),
                            child: Center(
                              child: Image.asset(
                              "assets/icons/back_left_icon_blue.png",
                                height: 16,
                                width: 16,
                              ),
                            ),
                          ),
                        ),
                        // ),
                        const SizedBox(
                          width: 0,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  isActive ? TextField(
                                    controller: textEditingController,
                                    //   onChanged:(value)=>onTextChanged!(value),
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                          hintStyle: TextStyle(
                                            fontSize: 14
                                          ),
                                          border: InputBorder.none,
                                          hintText:
                                          // // hintText ??
                                          "Recherchez ici..."),
                                      keyboardType:
                                      TextInputType.text,
                                      onSubmitted: (value) {
                                        onSubmitValue!(value);
                                      }) : Text(
                                    selectedEntityTitle != null ? selectedEntityTitle! : "Recherchez ici...",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              )
                              //     : Column(
                              //   mainAxisAlignment:
                              //   MainAxisAlignment.spaceBetween,
                              //   crossAxisAlignment:
                              //   CrossAxisAlignment.start,
                              //   children: [
                              //     Text(
                              //       "Où voulez vous aller ?",
                              //       style: TextStyle(
                              //           color: AppColors.primaryText,
                              //           fontWeight: FontWeight.w500,
                              //           fontSize: 14.sp),
                              //     ),
                              //     Text(
                              //       "Au travail, à la maison..",
                              //       style: TextStyle(
                              //           color: AppColors.secondaryText,
                              //           fontSize: 11.5.sp,
                              //           fontWeight: FontWeight.normal),
                              //     )
                              //   ],
                              // )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: (){
                            FocusScope.of(context).unfocus();
                            Future.delayed(const Duration(milliseconds: 390),
                                    () {
                              if(textValue != null && textValue!.isNotEmpty){

                                    onCancelSearch();
                              }
                                    debugPrint("Eyelashes lashed !");
                                });
                          },
                          child: Image.asset(
                            isActive ?
                            textValue == null || textValue!.isEmpty ? "assets/icons/mic_circle.png" : "assets/icons/cross_circle.png"
                                :
                            selectedEntityTitle == null || selectedEntityTitle!.isEmpty ? "assets/icons/mic_circle.png" : "assets/icons/cross_circle.png",
                            height: 33,
                            width: 33,
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
