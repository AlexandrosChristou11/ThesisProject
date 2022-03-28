// @Author: Alexandros Christou
// Date:  05Dec21
// Initialisation of GlobalMethods Class:
// This class holds function that will be called
// regularly - avoid boilerplate coding and duplicates


import 'package:another_flushbar/flushbar_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';


class GlobalMethods{

  static bool isConnected = false;

   static void showStatus(ConnectivityResult result, bool status, BuildContext context) {
     FlushbarHelper.createInformation(
       title: "No Network Connection",
       message: 'Please connect to the Internet',
       //message: "This is illegal action.")
     )
       ..show(context);
   }

  Future<void> showDialogForRemoveItem(String title, String subtitle, VoidCallback  fct, BuildContext context) async {
    showDialog(context: context, builder: (BuildContext ctx){
      return AlertDialog(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: Icon(MyAppIcons.warning,size: 24,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title ),
            )
          ],
        ),
        content: Text(subtitle),
        actions: [
          TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Cancel')),
          TextButton(onPressed: (){
            fct();
            Navigator.pop(context);
          }, child: Text('OK')),
        ],
      );

    });
  }

  Future<void> authenticationErrorHandler(String subtitle,  BuildContext context) async {
    showDialog(context: context, builder: (BuildContext ctx){
      return AlertDialog(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: Icon(MyAppIcons.warning,size: 24, color: Colors.red,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Error occurred:' ),
            )
          ],
        ),
        content: Text(subtitle),
        actions: [

          TextButton(onPressed: (){

            Navigator.pop(context);
          }, child: Text('OK', style: TextStyle(color: MyAppColor.favColor),)),
        ],
      );

    });
  }

  Future<void> getTicketQrCode(BuildContext context, String matchId, String ticketId) async {
    showDialog(context: context, builder: (BuildContext ctx){
      return Dialog(
        child: QrImage(
          backgroundColor: Colors.white,
          data: " { 'matchId' : $matchId , 'ticketId' : $ticketId  } ",
        ),
      );

    });
  }

  String _getPolicy() {
    return
        "These Terms of Service constitute a legally binding agreement made between you, whether personally or on behalf of an entity (“you”) and CY-SEATING (“we,” “us” or “our”), concerning your access to and use of the CY-Seating mobile application as well as any other media form, media channel, mobile website or mobile application related, linked, or otherwise connected thereto (collectively, the “Site”). " +

        "You agree that by accessing the application, you have read, understood, and agree to be bound by all of these Terms of Service. If you do not agree with all of these Terms of Service, then you are expressly prohibited from using the application and you must discontinue use immediately. " +

        "Supplemental Terms of Service or documents that may be posted on the Application from time to time are hereby expressly incorporated herein by reference. We reserve the right, in our sole discretion, to make changes or modifications to these Terms of Service at any time and for any reason. "+

        "We will alert you about any changes by updating the “Last updated” date of these Terms of Service, and you waive any right to receive specific notice of each such change. " ;

  }


  Future<void> getApplicationTermsAndPolicy(BuildContext context) async {
    showDialog(context: context, builder: (BuildContext ctx){
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Container(
          decoration: BoxDecoration(
           // color: MyAppColor.selected,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5),),
          ),
          child: Row(
            children: [
              Icon(MyAppIcons.policy_rounded),
              Container(
                child: Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('TERMS & CONDITIONS',
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        softWrap: false,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 19,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w900)),

                  ),
                ),
              )
            ],
          ),
        ),
        content: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: MyAppColor.selected),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12))
              ),
              child: SingleChildScrollView(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_getPolicy(), textAlign: TextAlign.left, style: TextStyle(color: Colors.black45),),
              ),)),

        actions: [

          Container(
            margin: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: MyAppColor.selected,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Align(
              alignment: Alignment.center,
                child: TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('I agree', style: TextStyle(color: MyAppColor.white),)),

            ),
          ),
        ],
      );

    });
  }

}