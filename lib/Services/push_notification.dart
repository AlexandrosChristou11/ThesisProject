

import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class PushNotification{

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static late bool recieveNotifications = false;

  static void sendPushNotification(String match) async{


    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAT-yNvF0:APA91bFgrAeZcoDpYVpBvudz3em3vshAMhRUsANl6QmiSymO2LTs452Pc4s_Ehp2a_XqcWNaTrpytZZzTnC8YQCZRmdExbH1etSRwxbdTjxMQTK3J3i2baw_rlSQmfVH1GItIBy85-Zl',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'NEW MATCH IS AVAILABLE',
              'title': 'Tickets for match $match are now available in Cy-Seating! Hurry up, and book yours.'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": "/topics/Animal",
          },
        ),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }


  static void requestPermission() async{

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized){
      print('User granted permission!');
    }else if (settings.authorizationStatus == AuthorizationStatus.provisional){
      print('User granted provisional permission!');
    }else{
      print('User declined or has not accepted permission !');
    }

  }

  static void listenFCM() async{
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });


  }

  static void loadFCM() async{
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

  }

  static void unsubscrbeFromTopic() async{
    await FirebaseMessaging.instance.unsubscribeFromTopic("GetNotifications");

  }

  static void subscrbeToTopic() async{
    await FirebaseMessaging.instance.subscribeToTopic("GetNotifications");

  }





}