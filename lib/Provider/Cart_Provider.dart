/// @author: Alexandros Christou
/// 03Nov21

import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sep21/Models/CartAttr.dart';
import 'package:sep21/Models/Sector.dart';
import 'package:sep21/Models/Stadium.dart';

class CartProvider with ChangeNotifier{

  Map<String, CartAttr> _cartItems = {};

  Map<String,CartAttr> get getCartItems{
    return this._cartItems;
  }

  double get totalAmount{
    var total = 0.0;
    _cartItems.forEach((key, value) {total += value.price * value.quantity;});
    return total;
  }
//, String ticketId
  void addProductToCart(String matchID, double price, String title, String imageURL, String type, String sector){


    _cartItems.update(matchID, (existingCart) => CartAttr(
        id: existingCart.id,
        title: existingCart.title,
        //quantity: existingCart.quantity + 1,
        quantity: 1,
        price: existingCart.price,
        imageUrl: existingCart.imageUrl,
        //,stadium: existingCart.stadium,
        matchId: matchID,
        sector: sector,
        ticketType: type

    ));

    // if (_cartItems.containsKey(matchID)){
    //   _cartItems.update(matchID, (existingCart) => CartAttr(
    //     id: existingCart.id,
    //     title: existingCart.title,
    //     quantity: existingCart.quantity + 1,
    //     price: existingCart.price,
    //     imageUrl: existingCart.imageUrl,
    //     //,stadium: existingCart.stadium,
    //     matchId: matchID,
    //     sector: sector,
    //     ticketType: type
    //
    //   ));
    // }else{
    //   _cartItems.putIfAbsent(matchID, () => CartAttr(
    //       id: DateTime.now().toString(),
    //       title: title,
    //       quantity:  1,
    //       price: price,
    //       imageUrl: imageURL,
    //       // stadium:  new Stadium("Antonis Papadopoulos", 7000,
    //       //   new Sector("SOUTH", 2400),
    //       //   new Sector("NORTH", 1200),
    //       //   new Sector("WEST", 3700),
    //       //   new Sector("EAST", 1500),
    //       // ),
    //       matchId: matchID,
    //     ticketType: type,
    //     sector:  sector
    //
    //   ));
    //
    // }
    notifyListeners();
  }

  void reduceItemCartByOne(String matchID) {
    if (_cartItems.containsKey(matchID)) {
      /// ToDoo:
      /// 1) add additional IDs arguments to each product
      ///   representing each sector and apply more checks
      ///   to distinguish the ticket type and sector !
      _cartItems.update(matchID, (existingCart) =>
          CartAttr(
              id: existingCart.id,
              title: existingCart.title,
              quantity: existingCart.quantity - 1 ,
              price: existingCart.price,
              imageUrl: existingCart.imageUrl,
              matchId: '3' ,
             // stadium: existingCart.stadium
            sector:  existingCart.sector,
            ticketType:  existingCart.ticketType
          ));
    }
    notifyListeners();
  }

  ///  removeItem method is being called when the user
  ///  press the 'x' button in the cart screen.
  ///  Then the product/ticket will be deleted
  ///  from the list
  void removeItem(String matchId){
    _cartItems.remove(matchId);
    notifyListeners();

  }

  /// when method clearCart  is invoked
  /// then the cart will be cleared.
  void clearCart(){
    _cartItems.clear();
    notifyListeners();
  }

}