/// @author: Alexandros Christou
/// 03Nov21

import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sep21/Models/CartAttr.dart';
import 'package:sep21/Models/Sector.dart';
import 'package:sep21/Models/Stadium.dart';
import 'package:sep21/ViewModels/CartDetailsVM.dart';
import 'package:uuid/uuid.dart';

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
  void addProductToCart(String matchID, double price, String title, String imageURL, String type, String sector,
      String stadium, String date, String fanId, String ticketId
      ){



    _cartItems.putIfAbsent(ticketId, () => CartAttr(
      ticketId: ticketId,
        id: matchID,
        title: title,
        //quantity: existingCart.quantity + 1,
        quantity: 1,
        price: price,
        imageUrl: imageURL,
        //,stadium: existingCart.stadium,
        matchId: matchID,
        sector: sector,
        ticketType: type,
        date: date,
        stadium: stadium,
        fanId: fanId

    ));
    //_items.add(new CartDetailsVM.name(type, sector, matchID, ticketId));

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

  void reduceItemCartByOne(String TicketId) {
    if (_cartItems.containsKey(TicketId)) {
      /// ToDoo:
      /// 1) add additional IDs arguments to each product
      ///   representing each sector and apply more checks
      ///   to distinguish the ticket type and sector !
      _cartItems.update(TicketId, (existingCart) =>
          CartAttr(
              ticketId: TicketId,
              id: existingCart.id,
              title: existingCart.title,
              quantity: existingCart.quantity - 1 ,
              price: existingCart.price,
              imageUrl: existingCart.imageUrl,
              matchId: '3' ,
             // stadium: existingCart.stadium
            sector:  existingCart.sector,
            ticketType:  existingCart.ticketType,
            stadium: existingCart.stadium,
            date: existingCart.date,
            fanId: existingCart.fanId
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

  /// get quantity and sector for each ticket in the provider ..
  List<CartDetailsVM> getCartDetails(){
    List<CartDetailsVM> items = [];
    
    // for (int i = 0; i < _cartItems.values.where((x) => x.ticketId != '').length; i ++){
    //   items.add(new CartDetailsVM(_cartItems[i]!.ticketType, _cartItems[i]!.sector, _cartItems[i]!.matchId));
    // }
    _cartItems.forEach((key, value) { items.add(new CartDetailsVM(value.ticketType, value.sector, value.matchId)) ; });
    
    return items;
    
  }

}