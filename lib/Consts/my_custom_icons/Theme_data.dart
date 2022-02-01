import 'package:flutter/material.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';

class Styles{
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme ? Colors.grey.shade900 :Colors.grey.shade200,
      primarySwatch: Colors.blue,
      primaryColor: isDarkTheme  ? Colors.grey.shade900 :Colors.grey.shade200,
      accentColor: Colors.blue[800],
     // backgroundColor: isDarkTheme ? Colors.grey.shade700 : Colors.white,
      backgroundColor: isDarkTheme ? Colors.grey.shade500 : Colors.white,
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Colors.grey.shade300 : Colors.grey.shade800,
      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      //canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      canvasColor: isDarkTheme ? Colors.black54 : Colors.grey[80],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
     // bannerTheme: isDarkTheme ? MyAppColor.gradiendLStart : Colors.black,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        //color: Colors.black54,
        elevation: 0.0,
      ),
    );
  }
}