import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Inner%20Screens/match_details.dart';
import 'package:sep21/Models/CartAttr.dart';
import 'package:sep21/Models/OrdersAttr.dart';
import 'package:sep21/Models/Stadium.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Provider/OrdersProvider.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:sep21/consts/my_custom_icons/MyAppColors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sep21/consts/my_custom_icons/MyAppIcons.dart';


class OrderFull extends StatefulWidget {

  @override
  _OrderFullState createState() => _OrderFullState();
}

class _OrderFullState extends State<OrderFull> {

  /// Declaration of Global methods class ...
  GlobalMethods globalMethods = GlobalMethods();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeChanged = Provider.of<DarkThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final orderAttrProvider = Provider.of<OrdersAttr>(context);


    return InkWell(
        onTap:  () => Navigator.pushNamed(context, MatchDetails.routeName, /*arguments: widget.matchId*/) ,
      child: Container(
        height: 140,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0)),
          color: Theme.of(context).backgroundColor,
        ),
        child: Row(
          children: [
            Container(
              width: 130,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage( orderAttrProvider.imageUrl ),
                     // fit: BoxFit.contain
                    )
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
                            orderAttrProvider.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(32),
                            onTap:() {
                              globalMethods.showDialogForRemoveItem('Remove Ticket', 'Tickets will be removed from MyTickets',
                                      () async{
                                setState(() {
                                  _isLoading = true;
                                });

                               await FirebaseFirestore.instance.collection('Order').doc(orderAttrProvider.orderId).delete(); }
                                  , context);

                              },
                            //{cartProvider.removeItem(widget.matchId); },
                            child: Container(
                                height: 50,
                                width: 50,
                                child:
                                _isLoading ? CircularProgressIndicator() :
                                Icon(Entypo.cross,
                                    color: Colors.red, size: 23)),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text('Quantity'),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          orderAttrProvider.quantity,
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        )
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
