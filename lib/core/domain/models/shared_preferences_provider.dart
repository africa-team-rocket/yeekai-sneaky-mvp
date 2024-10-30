import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider extends InheritedWidget {
  final String yeeguideId;
  final SharedPreferences sharedPrefs;

  const SharedPreferencesProvider({
    Key? key,
    required this.sharedPrefs,
    required this.yeeguideId,
    required Widget child,
  }) : super(key: key, child: child);

  static SharedPreferencesProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SharedPreferencesProvider>();
  }

  void setYeeguideId(String newYeeguideId) {
    
    sharedPrefs.setString("yeeguide_id", newYeeguideId);
  }

  @override
  bool updateShouldNotify(SharedPreferencesProvider oldWidget) {
    return yeeguideId != oldWidget.yeeguideId;
  }
}