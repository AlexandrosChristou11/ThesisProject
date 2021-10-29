import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreferences{
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool v) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, v);
  }

  Future <bool> getTheme() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(THEME_STATUS,) ?? false;
  }

}