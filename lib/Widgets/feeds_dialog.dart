// Feeds Dialog, will be a dialog containing
// some details regarding a match in the Feeds Screen
// @author: Alexandros Christou
// Date: 12Dec21

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Provider/Favorite_Provider.dart';
import 'package:sep21/Provider/Matches.dart';

class FeedDialog extends StatelessWidget{
  final String matchId;
  const FeedDialog({required this.matchId});

  @override
  Widget build(BuildContext context) {

    /// -----------------------
    ///      PROVIDERS:
    /// -----------------------
    final cartProvider = Provider.of<CartProvider>(context);
    final matchesProvider = Provider.of<Matches>(context, listen: false);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final matchAtrr = matchesProvider.findByID(matchId);


    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
               constraints: BoxConstraints(
                 minHeight: 100,
                 maxHeight: MediaQuery.of(context).size.height * 0.5
               ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor
              ),
              child: Image.network(matchAtrr.imageURL),
            ),
            /// ---------------------------
            ///  Bottom Widgets
            /// ---------------------------
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// (1) Wishlist ...
                  Flexible(child: dialogContent(context,0, (){})),
                  /// (2) View Match ..
                  Flexible(child: dialogContent(context,1, (){})),
                  /// (3) Add to Cart ..
                  Flexible(child: dialogContent(context,2, (){})),
                ],
              ),
              
            )
          ],
        ),
      )

    );


  }

  Widget dialogContent(BuildContext context, int i, Function fct ) {
    /// ----------------
    ///   PROVIDERS :
    /// ----------------
    final cart = Provider.of<CartProvider>(context);
    final favorites = Provider.of<FavoritesProvider>(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);




    List <IconData> _dialogIcons = [
      favorites.getFavoriteItems.containsKey(matchId)
        ? Icons.favorite
        : Icons.favorite_border,
      Feather.eye,
      MyAppIcons.cart,
    ];


    /// ----------------
    ///   ICONS:
    /// ----------------
    List<String> _texts = [
      favorites.getFavoriteItems.containsKey(matchId)
      ? 'In Wishlist'
      : 'Add to Wishlist',
      'View Product',
      cart.getCartItems.containsKey(matchId)? 'In Cart' : 'Add to Cart',
    ];

    /// ----------------
    ///   COLORS :
    /// ----------------
    List<Color> _colors = [
      favorites.getFavoriteItems.containsKey(matchId)
      ? Colors.red : Theme.of(context).textSelectionColor,
      Theme.of(context).textSelectionColor,
      Theme.of(context).textSelectionColor,
    ];

    return FittedBox(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: fct(),
          splashColor: Colors.grey,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.25,
            padding: EdgeInsets.all(4),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    // inkwell color
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          _dialogIcons[i],
                          color: _colors[i],
                          size: 25,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      _texts[i],
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        //  fontSize: 15,
                        color: themeChange.darkTheme
                            ? Theme.of(context).disabledColor
                            : MyAppColor.subTitle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );


  }
  
  
}