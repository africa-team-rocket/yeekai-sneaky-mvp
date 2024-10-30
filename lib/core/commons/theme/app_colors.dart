
import 'package:flutter/material.dart';

class AppColors{

    // static Color primaryColor = const Color(0xff5894CD);
    static Color primaryColor = const Color(0xff1BA3F0);


    static var primarySwatch = MaterialColor(primaryColor.value, {
        50: primaryColor.withOpacity(0.1),
        100: primaryColor.withOpacity(0.2),
        200: primaryColor.withOpacity(0.3),
        300: primaryColor.withOpacity(0.4),
        400: primaryColor.withOpacity(0.5),
        500: primaryColor.withOpacity(0.6),
        600: primaryColor.withOpacity(0.7),
        700: primaryColor.withOpacity(0.8),
        800: primaryColor.withOpacity(0.9),
        900: primaryColor.withOpacity(1.0),
    });

    // static var primaryVar0 = const Color(0xff5FA9FF);
    static var primaryVar0 = const Color(0xff1BA3F0);
    static var primaryVar1 = const Color(0xff8BB9E2);
    static var primaryVar2 = const Color(0xffDCE9F5);
    static var secondaryVar0 = const Color(0xffC6814D);
    static var secondaryVar1 = const Color(0xffF3AD5F);
    static var secondaryVar2 = const Color(0xffF9D9AE);
    static var alt = const Color(0xffFEF7EF);
    static var altLight = const Color(0xffFFFEFC);
    static var primaryText = const Color(0xff302F2E);
    static var secondaryText = const Color(0xffAAAAAA);

    static var bootstrapRed = const Color(0xFFFA767B);
    static var bootstrapYellow = const Color(0xFFF5D262);
    static var bootstrapGreen = const Color(0xFF439F14);
    static var lightRed = const Color(0xFFF69C9E);
    static var lightYellow = const Color(0xFFFFEAA9);
    static var lightGreen = const Color(0xFFD8F397);
    static var toastBg = const Color(0xffC9DEF1);
    // AACB5C si le vert est trop pâle
}