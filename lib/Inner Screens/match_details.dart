// The following inner screen will be displayed
// when the user clicks on any match. All the details
// about the match will be shown in this inner screen.
// @author: Alexandros Christou - 27Oct21

// COMMITS TEST !!

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Provider/Favorite_Provider.dart';
import 'package:sep21/Provider/Matches.dart';
import 'package:sep21/Screens/Card/cart.dart';
import 'package:sep21/Screens/feed.dart';
import 'package:sep21/Screens/Wishlist/wishlist.dart';
import 'package:sep21/Widgets/feeds_products.dart';
import 'package:sep21/Widgets/show_tickets_feed.dart';
import 'package:provider/provider.dart';
import 'package:sep21/consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Models/Match.dart';

class MatchDetails extends StatefulWidget {
  //const MatchDetails({Key? key}) : super(key: key);
  static const routeName = '/match_details';

  @override
  _MatchDetailsState createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails> {
  @override
  Widget build(BuildContext context) {
    /// ------------------------------------
    ///              PROVIDERS:
    /// ------------------------------------
    final cartProvider = Provider.of<CartProvider>(context);
    final themeState = Provider.of<DarkThemeProvider>(context);
    final matchesProvider = Provider.of<Matches>(context);
    List<Match> matchesList = matchesProvider.matches;
    final matchID = ModalRoute.of(context)!.settings.arguments as String;
    print("match ID: " + matchID);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    final matchAtrr = matchesProvider.findByID(matchID);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              foregroundDecoration: BoxDecoration(color: Colors.black12),
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
              child: Image.network(matchAtrr.imageURL)),
          SingleChildScrollView(
              padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 250),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  splashColor: Colors.purple[200],
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(30),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.save,
                                        size: 23,
                                        color: Colors.white,
                                      )))),
                          Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  splashColor: Colors.purple[200],
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(30),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.share,
                                        size: 23,
                                        color: Colors.white,
                                      )))),
                        ],
                      ),
                    ),
                    Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  /// ** (1) TEAMS **
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      alignment: Alignment.center,
                                      child: Text(
                                          matchAtrr.homeTeam +
                                              " vs " +
                                              matchAtrr.AwayTeam,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600))),
                                  SizedBox(
                                    height: 8,
                                  ),

                                  /// ** (2) Stadium **
                                  Container(
                                    alignment: Alignment.center,
                                    // child: Text(matchAtrr.stadium.name,
                                    //     style: TextStyle(
                                    //       //themeState.darkTheme
                                    //       // ? Theme.of(context).disabledColor
                                    //       /*:*/ color: MyAppColor.subTitle,
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 21.0,
                                    //     )),
                                  ),

                                  /// ** (3) Date - Time **
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(matchAtrr.date,
                                        style: TextStyle(
                                          //themeState.darkTheme
                                          // ? Theme.of(context).disabledColor
                                          /*:*/ color: MyAppColor.subTitle,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21.0,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 58.0),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                                height: 1,
                              ),
                            ),
                            _details(false, 'Available Tickets: ',
                              '2',context),//  matchAtrr.quantity.toString(), context),
                            _details(false, 'Date: ', matchAtrr.date, context),
                            const SizedBox(height: 15.0),
                            Divider(
                                thickness: 1, color: Colors.grey, height: 1),

                            /// ***************************************************
                            ///               Suggested Matches
                            /// ***************************************************
                            Container(
                                margin: EdgeInsets.only(bottom: 25),
                                width: double.infinity,
                                height: 340,
                                child: ListView.builder(
                                    itemCount: matchesList.length < 5 ? matchesList.length : 5 ,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext ctx, int index) {
                                      return ChangeNotifierProvider.value(
                                        value: matchesList[index],
                                        child: FeedProducts(),
                                      );
                                    }))
                          ],
                        ))
                  ])),

          /// ** TOP APP BAR **
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,

                  ///  Description
                  title: Text(
                    "MATCH DETAILS:",
                    style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.normal),
                  ),
                  actions: <Widget>[
                    ///  Description
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
                            iconSize: 24.0,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(Wishlist.routeName);
                            }),
                      ),
                    ),
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
                            iconSize: 24.0,
                            onPressed: () {
                              Navigator.of(context).pushNamed(Cart.routeName);
                            }),
                      ),
                    ),

                    ///  Cart icon

                  ])),

          /// ** BOTTOM BAR BUTTONS **
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  /// (1) Add to Cart Button
                  Expanded(
                    flex: 3,
                    child: Container(
                        height: 50,
                        child: RaisedButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape:
                                RoundedRectangleBorder(side: BorderSide.none),
                            color: Colors.redAccent.shade400,
                            onPressed: () {
                              ShowTicketOptions(matchAtrr, context);
                              //cartProvider.addProductToCart(matchID, matcAtrr.price, matcAtrr.title, matcAtrr.imageURL);
                            },
                            child: Text('Add to Card'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)))),
                  ),

                  /// (2) Buy Now Button
                  Expanded(
                    flex: 3,
                    child: Container(
                        height: 50,
                        child: RaisedButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape:
                                RoundedRectangleBorder(side: BorderSide.none),
                            color: Colors.white,
                            onPressed: () {},
                            child: Row(
                              children: [
                                Text('Buy Now'.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black)),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(Icons.payment,
                                    color: Colors.green.shade700, size: 19),
                              ],
                            ))),
                  ),

                  /// (3) Add to Wishlist
                  Expanded(
                    flex: 1,
                    child: Container(
                        color: themeState.darkTheme
                            ? Colors.black
                            : MyAppColor.subTitle,
                        height: 50,
                        child: InkWell(
                            splashColor: MyAppColor.favColor,
                            onTap: () {
                              favoritesProvider.AddAndRemoveFromFavorite(
                                  matchAtrr.id,
                                  matchAtrr.SectorB_RegularPrice,
                                  matchAtrr.title,
                                  matchAtrr.imageURL);
                            },
                            child: Center(
                                child: Icon(
                              favoritesProvider.getFavoriteItems
                                      .containsKey(matchAtrr.id)
                                  ? Icons.favorite
                                  : MyAppIcons.wishlist,
                              color: favoritesProvider.getFavoriteItems
                                      .containsKey(matchAtrr.id)
                                  ? Colors.red
                                  : Colors.white,
                            )))),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

/// Method which is called when the 'AddToCart' button is clicked
/// It shows all tickets type about the match
void ShowTicketOptions(Match match, BuildContext context) => showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        content: DisplayTickets(match),
      );
    });

/// called when the wishlist icon is being pressed
AddToFavotite(BuildContext context) {}
_details(bool stateTheme, String title, String info, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: TextSelectionTheme.of(context).selectionColor,
                fontWeight: FontWeight.w600,
                fontSize: 21.0)),
        Text(info,
            style: TextStyle(
                color: stateTheme
                    ? Theme.of(context).disabledColor
                    : MyAppColor.subTitle,
                fontWeight: FontWeight.w600,
                fontSize: 21.0)),
      ],
    ),
  );
}
