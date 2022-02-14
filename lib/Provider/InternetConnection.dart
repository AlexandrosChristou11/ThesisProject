/// @author: Alexandros Christou
/// Date: 10Feb21
/// Implementation of Internet connection class


import 'dart:async';
import 'dart:io';

import 'dart:async';
import 'dart:ui';

import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:backdrop/sub_header.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Inner%20Screens/team_navigation_rail.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Provider/InternetConnection.dart';
import 'package:sep21/Provider/Matches.dart';
import 'package:sep21/Widgets/backlayer.dart';
import 'package:sep21/Widgets/popular_matches.dart';
import 'package:sep21/Widgets/sportCategories.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/src/widgets/framework.dart';


class InternetConnection{
  static late Connectivity _connectivity = Connectivity();
  static late StreamSubscription< ConnectivityResult > _connectivitySubscription;


}