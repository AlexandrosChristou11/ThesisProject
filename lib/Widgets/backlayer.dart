import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sep21/Screens/Card/cart.dart';
import 'package:sep21/Screens/feed.dart';
import 'package:sep21/Screens/uploadNewMatch.dart';
import 'package:sep21/Screens/Wishlist/wishlist.dart';
import 'package:sep21/consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/consts/my_custom_icons/MyAppIcons.dart';

class BackLayerMenu extends StatelessWidget {
  //const BackLayerMenu({Key? key}) : super(key: key);
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _userId = "";


  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    _userId = user!.uid;
    print('CURRENT USER IS : ' + user.displayName.toString());
    print('USERS UID IS : ' + user.uid.toString());

    return Stack(
      fit: StackFit.expand,
      children: [
        Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [MyAppColor.starterColor, MyAppColor.endColor],
                //begin: const FractionalOffset(0.0, 0.0),
                //end: const FractionalOffset(1.0, 0.0),
               // stops: [0.0, 0.0, 3.0],
                tileMode: TileMode.clamp),
          ),
        ),
        Positioned(
            top: -100.0,
            left: 140.0,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white.withOpacity(0.3),
                ),
                width: 150,
                height: 250,
              ),
            )),
        Positioned(
            top: 0.0,
            left: 100.0,
            child: Transform.rotate(
              angle: -0.9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white.withOpacity(0.3),
                ),
                width: 150,
                height: 300,
              ),
            )),
        Positioned(
            top: 10.0,
            left: 0.0,
            child: Transform.rotate(
              angle: -0.8,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white.withOpacity(0.3),
                ),
                width: 150,
                height: 200,
              ),
            )),
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Container(
                      //   clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                            fit: BoxFit.fill,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                content(context, () {
                 navigateTo(context, Wishlist.routeName);
                }, 'Wishlist', 2),
                const SizedBox(height: 10.0),
                content(context, () {
                  navigateTo(context, Cart.routeName);
                }, 'Cart', 1),
                const SizedBox(height: 10.0),
                /// Check if the user is the admin and allow him to
                /// upload new matches
                if (user.displayName == "admin") content(context, () {
                  navigateTo(context, UploadMatchForm.routeName);
                }, 'Upload a new match', 3) else const SizedBox(height: 10.0),


              ],
            ),
          ),
        ),
      ],
    );
  }

   List _contentIcons = [
    MyAppIcons.rss,
    MyAppIcons.shopping_basket_outlined,
    MyAppIcons.wishlist,
    MyAppIcons.upload
  ];

  void navigateTo(BuildContext ctx, String routeName) {
    Navigator.of(ctx).pushNamed(
      routeName
    );
   // Navigator.pushNamed(ctx, routeName);
  }

  Widget content(BuildContext ctx, Function fct, String text, int index) {
    return InkWell(
      onTap:  () { fct(); },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
          Icon(_contentIcons[index])
        ],
      ),
    );
  }
}
