/// @author: Alexandros Christou
/// Date: 08Feb21
/// Implementation of Terms & Conditions Policy Screen of the application

import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {

  static const routeName = '\PolicyScreen';

  const PolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Terms & Privacy Policy'
        ),
      ),


    );
  }
}
