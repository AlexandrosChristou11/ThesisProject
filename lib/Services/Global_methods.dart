// @Author: Alexandros Christou
// Date:  05Dec21
// Initialisation of GlobalMethods Class:
// This class holds function that will be called
// regularly - avoid boilerplate coding and duplicates


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';


class GlobalMethods{

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

}