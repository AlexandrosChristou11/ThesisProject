
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Provider/DarkTheme.dart';


import '../feed.dart';

class  CartEmpty extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
        children:
        [
          Container(
            margin: EdgeInsets.only(top:80),
            width: double.infinity, // take the whole screen
            height: MediaQuery.of(context).size.height*0.4,
            decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill,
                        image: AssetImage('assets/images/emptycart.png'))),
          ),
          Text('Your cart is empty!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textSelectionColor, fontSize: 35, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 25,),  // margin between 2 texts!
          Text('You did not select any seat yet!',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: themeChange.darkTheme? Theme.of(context).disabledColor : MyAppColor.selected,
                fontSize: 25, fontWeight: FontWeight.w500),
          ),

          SizedBox(height: 25,),  // margin between text & button!

          Container(
            width: MediaQuery.of(context).size.width*0.8,
            height: MediaQuery.of(context).size.height*0.07,
            child: RaisedButton(onPressed: () { Navigator.pushNamed(context, Feed.routeName); },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.red),),
                color: Colors.redAccent,
              child:
              Text('BOOK NOW',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
              )

            ),
          )
        ]
    );


  }


}