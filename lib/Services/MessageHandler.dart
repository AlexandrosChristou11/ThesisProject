// import 'dart:async';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
//
//
// class MessageHandler extends StatefulWidget {
//   const MessageHandler({Key? key}) : super(key: key);
//
//   @override
//   _MessageHandlerState createState() => _MessageHandlerState();
// }
//
// class _MessageHandlerState extends State<MessageHandler> {
//
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   late StreamSubscription iosSubscription;
//
//   @override
//   void initState() {
//     super.initState();
// _fcm.app.
//     _fcm.configure(
//       onMessage: (Map<String, dynamic> message) async{
//         print("OnMessage: $message ");
//       },
//       onResume: (Map<String, dynamic> message) async{
//         print("OnResume: $message ");
//       },
//       onLaunch: (Map<String, dynamic> message) async{
//         print("onLaunch: $message ");
//       },
//
//     );
//
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
