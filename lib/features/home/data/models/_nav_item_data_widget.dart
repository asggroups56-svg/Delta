import 'package:flutter/widgets.dart';

class NavItemData {
  final IconData icon;
  final IconData inactiveIcon;
  final String labelAr;
  final String labelEn;

  const NavItemData({
    required this.icon,
    required this.inactiveIcon,
    required this.labelAr,
    required this.labelEn,
  });
}