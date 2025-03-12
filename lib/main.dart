import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:yeebus_filthy_mvp/core/commons/utils/firebase_engine.dart';
import 'package:yeebus_filthy_mvp/map_feature/presentation/gift_test_page.dart';
import 'core/commons/utils/app_constants.dart';
import 'core/data/database_instance.dart';
import 'core/di/locator.dart';
import 'firebase_options.dart';
import 'main_feature/presentation/home_screen/home_screen.dart';
import 'main_feature/presentation/new_welcome_screen/new_welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await initializeDateFormatting('fr_FR', '');
  // Intl.defaultLocale = 'fr_FR';
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    setupAppDependencies();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // On vérifie s'il y'a une valeur initiale, si non, on en met une.

    if (!prefs.containsKey('yeeguide_id') ||
        prefs.getString('yeeguide_id') == null) {
      prefs.setString("yeeguide_id", YeeguideId.raruto.value);
      debugPrint(
          "Il n'y avait pas de valeur pour yeeguide_id, on en a donc mis un : ${prefs.getString('yeeguide_id')}");
    } else {
      debugPrint("Il y avait déjà une valeur pour yeeguide_id, la voici : ${prefs.getString('yeeguide_id')}");
    }

    // On vérifie s'il y'a une valeur initiale pour le user id, si non, on en met une.
// prefs.remove("user_id");
    if (!prefs.containsKey('user_id') || prefs.getString('user_id') == null) {
      prefs.setString("user_id", const Uuid().v1());
      debugPrint(
          "Il n'y avait pas de valeur pour user_id, on en a donc mis un : ${prefs.getString('yeeguide_id')}");
    } else {
      debugPrint(
          "Il y avait déjà une valeur pour user_id, la voici : ${prefs.getString('yeeguide_id')}");
    }

    // debugRepaintRainbowEnabled = true;

    // WidgetsFlutterBinding.ensureInitialized();

    // Vérifiez si la base de données a déjà été initialisée
    // // final isDatabaseInitialized = await _databaseInstance.;
    //
    // if (!isDatabaseInitialized) {
    //   // Si la base de données n'est pas encore initialisée, créez-la.
    //   await _databaseInstance.createDatabase();
    // }

    await FirebaseEngine.init();
    WidgetsFlutterBinding.ensureInitialized();

    runApp(const YeebusApp());
  });
}

class YeebusApp extends StatelessWidget {
  const YeebusApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Je doute que ce soit bien de le mettre ici car tu crées peut-être des instances à tout va :/
    // debugPrint("Created database again :/");
    final databaseInstance = locator.get<AppLocalDatabase>();
    databaseInstance.createDatabase();
    // final rootScreen = locator.get<RootScreen>();

    return ScreenUtilInit(
        builder: (context, child) =>
            // SharedPreferencesProvider(
            //           sharedPrefs: locator.get<SharedPreferences>(),
            //           yeeguideId: locator.get<SharedPreferences>().getString("yeeguide_id") ?? "raruto",
            //           child:
            MaterialApp(
              // checkerboardOffscreenLayers: true,
              // checkerboardRasterCacheImages: true,
              theme: ThemeData(
                fontFamily: 'Poppins',
                appBarTheme: const AppBarTheme(
                  iconTheme: IconThemeData(
                      // color: Color(0xff3E9FD9)
                      color: Color(0xff1BA3F0)),
                ),
                primarySwatch: Colors.blue,
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: const Color(0xff1BA3F0),
                  selectionColor: const Color(0xff1BA3F0).withOpacity(.6),
                  selectionHandleColor: const Color(0xff302F2E),
                ),
                // hintColor: Color(0xff1BA3F0),
                // brightness: Brightness.light
              ),

              //home: const GiftTestPage(),
              home: locator
                  .get<SharedPreferences>()
                  .getBool("isOldUser") !=
                  true ? const NewWelcomeScreen() : const HomeScreen(),
              //home: const MapScreen(),

              // home: FlutterSplashScreen.gif(
              //   gifPath: 'assets/example.gif',
              //   gifWidth: 269,
              //   gifHeight: 474,
              //   nextScreen: WelcomeScreen(),
              //   duration: const Duration(milliseconds: 3515),
              //   onInit: () async {
              //     debugPrint("onInit");
              //   },
              //   onEnd: () async {
              //     debugPrint(  "onEnd 1");
              //   },
              // ),
              // home: IntermediateScreen(),
               debugShowCheckedModeBanner: false,
            ));
    // );
  }
}
