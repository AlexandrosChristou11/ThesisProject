

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Widgets/wishlist_empty.dart';
import 'package:sep21/Widgets/wishlit_full.dart';
import 'package:sep21/consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/consts/my_custom_icons/MyAppIcons.dart';
import '../bottom_bar.dart';
import '../Widgets/cart_empty.dart';
import '../Widgets/cart_full.dart';

class Wishlist extends StatelessWidget {

  static const routeName = '/wishlist';


  @override
  Widget build(BuildContext context) {
    List wishlist = [];
    return !wishlist.isEmpty
    // (a) In case the Wishlist is empty
    // -> then appear Wishlist is empty screen!
        ? Scaffold(
      body: WishlistsEmpty(),
    )
    // (b) Wishlist is not empty:
    // -> display Wishes
        : Scaffold(
            appBar: AppBar(
              title: Text('Wishlist ()'),
            ),
      body: ListView.builder(
      itemCount: 3,
      itemBuilder: (BuildContext ctx, int index ){
        return WishlistFull();
    },
    ),
    );
  }
}


