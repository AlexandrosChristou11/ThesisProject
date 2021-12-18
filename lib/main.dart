import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/bottom_bar.dart';

import 'package:sep21/consts/my_custom_icons/Theme_data.dart';

import 'Provider/Cart_Provider.dart';
import 'Provider/CurstomRoutes.dart';
import 'Provider/Favorite_Provider.dart';
import 'Provider/Matches.dart';
import 'Screens/landingPage.dart';




void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvide = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvide.darkTheme =
        await themeChangeProvide.darkThemePreferences.getTheme();
  }


  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          /// (1) Dark Theme Provider - state
          ChangeNotifierProvider(create: (_) {
            return themeChangeProvide;
          }),

          /// (2) Matches Provider - state
          ChangeNotifierProvider(create: (_) => Matches()
          ),

          /// (3) Cart Provider
           ChangeNotifierProvider(create: (_) => CartProvider()),

          /// (4) Favorites Provider
           ChangeNotifierProvider(create: (_) => FavoritesProvider())


        ],
        child:
            Consumer<DarkThemeProvider>(builder: (context, themeData, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: Styles.themeData(themeChangeProvide.darkTheme, context),
            initialRoute: '/',
            routes: customRoutes,
            home: LandingPage(),
          );
        }));
  }
}
