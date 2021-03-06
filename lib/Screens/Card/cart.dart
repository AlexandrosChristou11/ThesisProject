import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Services/payment_service.dart';
import 'package:sep21/ViewModels/CartDetailsVM.dart';
import 'package:sep21/ViewModels/TicketVM.dart';
import 'package:sep21/Widgets/payment.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:uuid/uuid.dart';
import '../CustomCardPaymentScreen.dart';
import '../NoWebhookPaymentCardFormScreen.dart';
import '../bottom_bar.dart';
import 'cart_empty.dart';
import 'cart_full.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class Cart extends StatefulWidget {
  static const routeName = '/cart';
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _userId = "";

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  // @override
  void initState() {
    StripeService.init();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);

  }
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription< ConnectivityResult > _connectivitySubscription;
  static bool isConnected = false;



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
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartItems.isEmpty
        // (a) In case that 'Cart' is empty (No tickets selected)
        // -> then appear a different screen !
        ? Scaffold(
            body: CartEmpty(),
          )

        // (b) in case that 'Cart' is not empty (Tickets are selected)
        // -> then show 'Basket'
        : Scaffold(
            bottomSheet: checkoutSection(context, cartProvider.totalAmount),
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      MyAppColor.starterColor,
                      MyAppColor.endColor
                    ])),
              ),
              title: Text(
                'Cart (${cartProvider.getCartItems.length}) ',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                IconButton(
                  color: Colors.black,
                  onPressed: () {
                    globalMethods.showDialogForRemoveItem(
                        'Clear Cart',
                        'Do you want to clear your cart?',
                        () => {cartProvider.clearCart()},
                        context);
                  },
                  icon: Icon(MyAppIcons.trash, color: MyAppColor.black,),
                )
              ],
            ),
            body: Container(
              margin: EdgeInsets.only(bottom: 60),
              child: ListView.builder(
                  itemCount: cartProvider.getCartItems.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return ChangeNotifierProvider.value(
                      value: cartProvider.getCartItems.values.toList()[index],
                      child: CartFull(
                        matchId: cartProvider.getCartItems.keys.toList()[index],
                        // id: cartProvider.getCartItems.values.toList()[index].id,// cast to list cause is of type 'Map'
                        // matchId: cartProvider.getCartItems.keys.toList()[index],
                        // price: cartProvider.getCartItems.values.toList()[index].price,
                        // title: cartProvider.getCartItems.values.toList()[index].title,
                        // imageUrl: cartProvider.getCartItems.values.toList()[index].imageUrl,
                        // quantity: cartProvider.getCartItems.values.toList()[index].quantity,
                        // stadium: cartProvider.getCartItems.values.toList()[index].stadium ,
                      ),
                    );
                  }),
            ));
  }
}

