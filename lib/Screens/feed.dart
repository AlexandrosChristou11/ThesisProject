

import 'dart:async';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:badges/badges.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Provider/Favorite_Provider.dart';
import 'package:sep21/Provider/Matches.dart';
import 'package:sep21/Screens/Wishlist/wishlist.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:sep21/Widgets/feeds_products.dart';
import 'package:sep21/Models/Match.dart';

import 'Card/cart.dart';

class Feed extends StatefulWidget{


  static const routeName = '/feed';

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  Future<void> _GetMatchesOnRefresh() async{
    await Provider.of<Matches>(context, listen: false).FetchMatches();
    setState(() {

    });
  }
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription< ConnectivityResult > _connectivitySubscription;
  static bool isConnected = false;

  @override
  void initState() {
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);

    super.initState();
  }

  Future< void > initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Error Occurred: ${e.toString()} ");
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _UpdateConnectionState(result);
  }

  Future<void> _UpdateConnectionState(ConnectivityResult result) async {
    if ((result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ) ) {
      if (!GlobalMethods.isConnected){
        GlobalMethods.isConnected = true;
      }

    } else if (result == ConnectivityResult.none && GlobalMethods.isConnected) {
      GlobalMethods.isConnected = false;
      GlobalMethods.showStatus(result, false, context);
    }
  }


  @override
  void dispose() {
    _connectivitySubscription.cancel();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    /// ************************************
    ///              PROVIDERS:
    /// ************************************
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final popular = ModalRoute.of(context)!.settings.arguments as String;
    final matchesProvider = Provider.of<Matches>(context);
   // matchesProvider.FetchMatches();
    List<Match> matchesList = matchesProvider.matches;

    if (popular == 'popular') {
      matchesList = matchesProvider.PopularMatches;
    }


    return Scaffold(

      // List with all the available matches.

    appBar: AppBar(
      title: Text("Available Matches"),
      flexibleSpace: Container(
      decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              MyAppColor.starterColor,
              MyAppColor.endColor
            ])),
      ),
          actions: [
            /// --------------------
            /// Favorites in App Bar
            /// --------------------
            Consumer<FavoritesProvider>(
              builder: (_, favoritesProvider, child) => Badge(
                badgeColor: MyAppColor.cartBadgeColor,
                animationType: BadgeAnimationType.slide,

                /// ** //
                toAnimate: true,
                position: BadgePosition.topEnd(top: 5, end: 7),
                badgeContent: Text(
                  favoritesProvider.getFavoriteItems.length.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: IconButton(
                    icon: Icon(MyAppIcons.wishlist),
                    color: Colors.red,
                    iconSize: 24.0,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(Wishlist.routeName);
                    }),
              ),
            ),
            /// --------------------
            /// Cart in App Bar
            /// --------------------
            Consumer<CartProvider>(
              builder: (_, cartProvider, child) => Badge(
                badgeColor: MyAppColor.cartBadgeColor,
                animationType: BadgeAnimationType.slide,

                /// ** //
                toAnimate: true,
                position: BadgePosition.topEnd(top: 5, end: 7),
                badgeContent: Text(
                  cartProvider.getCartItems.length.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child:   IconButton(
                    icon: Icon(MyAppIcons.cart, color: themeChange.darkTheme ? Colors.white : Colors.black54,),

                    iconSize: 24.0,
                    onPressed: () {
                      Navigator.of(context).pushNamed(Cart.routeName);
                    }),
              ),
            ),
          ],
    )
    ,body:
      // StaggeredGridView.countBuilder(
      //   crossAxisCount: 6,
      //   itemCount: 8,
      //   itemBuilder: (BuildContext context, int index) => FeedProducts(),
      //   staggeredTileBuilder: (int index) =>
      //   new StaggeredTile.count(3, index.isEven ? 4 : 5),
      //   mainAxisSpacing: 8.0,
      //   crossAxisSpacing: 6.0,
      // )
      RefreshIndicator(
        onRefresh: _GetMatchesOnRefresh ,
        child: GridView.count(crossAxisCount: 2,
        childAspectRatio: 240/420,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: List.generate(matchesList.length, (index) {
          return ChangeNotifierProvider.value(
          value: matchesList[index],
          child: FeedProducts(


            ),
          );
        }),
        ),
      )
    );
  }
}