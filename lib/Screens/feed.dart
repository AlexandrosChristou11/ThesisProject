

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Provider/Favorite_Provider.dart';
import 'package:sep21/Provider/Matches.dart';
import 'package:sep21/Screens/wishlist.dart';
import 'package:sep21/Widgets/feeds_products.dart';
import 'package:sep21/Models/Match.dart';

import 'cart.dart';

class Feed extends StatelessWidget{


  static const routeName = '/feed';
  @override
  Widget build(BuildContext context) {

    /// ************************************
    ///              PROVIDERS:
    /// ************************************
    final popular = ModalRoute.of(context)!.settings.arguments as String;
    final matchesProvider = Provider.of<Matches>(context);

    List<Match> matchesList = matchesProvider.matches;

    if (popular == 'popular') {
      matchesList = matchesProvider.PopularMatches;
    }


    return Scaffold(

      // List with all the available matches.

    appBar: AppBar(
          title: Text('Available Matches', style: TextStyle(color: Colors.black54),),
          backgroundColor: Theme.of(context).canvasColor,
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
                    icon: Icon(MyAppIcons.cart),
                    color: Colors.black54,
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
      GridView.count(crossAxisCount: 2,
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
      )
    );
  }

}