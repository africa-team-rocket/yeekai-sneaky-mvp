import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/commons/theme/app_colors.dart';
import '../../../core/di/locator.dart';
import '../home_screen/home_screen.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  double animationLevel = 0.0;
  String username = "";
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        username = _nameController.text;
      });
    });
    debugPrint(
        "Screen width and height : " + 1.sw.toString() + " " + 1.sh.toString());
    _startAnimation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _startAnimation() async {
    // await Future.delayed(const Duration(milliseconds: 200));

    // setState(() {
    //   animationLevel = 0.5;
    // });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      animationLevel = 1;
    });
  }

  Future<void> _continueAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      animationLevel = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            constraints: const BoxConstraints(maxHeight: 75, minHeight: 55),
            // color: Colors.blue,
            height: 150,
            width: 1.sw,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            padding: EdgeInsets.only(bottom: 15.0),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 140, minHeight: 55),
              // color: Colors.blue,
              height: 65,
              width: 1.sw,
              // padding: EdgeInsets.only(bottom: 10.0),

              child: ElevatedButton(
                onPressed: () {
                  if (username.length >= 2) {
                    debugPrint("Voici le blaze : " + username);
                    locator
                        .get<SharedPreferences>()
                        .setString("username", username);
                    FocusScope.of(context).unfocus();
                    Future.delayed(Duration.zero, () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          duration: const Duration(milliseconds: 500),
                          child: HomeScreen(),
                        ),
                      );
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  surfaceTintColor: Colors.blue,

                  backgroundColor: AppColors.primaryText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20), // Ajustez la valeur pour le border radius souhaité
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16), // Espacement intérieur pour le bouton
                  minimumSize: const Size(double.infinity,
                      55), // Pour que le bouton prenne toute la largeur de l'écran
                ),
                child: Text(
                  "Terminer",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              width: 1.sw,
              height: 1.sh,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10 + MediaQuery.of(context).padding.top,
                        width: 1.sw,
                      ),
                      SizedBox(
                        width: 1.sw,
                        // Je ne sais pas à quoi ça servait sur les autres interfaces, faut voir
                        // height: 110,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Et pour finir, ton nom !",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 1.sw > 340.0 ? 22 : 19,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Dis-nous comment souhaites-tu que ton yeeguide t'appelle",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 1.sw > 340.0 ? 13.5 : 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 49,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color:
                                // Colors.red),
                                AppColors.secondaryText.withOpacity(.2)),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextField(
                                    controller: _nameController,
                                    style: const TextStyle(
                                        fontSize: 14, height: 1.5),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets
                                          .symmetric(
                                          vertical: 0,
                                          horizontal:
                                              10), // Ajustez la marge intérieure verticale ici
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: username.length < 2
                                              ? AppColors.bootstrapRed
                                              : AppColors.secondaryText.withOpacity(
                                                  .5), // Couleur de la bordure inférieure lorsque la zone de texte est en focus
                                          width: username.length < 2 ? 1 : 0.5,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: username.length < 2
                                              ? AppColors.bootstrapRed
                                              : AppColors.secondaryText.withOpacity(
                                                  .5), // Couleur de la bordure inférieure lorsque la zone de texte est en focus
                                          width: 0.5,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ), // Bordure par défaut
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: username.length < 2
                                              ? AppColors.bootstrapRed
                                              : Colors
                                                  .transparent, // Couleur de la bordure inférieure lorsque la zone de texte est en focus
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      // errorBorder: OutlineInputBorder(
                                      //   borderSide: BorderSide(
                                      //     color: Colors
                                      //         .red, // Couleur de la bordure inférieure en cas d'erreur
                                      //     width: 0.5,
                                      //   ),
                                      //   borderRadius:
                                      //       BorderRadius.circular(15),
                                      // ),
                                      hintText: "Nom ou pseudo",
                                    ),
                                    keyboardType: TextInputType.text,
                                    // onChanged: (value) {
                                    //   context.read<RegisterBloc>().add(UpdateFullName(newFullName: value));
                                    //
                                    // },
                                    onSubmitted: (value) {
                                      // onSubmitValue!(value);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (username.length < 2) ...[
                        Text(
                          "Le nom doit faire au moins deux caractères",
                          style: TextStyle(
                              color: AppColors.bootstrapRed, fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ]),
              ),
            ),
          ),
        ));
  }
}
