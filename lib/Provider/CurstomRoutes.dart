
import 'package:flutter/material.dart';
import 'package:sep21/Inner%20Screens/match_details.dart';
import 'package:sep21/Inner%20Screens/team_navigation_rail.dart';
import 'package:sep21/Screens/cart.dart';
import 'package:sep21/Screens/feed.dart';
import 'package:sep21/Screens/home.dart';
import 'package:sep21/Screens/wishlist.dart';


var customRoutes = <String, WidgetBuilder>{
  ///   '/': (ctx) => LandingPage(),
  TeamsNavigationRailScreen.routeName: (ctx) =>
      TeamsNavigationRailScreen(),
   Cart.routeName: (ctx) => Cart(),
    Feed.routeName: (ctx) => Feed(),
   Wishlist.routeName: (ctx) => Wishlist(),
   MatchDetails.routeName: (ctx) => MatchDetails(),
   // CategoriesFeedsScreen.routeName: (ctx) => CategoriesFeedsScreen(),
};