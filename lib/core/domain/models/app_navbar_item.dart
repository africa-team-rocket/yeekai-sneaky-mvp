import 'package:flutter/cupertino.dart';

class AppNavbarItem{
  final Widget screen;
  final String unselectedIcon;
  final String selectedIcon;
  final String title;

  const AppNavbarItem(
      {required this.screen, required this.title, required this.selectedIcon, required this.unselectedIcon});
}