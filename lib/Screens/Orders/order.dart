import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  // @override
  void initState() {

    StripeService.init();
    // Stripe.publishableKey =
    // "pk_test_51KICB0LhcxMZGOuNPKCRVuWpa2m3FKH9i1VwdB20AJyXqLXFUHm7waL3hr2Nv4o5WYB2LXvtIpWJ97oQKvBnvkuv00MLU3pHIw";
    // Stripe.merchantIdentifier = 'test';
    // Stripe.instance.applySettings();
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

