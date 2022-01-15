// Feeds Dialog, will be a dialog containing
// some details regarding a match in the Feeds Screen
// @author: Alexandros Christou
// Date: 12Dec21

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Inner%20Screens/match_details.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Provider/Favorite_Provider.dart';
import 'package:sep21/Provider/Matches.dart';
import 'package:sep21/Widgets/show_tickets_feed.dart';

class FeedDialog extends StatelessWidget {
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
                    maxHeight: MediaQuery.of(context).size.height * 0.5),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
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
                    Flexible(
                        child: dialogContent(
                            context,
                            0, (){}
                            ), ),

                    /// (2) View Match ..
                    Flexible(child: dialogContent(context, 1, () {})),

                    /// (3) Add to Cart ..
                    //Flexible(child: dialogContent(context, 2, () {})),
                  ],
                ),
              ),

              /// -------------------------
              ///        CLOSE :
              /// -------------------------
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.3),
                    shape: BoxShape.circle),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    splashColor: Colors.grey,
                    onTap: () =>
                    Navigator.canPop(context) ? Navigator.pop(context) : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.close, size: 28, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),

        ));
  }


  Widget dialogContent(BuildContext context, int index, Function fct) {
    /// ----------------
    ///    PROVIDERS:
    /// ----------------
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final matchesProvider = Provider.of<Matches>(context, listen: false);
    final matchAtrr = matchesProvider.findByID(matchId);




    List<IconData> _dialogIcons = [
      favoritesProvider.getFavoriteItems.containsKey(matchId)
          ? Icons.favorite
          : Icons.favorite_border,
      Feather.eye,
      //MyAppIcons.cart,

    ];

    List<String> _texts = [
      favoritesProvider.getFavoriteItems.containsKey(matchId)
          ? 'In wishlist'
          : 'Add to wishlist',
      'View Match',
      //cartProvider.getCartItems.containsKey(matchId) ? 'In Cart ' : 'Add to cart',
    ];
    List<Color> _colors = [
      favoritesProvider.getFavoriteItems.containsKey(matchId)
          ? Colors.red
          : Theme.of(context).textSelectionColor,
      Theme.of(context).textSelectionColor,
      Theme.of(context).textSelectionColor,
    ];

    void _Favorites(){
      favoritesProvider.AddAndRemoveFromFavorite(matchId, /*matchAtrr.price*/ 0, matchAtrr.title, matchAtrr.imageURL);
      Navigator.canPop(context)? Navigator.pop(context):null;
    }



    void _ViewMatch()  {
      Navigator.pushNamed(context, MatchDetails.routeName, arguments: matchId)
            .then((value) => Navigator.canPop(context)? Navigator.pop(context):null);

    }

    return FittedBox(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: index==0 ?() async => _Favorites():
          index ==1 ? () async=> _ViewMatch(): ()=>print(index),
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
                          _dialogIcons[index],
                          color: _colors[index],
                          size: 25,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      _texts[index],
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
