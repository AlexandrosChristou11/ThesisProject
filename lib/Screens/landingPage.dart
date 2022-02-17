/// @author: Alexandros Christou
/// Date: 18Dec21
/// Implementation of Landing Page which will be displayed at first
/// launch & whenever the user decides to log out

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Screens/Authentication/login.dart';
import 'package:sep21/Screens/Authentication/signUp.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'bottom_bar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

/// TickerProviderStateMixin will allow us to make the background image to move ..
class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  List<String> sports = [
    "https://www.seekpng.com/png/full/29-294550_image-description-football-player-logo-png.png",
    "https://fashionsista.co/downloadpng/png/20200902/basketball-logo-2-player-ball-hoop-net-ball-sports-game.jpg",
    "https://images.assetsdelivery.com/compings_v2/dmytrohrynchak/dmytrohrynchak1809/dmytrohrynchak180900093.jpg",
    "https://media.gettyimages.com/vectors/handball-player-in-attack-team-sport-vector-id484966946?s=2048x2048"
  ];
  GlobalMethods gb = new GlobalMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  /// triggers the animation to start directly at screen launching
  /// and once the status is completed -> reset the animation
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sports.shuffle(); /// shuffles the indexes in the sport list, in order to show a different background at each display

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            /// check if animation is active or not..
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward(); // restarting the animation
            }
          });
    _animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  Future <void> _GoogleSignIn() async{
    final gooleSignIn = GoogleSignIn();
    final goolgeAccount = await gooleSignIn.signIn();

    // check if google account is not empty
    if (goolgeAccount != null) {
      // get credentials
      final googleAuthentication = await goolgeAccount.authentication;
      if (googleAuthentication.accessToken != null && googleAuthentication.idToken != null){
       try{
         var date = DateTime.now().toString();
         var dateParse = DateTime.parse(date);
         var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";

         final authResult = await _auth.signInWithCredential(GoogleAuthProvider.credential(
             idToken:  googleAuthentication.idToken, accessToken: googleAuthentication.accessToken));


         await FirebaseFirestore.instance.collection('Users').doc(authResult.user!.uid).set({
           'id': authResult.user!.uid,
           'name': authResult.user!.displayName,
           'email' : authResult.user!.email,
           'phoneNumber' : authResult.user!.phoneNumber,
           'ImageUrl': authResult.user!.photoURL,
           'joinedAt' : formattedDate,

         });
       }
       catch (e){
         gb.authenticationErrorHandler(e.toString(), context);
       }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 59.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.all( Radius.circular(180.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Image.asset(
                   'assets/images/logos-removebg.png',
                fit: BoxFit.fill,
                height: 300,
                width: 300,
                alignment: FractionalOffset(_animationController.value, 0),

              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   "Welcome",
              //   style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
              // ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Welcome to the CY-Seating",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                  )),
            ],
          ),
        ),

        /// -----------------------
        ///   BUTTONS ON THE BOTTOM
        /// -----------------------
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /// (1) Login ...
            Row(children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: ElevatedButton(

                      /// Button's rounded border ..
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue.shade300),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(
                                          color: MyAppColor.backgroundColor)))),
                      onPressed: ()=> {Navigator.pushNamed(context, LoginScreen.routName)},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17)),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Feather.user,
                            size: 17,
                          )
                        ],
                      ))),
              SizedBox(
                width: 10,
              ),

              /// (2) Sign Up ...
              Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue.shade300),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                        color: MyAppColor.backgroundColor)))),
                    onPressed: ()=>{Navigator.pushNamed(context, SingUpScreen.routName)},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sign up',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 17)),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Feather.user_plus,
                          size: 17,
                        )
                      ],
                    )),
              ),
              SizedBox(
                width: 10,
              ),
            ]),
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                ),
                Text(
                  "Or continue with",
                 // style: TextStyle(color: Colors.black54),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /// (3) Google sign in ...
                OutlineButton(
                  onPressed: _GoogleSignIn,
                  shape: StadiumBorder(),
                  highlightedBorderColor: Colors.red.shade200,

                  /// Border color wiil change once its clicked. .
                  borderSide: BorderSide(width: 2, color: Colors.red),
                  child: Text("Google +"),
                ),

                /// (4) Continue as guest ...
                // OutlineButton(
                //   onPressed: () {
                //     Navigator.pushNamed(context, BottomBarScreen.routeName);
                //   },
                //   shape: StadiumBorder(),
                //   highlightedBorderColor: Colors.deepPurpleAccent.shade200,
                //
                //   /// Border color wiil change once its clicked. .
                //   borderSide:
                //       BorderSide(width: 2, color: Colors.deepPurpleAccent),
                //   child: Text("Signing as a guest"),
                // ),
              ],
            ),

            SizedBox(
              height: 40,
            )
          ],
        )
      ],
    ));
  }
}
