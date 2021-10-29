import 'package:flutter/material.dart';
import 'package:sep21/Models/Dark_Theme_Preferences.dart';


class DarkThemeProvider with ChangeNotifier{

  DarkThemePreferences darkThemePreferences = DarkThemePreferences();

  bool _darkTheme = false;

  // Getter - Setter
  bool get darkTheme => _darkTheme;

  set darkTheme (bool v) {
    _darkTheme = v;
    darkThemePreferences.setDarkTheme(v);
    notifyListeners();  // keep listening to the changes

  }


}