// The following inner screen will be displayed
// when the user clicks on any match. All the details
// about the match will be shown in this inner screen.
// @author: Alexandros Christou - 27Oct21

// COMMITS TEST !!

import 'dart:async';

import 'package:badges/badges.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Provider/Favorite_Provider.dart';
import 'package:sep21/Provider/Matches.dart';
import 'package:sep21/Screens/Card/cart.dart';
import 'package:sep21/Screens/feed.dart';
import 'package:sep21/Screens/Wishlist/wishlist.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:sep21/Widgets/feeds_products.dart';
import 'package:sep21/Widgets/show_tickets_feed.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Models/Match.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';


class MatchDetails extends StatefulWidget {
  //const MatchDetails({Key? key}) : super(key: key);
  static const routeName = '/match_details';

  @override
  _MatchDetailsState createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails> {

  IconData _getSportIcon(String type){
    if (type.toLowerCase() == 'football'){
      return MyAppIcons.sports_soccer;
    }else if (type.toLowerCase() == 'basketball'){
      return MyAppIcons.sports_basketball_rounded;
    }else if (type.toLowerCase() == 'handball'){
      return MyAppIcons.sports_handball_rounded;
    }
    else if (type.toLowerCase() == 'volley'){
      return MyAppIcons.sports_volleyball_rounded;
    }

    return MyAppIcons.sports_soccer;
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

    int matchQuantity = matchAtrr.SectorA_RegularQuantity + matchAtrr.SectorA_StudentQuantity +
        matchAtrr.SectorB_RegularQuantity + matchAtrr.SectorB_StudentQuantity +
        matchAtrr.SectorC_RegularQuantity + matchAtrr.SectorC_StudentQuantity;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
    ),
            child: Container(
                foregroundDecoration: BoxDecoration(color: Colors.black12),
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                child: Image.network(matchAtrr.imageURL), ),
          ),
          SingleChildScrollView(
              padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 200),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  splashColor: Colors.purple[200],
                                  onTap: () {
                                    Share.share(
                                      'Hey mate! Would you like to join the game ${matchAtrr.title}, with me? Hurry up, few tickets left!'
                                          'Follow the link to download the app: https://play.app.goo.gl/?link=https://play.google.com/store/apps/details?id=com.example.sep21', subject: 'Tickets for ${matchAtrr.title}');
                                  },
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
                                  /// ** (1) TITLE **
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      alignment: Alignment.center,
                                      child: Text(
                                          matchAtrr.title,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600))
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Padding(padding: const EdgeInsets.only(top:0.01),
                            child:  Divider(
                                thickness: 1, color: Colors.grey, height: 1),),

                            Padding(

                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                /// -- MATCH DETAILS --
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      alignment: Alignment.center,
                                      child: Text(
                                          'Match Details:',
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600))),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                                height: 1,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            _details(false, '${matchAtrr.sport}, ${matchAtrr.type}', 'info', context, _getSportIcon(matchAtrr.sport)),
                            _details(false, matchAtrr.stadium, '2',context, MyAppIcons.location_on),//  matchAtrr.quantity.toString(), context),
                            //_details(false, ' ${DateFormat("dd-MM-yyyy").format(DateTime.parse(matchAtrr.date))} ', matchAtrr.date, context, MyAppIcons.date_range),
                            _details(false, ' ${ Jiffy(matchAtrr.date).yMMMd } ', matchAtrr.date, context, MyAppIcons.date_range),
                            _details(false, ' ${DateFormat.Hm().format(DateTime.parse(matchAtrr.date))} ', matchAtrr.date, context, MyAppIcons.access_time),
                            _details(false, ' Availability: ${matchQuantity} ', matchAtrr.date, context, MyAppIcons.data_saver_off),
                            const SizedBox(height: 15.0),
                            Divider(
                                thickness: 1, color: Colors.grey, height: 1),
                            const SizedBox(height: 20.0),


                            /// ---------------------------------------------------
                            ///               SUGGESTED MATCHES :
                            /// ---------------------------------------------------

                             Padding(
                               padding: const EdgeInsets.only(left:8.0),
                               child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    /// -- MATCH DETAILS --
                                    Container(
                                        width: MediaQuery.of(context).size.width *
                                            0.9,
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            'Suggested for you ..',
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w600))),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                             ),
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
                  ]),
          ),


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
                  // Expanded(
                  //   flex: 3,
                  //   child: Container(
                  //       height: 50,
                  //       child: RaisedButton(
                  //           materialTapTargetSize:
                  //               MaterialTapTargetSize.shrinkWrap,
                  //           shape:
                  //               RoundedRectangleBorder(side: BorderSide.none),
                  //           color: Colors.white,
                  //           onPressed: () {},
                  //           child: Row(
                  //             children: [
                  //               Text('Buy Now'.toUpperCase(),
                  //                   style: TextStyle(
                  //                       fontSize: 14, color: Colors.black)),
                  //               SizedBox(
                  //                 width: 5,
                  //               ),
                  //               Icon(Icons.payment,
                  //                   color: Colors.green.shade700, size: 19),
                  //             ],
                  //           ))),
                  // ),

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


_details(bool stateTheme, String title, String info, BuildContext context, IconData icon) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    //color:  Colors.grey.shade100,
    child: InkWell(
      splashColor: Theme.of(context).splashColor,
      child: ListTile(title: Text(title),
        //railing: Icon(Icons.chevron_right_rounded),
        //onTap: ()=> Navigator.of(context).pushNamed(Wishlist.routeName),
        leading: Icon(icon, color: MyAppColor.gradiendLStart,),
      ),
    ),
  );
}
