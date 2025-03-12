import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yeebus_filthy_mvp/main_feature/presentation/catalog_screen/widgets/catalog_header.dart';

import '../../../core/commons/theme/app_colors.dart';
import '../../../core/commons/utils/app_constants.dart';
import '../../../core/commons/utils/firebase_engine.dart';
import '../../../core/di/locator.dart';
import '../../../core/presentation/app_global_widgets.dart';
import '../../domain/model/yeeguide.dart';
import '../home_screen/home_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

void _showAlertDialog(BuildContext innerContext, Yeeguide newYeeguide) {
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
          'Vous êtes sur le point de remplacer votre yeeguide actuel qui est ${Yeeguide.getById(locator.get<SharedPreferences>().getString("yeeguide_id") ?? "").name} par ${newYeeguide.name}',
          style: TextStyle(fontSize: 15.5, color: AppColors.primaryText),
        ),
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          /// This parameter indicates this action is the default,
          /// and turns the action's text to bold text.
          // isDefaultAction: true,
          onPressed: () {
            FirebaseEngine.pagesTracked("pop_from_catalog_screen");

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
            FirebaseEngine.logCustomEvent("yeeguide_available_selected_from_catalog", {"yeeguide_id":newYeeguide.id});


            locator
                .get<SharedPreferences>()
                .setString("yeeguide_id", newYeeguide.id);
                
            // Future.delayed(
            //     Duration(milliseconds: 500),
            //     () => {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //               buildCustomSnackBar(context,
            //                   "Yeeguide changé avec succès", SnackBarType.info))
            //         });
            Navigator.pop(context);
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    duration: const Duration(milliseconds: 500),
                    child: HomeScreen()));
          },
          child: Text(
            'Oui svp',
            style: TextStyle(color: AppColors.primaryVar0),
          ),
        ),
      ],
    ),
  );
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  Widget build(BuildContext initialContext) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,

        floatingActionButton: FloatingActionButton(
          elevation: 3.0,
          onPressed: () {
            // TODO: Implement the add yeeguide feature

            FirebaseEngine.logCustomEvent("unavailable_add_yeeguide", {});

            //While this is not implemented, we will show a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              buildCustomSnackBar(
                context,
                "Fonctionnalité disponible prochainement 😉",
                SnackBarType.info,
                showCloseIcon: false,
              ),
            );
          },
          child: Icon(
            Icons.add_rounded,
            size: 40,
            color: Colors.white,
          ),
          backgroundColor: AppColors.primaryText,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: 1.sw,
            height: 1.sh,
            child: Stack(
              children: [
                SizedBox(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 20),
                    padding: EdgeInsets.only(top: 90.0 + MediaQuery.of(context).padding.top, bottom: 25.0),
                    shrinkWrap: true,
                    itemCount: AppConstants.yeeguidesOriginalList.length,
                    itemBuilder: (context, index) {
                      Yeeguide item = AppConstants.yeeguidesOriginalList[index];
                      return YeeguideResumeWidget(yeeguide: item);
                    },
                  ),
                ),
                CatalogScreenHeader(),
                // Text(locator
                //     .get<SharedPreferences>()
                //     .getString("yeeguide_id")!
                //     .toString())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class YeeguideResumeWidget extends StatelessWidget {
  const YeeguideResumeWidget({
    super.key,
    required this.yeeguide,
  });

  final Yeeguide yeeguide;

  @override
  Widget build(BuildContext context) {
    bool isAvailable = AppConstants.availableYeeguides.contains(yeeguide.id);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (!isAvailable) {
              FirebaseEngine.logCustomEvent("yeeguide_unavailable_pressed_from_catalog", {"yeeguide_id":Yeeguide.getById(locator.get<SharedPreferences>().getString("yeeguide_id") ?? 'unknown')});
              ScaffoldMessenger.of(context).showSnackBar(
                buildCustomSnackBar(
                  context,
                  "Ce yeeguide n'est pas encore disponible",
                  SnackBarType.info,
                ),
              );
              return;
            }

            if (Yeeguide.getById(locator
                            .get<SharedPreferences>()
                            .getString("yeeguide_id") ??
                        "")
                    .id !=
                yeeguide.id) {
              _showAlertDialog(
                  // initialContext,
                  context,
                  yeeguide);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(buildCustomSnackBar(
                  context,
                  "${Yeeguide.getById(locator.get<SharedPreferences>().getString("yeeguide_id") ?? "").name} est déjà votre yeeguide !",
                  SnackBarType.info));
            }
          },
          child: Stack(
            children: [
              Container(
                // height: 60,
                width: 1.sw,
                // margin: EdgeInsets.symmetric(horizontal: 15.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 0.9,
                      color: Yeeguide.getById(locator
                                          .get<SharedPreferences>()
                                          .getString("yeeguide_id") ??
                                      "")
                                  .id !=
                              yeeguide.id
                          ? AppColors.secondaryText.withOpacity(.3)
                          : AppColors.primaryVar0),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            // color: Colors.yellow,
                            // const Color.fromRGBO(255, 193, 7, 1),
                            width: 120,
                            height: 150,
                            child: Stack(
                              children: [
                                Image.asset(
                                  // "assets/yeeguides/songo_guide_square.png",
                                  yeeguide.profilePictureSquareAsset,
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
                              child: Container(
                            // width: 1.sw,
                            // color: Colors.green,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      yeeguide.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        height: 1,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primaryText,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      yeeguide.tag,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),
                                      textAlign: TextAlign.start,
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
                                  child:
                                      Yeeguide.buildRichText(yeeguide.shortBio),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 6),
                              decoration: BoxDecoration(
                                  color:
                                      AppColors.secondaryText.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/translate.png",
                                    height: 13,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Français",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.2,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.primaryText,
                                      ),
                                      textAlign: TextAlign.center,
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
                        if (true) ...[
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 6),
                              decoration: BoxDecoration(
                                  color:
                                      AppColors.secondaryText.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/message.png",
                                    height: 13,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      yeeguide.category,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.2,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.primaryText,
                                      ),
                                      textAlign: TextAlign.center,
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
                        if (true) ...[
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 6),
                              decoration: BoxDecoration(
                                  color:
                                      AppColors.secondaryText.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/audio.png",
                                    height: 13,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Audio",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.2,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.primaryText,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: Visibility(
                  visible: !isAvailable,
                  //add grey overlay
                  child: Container(
                    width: 1.sw,
                    //use max space available

                    margin: EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    //top left message "Disponible très bientôt !"
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 5.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(.8),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "Disponible très bientôt !",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
    );
  }
}
