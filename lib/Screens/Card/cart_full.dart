import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Inner%20Screens/match_details.dart';
import 'package:sep21/Models/CartAttr.dart';
import 'package:sep21/Models/Stadium.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Services/Global_methods.dart';

import 'package:fluttertoast/fluttertoast.dart';



class CartFull extends StatefulWidget {

  // final String id;
  // final String matchId;
  // final double price;
  // final int quantity;
  // final String title;
  // final String imageUrl;
  // final Stadium stadium;
  //
  //
  // const CartFull( {required this.id, required this.matchId, required this.price,
  //   required this.quantity, required this.title,
  //     required this.imageUrl, required this.stadium});

  final String matchId;


  CartFull({ required this.matchId});

  @override
  _CartFullState createState() => _CartFullState();
}

class _CartFullState extends State<CartFull> {

  /// Declaration of Global methods class ...
  GlobalMethods globalMethods = GlobalMethods();


  @override
  Widget build(BuildContext context) {
    final cartAttr = Provider.of<CartAttr>(context);
    final themeChanged = Provider.of<DarkThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    
    double subTotal = cartAttr.price * cartAttr.quantity;
    print ("MATCH ID: ${widget.matchId}");
    return InkWell(
        onTap:  () =>  Navigator.pushNamed(context, MatchDetails.routeName, arguments: cartAttr.matchId) ,
      child: Container(
        height: 180,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0)),
          color: Theme.of(context).backgroundColor,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 130,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                    ),
                    image: DecorationImage(
                        image: NetworkImage(
                            cartAttr.imageUrl),
                       // fit: BoxFit.contain
                      )
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            cartAttr.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 16,)
                            ,textAlign: TextAlign.center,
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(32),
                            onTap: () {
                              globalMethods.showDialogForRemoveItem('Remove Item', 'Tickets will be removed from cart',
                                ()=> {cartProvider.removeItem(widget.matchId) }
                            , context);},
                            //{cartProvider.removeItem(widget.matchId); },
                            child: Container(
                                height: 50,
                                width: 50,
                                child: Icon(Entypo.cross,
                                    color: Colors.red, size: 23)),
                          ),
                        )
                      ],
                    ),

                    Row(
                      children: [
                        Icon(MyAppIcons.date_range, size: 14,),

                        // padding: const EdgeInsets.symmetric(vertical: 8.0),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            //' ${DateFormat("dd-MM-yyyy").format(DateTime.parse(matchesAttributes.date))}' ,//+ matchesAttributes.price.toString(),
                            ' ${Jiffy(cartAttr.date).yMMMd}' ,//+ matchesAttributes.price.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900),

                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(MyAppIcons.seat, size: 14,),

                        // padding: const EdgeInsets.symmetric(vertical: 8.0),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            ' ${cartAttr.sector}' ,//+ matchesAttributes.price.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900),

                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(MyAppIcons.apps, size: 14,),

                        // padding: const EdgeInsets.symmetric(vertical: 8.0),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            ' ${cartAttr.ticketType}' ,//+ matchesAttributes.price.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900),

                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(MyAppIcons.perm_identity, size: 14,),

                        // padding: const EdgeInsets.symmetric(vertical: 8.0),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            ' ${cartAttr.fanId}' ,//+ matchesAttributes.price.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900),

                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(MyAppIcons.payment, size: 14,),

                        // padding: const EdgeInsets.symmetric(vertical: 8.0),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                              cartAttr.price.toStringAsFixed(2) + '€',//+ matchesAttributes.price.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900),

                          ),
                        ),
                      ],
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DisplayErrorMessage(BuildContext ctx) {
  Fluttertoast.showToast(
      msg: "Quantity can not be negative!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );

}