Widget checkoutSection(BuildContext ctx, double totalAmount) {
  final cartProvider = Provider.of<CartProvider>(ctx);
  FirebaseAuth _auth = FirebaseAuth.instance;
  String userId = "";
  var uuid = Uuid();

  return Container (
    decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                gradient: LinearGradient(
                  colors: [
                    MyAppColor.gradiendLStart,
                    MyAppColor.blueGrey,
                  ],
                  stops: [0.0, 0.7],
                ),
              ),
              child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  color: MyAppColor.selected,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(30.0),
                      onTap: () async {
                      try{
                        User? user = _auth.currentUser;
                        userId = user!.uid;
                        /// Stripe's receives amount as Integer - in cents, so we need to convert the total amount to cents
                        /// e.g $10.19 -> 10019 cents
                        double amountInCents = totalAmount * 1000;
                        int integerAmount = (amountInCents / 10).ceil();
                          int responseStatus = await initPaymentSheet(ctx,
                              email: user.email.toString(),
                              amount: integerAmount);

                        /// Complete order if transaction was successful
                        /// status code: 200 indicates that the https post request was OK
                        if (responseStatus == 200) {


                          cartProvider.getCartItems
                              .forEach((key, orderValue) async {
                            final orderId = uuid.v4();
                            try {
                              await FirebaseFirestore.instance
                                  .collection('Order')
                                  .doc(orderId)
                                  .set({
                                'orderId': orderId,
                                'userId': userId,
                                'matchId': orderValue.matchId,
                                'title': orderValue.title,
                                'imageUrl': orderValue.imageUrl,
                                'quantity': orderValue.quantity,
                                'date' : orderValue.date,
                                'stadium': orderValue.stadium,
                                'sector' : orderValue.sector,
                                'orderDate': DateTime.now()
                              });

                              List <CartDetailsVM> items = List.from(cartProvider.getCartDetails());
                              for (int i = 0; i < items.length; i ++){
                                print ('items: ${items[i].Type} & ${items[i].Sector}');
                               // String sector = _getSectorAttribute(items[i].Sector);
                                //int quantity = 1;
                                TicketVM ticket = await _getSectorAttribute(items[i].Sector, items[i].Type, items[i].MatchId);
                                var collection = await FirebaseFirestore.instance.collection('Matches');
                                collection
                                    .doc(items[i].MatchId) // <-- Doc ID where data should be updated.
                                    .update({ ticket.Field!  : '${ticket.Quantity}' } );
                              }

                              cartProvider.addListener(() { });

                              /// to do... reduce availability of tickets from
                              cartProvider.clearCart();



                            } catch (e) {
                              print('Error has been occured: ${e.toString()}');
                            }
                          });
                        }
                      } on StripeException catch (er){
                        print("STRIPE ERROR: ${er.toString()}");
                        GlobalMethods gb = new GlobalMethods();
                        gb.authenticationErrorHandler(er.error.toString(), ctx);

                      }catch(error){
                        print("STRIPE ERROR: ${error.toString()}");
                        GlobalMethods gb = new GlobalMethods();
                        gb.authenticationErrorHandler(error.toString(), ctx);
                      }

                      },
                      //() async{ Navigator.pushNamed(ctx, NoWebhookPaymentCardFormScreen.routName); },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Pay now',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(ctx).textSelectionColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600)),
                      ))),
            ),
          ),
          Spacer(),
          Text('Total: ',
              style: TextStyle(
                  color: Theme.of(ctx).textSelectionColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          Text(totalAmount.toStringAsFixed(2)  + '\???',
              // textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    ),
  );
}

Future<TicketVM> _getSectorAttribute(String sector, String type, String matchId) async{


  if (  sector == 'South'){
    if (type == 'Regular'){
      String Field = 'Sector A Regular Ticket Quantity';
      var collection = FirebaseFirestore.instance.collection('Matches');
      var docSnapshot = await collection.doc(matchId)
          .get();
      Map<String, dynamic>? data = docSnapshot.data();
      var quantity = int.parse(data?['Sector A Regular Ticket Quantity']); // <-- The value you want to retrieve.
      print ('QUANTITY: $quantity');
      quantity =- 1;
      TicketVM ticketVM = new TicketVM.name(Field, quantity);
      return ticketVM;
    }else{
      String Field = 'Sector A Student Ticket Quantity';
      var collection = FirebaseFirestore.instance.collection('Matches');
      var docSnapshot = await collection.doc(matchId)
          .get();
      Map<String, dynamic>? data = docSnapshot.data();
      var quantity = int.parse(data?['Sector A Student Ticket Quantity']); // <-- The value you want to retrieve.
      print ('QUANTITY: $quantity');
      int Quantity = quantity-=1;
      TicketVM ticketVM = new TicketVM.name(Field, Quantity);
      return ticketVM;
    }

  }
  else if (  sector == 'East'){
   if (type == 'Regular'){
     String Field = 'Sector B Regular Ticket Quantity';
     var collection = FirebaseFirestore.instance.collection('Matches');
     var docSnapshot = await collection.doc(matchId)
         .get();
     Map<String, dynamic>? data = docSnapshot.data();
     var quantity = int.parse(data?['Sector B Regular Ticket Quantity']); // <-- The value you want to retrieve.
     print ('QUANTITY: $quantity');
     int Quantity = quantity-=1;
     TicketVM ticketVM = new TicketVM.name(Field, Quantity);
     return ticketVM;
   }else{
     String Field = 'Sector B Student Ticket Quantity';
     var collection = FirebaseFirestore.instance.collection('Matches');
     var docSnapshot = await collection.doc(matchId)
         .get();
     Map<String, dynamic>? data = docSnapshot.data();
     var quantity = int.parse(data?['Sector B Student Ticket Quantity']); // <-- The value you want to retrieve.
     print ('QUANTITY: $quantity');
     int Quantity = quantity-=1;
     TicketVM ticketVM = new TicketVM.name(Field, Quantity);
     return ticketVM;
   }

  }
  else if (  sector == 'West'){
    if (type == 'Regular'){
      String Field = 'Sector C Regular Ticket Quantity';
      var collection = FirebaseFirestore.instance.collection('Matches');
      var docSnapshot = await collection.doc(matchId)
          .get();
      Map<String, dynamic>? data = docSnapshot.data();
      var quantity = int.parse(data?['Sector C Regular Ticket Quantity']); // <-- The value you want to retrieve.
      print ('QUANTITY: $quantity');
      int Quantity = quantity-=1;
      TicketVM ticketVM = new TicketVM.name(Field, Quantity);
      return ticketVM;
    }else{
      String Field = 'Sector C Student Ticket Quantity';
      var collection = FirebaseFirestore.instance.collection('Matches');
      var docSnapshot = await collection.doc(matchId)
          .get();
      Map<String, dynamic>? data = docSnapshot.data();
      var quantity = int.parse(data?['Sector C Student Ticket Quantity']); // <-- The value you want to retrieve.
      print ('QUANTITY: $quantity');
      int Quantity = quantity-=1;
      TicketVM ticketVM = new TicketVM.name(Field, Quantity);
      return ticketVM;
    }

  }
  TicketVM ticketVM = new TicketVM.name('Field', 1);
  return ticketVM;

}

void Checkouts(BuildContext context) => showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        content: PaymentWidget(),
      );
    });

Future<int> initPaymentSheet(context,
    {required String email, required int amount}) async {
  var response;
  try {
    response = await http.post(
        Uri.parse(
            'https://us-central1-ticketingapp-2e138.cloudfunctions.net/stripePaymentIntentRequest'),
        body: {'email': email, 'amount': amount.toString()});

    final jsonResponse = jsonDecode(response.body);
    log(jsonResponse.toString());

    /// Call Flutter's  stripe init payment sheet ..
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: jsonResponse['paymentIntent'],
            merchantDisplayName: 'Flutter Stripe CY-Seating Payment Demo',
            customerId: jsonResponse['customer'],
            customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
            style: ThemeMode.light,
            testEnv: true,
            merchantCountryCode: 'CY'));

    await Stripe.instance.presentPaymentSheet();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Payment Completed!')));


    return response.statusCode;
  } catch (e) {
    if (e is StripeException) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Payment was cancelled')));
      print('Error from Stripe: ${e.error.localizedMessage}');
      return 0;
    } else {
      print('Error from Stripe: ${e.toString()}');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error:')));

    }
  }

  return 0;

  /// Complete order if transaction was successfull ...
  if (response.statusCode == 200) {
    print('RESPONSE STATUS 200 & TRANSACTION SUCCESSFULL !');
  }
  print('RESPONSE STATUS: ${response.statusCode}');
}

