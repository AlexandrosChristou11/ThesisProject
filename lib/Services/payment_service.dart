import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;


class StripeTransactionResponse {
  String message;
  bool success;

  StripeTransactionResponse({required this.message, required this.success});
}

class StripeService {
  static String apiBase = 'http://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static Uri paymentApiUri = Uri.parse(paymentApiUrl);
  static String secret =
      'sk_test_51KICB0LhcxMZGOuNe7gWDPcyA016jJH9cpan8IPF65VoMe7bgZhH9ThzUS3bDMgTHaTiQgTwJYCxji7WI9EZXyZ800fFPRu5vG';

  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-type': 'application/x-www-form-urlencoded'
  };

  /// Initialize Stripe payment
  static init() {
    Stripe.publishableKey =
    "pk_test_51KICB0LhcxMZGOuNPKCRVuWpa2m3FKH9i1VwdB20AJyXqLXFUHm7waL3hr2Nv4o5WYB2LXvtIpWJ97oQKvBnvkuv00MLU3pHIw";
    //Stripe.merchantIdentifier = 'test';
    Stripe.instance.applySettings();
  }

  // Future<void> _handlePayPress() async{
  //
  //   try{
  //     /// 1) Gather user's information
  //     final billingDetails = BillingDetails();
  //
  //     /// (2) Create payment method
  //     final paymentMethod = await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(
  //       billingDetails: billingDetails
  //     ));
  //
  //     /// (3) Call API to create PaymentIntent
  //     final paymentIntentResult = await callNoWebhookPayEndpointMethodId(
  //         useStripeSdk: true, paymentMethodId: paymentMethod.id, currency: 'EUR');
  //
  //     if (paymentIntentResult['error'] != null) {
  //       // Error during creating or confirming Intent
  //       //ScaffoldMessenger.of(context).showSnackBar(
  //         //  SnackBar(content: Text('Error: ${paymentIntentResult['error']}')));
  //       print('Error: ${paymentIntentResult['error']}');
  //       return;
  //     }
  //
  //     if (paymentIntentResult['clientSecret'] != null &&
  //         paymentIntentResult['requiresAction'] == null) {
  //       // Payment succedeed
  //
  //      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //        //   content:
  //           print('Success!: The payment was confirmed successfully!');
  //       return;
  //     }
  //
  //     ///   4. if payment requires action calling handleCardAction
  //     if (paymentIntentResult['clientSecret'] != null &&
  //         paymentIntentResult['requiresAction'] == true) {
  //
  //       final paymentIntent = await Stripe.instance
  //           .handleCardAction(paymentIntentResult['clientSecret']);
  //     }
  //
  //     /// 5. Call API to confirm intent
  //     if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
  //
  //       await confirmIntent(paymentIntent.id);
  //     } else {
  //       // Payment succedeed
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text('Error: ${paymentIntentResult['error']}')));
  //       print('Error: ${paymentIntentResult['error']}');
  //     }
  //
  //   }catch(e){}
  //
  //
  // }

  Future<Map<String, dynamic>> callNoWebhookPayEndpointMethodId({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    List<Map<String, dynamic>>? items,
  }) async {
    Map<String, dynamic> body = {"amount": 100, "currency": currency};
    final url = Uri.parse(paymentApiUrl);
    final response = await http.post(
      url,
      headers: headers,
      body: body
      );

    return json.decode(response.body);
  }

}