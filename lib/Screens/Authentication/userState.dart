/// @Author: Alexandros Christou
/// Date: 24Dec21
/// In the userState class will be managed whether the user
/// is logged in or not

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sep21/Screens/home.dart';
import 'package:sep21/Screens/landingPage.dart';
import 'package:sep21/Screens/mainScreen.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),

        /// Notifies user's actions (e.g Logins, Register, Signups etc)
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (userSnapshot.connectionState == ConnectionState.active) {
            /// .hasData method indicates that the user is logged in
            if (userSnapshot.hasData) {
              print ('The user is already logged in!');
              return MainScreens();
              //return Home();
            } else {
              print ('The user did not log in  yet!');
              return LandingPage();
            }
          } else if (userSnapshot.hasError) {
            return Center(child: Text('Error occurred'));
          }
          throw '';
        });
  }
}
