/// @author: Alexandros Christou
/// Date: 18Dec21
/// Implementation of Landing Page which will be displayed at first
/// launch & whenever the user decides to log out

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: "http://welcomeqatar.com/wp-content/uploads/2015/02/QATAR-UNIVERSITY-STADIUM.jpg",
              placeholder: (context, url)=>Image.network("https://uploads.sitepoint.com/wp-content/uploads/2015/12/1450973046wordpress-errors.png",
                fit: BoxFit.contain,),
              fit: BoxFit.contain,
              errorWidget: (context, url, error)=> Icon(Icons.error),
              height: double.infinity,
              width: double.infinity,
              //alignment: ,
            ),
            Container(
              margin: EdgeInsets.only(top:30),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Welcome", style:TextStyle(fontSize: 40, fontWeight: FontWeight.w600),),
                  SizedBox(height: 20,),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text("Welcome to the CY-Seating", textAlign: TextAlign.center, style:TextStyle(fontSize: 26, fontWeight: FontWeight.w600),)),

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
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Expanded(
                    child: ElevatedButton(
                      /// Button's rounded border ..
                      style: ButtonStyle( backgroundColor: MaterialStateProperty.all(Colors.blue.shade300),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>
                        (RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: MyAppColor.backgroundColor)))) ,
                        onPressed: (){},
                        child: Text('Login',
                          style: TextStyle(fontWeight:FontWeight.w600, fontSize: 17 ) )),
                  ),
                    SizedBox(width: 10,),
                    /// (2) Sign Up ...
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blue.shade300),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>
                            (RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: MyAppColor.backgroundColor)))) ,
                          onPressed: (){},
                          child: Text('Sign up',
                              style: TextStyle(fontWeight:FontWeight.w600, fontSize: 17 ) )),
                    ),
                    SizedBox(width: 10,),
                  ]
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          color: Colors.white,
                          thickness: 2,),
                      ),
                    ),
                    Text("Or continue with", style: TextStyle(color: Colors.black54),),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          color: Colors.white,
                          thickness: 2,),
                      ),
                    ),
                  ],
                )
                
              ],
            )
          ],

        ));
  }
}
