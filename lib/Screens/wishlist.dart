

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Provider/Favorite_Provider.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:sep21/Widgets/wishlist_empty.dart';
import 'package:sep21/Widgets/wishlist_full.dart';
import 'package:sep21/consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/consts/my_custom_icons/MyAppIcons.dart';
import '../bottom_bar.dart';
import '../Widgets/cart_empty.dart';
import '../Widgets/cart_full.dart';

class Wishlist extends StatelessWidget {

  static const routeName = '/wishlist';


  @override
  Widget build(BuildContext context) {

    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    GlobalMethods globalMethods = GlobalMethods();

    return favoritesProvider.getFavoriteItems.isEmpty
    // (a) In case the Wishlist is empty
    // -> then appear Wishlist is empty screen!
        ? Scaffold(
      body: WishlistsEmpty(),
    )
    // (b) Wishlist is not empty:
    // -> display Wishes
        : Scaffold(
            appBar: AppBar(
              title: Text('Wishlist ('+ favoritesProvider.getFavoriteItems.length.toString() +')'),
              actions: [
                IconButton(color: Colors.black,
                  onPressed: () { globalMethods.showDialogForRemoveItem('Clear Wishlist', 'Do you want to clear your Wishlist?',
                          ()=> {favoritesProvider.clearFavorites() }
                      ,context); },
                  icon: Icon(MyAppIcons.trash),
                )
              ],
            ),
      body: ListView.builder(
      itemCount: favoritesProvider.getFavoriteItems.length,
      itemBuilder: (BuildContext ctx, int index ){
        return ChangeNotifierProvider.value(
            value: favoritesProvider.getFavoriteItems.values.toList()[index],
        child: WishlistFull(
          matchId: favoritesProvider.getFavoriteItems.keys.toList()[index],
        ));
    },
    ),
    );
  }
}


