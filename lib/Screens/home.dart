import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:backdrop/sub_header.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Inner%20Screens/team_navigation_rail.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Provider/InternetConnection.dart';
import 'package:sep21/Provider/Matches.dart';
import 'package:sep21/Screens/Wishlist/wishlist.dart';
import 'package:sep21/Screens/userInfo.dart' as userInfos;
import 'package:sep21/Services/Global_methods.dart';
import 'package:sep21/Services/push_notification.dart';
import 'package:sep21/Widgets/backlayer.dart';
import 'package:sep21/Widgets/popular_matches.dart';
import 'package:sep21/Widgets/sportCategories.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:http/http.dart' as http;


import 'feed.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String? _token;

  FirebaseAuth _auth = FirebaseAuth.instance;
  String _userId = "";
  String? _imageUrl;
  List _carouselImages = [
    'assets/images/pap.png',
    'assets/images/gsp.jpg',
    'assets/images/arena.jpg'
  ];
  List _sportImages = [
    'assets/images/Sports/vol.jpg',
    'assets/images/Sports/download.png',
    'assets/images/Sports/bask.png',
    'assets/images/Sports/ba.jpg'
  ];

  List _ClubsLogosImages =[
    'assets/images/Teams/ano.png',
    'assets/images/Teams/aek.png',
    'assets/images/Teams/ael.png',
    'assets/images/Teams/apoel.png',
    'assets/images/Teams/omo.png'
  ];

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription< ConnectivityResult > _connectivitySubscription;
  static bool isConnected = false;

   @override
  void initState() {
   initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);


   PushNotification.requestPermission();
   PushNotification.loadFCM();
   PushNotification.listenFCM();


    // requestPermission();
    //
    // loadFCM();
    //
    // listenFCM();
    //
     getToken();



    super.initState();
  }

  void sendPushNotification() async{
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

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
              'body': 'Test Body',
              'title': 'Test Title 2'
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

  void getToken() async{
     await FirebaseMessaging.instance.getToken().then((token)  {
       print('token: $token');
       setState(() {
         _token = token;
       });
     });

  }

  void requestPermission() async{

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

  void listenFCM() async{
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

  void loadFCM() async{
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

  Future<void> GetData () async{
    User? user = _auth.currentUser;
    _userId = user!.uid;
    final DocumentSnapshot userDocuments =
    await FirebaseFirestore.instance.collection('Users').doc(_userId).get();

    if (this.mounted) {
      setState(() {
        _imageUrl = userDocuments.get('ImageUrl');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /// --------------
    ///   PROVIDERS:
    /// --------------
    final darkTheme = Provider.of<DarkThemeProvider>(context);
    final matchesData = Provider.of<Matches>(context);
    matchesData.FetchMatches();
    final popularMatches = matchesData.PopularMatches;

    GetData();



    return  Scaffold(
        body: BackdropScaffold(
            frontLayerBackgroundColor:
                Theme.of(context).scaffoldBackgroundColor,
            headerHeight: MediaQuery.of(context).size.height * 0.25,
            appBar: BackdropAppBar(
              title: Text("Home"),
              leading: BackdropToggleButton(
                icon: AnimatedIcons.home_menu,
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  MyAppColor.starterColor,
                  MyAppColor.endColor
                ])),
              ),
              actions: <Widget>[
                InkWell(
                  onTap: ()=> Navigator.of(context).pushNamed('/userInfo'),
                  child: Container(
                    height: kToolbarHeight / 1.8,
                    width: kToolbarHeight / 1.8,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 1.0,
                        ),
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: NetworkImage(
                            this._imageUrl.toString() ?? "https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            backLayer: BackLayerMenu(),

            frontLayer: SingleChildScrollView(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // club selection text on the left
                children: [
                  Container(
                    child: SizedBox(
                      height: 190.0,
                      width: double.infinity,
                      child: Carousel(
                        boxFit: BoxFit.fill,
                        autoplay: true,
                        animationCurve: Curves.fastOutSlowIn,
                        animationDuration: Duration(milliseconds: 1000),
                        dotSize: 5.0,
                        dotIncreasedColor: Colors.blue,
                        dotBgColor: Colors.black.withOpacity(0.2),
                        dotPosition: DotPosition.bottomCenter,
                        //dotVerticalPadding: 10.0,
                        showIndicator: true,
                        indicatorBgPadding: 5.0,
                        images: [
                          ExactAssetImage(_carouselImages[0]),
                          ExactAssetImage(_carouselImages[1]),
                          ExactAssetImage(_carouselImages[2])
                        ],
                      ),
                    ),
                  ),

                  /// ***************************************************
                  ///                 SPORT SELECTION
                  /// ***************************************************
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(

                      child: Container(
                        decoration: BoxDecoration(

                            color: Theme.of(context).bottomAppBarColor,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0))),
                        child: Text(
                         ' Find your tickets for each sport: ',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 23),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:3.0, right: 3.0),
                    child: Container(
                        // decoration: Boxc.Decoration(
                        //
                        //     color: Theme.of(context).bottomAppBarColor,
                        //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0))),

                        width: double.infinity, height: 60,
                      child: ListView.builder(
                          itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext ctx,
                        int index){
                            return Container(
                                decoration: BoxDecoration(
                                    color: darkTheme.darkTheme ? Colors.white : Colors.black38,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8)
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: Offset(0, 1),
                                      ),
                                    ] ,),
                                child: TeamsWidget(index:index));
                        }, )
                    ),
                  ),
                  SizedBox( height: 30),

                  /// ***************************************************
                  ///               SPORT TYPE (CATEGORY) SELECTION
                  /// ***************************************************
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         "Select your sport:",
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.w800, fontSize: 20),
                  //       ),
                  //       Spacer(),
                  //       TextButton(
                  //         onPressed: () {},
                  //         child: Text("View all ..",
                  //             style: TextStyle(
                  //                 fontWeight: FontWeight.w800,
                  //                 fontSize: 15,
                  //                 color: Colors.red)),
                  //       )
                  //     ],
                  //   ),
                  // ),


                  // Container(
                  //     height: 180,
                  //    width: MediaQuery.of(context).size.width * 0.95,
                  //     child: Swiper(
                  //       itemCount: _sportImages.length,
                  //       autoplay: true,
                  //       onTap: (index) {},
                  //       itemBuilder: (BuildContext context, int index) {
                  //         return ClipRRect(
                  //           borderRadius: BorderRadius.circular(10),
                  //           child: Container(
                  //               color: Colors.blueGrey,
                  //               child: Image.asset(_sportImages[index],
                  //                   fit: BoxFit.contain)),
                  //         );
                  //       },
                  //     )),

                  /// ***************************************************
                  ///                 POPULAR TEAMS
                  /// ***************************************************
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: darkTheme.darkTheme ? Colors.white24 : Colors.black54),
                        color: Theme.of(context).bottomAppBarColor,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0))),
                      child: Row(
                        children: [
                          Text(
                            ' TICKETS BY CLUB',
                            style:
                            TextStyle(fontWeight: FontWeight.w800, fontSize: 23),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                TeamsNavigationRailScreen.routeName,
                                arguments: {
                                  5,
                                },
                              );
                            },
                            child: Text(
                              'View all...',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: Colors.red),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 210,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Swiper(
                      itemCount: _ClubsLogosImages.length,
                      autoplay: true,
                      viewportFraction: 0.8,
                      scale: 0.9,
                      onTap: (index) {
                        Navigator.of(context).pushNamed(
                          TeamsNavigationRailScreen.routeName,
                          arguments: {
                            index,
                          },
                        );
                      },
                      itemBuilder: (BuildContext ctx, int index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Theme.of(context).splashColor,
                              child: Image.asset(
                                _ClubsLogosImages[index],
                                fit: BoxFit.scaleDown,
                              ),


                          ),
                        );
                      },
                    ),
                  ),

                  /// ***************************************************
                  ///                POPULAR MATCHES
                  /// ***************************************************
                  SizedBox(height: 10,),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: darkTheme.darkTheme ? Colors.white24 : Colors.black54),
                        color: Theme.of(context).bottomAppBarColor,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),

                      ),
                      child: Row(
                        children: [
                          Text(
                            " POPULAR MATCHES",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 23),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(Feed.routeName, arguments: 'popular');
                            },
                            child: Text("View all ..",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: Colors.red)),
                          )
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: 285,
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: popularMatches.length,
                      itemBuilder: (BuildContext ctx, int index){
                        return ChangeNotifierProvider.value(
                          value: popularMatches[index],
                          child: PopularMatches(
                            imageURL:popularMatches[index].imageURL,
                            title: popularMatches[index].homeTeam + " vs " + popularMatches[index].AwayTeam,
                            type: popularMatches[index].type,
                            stadium: popularMatches[index].stadium,

                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )));
  }



}
