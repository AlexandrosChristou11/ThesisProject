
// The following widget will be displayed in
// case that the 'Wishlist' contains any items
// @author: Alexandros Christou - 27Oct21

import 'package:flutter/material.dart';
import 'package:sep21/consts/my_custom_icons/MyAppColors.dart';

class WishlistFull extends StatefulWidget {
  //const WishlistFull({Key? key}) : super(key: key);

  @override
  _WishlistFullState createState() => _WishlistFullState();
}

class _WishlistFullState extends State<WishlistFull> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,// take the full width of the screen
          margin: EdgeInsets.only(right: 30.0, bottom: 10.0),
          child: Material(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(6.0),
            elevation: 3.0,
            child: InkWell(
              onTap: (){},
              child: Container(
                padding: EdgeInsets.all(16.0),
                child:  Row(
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: Image.network('https://upload.wikimedia.org/wikipedia/en/thumb/5/50/Anorthosis_FC_logo.svg/1200px-Anorthosis_FC_logo.svg.png'),
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'title', style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold
                          ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'name', style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0
                          ),
                          )
                        ],
                      )
                    )
                  ],
                )
              )

            )

          )
        ),
        positionedRemoved(),

      ],

    );
  }

  positionedRemoved() {
    return Positioned(
      top:20, right: 15,
      child: Container(
        height: 30,
        width: 30,
        child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))
        ,
            padding: EdgeInsets.all(0.0),
            color: MyAppColor.favColor,
            child: (Icon(
              Icons.clear, color: Colors.white,
            ))
            ,onPressed: () {  },),
      ),
      
    );

  }
}
