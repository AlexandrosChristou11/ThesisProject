import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Services/payment_service.dart';
import 'package:sep21/Widgets/payment.dart';
import 'package:sep21/consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/consts/my_custom_icons/MyAppIcons.dart';
import '../CustomCardPaymentScreen.dart';
import '../NoWebhookPaymentCardFormScreen.dart';
import '../bottom_bar.dart';
import 'cart_empty.dart';
import 'cart_full.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;


class Cart extends StatefulWidget {

  static const routeName = '/cart';

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

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
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text('Cart (${cartProvider.getCartItems.length}) ', style: TextStyle(color: Colors.black),),

              actions: [
                IconButton(color: Colors.black,
                  onPressed: () { globalMethods.showDialogForRemoveItem('Clear Cart', 'Do you want to clear your cart?',
                          ()=> {cartProvider.clearCart() }
                  ,context); },
                  icon: Icon(MyAppIcons.trash),
                )
              ],
            ),
            body: Container(
              margin: EdgeInsets.only(bottom: 60),
              child: ListView.builder(itemCount:cartProvider.getCartItems.length,
                  itemBuilder: (BuildContext ctx, int index){
                return ChangeNotifierProvider.value(
                value: cartProvider.getCartItems.values.toList()[index]
                ,child: CartFull(
                     matchId:cartProvider.getCartItems.keys.toList()[index] ,
                    // id: cartProvider.getCartItems.values.toList()[index].id,// cast to list cause is of type 'Map'
                    // matchId: cartProvider.getCartItems.keys.toList()[index],
                    // price: cartProvider.getCartItems.values.toList()[index].price,
                    // title: cartProvider.getCartItems.values.toList()[index].title,
                    // imageUrl: cartProvider.getCartItems.values.toList()[index].imageUrl,
                    // quantity: cartProvider.getCartItems.values.toList()[index].quantity,
                    // stadium: cartProvider.getCartItems.values.toList()[index].stadium ,
                  ),
                );
                  }

              ),
            ));
    }


}

  Widget checkoutSection(BuildContext ctx, double totalAmount) {

    return Container(

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
                  gradient: LinearGradient(colors: [
                    MyAppColor.gradiendLStart,
                    MyAppColor.blueGrey,
                  ], stops: [
                    0.0,
                    0.7
                  ],),
                ),
                child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.transparent ,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(30.0),
                        onTap: () async {
                          /// Stripe's recieves amount as Integer - in cents, so we need to convert the total amount to cents
                          /// e.g $10.19 -> 10019 cents
                          double amountInCents = totalAmount*1000;
                          int integerAmount = (amountInCents/10).ceil();
                          await initPaymentSheet(ctx, email: 'example@gmail.com', amount: integerAmount);
                        },
                        //() async{ Navigator.pushNamed(ctx, NoWebhookPaymentCardFormScreen.routName); },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Checkout',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(ctx).textSelectionColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
                        ))),
              ),
            ),
            Spacer(),
            Text('Total ',
                style: TextStyle(
                    color: Theme.of(ctx).textSelectionColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            Text( totalAmount.toString() +'\€',
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


void Checkouts(BuildContext context) => showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        content: PaymentWidget(),
      );
    });


Future <void> initPaymentSheet( context, { required String email, required int amount }  ) async{

  try{
    final response = await http.post( Uri.parse('https://us-central1-ticketingapp-2e138.cloudfunctions.net/stripePaymentIntentRequest'),
        body: {'email' : email, 'amount' : amount.toString()}
    );

    final jsonResponse = jsonDecode(response.body);
    log( jsonResponse.toString() );

    /// Call Flutter's  stripe init payment sheet ..
    await Stripe.instance.initPaymentSheet
      (paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret:  jsonResponse['paymentIntent'],
        merchantDisplayName: 'Flutter Stripe CY-Seating Payment Demo',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
        style: ThemeMode.light,
        testEnv: true,
        merchantCountryCode: 'CY'

    ));

    await Stripe.instance.presentPaymentSheet();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Completed!')));

  }catch(e){

    if (e is StripeException){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error from stripe: ')));
      print('Error from Stripe: ${e.error.localizedMessage}');
    }else{
      print('Error from Stripe: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error:')));
    }

  }

}

Future<void> Checkout() async {
  
  print(Stripe.publishableKey);
  //Stripe.buildWebCard();
  //Stripe
  //StripeService.payWithNewCard(amount: '100', currency: 'usd');
}