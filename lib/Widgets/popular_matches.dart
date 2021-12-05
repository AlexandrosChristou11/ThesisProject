// The following widget is responsible to
// display all upcoming matches on the home screen ..
// 22Oct21 - @Author: Alexandros Christou

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Inner%20Screens/match_details.dart';
import 'package:sep21/Models/CartAttr.dart';
import 'package:sep21/Models/Match.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Provider/Favorite_Provider.dart';
import 'package:sep21/Widgets/show_tickets_feed.dart';

class PopularMatches extends StatelessWidget {
  // const PopularMatches({Key? key, required this.imageURL, required this.title, required this.type, required this.stadium}) : super(key: key);
  //
  //  final String imageURL;
  //  final String title;
  // final String type;
  //  final String  stadium;
  //

  @override
  Widget build(BuildContext context) {

    /// ************************************
    ///              PROVIDERS:
    /// ************************************
    final matchesAttributes = Provider.of<Match>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: 250,
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              )),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
            child: InkWell(
              onTap:  () => Navigator.pushNamed(context, MatchDetails.routeName, arguments: matchesAttributes.id),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 170,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      matchesAttributes.imageURL),
                                  fit: BoxFit.contain))),
                      Positioned(
                        right: 10,
                        top: 8,
                        child: Icon(
                          Entypo.star,
                          color: favoritesProvider.getFavoriteItems.containsKey(matchesAttributes.id) ?
                          Colors.red  :
                          Colors.grey.shade800,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 8,
                        child: Icon(
                          Entypo.star_outlined,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                          right: 12,
                          top: 32,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            color: Theme.of(context).backgroundColor,
                            //text: Text()
                          ))
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(matchesAttributes.homeTeam + " vs " + matchesAttributes.AwayTeam,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))
                        ],
                      )),
                  Container(
                      //padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(matchesAttributes.stadium.name,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold))
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(matchesAttributes.type,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800])),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 1,
                        child: Material ( color: Colors.transparent ,
                            child: InkWell(
                              onTap:(){ShowTicketOption(matchesAttributes, context);},
                              borderRadius: BorderRadius.circular(30),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  /// Display the appropriate icon
                                  /// whether the product is added already in cart or not;
                                  cartProvider.getCartItems.containsKey(matchesAttributes.id,)
                                  ? // (a) show basket icon
                                  MaterialCommunityIcons.check_all
                                  :
                                    // (b) show icon 'already added'!
                                    MaterialCommunityIcons.cart_plus


                                    ,size: 25,
                                  color: Colors.black,


                                  ),
                              )
                              )
                            ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

}

ShowTicketOption(Match matchesAttributes, BuildContext context) async {

  await Future.delayed(Duration(seconds: 1), ()
  {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: DisplayTickets(matchesAttributes),

          );
        });
  });
}



