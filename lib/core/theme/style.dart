import 'package:flutter/material.dart';

import '../extension/context_extension.dart';
import 'app_colors.dart';
import 'app_text_style.dart';
import 'app_theme.dart';

ThemeData appThemeData(BuildContext context) {
  final brightness = AppTheme.getByTheme(
    context,
    light: Brightness.light,
    dark: Brightness.dark,
  );
  final primaryTextColor = AppColor.titleFormFiledColor(context);
  final secondaryTextColor = AppColor.darkTextColor(context);

  return ThemeData(
    primaryColor: AppColor.primaryColor(context),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: false,
    hintColor: AppColor.hintColor(context),
    brightness: brightness,
    textTheme: ThemeData(brightness: brightness).textTheme.apply(
      bodyColor: primaryTextColor,
      displayColor: primaryTextColor,
      fontFamily: context.fontFamily(),
    ),
    primaryTextTheme: ThemeData(brightness: brightness).primaryTextTheme.apply(
      bodyColor: primaryTextColor,
      displayColor: primaryTextColor,
      fontFamily: context.fontFamily(),
    ),
    iconTheme: IconThemeData(color: secondaryTextColor),
    dividerColor: AppColor.borderColor(context),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColor.primaryColor(context),
      alignedDropdown: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.textFormFillColor(context),
      hintStyle: TextStyle(color: AppColor.hintColor(context)),
      labelStyle: TextStyle(color: secondaryTextColor),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.textFormBorderColor(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.primaryColor(context)),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColor.cardColor(context),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColor.cardColor(context),
      surfaceTintColor: Colors.transparent,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColor.primaryColor(context),
      secondary: AppColor.secondAppColor(context),
      surface: AppColor.cardColor(context),
      onSurface: primaryTextColor,
      brightness: brightness,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.appBarColor(context),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyle.appBarStyle(context),
      foregroundColor: AppColor.appBarTextColor(context),
    ),
    scaffoldBackgroundColor: AppColor.scaffoldColor(context),
    fontFamily: context.fontFamily(),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.primaryColor(context),
      selectionColor: AppColor.primaryColor(context).withValues(alpha: 0.25),
      selectionHandleColor: AppColor.primaryColor(context),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColor.cardColor(context),
      textStyle: TextStyle(color: primaryTextColor),
    ),
    listTileTheme: ListTileThemeData(
      textColor: primaryTextColor,
      iconColor: secondaryTextColor,
    ),
    platform: TargetPlatform.iOS,
  );
}

List<BoxShadow> appShadow = [
  const BoxShadow(
    color: Color(0x3FD3D1D8),
    blurRadius: 22.5,
    offset: Offset(11.25, 11.25),
    spreadRadius: 0,
  ),
];
