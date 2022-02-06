
import 'package:flutter/material.dart';
import 'package:sep21/Inner%20Screens/match_details.dart';
import 'package:sep21/Inner%20Screens/team_navigation_rail.dart';
import 'package:sep21/Models/MatchPreview.dart';
import 'package:sep21/Screens/Authentication/forgetPassword.dart';
import 'package:sep21/Screens/Authentication/signUp.dart';
import 'package:sep21/Screens/CustomCardPaymentScreen.dart';
import 'package:sep21/Screens/NoWebhookPaymentCardFormScreen.dart';
import 'package:sep21/Screens/Orders/order.dart';
import 'package:sep21/Screens/bottom_bar.dart';
import 'package:sep21/Screens/Card/cart.dart';
import 'package:sep21/Screens/feed.dart';
import 'package:sep21/Screens/home.dart';
import 'package:sep21/Screens/matchPreview.dart';
import 'package:sep21/Screens/uploadNewMatch.dart';
import 'package:sep21/Screens/userInfo.dart';
import 'package:sep21/Screens/Wishlist/wishlist.dart';
import 'package:sep21/Inner Screens/categories_feeds.dart';
import 'package:sep21/Screens/Authentication/login.dart';


var customRoutes = <String, WidgetBuilder>{
  ///   '/': (ctx) => LandingPage(),
  TeamsNavigationRailScreen.routeName: (ctx) =>
      TeamsNavigationRailScreen(),
  Cart.routeName: (ctx) => Cart(),
  Feed.routeName: (ctx) => Feed(),
  Wishlist.routeName: (ctx) => Wishlist(),
  MatchDetails.routeName: (ctx) => MatchDetails(),
  CategoriesFeedsScreen.routeName: (ctx) => CategoriesFeedsScreen(),
  UserInfo.routeName: (ctx) => UserInfo(),
  LoginScreen.routName: (ctx) => LoginScreen(),
  SingUpScreen.routName: (ctx) => SingUpScreen(),
  BottomBarScreen.routeName: (ctx) => BottomBarScreen(),
  UploadMatchForm.routeName: (ctx) => UploadMatchForm(),
  ForgetPassword.routeName: (ctx) => ForgetPassword(),
  CustomCardPaymentScreen.routName: (ctx) => CustomCardPaymentScreen(),
  NoWebhookPaymentCardFormScreen.routName: (ctx) => NoWebhookPaymentCardFormScreen(),
  Order.routeName: (ctx) => Order(),
  MatchPreviewScreen.routeName: (ctx) => MatchPreviewScreen(),

   // CategoriesFeedsScreen.routeName: (ctx) => CategoriesFeedsScreen(),
};