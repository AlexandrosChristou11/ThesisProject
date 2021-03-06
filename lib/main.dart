import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Provider/InternetConnection.dart';
import 'package:sep21/Provider/OrdersProvider.dart';
import 'package:sep21/Screens/Authentication/userState.dart';
import 'package:sep21/Screens/bottom_bar.dart';
import 'package:sep21/Screens/mainScreen.dart';
import 'package:sep21/consts/my_custom_icons/Theme_data.dart';
import 'package:wiredash/wiredash.dart';
import 'Consts/constants.dart';
import 'Provider/Cart_Provider.dart';
import 'Provider/CurstomRoutes.dart';
import 'Provider/Favorite_Provider.dart';
import 'Provider/Matches.dart';
import 'Screens/landingPage.dart';
import 'package:firebase_core/firebase_core.dart';

/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() {

  /// Initialize the App ..
  WidgetsFlutterBinding.ensureInitialized();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvide = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvide.darkTheme =
        await themeChangeProvide.darkThemePreferences.getTheme();
  }


  @override
  void initState() {

    getCurrentAppTheme();
    super.initState();
  }


  /// Firebase depends on firebase_core so we need to include the
  /// appropriate dependency in the pubspec.yaml file and
  /// initialise the firebase service on the application
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return MaterialApp(
            home: Scaffold(body: Center(
              child: CircularProgressIndicator(),
            ),)
          );
        }
        else if (snapshot.hasError){
          MaterialApp(
              home: Scaffold(body: Center(
                child: Text("Error occurred"),
              ),)
          );
        }
        return MultiProvider(
            providers: [
              /// (1) Dark Theme Provider - state
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvide;
              }),

              /// (2) Matches Provider - state
              ChangeNotifierProvider(create: (_) => Matches()
              ),

              /// (3) Cart Provider
               ChangeNotifierProvider(create: (_) => CartProvider()),

              /// (4) Favorites Provider
               ChangeNotifierProvider(create: (_) => FavoritesProvider()),

              /// (5) Orders Provider
              ChangeNotifierProvider(create: (_) => OrderProvider()),


            ],
            child:
                Consumer<DarkThemeProvider>(builder: (context, themeData, child) {
              return Wiredash(
                secret: ConstantKeys.wiredashSecret,
                projectId: ConstantKeys.wiredashProjectId,
                navigatorKey: _navigatorKey ,
                child: MaterialApp(
                    navigatorKey: _navigatorKey,
                  title: 'Flutter Demo',
                  theme: Styles.themeData(themeChangeProvide.darkTheme, context),
                  initialRoute: '/',
                  routes: customRoutes,
                  home: UserState()//MainScreens(), //LandingPage(),
                ),
              );
            }));
      }
    );
  }
}
