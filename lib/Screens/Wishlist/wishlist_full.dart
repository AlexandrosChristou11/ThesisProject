
// The following widget will be displayed in
// case that the 'Wishlist' contains any items
// @author: Alexandros Christou - 27Oct21

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Models/FavoritesAttr.dart';
import 'package:sep21/Provider/Favorite_Provider.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:sep21/consts/my_custom_icons/MyAppColors.dart';

class WishlistFull extends StatefulWidget {
  //const WishlistFull({Key? key}) : super(key: key);
  final String matchId;

  const WishlistFull({Key? key, required this.matchId}) ;

  @override
  _WishlistFullState createState() => _WishlistFullState();
}

class _WishlistFullState extends State<WishlistFull> {

  @override
  Widget build(BuildContext context) {
    final favoritesAttributes = Provider.of<FavoritestAttr>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
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
                      child: Image.network(favoritesAttributes.imageUrl),
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            favoritesAttributes.title, style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold
                          ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            favoritesAttributes.stadium.name, style: TextStyle(
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
        positionedRemoved(favoritesProvider),

      ],

    );
  }

  positionedRemoved(FavoritesProvider favoritesProvider) {
    GlobalMethods globalMethods = GlobalMethods();
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
            ,onPressed: ()=>{
              globalMethods.showDialogForRemoveItem
              ('Remove Wish', 'Match will be removed from wishlist',
              ()=> favoritesProvider.removeItem(widget.matchId)
              , context)},

      ),
      
    ));

  }
}
