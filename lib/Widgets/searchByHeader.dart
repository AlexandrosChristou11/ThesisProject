/// Implementation of SearchByHeader class ..
/// @Author: Alexandros Christou
/// Date: 13Dec21

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Provider/Favorite_Provider.dart';
import 'package:sep21/Screens/Card/cart.dart';
import 'package:sep21/Screens/userInfo.dart';
import 'package:sep21/Screens/Wishlist/wishlist.dart';

class SearchByHeader extends SliverPersistentHeaderDelegate{

  final double flexibleSpace;
  final double backgroundHeight;
  final double stackPaddingTop;
  final double titlePaddingTop;
  final Widget title;
  // final Widget subTitle;
  // final Widget leading;
  // final Widget action;
  final Widget stackChild;


  SearchByHeader({
    this.flexibleSpace = 250,
    this.backgroundHeight = 200,
    required this.stackPaddingTop,
    this.titlePaddingTop = 35,
    required this.title,
  //  required this.subTitle,
    required this.stackChild,
    //required this.leading,
    //required this.action,

  });



  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    var percent = shrinkOffset / (maxExtent - minExtent);
    double calculate = 1 - percent < 0 ? 0 : (1-percent);



    return SizedBox(
      height: maxExtent,
      child: Stack(

        /// ------------------------
        ///
        /// ------------------------
        children: <Widget>[
          Container(
            height: minExtent + ((backgroundHeight -minExtent) * calculate),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyAppColor.starterColor,
                  MyAppColor.endColor,
                ],
                begin: const FractionalOffset(0.0, 1.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode:  TileMode.clamp
              )
            ),
          ),

          /// -------------------------------------
          ///         TOP BAR:
          /// -------------------------------------


          /// ------------------------
          ///     (1) FAVORITES:
          /// ------------------------
          Positioned(
            top:30,
            right: 10
          ,child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Consumer<FavoritesProvider>(
                builder: (_, favorites, ch)=> Badge(
                  badgeColor: MyAppColor.favBadgeColor,
                  position: BadgePosition.topEnd(top: 5, end: 7),
                  badgeContent: Text(
                    favorites.getFavoriteItems.length.toString(),
                    style: TextStyle(color: MyAppColor.white),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.favorite, color: MyAppColor.white,),
                    onPressed: ()=> {Navigator.of(context).pushNamed(Wishlist.routeName)},
                  ),
                )
              ),

              /// ------------------------
              ///     (2) CART:
              /// ------------------------
              Consumer<CartProvider>(
                  builder: (_, cartProvider, ch)=> Badge(
                    badgeColor: MyAppColor.cartBadgeColor,
                    position: BadgePosition.topEnd(top: 5, end: 7),
                    badgeContent: Text(
                      cartProvider.getCartItems.length.toString(),
                      style: TextStyle(color: MyAppColor.white),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart, color: MyAppColor.white),
                      onPressed: ()=> {Navigator.of(context).pushNamed(Cart.routeName)},
                    ),
                  )
              ),
            ],
          ),),
          /// ------------------------
          ///     (3) ACCOUNT:
          /// ------------------------
          Positioned(
          top: 32,
          left: 10,
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey.shade300,
            child: InkWell(
              borderRadius:BorderRadius.circular(10.0),
              splashColor: Colors.grey,
              onTap: ()=> {Navigator.push(context,MaterialPageRoute(builder: (context)=>  UserInfo(),
              )
              )},
              child: Container(
                height: 40,
                width: 40,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://www.kindpng.com/picc/m/9-93976_my-account-hover-comments-icon-hd-png-download.png"
                    ),
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
          ),
          ),
          /// ------------------------
          ///     (4) SEARCH .. :
          /// ------------------------
          Positioned(
          left: MediaQuery.of(context).size.width * 0.35,
          top: titlePaddingTop * calculate + 27,
          bottom: 0.0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget> [
                //leading ??
                    SizedBox(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget> [
                    Transform.scale(
                        alignment: Alignment.centerLeft,
                        scale: 1 + (calculate * .5),
                        child: Padding(
                          padding: EdgeInsets.only(top: 14 * (1 - calculate)),
                        ),
                    ),
                    // if (calculate > .5) ...[
                    //   SizedBox(height: 10),
                    //   Opacity(opacity: calculate, child: subTitle ?? SizedBox(),)
                    // ]
                  ],
                ),
                Expanded(child: SizedBox()),
                Padding(
                    padding: EdgeInsets.only(top: 14 * calculate),
                    child: //action ??
                   SizedBox(),)
              ],
            ),
          )),
          Positioned(
              top: minExtent + ((stackPaddingTop - minExtent) * calculate),
              child: Opacity(
                opacity: calculate,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: stackChild
                )
              ))

        ],

      ),

    );
  }

  @override
  double get maxExtent => flexibleSpace;

  @override
  double get minExtent => kToolbarHeight + 25;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;



}