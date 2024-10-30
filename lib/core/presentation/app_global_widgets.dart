import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../commons/theme/app_colors.dart';

enum SnackBarType { info, error, success }

SnackBar buildCustomSnackBar(
  BuildContext context,
  String message,
  SnackBarType type, {
  bool showCloseIcon = true,
}) {
  Color backgroundColor;
  Color textColor;
  Color iconColor;

  switch (type) {
    case SnackBarType.info:
      backgroundColor = AppColors.toastBg;
      textColor = AppColors.primaryText;
      iconColor = Colors.black;
      break;
    case SnackBarType.error:
      backgroundColor = AppColors.bootstrapRed;
      textColor = Colors.white;
      iconColor = Colors.white;
      break;
    case SnackBarType.success:
      backgroundColor = AppColors.bootstrapGreen;
      textColor = Colors.white;
      iconColor = Colors.white;
      break;
  }

  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.fixed,
    backgroundColor: Colors.transparent,
    content: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      // height: 60,
      constraints: BoxConstraints(minHeight: 60),
      width: 1.sw,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 0),
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textColor,
                  ),
                ),
              ),
              Visibility(
                visible: showCloseIcon,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: Icon(Icons.close, color: iconColor),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    duration: Duration(seconds: 2),
  );
}
