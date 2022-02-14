import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Provider/OrdersProvider.dart';
import 'package:sep21/Services/payment_service.dart';
import 'package:sep21/Widgets/payment.dart';
import 'package:sep21/consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/consts/my_custom_icons/MyAppIcons.dart';
import '../CustomCardPaymentScreen.dart';
import '../NoWebhookPaymentCardFormScreen.dart';
import '../bottom_bar.dart';
import 'order_empty.dart';
import 'order_full.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;


class Order extends StatefulWidget {

  static const routeName = '/order';

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription< ConnectivityResult > _connectivitySubscription;
  static bool isConnected = false;

  // @override
  void initState() {

    StripeService.init();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);
    // Stripe.publishableKey =
    // "pk_test_51KICB0LhcxMZGOuNPKCRVuWpa2m3FKH9i1VwdB20AJyXqLXFUHm7waL3hr2Nv4o5WYB2LXvtIpWJ97oQKvBnvkuv00MLU3pHIw";
    // Stripe.merchantIdentifier = 'test';
    // Stripe.instance.applySettings();
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



    /// Declaration of Global methods class ...
    GlobalMethods globalMethods = GlobalMethods();




    /// ************
    ///  PROVIDERS:
    /// ************
    //final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    bool isOrder = false;


    return FutureBuilder(
      future: orderProvider.FetchOrders(),
      builder: (context, snapshot) {
        return orderProvider.getOrders.isEmpty
        // (a) In case that 'Cart' is empty (No tickets selected)
        // -> then appear a different screen !
            ? Scaffold(
                body: OrderEmpty(),
              )

        // (b) in case that 'Cart' is not empty (Tickets are selected)
        // -> then show 'Basket'
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).backgroundColor,
                  title: Text('MyTickets (${orderProvider.getOrders.length}) ', style: TextStyle(color: Colors.black),),

                  actions: [
                    IconButton(color: Colors.black,
                      onPressed: (){},

                      /*{ globalMethods.showDialogForRemoveItem('Clear Cart', 'Do you want to clear your cart?',
                              ()=> {cartProvider.clearCart() }
                      ,context); },*/
                      icon: Icon(MyAppIcons.trash),
                    )
                  ],
                ),
                    body: Container(
                      margin: EdgeInsets.only(bottom: 60),
                      child: ListView.builder(itemCount:orderProvider.getOrders.length,
                          itemBuilder: (BuildContext ctx, int index){
                        return ChangeNotifierProvider.value(
                            value: orderProvider.getOrders[index],
                            child: OrderFull());

                          }

                      ),
                    )
                );
      }
    );
    }


}

